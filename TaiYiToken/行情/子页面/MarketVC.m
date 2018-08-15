//
//  MarketVC.m
//  TaiYiToken
//
//  Created by admin on 2018/8/15.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MarketVC.h"
#import "MarketCell.h"
#import "CurrencyModel.h"
@interface MarketVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic)UITableView *tableView;
@property(nonatomic)NSMutableArray <CurrencyModel*> *modelarray;

@end

@implementation MarketVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.modelarray = [NSMutableArray array];
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(30);
    }];
    
    UILabel *alabel = [[UILabel alloc] init];
    alabel.textColor = [UIColor grayColor];
    alabel.font = [UIFont systemFontOfSize:15];
    alabel.textAlignment = NSTextAlignmentLeft;
    alabel.numberOfLines = 1;
    alabel.text = @"币名";
    [headView addSubview:alabel];
    [alabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(0);
        make.width.equalTo(100);
        make.height.equalTo(30);
    }];
    
    UILabel *blabel = [[UILabel alloc] init];
    blabel.textColor = [UIColor grayColor];
    blabel.font = [UIFont systemFontOfSize:15];
    blabel.textAlignment = NSTextAlignmentLeft;
    blabel.numberOfLines = 1;
    blabel.text = @"最新价格";
    [headView addSubview:blabel];
    [blabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(ScreenWidth/2-10);
        make.width.equalTo(100);
        make.height.equalTo(30);
    }];
    
    UILabel *clabel = [[UILabel alloc] init];
    clabel.textColor = [UIColor grayColor];
    clabel.font = [UIFont systemFontOfSize:15];
    clabel.textAlignment = NSTextAlignmentRight;
    clabel.numberOfLines = 1;
    clabel.text = [self.indexName isEqualToString:@"d"]?@"成交量":@"24H 涨跌";
    [headView addSubview:clabel];
    [clabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.right.equalTo(-16);
        make.width.equalTo(100);
        make.height.equalTo(30);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [headView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(1);
    }];
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
    MarketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MarketCell"];
    if (cell == nil) {
        cell = [MarketCell new];
    }
    CurrencyModel *model = self.modelarray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.namelabel setText:[NSString stringWithFormat:@"#%ld",indexPath.row]];
    [cell.coinNamelabel setText:model.symbol];
    [cell.marketValuelabel setText:[NSString stringWithFormat:@"市值：%.2f",model.marketValue]];
    [cell.pricelabel setText:[NSString stringWithFormat:@"￥%.3f",model.rmb]];
    [cell.ratelabel setTextColor:[self.indexName isEqualToString:@"d"]?[UIColor blackColor]:[UIColor textOrangeColor]];
    [cell.ratelabel setText:[self.indexName isEqualToString:@"d"]?[NSString stringWithFormat:@"%.2f",model.quoteVolume]:[NSString stringWithFormat:@"%.2f%%",model.priceChangePercent*100]];
    
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
        [_tableView registerClass:[MarketCell class] forCellReuseIdentifier:@"MarketCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(30);
            make.left.right.equalTo(0);
            make.bottom.equalTo(-119);
        }];
    }
    return _tableView;
}
@end
