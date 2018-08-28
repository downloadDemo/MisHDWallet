//
//  NetManager.h
//  TRProject


#import "BaseNetworking.h"
#import "Constant.h"
@interface NetManager : BaseNetworking
+(id)GETCurrencyListWithMySymbol:(NSString *)mySymbol  completionHandler:(void (^)(id responseObj, NSError *error))handler;
+(void)GETKLineWthkSearchSymbol:(NSString*)symbol LineType:(KLineType)kLineType searchNum:(NSInteger)searchNum completionHandler:(void (^)(id responseObj, NSError *error))handler;
@end
