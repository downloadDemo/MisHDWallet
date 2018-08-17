//
//  MarketVC.m
//  TaiYiToken
//
//  Created by admin on 2018/8/15.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MarketVC.h"
#import "MarketCell.h"
#import "MarketDetailVC.h"
@interface MarketVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)dispatch_source_t time;
@property(nonatomic)UIButton *iv1;
@property(nonatomic)UIButton *iv2;
@property(nonatomic)BOOL Add;
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
  
    if ([self.indexName isEqualToString:@"c"]) {
        //涨跌排序
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iv1Click) name:@"iv1" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iv2Click) name:@"iv2" object:nil];
        self.Add = YES;
    }
    [self.tableView reloadData];
  
}

-(void)iv1Click{
    [self sortingForBubblingAdd:NO];
    self.Add = NO;
    NSLog(@"iv1");
}
-(void)iv2Click{
    [self sortingForBubblingAdd:YES];
    self.Add = YES;
    NSLog(@"iv2");
}
-(void)sortingForBubblingAdd:(BOOL)add{
    if (self.modelarray == nil || self.modelarray.count == 0) {
        return;
    }
    for (int i=0; i<=self.modelarray.count-1; i++) {
        for (int j=0; j<self.modelarray.count-1-i; j++) {
             if (add == YES) {//降序
            if (((CurrencyModel*)self.modelarray[j]).priceChangePercent < ((CurrencyModel*)self.modelarray[j+1]).priceChangePercent) {
                CurrencyModel* temp = self.modelarray[j];
                self.modelarray[j]= self.modelarray[j+1];
                self.modelarray[j+1] = temp;
            }
            }else{//升序
                if (((CurrencyModel*)self.modelarray[j]).priceChangePercent > ((CurrencyModel*)self.modelarray[j+1]).priceChangePercent) {
                    CurrencyModel* temp = self.modelarray[j];
                    self.modelarray[j]= self.modelarray[j+1];
                    self.modelarray[j+1] = temp;
                }
            }
        }
    }
    [self.tableView reloadData];
}




//请求数据
-(void)GetData{
  
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
                if ([self.indexName isEqualToString:@"c"]) {
                    if (self.Add == YES) {
                        [self sortingForBubblingAdd:YES];
                    }else{
                        [self sortingForBubblingAdd:NO];
                    }
                    [self sortingForBubblingAdd:YES];
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
        //dispatch_cancel(self.time);
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
    detailVC.model =  self.modelarray == nil? nil : self.modelarray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
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
    [cell.ratelabel setText:[self.indexName isEqualToString:@"d"]?[NSString stringWithFormat:@"%.2f",model.quoteVolume]:[NSString stringWithFormat:@"%.2f%%",model.priceChangePercent]];
    
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
            make.bottom.equalTo(-49);
        }];
    }
    return _tableView;
}
-(void)dealloc {
    if ([self.indexName isEqualToString:@"c"]) {
         [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
@end
