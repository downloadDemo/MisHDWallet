//
//  NetManager.m
//  TRProject


#import "NetManager.h"

#define BASE_URL @"http://159.138.7.23:8080/mission-wallet"
//获取行情列表 mySymbol自选交易对，没有填空
//http://159.138.7.23:8080/mission-wallet/getMarketTickers?mySymbol=ETH/BTC,ETH/USDT
//获取交易对详情
//http://159.138.7.23:8080/mission-wallet/getSymbolInfo?searchSymbol=EOS/ETH&kLineType=1&searchNum=500

@implementation NetManager
//获取全部币种的接口
//http://192.168.1.27:8080/wallet_manager/currencyList
+(id)GETCurrencyListWithMySymbol:(NSString *)mySymbol  completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",BASE_URL,@"/getMarketTickers"];
    NSDictionary *params = @{@"mySymbol":mySymbol == nil?@"":mySymbol};
    return [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        !handler ?:handler(repsonseObj,error);
    }];
}
+(void)GETKLineWthkSearchSymbol:(NSString*)symbol LineType:(KLineType)kLineType searchNum:(NSInteger)searchNum completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",BASE_URL,@"/getSymbolInfo"];
    NSDictionary *params = @{@"searchSymbol":symbol == nil?@"":symbol,
                             @"kLineType":[NSString stringWithFormat:@"%u", kLineType],
                             @"searchNum":[NSString stringWithFormat:@"%ld",searchNum]
                             };
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        !handler ?:handler(repsonseObj,error);
    }];
}
@end
