//
//  EOSAccountKey.m
//  TaiYiToken
//
//  Created by admin on 2018/9/26.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "EOSAccountKey.h"

@implementation EOSAccountKey
+(void)EOSKeyByMnemonic:(NSString*)mnemonic KeyType:(EOSKeyType)keyType callback: (void (^)(EOSAccountKey *key))callback{
    if (keyType == EOS_ACTIVE_KEY) {
        [CreateAll CreateEosActivePrivateKeyByMnemonic:mnemonic callback:^(id response) {
            if (response != nil) {
                NSString *pri = response;
                [CreateAll EOSPrivateKeyToPublicKey:pri callback:^(id response) {
                    if (response != nil) {
                        NSString *pub = response;
                        EOSAccountKey *eoskey = [EOSAccountKey new];
                        eoskey.eosPrivateKey = pri;
                        eoskey.eosPublicKey = pub;
                        callback(eoskey);
                    }else{
                        callback(nil);
                    }
                }];
            }else{
                callback(nil);
            }
        }];
    }else if (keyType == EOS_OWNER_KEY){
        [CreateAll CreateEosOwnerPrivateKeyByMnemonic:mnemonic callback:^(id response) {
            if (response != nil) {
                NSString *pri = response;
                [CreateAll EOSPrivateKeyToPublicKey:pri callback:^(id response) {
                    if (response != nil) {
                        NSString *pub = response;
                        EOSAccountKey *eoskey = [EOSAccountKey new];
                        eoskey.eosPrivateKey = pri;
                        eoskey.eosPublicKey = pub;
                        callback(eoskey);
                    }else{
                        callback(nil);
                    }
                }];
            }else{
                callback(nil);
            }
        }];
    }else{
        callback(nil);
    }
   
}
@end
