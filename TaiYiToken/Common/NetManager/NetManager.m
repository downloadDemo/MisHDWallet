//
//  NetManager.m
//  TRProject


#import "NetManager.h"

#define BASE_URL @"http://192.168.1.27:8080/wallet_manager"
//http://localhost:8080/wallet_manager/kLine?type=m&symbol=ETHBTC
@implementation NetManager
//获取全部币种的接口
//http://192.168.1.27:8080/wallet_manager/currencyList
+(id)GETCurrencyListcompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",BASE_URL,@"/currencyList"];
    return [self GET:path parameters:nil completionHandler:^(id repsonseObj, NSError *error) {
        !handler ?:handler(repsonseObj,error);
    }];
}
+(void)GETKLineWthType:(NSString*)type Symbol:(NSString*)symbol completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"http://192.168.1.27:8080/wallet_manager/kLine?type=%@&symbol=%@",type,symbol];
    [self GET:path parameters:nil completionHandler:^(id repsonseObj, NSError *error) {
        !handler ?:handler(repsonseObj,error);
    }];
}
@end
