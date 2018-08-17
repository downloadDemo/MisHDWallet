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
#import "MarketDetailVC.h"
@interface SelfChooseVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)dispatch_source_t time;
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
}

//请求数据
-(void)GetData{
    // NSLog(@"sssss   ****%@",self.indexName);
    [NetManager GETCurrencyListcompletionHandler:^(id responseObj, NSError *error) {
        if (!error) {
            NSNumber* code =(NSNumber*)responseObj[@"code"];
            long codex = code.longValue;
            if (codex == 0) {
                NSArray *arr = responseObj[@"result"];
                if (arr == nil) {
                    return ;
                }
                [self.modelarray removeAllObjects];
                for (id obj in arr) {
                    CurrencyModel *currency = [CurrencyModel parse:obj];
                    [self.modelarray addObject:currency];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
            }else{
                [self.view showMsg:responseObj[@"message"]];
            }
        }else{
            
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    
    //获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个定时器
    self.time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(5.0* NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(self.time, start, interval, 0);
    //设置回调
    dispatch_source_set_event_handler(self.time, ^{
        [self GetData];
      
    });
    //由于定时器默认是暂停的所以我们启动一下
    //启动定时器
    dispatch_resume(self.time);
}
-(void)viewWillDisappear:(BOOL)animated{
    dispatch_cancel(self.time);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MarketDetailVC *detailVC = [MarketDetailVC new];
    detailVC.model =  self.modelarray != nil? nil : self.modelarray[indexPath.row];
    [self presentViewController:detailVC animated:YES completion:nil];
}

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
    [cell.ratelabel setText:[NSString stringWithFormat:@"%.2f%%",model.priceChangePercent]];
    
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
            make.bottom.equalTo(-49);
        }];
    }
    return _tableView;
}

@end
