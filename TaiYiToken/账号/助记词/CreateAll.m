//
//  CreateAll.m
//  TaiYiToken
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 admin. All rights reserved.
//
#import <Foundation/Foundation.h>
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


@end

@implementation NSString (Hex)

+ (NSString*) hexStringWithData: (unsigned char*) data ofLength: (NSUInteger) len
{
    NSMutableString *tmp = [NSMutableString string];
    for (NSUInteger i=0; i<len; i++)
    [tmp appendFormat:@"%02x", data[i]];
    return [NSString stringWithString:tmp];
}

@end



@implementation CreateAll
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
    //passphrase作用是位移 助记词只要反向位移password位移的值就能生成正确的私钥
    NSString *seed = [NYMnemonic deterministicSeedStringFromMnemonicString:mnemonic
                                                                passphrase:password
                                                                language:@"english"];
   
   
    
    NSLog(@"seed = %@",seed);
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

//512位种子 长度为128字符 64Byte
/*根种子通过不可逆HMAC-SHA512算法推算出512位的哈希串，左256位是主私钥Master Private Key (m)，右256位是主链码Master Chain Code；链码chain code作为推导下级密钥的熵。*/
+(NSMutableArray *)CreateMasterPrivateKeyBySeed:(NSString *)seed Password:(NSString *)password{
    //******************YYKit HMAC-SHA512方法生成主私钥+主链码
    NSString *hashcode = [seed hmacSHA512StringWithKey:@""];//
     NSLog(@"master = %ld \n %@",hashcode.length,hashcode);
    NSString *masterPrivateKey = [hashcode substringToIndex:64];
    NSString *masterChainCode = [hashcode substringFromIndex:64];
    NSMutableArray *array = [NSMutableArray new];
    [array addObject:masterPrivateKey];
    [array addObject:masterChainCode];
    NSLog(@"a = %@ b= %@",masterPrivateKey,masterChainCode);
    
    ////**********************输出生成主公钥过程中的私钥
    BRBIP32Sequence *seq = [BRBIP32Sequence new];
    NSString *prikeyseq32 = [NSString hexWithData:[seq CreatePrivateKeyFromSeed:seed.hexToData Pass:password.hexToData]];
    NSLog(@"prikeyseq32 = %@",prikeyseq32);

   //*************************比特币地址+私钥
    NSString *privKey = [seq bitIdPrivateKey:0 forURI:@"http://bitid.bitcoin.blue/callback" fromSeed:seed.hexToData];
    NSString *addr = [BRKey keyWithPrivateKey:privKey].address;
    
    NSLog(@"\n\n\n test privKey = %@ \n addr =  %@",privKey,addr);
    
    
    return array;
}

//secp256k1 主私钥生成主公钥
+(NSString *)CreatePublicKeyWithPrivateKey:(NSString *)privateKey Seed:(NSString *)seed{

 
    BRBIP32Sequence *seq = [BRBIP32Sequence new];
    NSData *mpk = [seq masterPublicKeyFromSeed:seed.hexToData];
    NSString *mpkstr = [NSString hexWithData:mpk];
    //mpk前4位为较验位
    NSLog(@"master pub *** %@ ， %ld",mpkstr,mpkstr.length);
    
    NSData *pubFromMasterPubkey = [seq publicKey:0 internal:NO masterPublicKey:mpk];

    NSLog(@" pubFromMasterPubkey *** = %@", [NSString hexWithData:pubFromMasterPubkey]);
    ///
    
    
    
    return  mpkstr;
}




@end
