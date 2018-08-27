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

/* 1 * 生成种子
 助记词由长度为128到256位的随机序列(熵)匹配词库而来，随后采用PBKDF2(Password-Based Key Derivation Function 2)推导出更长的种子(seed)。
 生成的种子被用来生成构建deterministic Wallet和推导钱包密钥。
 1）PBKDF2有两个参数：助记词和盐。盐的目的是提升进行暴力攻击时的困难度，可以参见BIP-39标准。盐由字符串常数“助记词"与可选的用户提供的密码字符串连接组成；
 2）PBKDF2使用HMAC-SHA512作为随机算法+2048次哈希重复计算，最终得到BIP32 种子，512 位(64字节)是期望得到的种子长度。即DK = PBKDF2(PRF, Password, Salt, c, dkLen)，
 其中，PRF是一个伪随机函数，例如HASH_HMAC函数，它会输出长度为hLen的结果；Password是用来生成密钥的原文密码；Salt是一个加密用的盐值；c是进行重复计算的次数；dkLen是期望得到的密钥的长度；
 DK是最后产生的密钥。
 */
+(NSString *)CreateSeedByMnemonic:(NSString *)mnemonic AndPassword:(NSString *)password{
    mnemonic = @"breeze eternal fiction junior ethics lumber chaos squirrel code jar snack broccoli";
    password = @"";//不用其作盐
    NSLog(@"mnemonic = %@",mnemonic);
    //passphrase作用是位移 助记词只要反向位移password位移的值就能生成正确的私钥
    NSString *seed = [NYMnemonic deterministicSeedStringFromMnemonicString:mnemonic
                                                                passphrase:password
                                                                language:@"english"];
    NSLog(@"seed = %@",seed);
    return seed;
}


//扩展主公私钥生成
+(NSString *)CreatePublicKeyWithSeed:(NSString *)seed{

    BRBIP32Sequence *seq = [BRBIP32Sequence new];
    NSData *mpk = [seq masterPublicKeyFromSeed:seed.hexToData];
    NSString *mpkstr = [NSString hexWithData:mpk];
    //mpk前4位为较验位
   // NSLog(@"\n\n\n *****  \n master pub  %@ ， %ld *******\n",mpkstr,mpkstr.length);
   
    //**********BIP32SequenceSerializedPrivateMasterFromSeed
    NSString *xprv = [seq serializedPrivateMasterFromSeed:seed.hexToData];
    NSLog(@"\n ******* xpriv = %@ *******\n", xprv);
   
    //*********BIP32SequenceSerializedMasterPublicKey 对应的是"m/0'" (hardened child #0 of the root key)
    NSString *xpub = [seq serializedMasterPublicKey:mpk];
    NSLog(@"\n ****** xpub = %@ *******\n", xpub);
    
    [CreateAll CreateBTCKeychainByXprv:xprv index:0 CoinType:BTC];
    [CreateAll CreateBTCKeychainByXprv:xprv index:0 CoinType:ETH];
    return  mpkstr;
}
/*
 xprv,index,coinTYpe
 ******************************************
// ⽬前有三种货币被定义：Bitcoin is m/44'/0'、Bitcoin Testnet is m/44'/1'，以及Litecoin is
 m/44'/2'。
 // "" (root key)
 // "m" (root key)
 // "/" (root key)
 // "m/0'" (hardened child #0 of the root key)
 // "/0'" (hardened child #0 of the root key)
 // "0'" (hardened child #0 of the root key)
 // "m/44'/1'/2'" (BIP44 testnet account #2)
 // "/44'/1'/2'" (BIP44 testnet account #2)
 // "44'/1'/2'" (BIP44 testnet account #2)
 */
+(BTCKey *)CreateBTCKeychainByXprv:(NSString*)xprv index:(UInt32)index CoinType:(CoinType)coinType{
    // Initializes master keychain from a seed
   // BTCKeychain *masterchain = [[BTCKeychain alloc]initWithSeed:seed.hexToData];
    
    BTCKeychain *btckeychainxprv = [[BTCKeychain alloc]initWithExtendedKey:xprv];
 
    
    //Account Extendedm/44'/60'/0'/0
    NSString *AccountPath = [NSString stringWithFormat:@"m/44'/%d'/0'",coinType];
    NSLog(@"\n\n path = %@\n\n",AccountPath);
    NSString *AccountExtendedPrivateKey  =  [btckeychainxprv derivedKeychainWithPath:AccountPath].extendedPrivateKey;
    NSString *AccountExtendedPublicKey  = [btckeychainxprv derivedKeychainWithPath:AccountPath].extendedPublicKey;
    NSLog(@"\n *** Account Extended ***\n pri = %@ \n pub = %@",AccountExtendedPrivateKey,AccountExtendedPublicKey);
   // BIP32 Extended
    NSString *BIP32Path = [NSString stringWithFormat:@"m/44'/%d'/0'/0",coinType];
    NSString *BIP32ExtendedPrivateKey = [btckeychainxprv derivedKeychainWithPath:BIP32Path].extendedPrivateKey;
    NSString *BIP32ExtendedPublicKey = [btckeychainxprv derivedKeychainWithPath:BIP32Path].extendedPublicKey;
    NSLog(@"\n *** BIP32 Extended ***\n pri = %@ \n pub = %@",BIP32ExtendedPrivateKey,BIP32ExtendedPublicKey);
    
   
    
    //第一个地址和私钥m/44'/0'/0'/0  m/44'/60'/0'/0
    //compressedPublicKeyAddress = 16UZrzsDdeEnq95HSWhcW8RSdqpG4vJQeX                          BTC地址
    //privateKey = L5Y7u1iYyyQS39UaSyCVD223HYEQLARFVQgY3SyqzrmQnHrfPV7d                        BTC私钥
    //compressedPublicKey = 02c1cfd635ffc3a3b78ec76248d1fbba50f0e40cba89613d51ff2a177dea51844a BTC公钥
    BTCKey* key = [[btckeychainxprv derivedKeychainWithPath:BIP32Path] keyAtIndex:index];
    if(coinType == BTC){
        NSString *compressedPublicKeyAddress = key.compressedPublicKeyAddress.string;
        NSString *privateKey = key.privateKeyAddress.string;
        NSString *compressedPublicKey = [NSString hexWithData:key.compressedPublicKey];
        NSLog(@"\n   privateKey= %@\n Address = %@\n  PublicKey = %@\n",privateKey,compressedPublicKeyAddress, compressedPublicKey);
        
    }else{
        
        NSString *compressedPublicKeyAddress = [NSString hexWithData:key.compressedPublicKeyAddress.data];//错误
        
        NSString *uncompressedPublicKeyAddress = [NSString hexWithData:key.uncompressedPublicKeyAddress.data];
        NSString *address = [NSString hexWithData:key.address.data];
        NSString *addressTestnet = [NSString hexWithData:key.addressTestnet.data];
        NSString *privateKeyAddressTestnet = [NSString hexWithData:key.privateKeyAddressTestnet.data];
        
        NSLog(@"\n\n\n**************\n");
        NSLog(@"compressedPublicKeyAddress = %@",compressedPublicKeyAddress);
        NSLog(@"uncompressedPublicKeyAddress = %@",uncompressedPublicKeyAddress);
        NSLog(@"address = %@",address);
        NSLog(@"addressTestnet = %@",addressTestnet);
        NSLog(@"privateKeyAddressTestnet = %@",privateKeyAddressTestnet);
        NSLog(@"\n**************\n\n\n");
        NSString *privateKey = [NSString hexWithData:key.privateKeyAddress.data];
        NSString *compressedPublicKey = [NSString hexWithData:key.compressedPublicKey];
        NSLog(@"\n   privateKey= %@\n Address = %@\n  PublicKey = %@\n",privateKey,compressedPublicKeyAddress, compressedPublicKey);
    }
    return key;
}

@end
