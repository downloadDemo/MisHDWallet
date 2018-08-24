//
//  CreateAll.h
//  TaiYiToken
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 admin. All rights reserved.
//
/*
 生成钱包的整体流程
 
 */
#import <Foundation/Foundation.h>

@interface CreateAll : NSObject

//由助记词生成种子
+(NSString *)CreateSeedByMnemonic:(NSString *)mnemonic AndPassword:(NSString *)password;
//分层 HmacSHA512 由seed生成主私钥+链码，链码作为推导下级密钥的熵
+(NSMutableArray *)CreateMasterPrivateKeyBySeed:(NSString *)seed Password:(NSString *)password;
//secp256k1 私钥生成公钥
+(NSString *)CreatePublicKeyWithPrivateKey:(NSString *)privateKey Seed:(NSString *)seed;
//test
+(void)CreateBTCKeychainBySeed:(NSString *)seed Xprv:(NSString*)xprv Xpub:(NSString*)xpub;

@end
