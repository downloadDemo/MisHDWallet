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
@property(nonatomic)UIButton *iv3;
@property(nonatomic)UIButton *iv4;
@property(nonatomic)UIButton *priceBtn;
@property(nonatomic)UIButton *rateBtn;
@property(nonatomic)BOOL rateSortAdd;
@property(nonatomic)BOOL priceSortAdd;
@end

@implementation MarketVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.rateSortAdd = NO;
    self.priceSortAdd = NO;
   
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
    
    _priceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_priceBtn setTitle:@"最新价" forState:UIControlStateNormal];
    [_priceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _priceBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _priceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_priceBtn addTarget:self action:@selector(switchActionPriceBtn) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_priceBtn];
    [_priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(ScreenWidth/2-10);
        make.width.equalTo(100);
        make.height.equalTo(30);
    }];
    
    _rateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_rateBtn setTitle:@"涨跌幅" forState:UIControlStateNormal];
    [_rateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _rateBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    _rateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rateBtn addTarget:self action:@selector(switchActionRateBtn) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_rateBtn];
    [_rateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
  
    [self initSortButtons];
    [self.tableView reloadData];
  
}
-(void)initSortButtons{
    /*
     最新价按钮
     */
    _iv1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_iv1 setImage:[UIImage imageNamed:@"ico_up_default"] forState:UIControlStateNormal];
    [_iv1 setImage:[UIImage imageNamed:@"ico_up_select"] forState:UIControlStateSelected];
    [self.iv1 setSelected:NO];
    [_priceBtn addSubview:_iv1];
    [_iv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(-4);
        make.right.equalTo(-17);
        make.width.equalTo(10);
        make.height.equalTo(6);
    }];
    _iv2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_iv2 setImage:[UIImage imageNamed:@"ico_down_default"] forState:UIControlStateNormal];
    [_iv2 setImage:[UIImage imageNamed:@"ico_down_select"] forState:UIControlStateSelected];
    [self.iv2 setSelected:NO];
    [_priceBtn addSubview:_iv2];
    [_iv2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(4);
        make.right.equalTo(-17);
        make.width.equalTo(10);
        make.height.equalTo(6);
    }];
    
    /*
     涨跌按钮
     */
    _iv3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_iv3 setImage:[UIImage imageNamed:@"ico_up_default"] forState:UIControlStateNormal];
    [_iv3 setImage:[UIImage imageNamed:@"ico_up_select"] forState:UIControlStateSelected];
    [self.iv3 setSelected:NO];
    [_rateBtn addSubview:_iv3];
    [_iv3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(-4);
        make.right.equalTo(-17);
        make.width.equalTo(10);
        make.height.equalTo(6);
    }];
    _iv4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_iv4 setImage:[UIImage imageNamed:@"ico_down_default"] forState:UIControlStateNormal];
    [_iv4 setImage:[UIImage imageNamed:@"ico_down_select"] forState:UIControlStateSelected];
    [self.iv4 setSelected:NO];
    [_rateBtn addSubview:_iv4];
    [_iv4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(4);
        make.right.equalTo(-17);
        make.width.equalTo(10);
        make.height.equalTo(6);
    }];
}
-(void)switchActionRateBtn{
    self.rateSortAdd = YES;
    self.priceSortAdd = NO;
    [self.iv1 setSelected:NO];
    [self.iv2 setSelected:NO];
    if (self.iv3.selected == YES&&self.iv4.selected == NO) {
        [self.iv3 setSelected:NO];
        [self.iv4 setSelected:YES];
        [_rateBtn setTitle:@"跌幅" forState:UIControlStateNormal];
        [self sortingForRateAdd:NO];
    }else{
        [_rateBtn setTitle:@"涨幅" forState:UIControlStateNormal];
        [self.iv3 setSelected:YES];
        [self.iv4 setSelected:NO];
        [self sortingForRateAdd:YES];
    }
}
-(void)switchActionPriceBtn{
    self.rateSortAdd = NO;
    self.priceSortAdd = YES;
    [_rateBtn setTitle:@"涨跌幅" forState:UIControlStateNormal];
    [self.iv3 setSelected:NO];
    [self.iv4 setSelected:NO];
    
    if (self.iv1.selected == YES&&self.iv2.selected == NO) {
        [self.iv1 setSelected:NO];
        [self.iv2 setSelected:YES];
        [self sortingForPriceAdd:NO];
    }else{
        [self.iv1 setSelected:YES];
        [self.iv2 setSelected:NO];
        [self sortingForPriceAdd:YES];
    }
}
/* 涨跌排序 */
-(void)sortingForRateAdd:(BOOL)add{
    if (self.modelarray == nil || self.modelarray.count == 0) {
        return;
    }
    for (int i=0; i<=self.modelarray.count-1; i++) {
        for (int j=0; j<self.modelarray.count-1-i; j++) {
            SymbolModel *modelj = [SymbolModel parse:self.modelarray[j]];
            SymbolModel *modelj1 = [SymbolModel parse:self.modelarray[j+1]];
             if (add == YES) {//降序
                 
            if (modelj.priceChange < modelj1.priceChange) {
                SymbolModel* temp = self.modelarray[j];
                self.modelarray[j]= self.modelarray[j+1];
                self.modelarray[j+1] = temp;
            }
            }else{//升序
                if (modelj.priceChange > modelj1.priceChange) {
                    SymbolModel* temp = self.modelarray[j];
                    self.modelarray[j]= self.modelarray[j+1];
                    self.modelarray[j+1] = temp;
                }
            }
        }
    }
    [self.tableView reloadData];
}

/* 涨跌排序 */
-(void)sortingForPriceAdd:(BOOL)add{
    if (self.modelarray == nil || self.modelarray.count == 0) {
        return;
    }
    for (int i=0; i<=self.modelarray.count-1; i++) {
        for (int j=0; j<self.modelarray.count-1-i; j++) {
            SymbolModel *modelj = [SymbolModel parse:self.modelarray[j]];
            SymbolModel *modelj1 = [SymbolModel parse:self.modelarray[j+1]];
            if (add == YES) {//降序
                
                if (modelj.rmbClosePrice < modelj1.rmbClosePrice) {
                    SymbolModel* temp = self.modelarray[j];
                    self.modelarray[j]= self.modelarray[j+1];
                    self.modelarray[j+1] = temp;
                }
            }else{//升序
                if (modelj.rmbClosePrice > modelj1.rmbClosePrice) {
                    SymbolModel* temp = self.modelarray[j];
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
    
    NSString *mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
    [NetManager GETCurrencyListWithMySymbol:mysymbol completionHandler:^(id responseObj, NSError *error) {
        if (!error) {
            
            NSNumber* code =(NSNumber*)responseObj[@"code"];
            long codex = code.longValue;
            if (codex == 0) {
                NSDictionary *result = responseObj[@"result"];
                if (result == nil) {
                    return ;
                }
                //[self.modelarray removeAllObjects];
                CurrencyModel *currency = [CurrencyModel parse:result];
                self.currency = currency;
                if([self.indexName isEqualToString:@"a"]){
                    self.modelarray = currency.myMarket;
                }else if ([self.indexName isEqualToString:@"b"]){
                    self.modelarray = currency.btcMarket;
                }else if ([self.indexName isEqualToString:@"c"]){
                    self.modelarray = currency.ethMarket;
                }else if ([self.indexName isEqualToString:@"d"]){
                    self.modelarray = currency.htMarket;
                }else if ([self.indexName isEqualToString:@"e"]){
                    self.modelarray = currency.usdtMarket;
                }
                if(self.priceSortAdd == YES){
                    [self sortingForPriceAdd:YES];
                }
                if(self.rateSortAdd == YES){
                    [self sortingForRateAdd:YES];
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
    if([self.indexName isEqualToString:@"search"]||self.ifNeedRequestData == YES){
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
       
    }else{
        [self.tableView reloadData];
    }
   
}
-(void)viewWillDisappear:(BOOL)animated{
    if([self.indexName isEqualToString:@"search"]||self.ifNeedRequestData == YES){
        dispatch_cancel(self.time);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MarketDetailVC *detailVC = [MarketDetailVC new];
   // detailVC.model =  self.modelarray == nil? nil : self.modelarray[indexPath.row];
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
    if(indexPath.row>self.modelarray.count - 1||indexPath.row<0){
        return nil;
    }
    SymbolModel *modeldic = self.modelarray[indexPath.row];
    SymbolModel *model = [SymbolModel parse:modeldic];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *name = [NSString stringWithFormat:@"%@",model.symbolName == NULL?@"":model.symbolName];
    [cell.namelabel setText:name];
    [cell.coinNamelabel setText:model.symbol];
    [cell.marketValuelabel setText:[NSString stringWithFormat:@"%.2f",model.rmbClosePrice]];
    [cell.pricelabel setText:[NSString stringWithFormat:@"￥%.3f",model.closePrice]];
    [cell.rateBtn setTitle:[NSString stringWithFormat:@"%.2f%%",model.priceChange] forState:UIControlStateNormal];

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
            make.bottom.equalTo(0);
        }];
    }
    return _tableView;
}
-(void)dealloc {

}

@end
