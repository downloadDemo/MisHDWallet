//
//  CreateAll.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/21.
//  Copyright © 2018年 Frued. All rights reserved.
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
//#import <iconv.h>

@implementation CreateAll

/* 1 * 生成种子
 助记词由长度为128到256位的随机序列(熵)匹配词库而来，随后采用PBKDF2(Password-Based Key Derivation Function 2)推导出更长的种子(seed)。
 生成的种子被用来生成构建deterministic Wallet和推导钱包密钥。
 */
+(NSString *)CreateSeedByMnemonic:(NSString *)mnemonic Password:(NSString *)password{
    mnemonic = @"breeze eternal fiction junior ethics lumber chaos squirrel code jar snack broccoli";
    password = @"";//不用其作盐
    NSLog(@"mnemonic = %@",mnemonic);
    //passphrase作用是位移 助记词只要反向位移password位移的值就能生成正确的私钥
    NSString *seed = [NYMnemonic deterministicSeedStringFromMnemonicString:mnemonic
                                                                passphrase:password
                                                                language:@"english"];
    NSLog(@"seed = %@",seed);
    
    [CreateAll CreateKeyStoreByMnemonic:mnemonic Password:password callback:^(Account *account, NSError *NSError) {
        NSLog(@"**** finished ! ****");
    }];
    
    return seed;
}
/*
 根据mnemonic生成keystore,用于恢复账号，备份私钥，导出助记词等
 */
+(void)CreateKeyStoreByMnemonic:(NSString *)mnemonic Password:(NSString *)password  callback: (void (^)(Account *account, NSError *NSError))callback{
    Account *account = [Account accountWithMnemonicPhrase:mnemonic];
    [account encryptSecretStorageJSON:password callback:^(NSString *json) {
       // NSLog(@"\n keystore(json) = %@",json);
        [Account decryptSecretStorageJSON:json password:password callback:^(Account *decryptedAccount, NSError *error) {
            if (![account.address isEqual:decryptedAccount.address]) {
                NSLog(@"keystore生成错误");
            }else{
                NSLog(@"\n\n\n** keystore 恢复 mnemonic ** = \n %@ \n\n\n",decryptedAccount.mnemonicPhrase);
                //按密码保存keystore
                [[NSUserDefaults standardUserDefaults] setObject:@"keystore" forKey:password];
            }
            callback(decryptedAccount,error);

        }];
    }];
}

//扩展主公钥生成
+(NSString *)CreateMasterPublicKeyWithSeed:(NSString *)seed{
    BRBIP32Sequence *seq = [BRBIP32Sequence new];
    NSData *mpk = [seq masterPublicKeyFromSeed:seed.hexToData];
    //mpk前4位为较验位
    NSString *mpkstr = [NSString hexWithData:mpk];
    return  mpkstr;
}

//扩展账号私钥生成  BIP32 Root Key
+(NSString *)CreateExtendPrivateKeyWithSeed:(NSString *)seed{
    BRBIP32Sequence *seq = [BRBIP32Sequence new];
    //**********BIP32SequenceSerializedPrivateMasterFromSeed
    NSString *xprv = [seq serializedPrivateMasterFromSeed:seed.hexToData];
    NSLog(@"xprv = %@",xprv);
    return  xprv;
}

//扩展账号公钥生成
+(NSString *)CreateExtendPublicWithSeed:(NSString *)seed{
    BRBIP32Sequence *seq = [BRBIP32Sequence new];
    NSData *mpk = [seq masterPublicKeyFromSeed:seed.hexToData];
  //*********BIP32SequenceSerializedMasterPublicKey 对应的是"m/0'" (hardened child #0 of the root key)
    NSString *xpub = [seq serializedMasterPublicKey:mpk];
    NSLog(@"xpub = %@",xpub);
    return  xpub;
}
/*
 由扩展私钥生成钱包，指定钱包索引，币种两个参数
 xprv,index,coinType
 */
-(MissionWallet *)CreateWalletByXprv:(NSString*)xprv index:(UInt32)index CoinType:(CoinType)coinType{
   // BTCKeychain *masterchain = [[BTCKeychain alloc]initWithSeed:seed.hexToData];
    MissionWallet *wallet = [MissionWallet new];
    wallet.coinType = coinType;
    
    BTCKeychain *btckeychainxprv = [[BTCKeychain alloc]initWithExtendedKey:xprv];
    
    //Account Extendedm
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
    
    wallet.AccountExtendedPrivateKey = AccountExtendedPrivateKey;
    wallet.AccountExtendedPublicKey = AccountExtendedPublicKey;
    wallet.BIP32ExtendedPrivateKey = BIP32ExtendedPrivateKey;
    wallet.BIP32ExtendedPublicKey = BIP32ExtendedPublicKey;
    
    
    //第一个地址和私钥m/44'/0'/0'/0  m/44'/60'/0'/0
    BTCKey* key = [[btckeychainxprv derivedKeychainWithPath:BIP32Path] keyAtIndex:index];
    if(coinType == BTC){
        NSString *compressedPublicKeyAddress = key.compressedPublicKeyAddress.string;
        NSString *privateKey = key.privateKeyAddress.string;
        NSString *compressedPublicKey = [NSString hexWithData:key.compressedPublicKey];
        wallet.privateKey = privateKey;
        wallet.publicKey = compressedPublicKey;
        wallet.address = compressedPublicKeyAddress;
        NSLog(@"\n BTC  privateKey= %@\n Address = %@\n  PublicKey = %@\n",privateKey,compressedPublicKeyAddress, compressedPublicKey);
        
    }else{
        Account *account = [Account accountWithPrivateKey:key.privateKeyAddress.data];
        NSString *privateKey = [NSString hexWithData:key.privateKeyAddress.data];
        NSString *compressedPublicKey = [NSString hexWithData:key.compressedPublicKey];
        wallet.privateKey = privateKey;
        wallet.publicKey = compressedPublicKey;
        wallet.address = account.address.checksumAddress;
        NSLog(@"\n ETH  privateKey= %@\n Address = %@\n  PublicKey = %@\n",privateKey,account.address.checksumAddress, compressedPublicKey);
    }
    
    return wallet;
}

@end
