//
//  NetManager.m
//  TRProject


#import "NetManager.h"

#define BASE_URL @"http://159.138.7.23:8080/mission-wallet"

#define BTC_GETBalance_URL @"https://insight.bitpay.com/api/addr/"
#define BTC_GETTXList_URL @"https://insight.bitpay.com/api/txs"
#define BTC_GETCurrency_URL @"https://insight.bitpay.com/api/currency"
#define BTC_GETTXDetail_URL @"https://insight.bitpay.com/api/tx/"
#define BTC_BroadcastTransaction_URL @"https://insight.bitpay.com/api/tx/send"

//BTC testnet
//ChangeToTESTNET = 0正式网，= 1测试网
#define ChangeToTESTNET 1
#define BTC_GETBalance_URL_TESTNET @"http://47.96.79.74:3001/insight-api/addr/"
#define BTC_GETTXList_URL_TESTNET @"http://47.96.79.74:3001/insight-api/txs/"
#define BTC_GETCurrency_URL_TESTNET @"http://47.96.79.74:3001/insight-api/currency"
#define BTC_GETTXDetail_URL_TESTNET @"http://47.96.79.74:3001/insight-api/tx/"
#define BTC_BroadcastTransaction_URL_TESTNET @"http://47.96.79.74:3001/insight-api/tx/send"
/*
 *****************************************  行情  *******************************
 */
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
//获取交易对详情
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
/*
 *****************************************  BTC  *******************************
 */
//比特币美元汇率
+(void)GetCurrencyCompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@",ChangeToTESTNET == 1?BTC_GETCurrency_URL_TESTNET : BTC_GETCurrency_URL];
    NSDictionary *params = nil;
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        !handler ?:handler(repsonseObj,error);
    }];
}
//BTC查询余额https://insight.bitpay.com/api/addr/1D9NoaVRDVoGuUcCq735JSX52gcxvc1rf4
+(void)GetBalanceForBTCAdress:(NSString *)address noTxList:(int)noTxList completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",ChangeToTESTNET == 1?BTC_GETBalance_URL_TESTNET : BTC_GETBalance_URL,address];
    NSDictionary *params = nil;
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        !handler ?:handler(repsonseObj,error);
    }];
}
//BTC获取交易列表https://insight.bitpay.com/api/txs?address=1D9NoaVRDVoGuUcCq735JSX52gcxvc1rf4&pageNum=0
+(void)GetTXListBTCAdress:(NSString *)address pageNum:(int)pageNum completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@",ChangeToTESTNET == 1?BTC_GETTXList_URL_TESTNET : BTC_GETTXList_URL];
    NSDictionary *params = @{@"address":address == nil?@"":address,
                             @"pageNum":[NSString stringWithFormat:@"%d", pageNum],
                             };
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        !handler ?:handler(repsonseObj,error);
    }];
}
//获取交易详情
+(void)GetTXDetailByTXID:(NSString *)txid completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",ChangeToTESTNET == 1? BTC_GETTXDetail_URL_TESTNET : BTC_GETTXDetail_URL,txid];
    NSDictionary *params = nil;
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        !handler ?:handler(repsonseObj,error);
    }];
}

//获取UTXO https://insight.bitpay.com/api/addr/1NcXPMRaanz43b1kokpPuYDdk6GGDvxT2T/utxo
+(void)GetUTXOByBTCAdress:(NSString *)address completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@/utxo",ChangeToTESTNET == 1?BTC_GETBalance_URL_TESTNET : BTC_GETBalance_URL,address];
    NSDictionary *params = nil;
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        !handler ?:handler(repsonseObj,error);
    }];
}


//交易广播 Rawtx参数为交易信息签名
+(void)BroadcastBTCTransactionData:(NSString *)transaction completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@",ChangeToTESTNET == 1?BTC_BroadcastTransaction_URL_TESTNET : BTC_BroadcastTransaction_URL];
    NSDictionary *params = @{@"rawtx": transaction};
    [self POSTImage:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        !handler?:handler(repsonseObj,error);
    }];
}






@end
