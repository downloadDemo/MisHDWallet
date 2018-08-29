//
//  MarketDetailVC.m
//  TaiYiToken
//
//  Created by admin on 2018/8/16.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MarketDetailVC.h"
#import "DataView.h"
#import "ButtonsView.h"
#import "DataPointView.h"
#import "YYStock.h"
#import "YYStockVariable.h"
#import "UIColor+YYStockTheme.h"
#import "YYLineDataModel.h"
@interface MarketDetailVC ()<UIScrollViewDelegate,UIScrollViewAccessibilityDelegate,YYStockDataSource>
//
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *bridgeContentView;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)DataView *dataView;
@property(nonatomic)ButtonsView *buttonsView;
@property(nonatomic,strong)DataPointView *dataSelectView;
@property(nonatomic,strong)UIView *headBackgroundView;
@property(nonatomic,strong)UIButton *collectBtn;
@property(nonatomic,assign)KLineType linetype;
/***** K线图 ****/
@property (strong, nonatomic) YYStock *stock;
@property (strong, nonatomic) UIView *stockContainerView;

@property (strong, nonatomic) NSMutableDictionary *stockDatadict;
@property (copy, nonatomic) NSArray *stockDataKeyArray;
@property (copy, nonatomic) NSArray *stockTopBarTitleArray;

@property(nonatomic,copy)NSMutableArray <YYLineDataModel*> *linedataarray;
@end

@implementation MarketDetailVC
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.hidesBottomBarWhenPushed = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    //离开页面时 存储自选
    _mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
    if (_mysymbol == nil) {
        _mysymbol = @"";    //qqq,
    }
    if (self.collectBtn.selected == YES) {
        _mysymbol = [NSString stringWithFormat:@"%@,%@",self.symbolmodel.symbol,_mysymbol];
    }else{
        NSString *str = [NSString stringWithFormat:@"%@,",self.symbolmodel.symbol];
        NSString *forestr = [_mysymbol componentsSeparatedByString:str].firstObject;
        NSString *laststr = [_mysymbol componentsSeparatedByString:str].lastObject;
        _mysymbol = [NSString stringWithFormat:@"%@%@",forestr,laststr];
    }
    [[NSUserDefaults standardUserDefaults] setObject:_mysymbol forKey:@"MySymbol"];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
   
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
/******************************************* 上方数据视图 ************************************************/
-(void)initHead{
    //头部背景
    _headBackgroundView = [UIView new];
    _headBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#5091FF"];
    [self.view addSubview:_headBackgroundView];
    [_headBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(130);
    }];
    UILabel *symbolLabel = [UILabel new];
    symbolLabel.font = [UIFont boldSystemFontOfSize:18];
    symbolLabel.text = self.symbolmodel.symbol;
    symbolLabel.textColor = [UIColor textWhiteColor];
    symbolLabel.textAlignment = NSTextAlignmentCenter;
    [self.headBackgroundView addSubview:symbolLabel];
    [symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.centerY.equalTo(-15);
    }];
    UILabel *symbolNameLabel = [UILabel new];
    symbolNameLabel.font = [UIFont systemFontOfSize:10];
    symbolNameLabel.textColor = [UIColor textWhiteColor];
    symbolNameLabel.text = self.symbolmodel.symbolName;
    symbolNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.headBackgroundView addSubview:symbolNameLabel];
    [symbolNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.centerY.equalTo(5);
    }];
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn setImage:[UIImage imageNamed:@"ico_focus_default"] forState:UIControlStateNormal];
    [_collectBtn setImage:[UIImage imageNamed:@"ico_focus_select"] forState:UIControlStateSelected];
    _mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
    if ([_mysymbol containsString:self.symbolmodel.symbol]) {
        [self.collectBtn setSelected:YES];
    }else{
        [self.collectBtn setSelected:NO];
    }
    [_collectBtn addTarget:self action:@selector(collectToMySymbol) forControlEvents:UIControlEventTouchUpInside];
    [self.headBackgroundView addSubview:_collectBtn];
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.centerY.equalTo(-10);
        make.width.height.equalTo(30);
    }];
}
-(void)initUI{
    
    //基本数据
    _dataView = [[DataView alloc]init];
    _dataView.backgroundColor = [UIColor whiteColor];
    [_bridgeContentView addSubview:_dataView];
    [_dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(0);
        make.height.equalTo(100);
    }];
    _dataView.dollarlabel.text = [NSString stringWithFormat:@"%.2f", self.symbolmodel.dollarClosePrice];
    _dataView.rmblabel.text = [NSString stringWithFormat:@"≈￥%.2f",self.symbolmodel.rmbClosePrice];
    _dataView.ratelabel.text = self.symbolmodel.priceChange > 0? [NSString stringWithFormat:@"+%.2f%%",self.symbolmodel.priceChange]: [NSString stringWithFormat:@"%.2f%%",self.symbolmodel.priceChange];
    _dataView.marketpricelabel.text = [NSString stringWithFormat:@"市值 ￥    24h交易量 %.2f    换手率 ",self.symbolmodel.amount];
    

    _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _backBtn.backgroundColor = [UIColor clearColor];
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn setImage:[UIImage imageNamed:@"ico_right_arrow"] forState:UIControlStateNormal];
    _backBtn.tintColor = RGB(255, 255, 255);
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    _backBtn.userInteractionEnabled = YES;
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(40);
        make.height.equalTo(25);
        make.left.equalTo(10);
        make.width.equalTo(30);
    }];
    
    self.buttonsView = [[ButtonsView alloc]initWithFrame:CGRectMake(0, 105, ScreenWidth, 35)];
    [self.scrollView addSubview:self.buttonsView];

    [self.buttonsView initButtonsViewWidth:ScreenWidth Height:35];
    int i = 0;
    [self.buttonsView.FIVEMINBtn setSelected:YES];//默认
    for (UIButton *btn in self.buttonsView.btnArray) {
        btn.tag = i;
        i++;
        [btn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
/*
 加入/移除 自选
 */
-(void)collectToMySymbol{
    if (_collectBtn.selected == YES) {
        [_collectBtn setSelected:NO];
    }else{
        [_collectBtn setSelected:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.linetype = FIVE_MIN;
    [self initHead];
    [self scrollView];
    _bridgeContentView = [UIView new];
    [_scrollView addSubview:_bridgeContentView];
    [_bridgeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.height.equalTo(self.scrollView);
    }];
    [self initUI];
    
    _dataSelectView = [DataPointView new];
    _dataSelectView.backgroundColor = RGB(250, 250, 250);
    [_bridgeContentView addSubview:_dataSelectView];
    [_dataSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.top.equalTo(self.buttonsView.mas_bottom);
        make.left.equalTo(0);
        make.height.equalTo(15);
    }];
    [self RequestKLineData];
}
-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollView.backgroundColor = RGB(230, 230, 230);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 300);
        _scrollView.delegate =self;
        // _scrollView.scrollsToTop = YES;
        //  _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(80);
            make.bottom.equalTo(-49);
        }];
        
    }
    
    return _scrollView;
}
/******************************************* 上方数据视图 ************************************************/


/******************************************* K线图 ************************************************/

/*
选择k线图时间
 */
-(void)switchBtnClick:(UIButton*)button{
    for (UIButton *btn in self.buttonsView.btnArray) {
        if(btn.tag != button.tag){
            [btn setSelected:NO];
        }
    }
    [button setSelected:YES];
    self.linetype = (int)button.tag;
    //修改数据
    
}

- (void)initStockView {
    [YYStockVariable setStockLineWidthArray:@[@6,@6,@6,@6]];
    self.stockContainerView = [UIView new];
    self.stockContainerView.backgroundColor = [UIColor whiteColor];
    [self.bridgeContentView addSubview:_stockContainerView];
    [_stockContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dataSelectView.mas_bottom).equalTo(5);
        make.left.right.equalTo(0);
        make.height.equalTo(150);
    }];
    
    
    YYStock *stock = [[YYStock alloc]initWithFrame:self.stockContainerView.frame dataSource:self];
    _stock = stock;
    [self.stockContainerView addSubview:stock.mainView];
    [stock.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.stockContainerView);
    }];
   
    
}

-(void)CreateKline{
    
}



-(void)parseKlineData:(NSMutableArray *)kLineDataArray{
    NSMutableArray <klineData*> *parsearray = [NSMutableArray new];
    self.linedataarray = [NSMutableArray new];
    for (NSDictionary *dic in kLineDataArray) {
        klineData *data = [klineData parse:dic];
        [parsearray addObject:data];
        YYLineDataModel *model = [YYLineDataModel new];
        model.Close = [NSNumber numberWithFloat:data.rmbClosePrice];
        model.Open = [NSNumber numberWithFloat:data.rmbOpenPrice];
        model.Low = [NSNumber numberWithFloat:data.rmbLowPrice];
        model.High = [NSNumber numberWithFloat:data.rmbHighPrice];
        model.Volume =data.rmbVol;
        [self.linedataarray addObject:model];
    }
    self.klineDataarray = [parsearray mutableCopy];
    /*
     NSDictionary * _dict;
     NSString *Close;
     NSString *Open;
     NSString *Low;
     NSString *High;
     NSString *Volume;
     NSNumber *MA5;
     NSNumber *MA10;
     NSNumber *MA20;
     
     ////////
     //开盘价
     @property (nonatomic, assign) CGFloat rmbOpenPrice;
     //收盘价
     @property (nonatomic, assign) CGFloat rmbClosePrice;
     //最高价
     @property (nonatomic, assign) CGFloat rmbHighPrice;
     //最低价
     @property (nonatomic, assign) CGFloat rmbLowPrice;
     //成交量
     @property (nonatomic, assign) CGFloat rmbAmount;
     //成交额
     @property (nonatomic, assign) CGFloat rmbVol;
     //成交笔数
     @property (nonatomic, assign) NSInteger count;
     //5点线
     @property (nonatomic, assign) CGFloat rmbFiveData;
     //15点线
     @property (nonatomic, assign) CGFloat rmbFifteenData;
     //30点线
     @property (nonatomic, assign) CGFloat rmbThirtyData;
     */
   
    
    
}
-(void)RequestKLineData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NetManager GETKLineWthkSearchSymbol:self.symbolmodel.symbol LineType:self.linetype searchNum:100 completionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                
                NSNumber* code =(NSNumber*)responseObj[@"code"];
                long codex = code.longValue;
                if (codex == 0) {
                    NSDictionary *result = responseObj[@"result"];
                    if (result == nil) {
                        return ;
                    }
                    KLinePointModel  *klinemodel = [KLinePointModel parse:result];
                    self.coinBaseInfo = [CoinBaseInfo parse:klinemodel.coinBaseInfo];
                    [self parseKlineData:klinemodel.klineData];
                    self.rmbMarketValue = klinemodel.rmbMarketValue;
                    self.symbolInfo = [SymbolInfo parse:klinemodel.symbolInfo];
                    
                }else{
                    [self.view showMsg:responseObj[@"message"]];
                }
                
            }else{
                [self.view showMsg:error.description];
            }
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
