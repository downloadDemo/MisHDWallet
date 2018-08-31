//
//  MissionWallet.h
//  TaiYiToken
//
//  Created by Frued on 2018/8/27.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MissionWallet : NSObject
/*
 BTC/ETH
 */
@property(nonatomic,copy)NSString *AccountExtendedPrivateKey;
@property(nonatomic,copy)NSString *AccountExtendedPublicKey;
@property(nonatomic,copy)NSString *BIP32ExtendedPrivateKey;
@property(nonatomic,copy)NSString *BIP32ExtendedPublicKey;

@property(nonatomic,copy)NSString *privateKey;
@property(nonatomic,copy)NSString *publicKey;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,assign)CoinType coinType;
@end
