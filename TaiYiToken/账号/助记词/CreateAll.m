//
//  CreateAll.m
//  TaiYiToken
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "CreateAll.h"
#import "NYMnemonic.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>


#import "secp256k1.h"
#import "secp256k1_ecdh.h"
#import "secp256k1_recovery.h"
#import "util.h"
#import "BRKey.h"

#import "NSString+Bitcoin.h"
#import "NSData+Bitcoin.h"
#import "NSMutableData+Bitcoin.h"
#import "BRBIP32Sequence.h"
#import <iconv.h>
@implementation NSData (NSData_hexadecimalString)

- (NSString *)hexString {
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    if (!dataBuffer) return [NSString string];
    
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
    [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}
/**
 剔除非UTF-8字符
 
 @param data 原来的数据data
 @return 处理后的输入data
 */
- (NSData *)cleanUTF8:(NSData *)data {
    iconv_t cd = iconv_open("UTF-8", "UTF-8"); // 从UTF-8转UTF-8
    int one = 1;
    iconvctl(cd, ICONV_SET_DISCARD_ILSEQ, &one); // 剔除非UTF-8的字符
    
    size_t inbytesleft, outbytesleft;
    inbytesleft = outbytesleft = data.length;
    char *inbuf  = (char *)data.bytes;
    char *outbuf = malloc(sizeof(char) * data.length);
    char *outptr = outbuf;
    if (iconv(cd, &inbuf, &inbytesleft, &outptr, &outbytesleft)
        == (size_t)-1) {
        NSLog(@"this should not happen, seriously");
        return nil;
    }
    NSData *result = [NSData dataWithBytes:outbuf length:data.length - outbytesleft];
    iconv_close(cd);
    free(outbuf);
    return result;
}

@end

@implementation NSString (Hex)

+ (NSString*) hexStringWithData: (unsigned char*) data ofLength: (NSUInteger) len
{
    NSMutableString *tmp = [NSMutableString string];
    for (NSUInteger i=0; i<len; i++)
    [tmp appendFormat:@"%02x", data[i]];
    return [NSString stringWithString:tmp];
}

//- (NSData *)dataFromHexString {
//
//    return dataFromChar([self UTF8String],(int)[self length]);
//}


@end


static int custom_nonce_function_rfc6979(unsigned char *nonce32, const unsigned char *msg32, const unsigned char *key32, const unsigned char *algo16, void *data, unsigned int counter){
    return secp256k1_nonce_function_rfc6979(nonce32, msg32, key32, algo16, data, counter);
}

@implementation CreateAll

/* 1 * 生成种子
 助记词由长度为128到256位的随机序列(熵)匹配词库而来，随后采用PBKDF2(Password-Based Key Derivation Function 2)推导出更长的种子(seed)。
 生成的种子被用来生成构建deterministic Wallet和推导钱包密钥。
 1）PBKDF2有两个参数：助记词和盐。盐的目的是提升进行暴力攻击时的困难度，可以参见BIP-39标准。盐由字符串常数“助记词"与可选的用户提供的密码字符串连接组成；
 2）PBKDF2使用HMAC-SHA512作为随机算法+2048次哈希重复计算，最终得到BIP32 种子，512 位(64字节)是期望得到的种子长度。即DK = PBKDF2(PRF, Password, Salt, c, dkLen)，
 其中，PRF是一个伪随机函数，例如HASH_HMAC函数，它会输出长度为hLen的结果；Password是用来生成密钥的原文密码；Salt是一个加密用的盐值；c是进行重复计算的次数；dkLen是期望得到的密钥的长度；
 DK是最后产生的密钥。
 */
//password 用于做盐
+(NSString *)CreateSeedByMnemonic:(NSString *)mnemonic AndPassword:(NSString *)password{
    NSLog(@"mnemonic = %@",mnemonic);
    NSString *seed = [NYMnemonic deterministicSeedStringFromMnemonicString:mnemonic
                                                                passphrase:password
                                                                  language:@"english"];
    return seed;
}

/**
 *  加密方式,MAC算法: HmacSHA256
 *
 *  @param plaintext 要加密的文本
 *  @param key       秘钥
 *
 *  @return 加密后的字符串
 
 首先是从根种子生成主密钥 (master key) 和主链码 (master chain code)
 上图中根种子通过不可逆 HMAC-SHA512 算法推算出 512 位的哈希串，左 256 位是 Master Private key(m), 右 256 位是 master chain code,
 通过 m 结合推导公钥的椭圆曲线算法能推导出与之对应的 264 位 master public Key (M)。chain code 作为推导下级密钥的熵。
 */
+ (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    
    return HMAC;
}
//512位种子 长度为128字符 64Byte
/*根种子通过不可逆HMAC-SHA512算法推算出512位的哈希串，左256位是主私钥Master Private Key (m)，右256位是主链码Master Chain Code；链码chain code作为推导下级密钥的熵。*/
+(NSMutableArray *)CreateMasterPrivateKeyBySeed:(NSString *)seed Password:(NSString *)password{
    NSString *hashcode = [seed hmacSHA512StringWithKey:password];
   // NSLog(@"master = %ld \n %@",hashcode.length,hashcode);
    NSString *masterPrivateKey = [hashcode substringToIndex:64];
    NSString *masterChainCode = [hashcode substringFromIndex:64];
    NSMutableArray *array = [NSMutableArray new];
    [array addObject:masterPrivateKey];
    [array addObject:masterChainCode];
    NSLog(@"a = %@ b= %@",masterPrivateKey,masterChainCode);
    return array;
}
//验证字符串位数
+ (int)convertToByte:(NSString*)str {
    int strlength = 0;
    char* p = (char*)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}
//secp256k1 私钥生成公钥
+(NSString *)CreatePublicKeyWithPrivateKey:(NSString *)privateKey Seed:(NSString *)seed{
    //?????
    BRKey *BTCPublicKey =  [BRKey keyWithPrivateKey:privateKey];
   
    NSLog(@"privateKey = %@",BTCPublicKey.privateKey);
    NSLog(@"address = %@",BTCPublicKey.address);
    BRBIP32Sequence *seq = [BRBIP32Sequence new];
    NSData *mpk = [seq masterPublicKeyFromSeed:privateKey.hexToData];
    
    NSLog(@"pub *** %@ ， %ld",[NSString hexWithData:mpk],[NSString hexWithData:mpk].length);
    NSString *a = @"04a34b99f22c790c4e36b2b3c2c35a36db06226e41c692fc82b8b56ac1c540c5bd5b8dec5235a0fa8722476c7709c02559e3aa73aa03918ba2d492eea75abea235";
    NSLog(@"\n%ld",a.length);
    //04a34b99f22c790c4e36b2b3c2c35a36db06226e41c692fc82b8b56ac1c540c5bd5b8dec5235a0fa8722476c7709c02559e3aa73aa03918ba2d492eea75abea235
 
   // [CreateAll CreatePubKey:@"S6c56bnXQiBjk9mqSYE7ykVQ7NzrRy"];
    return  [NSString hexWithData:mpk];
}



//////********椭圆算法*********
+(void) CreatePubKey:(NSString *)privateKey{
    unsigned char key[32];
    NSLog(@"copying secret");
    memcpy(key,[privateKey dataUsingEncoding:NSUTF8StringEncoding].bytes,
           32);
    secp256k1_context * ctx = secp256k1_context_create(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY);
    
   // secp256k1_ec_pubkey_create(const secp256k1_context* ctx, secp256k1_pubkey *pubkey, const unsigned char *seckey)
   
    secp256k1_pubkey pubkey;
    
    NSData *pubkeydata = nil;
    //
    NSMutableData *d = [NSMutableData secureDataWithLength:NO ? 33 : 65];
    size_t len = d.length;
  
    UInt256 seckey =  *(UInt256 *)privateKey.hexToData.bytes;
    if (secp256k1_ec_pubkey_create(ctx, &pubkey, seckey.u8)) {
        secp256k1_ec_pubkey_serialize(ctx, d.mutableBytes, &len, &pubkey,
                                      (NO ? SECP256K1_EC_COMPRESSED : SECP256K1_EC_UNCOMPRESSED));
        if (len == d.length) pubkeydata = d;
    }
    NSString *strkey = [[NSString alloc]initWithData:pubkeydata encoding:NSUTF8StringEncoding];
 
    if (secp256k1_ec_pubkey_create(ctx, &pubkey, key)) {
        NSString *s = @"";
        for(int i = 0;i<64;i++){
            unsigned char cc = pubkey.data[i];
            NSString *str1 = [NSString stringWithFormat:@"%c",cc];
            NSString *str = [NSString stringWithUTF32Char:cc];
            s = [NSString stringWithFormat:@"%@%@",s,str];
        }
       

       // NSLog(@"str  =  =  %@",[NSString hexWithData:pubkey]);
    }

    
}


//- (void) testSignatureWithPrivateKey:(NSString *)privateKey{
//    unsigned char key[32];
//    NSLog(@"copying secret");
//    memcpy(key,[privateKey dataFromHexString].bytes,
//           32);
//    secp256k1_context * ctx = secp256k1_context_create(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY);
//
//    char* elem = [[NSString stringWithFormat:@"element"] UTF8String];
//
//    char hashedTransaction[32];
//   // keccack_256(hashedTransaction, 32, elem , 7);
//    NSLog(@"hashed tx: %@", [NSString hexStringWithData:hashedTransaction ofLength:32]);
//    secp256k1_ecdsa_signature signature;
//    unsigned char sig[74];
//    size_t siglen = 74;
//    secp256k1_ecdsa_recoverable_signature recoverable_sig;
//
//    secp256k1_ecdsa_sign_recoverable(ctx, &recoverable_sig, hashedTransaction, key, custom_nonce_function_rfc6979, NULL);
//
//
//    secp256k1_ecdsa_recoverable_signature_convert(ctx,
//                                                  &signature,
//                                                  &recoverable_sig);
//
//    //secp256k1_ecdsa_signature_recoverable_serialize_der(ctx, sig, &siglen, &signature);
//    //secp256k1_ecdsa_sign(ctx, &signature, hashedTransaction, key, custom_nonce_function_rfc6979, NULL);
//    secp256k1_ecdsa_signature_serialize_der(ctx, sig, &siglen, &signature);
//    uint8_t r[32];
//    uint8_t s[32];
//
//    der_sig_parse(r,s, sig, siglen);
//    //t.s = s;
//    //t.r = r;
//
// 
//    NSLog(@"%d",(uint8_t)recoverable_sig.data[64]);
//    secp256k1_context_destroy(ctx);
//
//}



static int der_sig_parse(char *rr, char *rs, const unsigned char *sig, size_t size) {
    const unsigned char *sigend = sig + size;
    int rlen;
    if (sig == sigend || *(sig++) != 0x30) {
        /* The encoding doesn't start with a constructed sequence (X.690-0207 8.9.1). */
        return 0;
    }
    rlen = secp256k1_der_read_len(&sig, sigend);
    if (rlen < 0 || sig + rlen > sigend) {
        /* Tuple exceeds bounds */
        return 0;
    }
    if (sig + rlen != sigend) {
        /* Garbage after tuple. */
        return 0;
    }

    if (!secp256k1_der_parse_integer(rr, &sig, sigend)) {
        return 0;
    }
    if (!secp256k1_der_parse_integer(rs, &sig, sigend)) {
        return 0;
    }

    if (sig != sigend) {
        /* Trailing garbage inside tuple. */
        return 0;
    }

    return 1;
}

static int secp256k1_der_parse_integer(char *r, const unsigned char **sig, const unsigned char *sigend) {
    int overflow = 0;
    unsigned char ra[32] = {0};
    int rlen;

    if (*sig == sigend || **sig != 0x02) {
        /* Not a primitive integer (X.690-0207 8.3.1). */
        return 0;
    }
    (*sig)++;
    rlen = secp256k1_der_read_len(sig, sigend);
    if (rlen <= 0 || (*sig) + rlen > sigend) {
        /* Exceeds bounds or not at least length 1 (X.690-0207 8.3.1).  */
        return 0;
    }
    if (**sig == 0x00 && rlen > 1 && (((*sig)[1]) & 0x80) == 0x00) {
        /* Excessive 0x00 padding. */
        return 0;
    }
    if (**sig == 0xFF && rlen > 1 && (((*sig)[1]) & 0x80) == 0x80) {
        /* Excessive 0xFF padding. */
        return 0;
    }
    if ((**sig & 0x80) == 0x80) {
        /* Negative. */
        overflow = 1;
    }
    while (rlen > 0 && **sig == 0) {
        /* Skip leading zero bytes */
        rlen--;
        (*sig)++;
    }
    if (rlen > 32) {
        overflow = 1;
    }
    if (!overflow) {
        memcpy(ra + 32 - rlen, *sig, rlen);

        //secp256k1_scalar_set_b32(r, ra, &overflow);
    }
    if (overflow) {
        //secp256k1_scalar_set_int(r, 0);
    }
    (*sig) += rlen;

    memcpy(r,ra,rlen);
    return 1;
}

static int secp256k1_der_read_len(const unsigned char **sigp, const unsigned char *sigend) {
    int lenleft, b1;
    size_t ret = 0;
    if (*sigp >= sigend) {
        return -1;
    }
    b1 = *((*sigp)++);
    if (b1 == 0xFF) {
        /* X.690-0207 8.1.3.5.c the value 0xFF shall not be used. */
        return -1;
    }
    if ((b1 & 0x80) == 0) {
        /* X.690-0207 8.1.3.4 short form length octets */
        return b1;
    }
    if (b1 == 0x80) {
        /* Indefinite length is not allowed in DER. */
        return -1;
    }
    /* X.690-207 8.1.3.5 long form length octets */
    lenleft = b1 & 0x7F;
    if (lenleft > sigend - *sigp) {
        return -1;
    }
    if (**sigp == 0) {
        /* Not the shortest possible length encoding. */
        return -1;
    }
    if ((size_t)lenleft > sizeof(size_t)) {
        /* The resulting length would exceed the range of a size_t, so
         * certainly longer than the passed array size.
         */
        return -1;
    }
    while (lenleft > 0) {
        ret = (ret << 8) | **sigp;
        if (ret + lenleft > (size_t)(sigend - *sigp)) {
            /* Result exceeds the length of the passed array. */
            return -1;
        }
        (*sigp)++;
        lenleft--;
    }
    if (ret < 128) {
        /* Not the shortest possible length encoding. */
        return -1;
    }
    return ret;
}

@end
