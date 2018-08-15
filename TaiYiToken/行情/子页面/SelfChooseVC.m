//
//  SelfChooseVC.m
//  TaiYiToken
//
//  Created by admin on 2018/8/15.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SelfChooseVC.h"
#import "SelfChooseCell.h"
#import "CurrencyModel.h"
@interface SelfChooseVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic)UITableView *tableView;
@property(nonatomic)NSMutableArray <CurrencyModel*> *modelarray;

@end

@implementation SelfChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modelarray = [NSMutableArray array];
   
    /*测试数据*/
    NSDictionary* responseObj = @{
                    @"code": @0,
                    @"message": @"成功",
                    @"result": @[
                            @{
                                @"symbol": @"ETH/BTC",
                                @"priceChangePercent": @0.42,
                                @"lastPrice": @0.044485,
                                @"dollar": @280.82535,
                                @"quoteVolume": @9879.707,
                                @"rmb": @1933.6509,
                                @"marketValue": @0,
                                @"openPrice": @0.044299,
                                @"highPrice": @0.046369,
                                @"lowPrice": @0.041941,
                                @"circulation": @0,
                                @"describe": @"",
                                @"turnover": @0
                                },
                            @{
                                @"symbol": @"LTC/BTC",
                                @"priceChangePercent": @1.52,
                                @"lastPrice": @0.008747,
                                @"dollar": @55.21815,
                                @"quoteVolume": @1578.4524,
                                @"rmb": @380.2101,
                                @"marketValue": @0,
                                @"openPrice": @0.008616,
                                @"highPrice": @0.009012,
                                @"lowPrice": @0.008445,
                                @"circulation": @0,
                                @"describe": @"",
                                @"turnover": @0
                                }]};
    NSArray *arr = responseObj[@"result"];
    for (id obj in arr) {
        CurrencyModel *currency = [CurrencyModel parse:obj];
        [self.modelarray addObject:currency];
    }
   
    [self.tableView reloadData];

    //服务器处于内网 无法访问
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NetManager GETCurrencyListcompletionHandler:^(id responseObj, NSError *error) {
           if (!error) {
                
                responseObj = @{
                    @"code": @0,
                    @"message": @"成功",
                    @"result": @[
                               @{
                                   @"symbol": @"ETH/BTC",
                                   @"priceChangePercent": @0.42,
                                   @"lastPrice": @0.044485,
                                   @"dollar": @280.82535,
                                   @"quoteVolume": @9879.707,
                                   @"rmb": @1933.6509,
                                   @"marketValue": @0,
                                   @"openPrice": @0.044299,
                                   @"highPrice": @0.046369,
                                   @"lowPrice": @0.041941,
                                   @"circulation": @0,
                                   @"describe": @"",
                                   @"turnover": @0
                               },
                               @{
                                   @"symbol": @"LTC/BTC",
                                   @"priceChangePercent": @1.52,
                                   @"lastPrice": @0.008747,
                                   @"dollar": @55.21815,
                                   @"quoteVolume": @1578.4524,
                                   @"rmb": @380.2101,
                                   @"marketValue": @0,
                                   @"openPrice": @0.008616,
                                   @"highPrice": @0.009012,
                                   @"lowPrice": @0.008445,
                                   @"circulation": @0,
                                   @"describe": @"",
                                   @"turnover": @0
                               }]};
                NSDictionary *ret = responseObj[@"ret"];
                NSNumber *codestr = (NSNumber*)ret[@"code"];
                if ([codestr isEqualToNumber:@0]) {
                    NSArray *arr = responseObj[@"result"];
                    for (id obj in arr) {
                        CurrencyModel *currency = [CurrencyModel parse:obj];
                        [self.modelarray addObject:currency];
                    }
                    dispatch_async_on_main_queue(^{
                        [self.tableView reloadData];
                    });
                }
            }else{

            }
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma tableView delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelarray == nil?0:self.modelarray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelfChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelfChooseCell"];
    if (cell == nil) {
        cell = [SelfChooseCell new];
    }
    CurrencyModel *model = self.modelarray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;


//    "symbol": "ETH/BTC",
//    "priceChangePercent": 0.42,
//    "lastPrice": 0.044485,
//    "dollar": 280.82535,
//    "quoteVolume": 9879.707,
//    "rmb": 1933.6509,
//    "marketValue": 0,
//    "openPrice": 0.044299,
//    "highPrice": 0.046369,
//    "lowPrice": 0.041941,
//    "circulation": 0,
//    "describe": null,
//    "turnover": 0
    [cell.coinNamelabel setText:model.symbol];
    [cell.marketValuelabel setText:[NSString stringWithFormat:@"市值：%.2f",model.marketValue]];
    [cell.pricelabel setText:[NSString stringWithFormat:@"%.3f",model.lastPrice]];
    [cell.rmblabel setText:[NSString stringWithFormat:@"Rmb:%.2f",model.rmb]];
    [cell.ratelabel setText:[NSString stringWithFormat:@"%.2f%%",model.priceChangePercent*100]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins  = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[SelfChooseCell class] forCellReuseIdentifier:@"SelfChooseCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.right.equalTo(0);
            make.bottom.equalTo(-119);
        }];
    }
    return _tableView;
}

@end
