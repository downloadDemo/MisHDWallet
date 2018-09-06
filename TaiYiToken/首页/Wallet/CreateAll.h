//
//  CreateAll.h
//  TaiYiToken
//
//  Created by Frued on 2018/8/21.
//  Copyright © 2018年 Frued. All rights reserved.
//
/*
 生成钱包的整体流程
 
 *** bitcoin钱包生成 ***
 1.生成一个助记词（参见 BIP39）
 2.该助记词使用 PBKDF2 转化为种子（参见 BIP39）
 3.种子用于使用 HMAC-SHA512 生成根私钥（参见BIP32）
 4.从该根私钥，导出子私钥（参见BIP32），其中节点布局由BIP44设置
 
 包含私钥的扩展密钥用以推导子私钥，从子私钥又可推导对应的公钥和比特币地址
 包含公钥的扩展密钥用以推导子公钥
 扩展密钥使用 Base58Check 算法加上特定的前缀编码，编码得到的包含私钥的前缀为 xprv, 包含公钥的扩展密钥前缀为 xpub，相比比特币的公私钥，扩展密钥编码之后得到的长度为 512 或 513 位
 
 *** eth钱包生成 ***
 1.同上
 2.生成地址使用ethers接口实现
 */
#import <Foundation/Foundation.h>
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
@interface CreateAll : NSObject
/*
 *********钱包生成/导入/恢复**********
 */
//由助记词生成种子  seed
+(NSString *)CreateSeedByMnemonic:(NSString *)mnemonic Password:(NSString *)password;

//根据mnemonic生成keystore,用于恢复账号，备份私钥，导出助记词等
+(void)CreateKeyStoreByMnemonic:(NSString *)mnemonic Password:(NSString *)password  callback: (void (^)(Account *account, NSError *NSError))callback;

//扩展主公钥生成    mpk
+(NSString *)CreateMasterPublicKeyWithSeed:(NSString *)seed;
//取主公钥
+(NSData *)GetMasterPublicKey;

//根据BIP32ExtendedPublicKey扩展公钥生成index索引的子BTCKey
+(BTCKey *)CreateBTCAddressAtIndex:(UInt32)index ExtendKey:(NSString *)extendedPublicKey;

//扩展账号私钥生成  xprv
+(NSString *)CreateExtendPrivateKeyWithSeed:(NSString *)seed;
//扩展账号公钥生成  xpub
+(NSString *)CreateExtendPublicWithSeed:(NSString *)seed;

//创建钱包 由扩展私钥xprv生成第index个秘钥对及地址
+(MissionWallet *)CreateWalletByXprv:(NSString*)xprv index:(UInt32)index CoinType:(CoinType)coinType;

//从keystore恢复账号
+(void)RecoverAccountByPassword:(NSString *)password callback: (void (^)(Account *account, NSError *error))callback;

//生成地址二维码
+(UIImage *)CreateQRCodeForAddress:(NSString *)address;
/*
 ************** 钱包导入 ***************
 */
//由私钥导入钱包
+(MissionWallet *)ImportWalletByPrivateKey:(NSString *)privateKey CoinType:(CoinType)coinType;

/*
 ************** 钱包导出 ***************
 */
//导出keystore
+(void)ExportKeyStoreByPassword:(NSString *)password  callback: (void (^)(NSString *address, NSError *error))callback;

//导出助记词
+(void)ExportMnemonicByPassword:(NSString *)password  callback: (void (^)(NSString *mnemonic, NSError *error))callback;

//导出私钥
+(void)ExportPrivateKeyByPassword:(NSString *)password CoinType:(CoinType)coinType index:(UInt32)index  callback: (void (^)(NSString *privateKey, NSError *error))callback;

/*
 ***************钱包账号存取管理************
 */
//清空所有钱包，退出账号
+(void)RemoveAllWallet;

//取得所有钱包名称（包含导入）
+(NSArray *)GetWalletNameArray;

//取得所有导入的钱包名称
+(NSArray *)GetImportWalletNameArray;

//根据钱包名称取钱包
+(MissionWallet *)GetMissionWalletByName:(NSString *)walletname;

//存储钱包
+(void)SaveWallet:(MissionWallet *)wallet Name:(NSString *)walletname WalletType:(WALLET_TYPE)walletType;


@end
