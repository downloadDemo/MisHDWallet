//
//  CreateAll.h
//  TaiYiToken
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 admin. All rights reserved.
//
/*
 生成钱包的整体流程
 
 *** bitcoin钱包生成 ***
 生成一个助记词（参见 BIP39）
 该助记词使用 PBKDF2 转化为种子（参见 BIP39）
 种子用于使用 HMAC-SHA512 生成根私钥（参见BIP32）
 从该根私钥，导出子私钥（参见BIP32），其中节点布局由BIP44设置
 
 包含私钥的扩展密钥用以推导子私钥，从子私钥又可推导对应的公钥和比特币地址
 包含公钥的扩展密钥用以推导子公钥
 扩展密钥使用 Base58Check 算法加上特定的前缀编码，编码得到的包含私钥的前缀为 xprv, 包含公钥的扩展密钥前缀为 xpub，相比比特币的公私钥，扩展密钥编码之后得到的长度为 512 或 513 位
 
 
 *** eth钱包生成 ***
 
 */
#import <Foundation/Foundation.h>

@interface CreateAll : NSObject

//由助记词生成种子  seed
+(NSString *)CreateSeedByMnemonic:(NSString *)mnemonic AndPassword:(NSString *)password;

//扩展主公钥生成    mpk
+(NSString *)CreateMasterPublicKeyWithSeed:(NSString *)seed;
//扩展账号私钥生成  xprv
+(NSString *)CreateExtendPrivateKeyWithSeed:(NSString *)seed;
//扩展账号公钥生成  xpub
+(NSString *)CreateExtendPublicWithSeed:(NSString *)seed;


//创建钱包
//由扩展私钥xprv生成第index个秘钥对及地址
+(MissionWallet *)CreateBTCKeychainByXprv:(NSString*)xprv index:(UInt32)index CoinType:(CoinType)coinType;



@end
