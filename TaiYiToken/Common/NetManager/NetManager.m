//
//  NetManager.m
//  TRProject


#import "NetManager.h"

#define BASE_URL @"http://192.168.1.27:8080"
@implementation NetManager
//获取全部币种的接口
//http://192.168.1.27:8080/wallet_manager/currencyList
+(id)GETCurrencyListcompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",BASE_URL,@"/wallet_manager/currencyList"];
    return [self GET:path parameters:nil completionHandler:^(id repsonseObj, NSError *error) {
        !handler ?:handler(repsonseObj,error);
    }];
}
@end
