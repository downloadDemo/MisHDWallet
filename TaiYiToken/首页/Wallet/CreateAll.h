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


#import "NSString+Bitcoin.h"
#import "NSData+Bitcoin.h"
#import "NSMutableData+Bitcoin.h"
#import "BRBIP32Sequence.h"
@interface CreateAll : NSObject
/*
 ********************************************** 钱包生成/导入/恢复 ***********************************************
 */
//由助记词生成种子  seed
+(NSString *)CreateSeedByMnemonic:(NSString *)mnemonic Password:(NSString *)password;


//根据mnemonic生成keystore,用于恢复账号，备份私钥，导出助记词等
+(void)CreateKeyStoreByMnemonic:(NSString *)mnemonic WalletAddress:(NSString *)walletAddress Password:(NSString *)password  callback: (void (^)(Account *account, NSError *error))callback;
//根据PrivateKey生成keystore,用于恢复账号，备份私钥，导出助记词等
+(void)CreateKeyStoreByPrivateKey:(NSString *)privatekey WalletAddress:(NSString *)walletAddress Password:(NSString *)password  callback: (void (^)(Account *account, NSError *error))callback;


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

//生成地址二维码
+(UIImage *)CreateQRCodeForAddress:(NSString *)address;







/*
 *************************************************** 钱包导入 ****************************************************
 */

//由助记词导入钱包 （存储钱包 生成存储KeyStore）
/*
 return nil; 表示钱包已存在 提示导入错误
 */
+(void)ImportWalletByMnemonic:(NSString *)mnemonic CoinType:(CoinType)coinType Password:(NSString *)password PasswordHint:(NSString *)passwordHint callback: (void (^)(MissionWallet *wallet, NSError *error))completionHandler;

//由私钥导入钱包  （存储钱包 生成存储KeyStore）
/*
 return nil; 表示钱包已存在 提示导入错误
 */
+(MissionWallet *)ImportWalletByPrivateKey:(NSString *)privateKey CoinType:(CoinType)coinType Password:(NSString *)password PasswordHint:(NSString *)passwordHint;
//由KeyStore导入钱包 （存储钱包 生成存储KeyStore）
/*
 wallet == nil; 表示钱包已存在 提示导入错误
 */
+(void)ImportWalletByKeyStore:(NSString *)keystore  CoinType:(CoinType)coinType Password:(NSString *)password PasswordHint:(NSString *)passwordHint callback: (void (^)(MissionWallet *wallet, NSError *error))callback;

//移除导入的钱包
/*
 return @"WalletType is LOCAL_WALLET !";
 return @"Delete WalletName Failed!";
 return @"Delete Wallet Failed!";
 return @"Delete Successed!"; 成功
 */
+(NSString *)RemoveImportedWallet:(MissionWallet *)wallet;


//创建EOS KeyPair
+(void)CreateEOSKeyPairWithMnemonicCode:(NSString *)mnemonic;

/*
 ************************************************** 钱包导出 *************************************
 */
//导出keystore
+(void)ExportKeyStoreByPassword:(NSString *)password  WalletAddress:(NSString *)walletAddress callback: (void (^)(NSString *address, NSError *error))callback;

//导出助记词
+(void)ExportMnemonicByPassword:(NSString *)password WalletAddress:(NSString *)walletAddress callback: (void (^)(NSString *mnemonic, NSError *error))callback;

//导出私钥
+(void)ExportPrivateKeyByPassword:(NSString *)password CoinType:(CoinType)coinType WalletAddress:(NSString *)walletAddress  index:(UInt32)index  callback: (void (^)(NSString *privateKey, NSError *error))callback;

//验证某钱包的密码
+(void)VerifyPassword:(NSString *)password WalletAddress:(NSString *)walletAddress callback: (void (^)(BOOL passwordIsRight, NSError *error))callback;







/*
 *************************************************** 钱包账号存取管理 *************************************************
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
+(void)SaveWallet:(MissionWallet *)wallet Name:(NSString *)walletname WalletType:(WALLET_TYPE)walletType Password:(NSString *)password;



//TODO
//增加钱包存储使用密码加密，解锁使用密码加密，一定时间内未登录 再登录时需要密码解锁钱包对象 



/*
 ********************************************** 转账 *******************************************************************
 */
//**************  BTC ********************
//转账
+(void)BTCTransactionFromWallet:(MissionWallet *)wallet ToAddress:(NSString *)address Amount:(BTCAmount)amount
                            Fee:(BTCAmount)fee
                            Api:(BTCAPI)btcApi
                       callback: (void (^)(NSString *result, NSError *error))callback;

//**************  ETH ********************
//转账
+(void)ETHTransaction:(Transaction *)transaction Wallet:(MissionWallet *)wallet GasPrice:(BigNumber *)gasPrice GasLimit:(BigNumber *)gasLimit callback: (void (^)(HashPromise *promise))callback;
//获取ETH价格
+(void)GetETHCurrencyCallback: (void (^)(FloatPromise *etherprice))callback;
//获取GAS价格
+(void)GetGasPriceCallback: (void (^)(BigNumberPromise *gasPrice))callback;
//获取交易记录
+(void)GetTransactionsForAddress:(NSString *)address startBlockTag: (BlockTag)blockTag Callback: (void (^)(ArrayPromise *promiseArray))callback;
//获取交易详情
+(void)GetTransactionDetaslByHash:(NSString *)hash Callback: (void (^)(TransactionInfoPromise *promise))callback;
//获取余额
+(void)GetBalanceETHForWallet:(MissionWallet *)wallet callback: (void (^)(BigNumber *balance))callback;
//创建交易
+(void)CreateETHTransactionFromWallet:(MissionWallet *)wallet ToAddress:(NSString *)address Value:(BigNumber *)value callback: (void (^)(Transaction *transaction))callback;
//获取交易预估gas
+(void)GetGasLimitPriceForTransaction:(Transaction *)transaction callback: (void (^)(BigNumber *gasLimitPrice))callback;
@end
