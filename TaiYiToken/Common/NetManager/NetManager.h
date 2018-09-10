//
//  NetManager.h
//  TRProject


#import "BaseNetworking.h"
#import "Constant.h"
#import <ethers/Account.h>
@interface NetManager : BaseNetworking
//******************  行情 ****************
+(id)GETCurrencyListWithMySymbol:(NSString *)mySymbol  completionHandler:(void (^)(id responseObj, NSError *error))handler;
+(void)GETKLineWthkSearchSymbol:(NSString*)symbol LineType:(KLineType)kLineType searchNum:(NSInteger)searchNum completionHandler:(void (^)(id responseObj, NSError *error))handler;

//****************** BTC交易 ****************
//比特币美元汇率
+(void)GetCurrencyCompletionHandler:(void (^)(id responseObj, NSError *error))handler;
//BTC查询余额
+(void)GetBalanceForBTCAdress:(NSString *)address noTxList:(int)noTxList completionHandler:(void (^)(id responseObj, NSError *error))handler;
//BTC获取交易列表
+(void)GetTXListBTCAdress:(NSString *)address pageNum:(int)pageNum completionHandler:(void (^)(id responseObj, NSError *error))handler;
//获取交易详情
+(void)GetTXDetailByTXID:(NSString *)txid completionHandler:(void (^)(id responseObj, NSError *error))handler;
//获取UTXO
+(void)GetUTXOByBTCAdress:(NSString *)address completionHandler:(void (^)(id responseObj, NSError *error))handler;
//交易广播 Rawtx参数为交易信息签名
+(void)BroadcastBTCTransactionData:(NSData *)transaction completionHandler:(void (^)(id responseObj, NSError *error))handler;
@end
