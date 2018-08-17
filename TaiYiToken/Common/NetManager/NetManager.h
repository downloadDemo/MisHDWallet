//
//  NetManager.h
//  TRProject


#import "BaseNetworking.h"

@interface NetManager : BaseNetworking
+(id)GETCurrencyListcompletionHandler:(void (^)(id responseObj, NSError *))handler;
+(void)GETKLineWthType:(NSString*)type Symbol:(NSString*)symbol completionHandler:(void (^)(id responseObj, NSError *error))handler;
@end
