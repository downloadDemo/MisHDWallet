//
//  NetManager.h
//  TRProject


#import "BaseNetworking.h"

@interface NetManager : BaseNetworking
+(id)GETCurrencyListcompletionHandler:(void (^)(id responseObj, NSError *))handler;
@end
