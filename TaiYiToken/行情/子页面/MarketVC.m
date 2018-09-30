//
//  MarketVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/15.
//  Copyright © 2018年 Frued. All rights reserved.
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
@property(nonatomic)float TimeInterval;
//标记cell的rateBtn显示的数据，0 - priceChange/1 - amount
@property(nonatomic)int dataChoose;

//自选
@property(nonatomic)NSString *mysymbol;
@property(nonatomic)NSMutableArray <SymbolModel *>*deleteArray;
@end

@implementation MarketVC
-(void)viewWillAppear:(BOOL)animated{
    if (self.indexName == SELF_CHOOSE) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ifHasAccount"] == YES) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EditMYSymbol) name:@"EditMYSymbol" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ExitEditMySymbol) name:@"ExitEditMySymbol" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeleteSelectMySymbol) name:@"DeleteSelectMySymbol" object:nil];
        }
    }
    if(self.indexName == SEARCH_CHOOSE){
        if (self.modelarray == nil || self.modelarray.count == 0) {
            [self.view showMsg:NSLocalizedString(@"暂无数据", nil)];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mysymbol = @"";
    self.rateSortAdd = NO;
    self.priceSortAdd = NO;
    self.dataChoose = 0;
    self.TimeInterval = 5.0;
    self.deleteArray = [NSMutableArray array];
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
    alabel.text = NSLocalizedString(@"币名", nil);
    [headView addSubview:alabel];
    [alabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(0);
        make.width.equalTo(100);
        make.height.equalTo(30);
    }];
    
    _priceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_priceBtn setTitle:NSLocalizedString(@"最新价", nil) forState:UIControlStateNormal];
    [_priceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _priceBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _priceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_priceBtn addTarget:self action:@selector(switchActionPriceBtn) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_priceBtn];
    [_priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(ScreenWidth/2-20);
        make.width.equalTo(100);
        make.height.equalTo(30);
    }];
    
    _rateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_rateBtn setTitle:NSLocalizedString(@"涨跌幅", nil) forState:UIControlStateNormal];
    [_rateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _rateBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    _rateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rateBtn addTarget:self action:@selector(switchActionRateBtn) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_rateBtn];
    [_rateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.right.equalTo(0);
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
        make.right.equalTo(-10);
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
        make.right.equalTo(-10);
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
        make.right.equalTo(-10);
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
        make.right.equalTo(-10);
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
        [self sortingForRateAdd:NO];
    }else{
        [self.iv3 setSelected:YES];
        [self.iv4 setSelected:NO];
        [self sortingForRateAdd:YES];
    }
}
-(void)switchActionPriceBtn{
    self.rateSortAdd = NO;
    self.priceSortAdd = YES;
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
-(void)SwapModelFromIndex:(int)i ToIndex:(int)j{
    SymbolModel* temp = self.modelarray[i];
    self.modelarray[i]= self.modelarray[j];
    self.modelarray[j] = temp;
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
            if (self.dataChoose == 0) {
                if (add == YES) {//降序
                    if (modelj.priceChange < modelj1.priceChange) {
                        [self SwapModelFromIndex:j ToIndex:j+1];
                    }
                }else{//升序
                    if (modelj.priceChange > modelj1.priceChange) {
                       [self SwapModelFromIndex:j ToIndex:j+1];
                    }
                }
            }else{//self.dataChoose == 1
                if (add == YES) {//降序
                    if (modelj.amount < modelj1.amount) {
                       [self SwapModelFromIndex:j ToIndex:j+1];
                    }
                }else{//升序
                    if (modelj.amount > modelj1.amount) {
                        [self SwapModelFromIndex:j ToIndex:j+1];
                    }
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
                    [self SwapModelFromIndex:j ToIndex:j+1];
                }
            }else{//升序
                if (modelj.rmbClosePrice > modelj1.rmbClosePrice) {
                   [self SwapModelFromIndex:j ToIndex:j+1];
                }
            }
        }
    }
    [self.tableView reloadData];
}


//请求数据
-(void)GetData{
    if(self.indexName == SELF_CHOOSE){
        _mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
    }
   //  [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"MySymbol"];
    [NetManager GETCurrencyListWithMySymbol:self.mysymbol completionHandler:^(id responseObj, NSError *error) {
        if (!error) {
            
            NSNumber* code =(NSNumber*)responseObj[@"code"];
            long codex = code.longValue;
            if (codex == 0) {
                self.TimeInterval = 5.0;//请求正确，请求间隔恢复为5.0
                NSDictionary *result = responseObj[@"result"];
                if (result == nil) {
                    return ;
                }
                //[self.modelarray removeAllObjects];
                CurrencyModel *currency = [CurrencyModel parse:result];
                self.currency = currency;
                if(self.indexName == SELF_CHOOSE){
                    self.modelarray = currency.myMarket;
                }else if (self.indexName == BTC_CHOOSE){
                    self.modelarray = currency.btcMarket;
                }else if (self.indexName == ETH_CHOOSE){
                    self.modelarray = currency.ethMarket;
                }else if (self.indexName == HT_CHOOSE){
                    self.modelarray = currency.htMarket;
                }else if (self.indexName == USDT_CHOOSE){
                    self.modelarray = currency.usdtMarket;
                }
                if(self.priceSortAdd == YES){
                    if (self.iv1.selected == YES&&self.iv2.selected == NO) {
                        [self sortingForPriceAdd:YES];
                    }else{
                        [self sortingForPriceAdd:NO];
                    }
                }
                if(self.rateSortAdd == YES){
                    if (self.iv3.selected == YES&&self.iv4.selected == NO) {
                        [self sortingForRateAdd:YES];
                    }else{
                        [self sortingForRateAdd:NO];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
            }else{
                [self.view showMsg:responseObj[@"message"]];
                self.TimeInterval += 10.0;//请求出错，延长请求间隔
            }
            
        }else{
            self.TimeInterval += 10.0;//请求出错，延长请求间隔
        }
    }];
   
}
-(void)InitTimerRequest{
    //获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个定时器
    self.time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(self.TimeInterval* NSEC_PER_SEC);
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
-(void)viewDidAppear:(BOOL)animated{
    if(self.ifNeedRequestData == YES){
        [self InitTimerRequest];
    }else{
        [self.tableView reloadData];
    }
   
}
-(void)viewWillDisappear:(BOOL)animated{
    if(self.ifNeedRequestData == YES){
        dispatch_cancel(self.time);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.modelarray removeAllObjects];
}
#pragma tableView delegate
//********************编辑
-(void)EditMYSymbol{
    //开始编辑 停止数据请求
    dispatch_cancel(self.time);
    [self.tableView setEditing:YES animated:YES];
}
-(void)ExitEditMySymbol{
    //结束编辑 重新请求数据
    [self InitTimerRequest];
    [self.tableView setEditing:NO animated:YES];
    [self.deleteArray removeAllObjects];
}
-(void)DeleteSelectMySymbol{
    //结束编辑 重新请求数据
    [self InitTimerRequest];
    [self.tableView setEditing:NO animated:YES];
    if (self.deleteArray.count > 0) {
        [self DeleteMySymbolFromUserDefaults];
        [self.modelarray removeObjectsInArray:self.deleteArray];
        [self.deleteArray removeAllObjects];
        [self.tableView reloadData];
    }
}



-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}
-(void)DeleteMySymbolFromUserDefaults{
    NSString *mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
    if (mysymbol == nil) {
        mysymbol = @"";
    }
    for (SymbolModel *dicmodel in self.deleteArray) {
        SymbolModel *model = [SymbolModel parse:dicmodel];
        
        if([mysymbol containsString:model.symbol]){
            NSString *str = [NSString stringWithFormat:@"%@,",model.symbol];
            NSString *forestr = [mysymbol componentsSeparatedByString:str].firstObject;
            NSString *laststr = [mysymbol componentsSeparatedByString:str].lastObject;
            mysymbol = [NSString stringWithFormat:@"%@%@",forestr,laststr];
        }
    }
  [[NSUserDefaults standardUserDefaults] setObject:mysymbol forKey:@"MySymbol"];
}
//********************编辑
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing) {
        [self.deleteArray removeObject:self.modelarray[indexPath.row]];
        NSLog(@"\n deselect %ld ",self.deleteArray.count);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.isEditing) {
        [self.deleteArray addObject:self.modelarray[indexPath.row]];
         NSLog(@"\n deselect %ld",self.deleteArray.count);
    }else{
        MarketDetailVC *detailVC = [MarketDetailVC new];
        SymbolModel *modeldic = self.modelarray[indexPath.row];
        SymbolModel *model = [SymbolModel parse:modeldic];
        detailVC.symbolmodel =  model;
        detailVC.mysymbol = self.mysymbol;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
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
-(void)LookOtherDataOfCell:(UIButton *)btn{
    self.dataChoose = self.dataChoose == 0? 1 : 0;
    if(self.dataChoose == 0){
        [self.rateBtn setTitle:NSLocalizedString(@"涨跌幅", nil) forState:UIControlStateNormal];
        
        [self.tableView reloadData];
    }else{
        [self.rateBtn setTitle:NSLocalizedString(@"成交量", nil) forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
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
   
    NSString *name = [NSString stringWithFormat:@"%@",model.symbolName == NULL?@"":model.symbolName];
    [cell.namelabel setText:name];
    [cell.coinNamelabel setText:model.symbol];
    [cell.marketValuelabel setText:[NSString stringWithFormat:@"￥%.2f",model.rmbClosePrice]];
    [cell.pricelabel setText:[NSString stringWithFormat:@"%.6f",model.closePrice]];
    if (self.dataChoose == 0) {
         [cell.rateBtn setTitle:model.priceChange >0 ?[NSString stringWithFormat:@"+%.2f%%",model.priceChange]:[NSString stringWithFormat:@"%.2f%%",model.priceChange] forState:UIControlStateNormal];
    }else{
         [cell.rateBtn setTitle:[NSString stringWithFormat:@"%.0f",model.amount] forState:UIControlStateNormal];
    }
    [cell.rateBtn setBackgroundColor:[UIColor colorWithHexString:@"#DBDBDB"]];
    [cell.rateBtn setBackgroundColor:model.priceChange > 0?BTNRISECOLOR : BTNFALLCOLOR];
    [cell.rateBtn addTarget:self action:@selector(LookOtherDataOfCell:) forControlEvents:UIControlEventTouchUpInside];
    if (self.indexName == SELF_CHOOSE) {
        UIView *bcView = [UIView new];
        bcView.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = bcView;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
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
        
        if (self.indexName == SELF_CHOOSE) {
            // 编辑模式下是否可以选中
            _tableView.allowsSelectionDuringEditing = YES;
            // 编辑模式下是否可以多选
            _tableView.allowsMultipleSelectionDuringEditing = YES;
        }
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
    if (self.indexName == SELF_CHOOSE) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ifHasAccount"] == YES) {
            [[NSNotificationCenter defaultCenter]removeObserver:self];
        }
    }
}

@end
