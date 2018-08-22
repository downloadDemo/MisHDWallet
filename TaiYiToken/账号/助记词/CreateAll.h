//
//  CreateAll.h
//  TaiYiToken
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateAll : NSObject

//生成种子
+(NSString *)CreateSeedByMnemonic:(NSString *)mnemonic AndPassword:(NSString *)password;
//HmacSHA256  由seed生成私钥 （暂时只用下面的HmacSHA512）
+ (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key;
//分层 HmacSHA512 由seed生成主私钥+链码，链码作为推导下级密钥的熵
+(NSMutableArray *)CreateMasterPrivateKeyBySeed:(NSString *)seed Password:(NSString *)password;
//secp256k1 私钥生成公钥
+(NSString *)CreatePublicKeyWithPrivateKey:(NSString *)privateKey Seed:(NSString *)seed;

/*
 工具方法
 */
//验证字符串Byte位数
+ (int)convertToByte:(NSString*)str;
@end
