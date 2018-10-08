//
//  MarketDetailVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/16.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "MarketDetailVC.h"
#import "DataView.h"
#import "ButtonsView.h"
#import "DataPointView.h"
#import "YYStock.h"
#import "YYStockVariable.h"
#import "UIColor+YYStockTheme.h"
#import "YYLineDataModel.h"
#import "MarketDetailTextCell.h"
#import "MarketDetailTextViewCell.h"
#import "WebVC.h"
#import "ShareMenuView.h"
#define ShareMenuViewHeight 220
@interface MarketDetailVC ()<UIScrollViewDelegate,UIScrollViewAccessibilityDelegate,YYStockDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) id observer;
@property(nonatomic,strong)UIView *showView;
@property(nonatomic,strong)UIImageView *showImageView;
@property(nonatomic,strong)UIButton *cancelbtn;
@property(nonatomic,strong)ShareMenuView * menuView;
@property(nonatomic,strong)UIView *dimView;
/*** 上方行情基础信息，K线图选择按钮  ***/
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
/**** 下方项目介绍  ****/
@property(nonatomic,strong)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *leftarray;
@property (strong, nonatomic)NSMutableArray *rightarray;
@end

@implementation MarketDetailVC
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // executes after screenshot
        NSLog(@"截屏");
        [self userDidTakeScreenshot];
    }];

}
-(void)viewWillDisappear:(BOOL)animated{
    //离开页面时 存储自选
    _mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
    if (_mysymbol == nil) {
        _mysymbol = @"";    //qqq,
    }
    if (self.collectBtn.selected == YES && ![_mysymbol containsString:self.symbolmodel.symbol]) {
        _mysymbol = [NSString stringWithFormat:@"%@,%@",self.symbolmodel.symbol,_mysymbol];
    }else if(self.collectBtn.selected == NO && [_mysymbol containsString:self.symbolmodel.symbol]){
        NSString *str = [NSString stringWithFormat:@"%@,",self.symbolmodel.symbol];
        NSString *forestr = [_mysymbol componentsSeparatedByString:str].firstObject;
        NSString *laststr = [_mysymbol componentsSeparatedByString:str].lastObject;
        _mysymbol = [NSString stringWithFormat:@"%@%@",forestr,laststr];
    }
    
    NSLog(@"mysymbol = *** %@",_mysymbol);
    [[NSUserDefaults standardUserDefaults] setObject:_mysymbol forKey:@"MySymbol"];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
    if (self.observer) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
        self.observer = nil;
    }
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
/******************************************* 截图分享 ************************************************/

//截屏响应
- (void)userDidTakeScreenshot{
    
    
    NSLog(@"检测到截屏");
    //人为截屏, 模拟用户截屏行为, 获取所截图片
    UIImage *image = [self imageWithScreenshot];
    UIImage *resultimage = [self generateShareImageWithMasterImage:image];
    
    _dimView = [UIView new];
    _dimView.backgroundColor = [UIColor blackColor];
    _dimView.alpha = 0.0;
    [self.view addSubview:_dimView];
    [_dimView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    _showView = [UIView new];
    _showView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_showView];
    [_showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(-50);
        make.left.equalTo(100);
        make.right.equalTo(-100);
        make.height.equalTo(ScreenHeight - 370);
    }];
    _showImageView = [UIImageView new];
    _showImageView.contentMode = UIViewContentModeScaleToFill;
    _showImageView.backgroundColor = [UIColor clearColor];
    [_showImageView setImage:resultimage];
    [_showView addSubview:_showImageView];
    [_showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(5);
        make.right.equalTo(-5);
        make.bottom.equalTo(-30);
    }];
     self.tabBarController.tabBar.hidden = YES;
    _menuView = [ShareMenuView new];
    _menuView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, ShareMenuViewHeight);
    [_menuView loadShareMenuView];
    [_menuView.hideBtn addTarget:self action:@selector(cancelShowView) forControlEvents:UIControlEventTouchUpInside];
    _menuView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_menuView];

    __block CGRect oldframe = self.menuView.frame;
    [UIView animateWithDuration:.5 animations:^{
        self.dimView.alpha = 0.7;
        self.menuView.frame = CGRectMake(oldframe.origin.x, oldframe.origin.y - ShareMenuViewHeight, oldframe.size.width, oldframe.size.height);
    } completion:^(BOOL finished) {
    }];
}
-(void)cancelShowView{
    
    [self.showView removeFromSuperview];
    __block CGRect oldframe = self.menuView.frame;
    [UIView animateWithDuration:.5 animations:^{
        self.dimView.alpha = 0;
        self.menuView.frame = CGRectMake(oldframe.origin.x, ScreenHeight + ShareMenuViewHeight, oldframe.size.width, oldframe.size.height);
    } completion:^(BOOL finished) {
        [self.dimView removeFromSuperview];
        [self.menuView removeFromSuperview];
        self.tabBarController.tabBar.hidden = NO;
    }];
    
}
/**
     *  返回截取到的图片
     *
     *  @return UIImage *
     */
- (UIImage *)imageWithScreenshot{
        NSData *imageData = [self dataWithScreenshotInPNGFormat];
        return [UIImage imageWithData:imageData];
}
    
/**
     *  截取当前屏幕
     *
     *  @return NSData *
     */
- (NSData *)dataWithScreenshotInPNGFormat{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
    imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-140);
    else
    imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y-15);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}
- (UIImage *)screenShotWithSize:(CGSize)size{
    UIImage* image = nil;
    /*
     *UIGraphicsBeginImageContextWithOptions有三个参数
     *size    bitmap上下文的大小，就是生成图片的size
     *opaque  是否不透明，当指定为YES的时候图片的质量会比较好
     *scale   缩放比例，指定为0.0表示使用手机主屏幕的缩放比例
     */
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.5);
    
    [self.view.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    if (image != nil) {
        return image;
    }else {
        return nil;
    }
}
/*
     masterImage  主图片，生成的图片的宽度为masterImage的宽度
     slaveImage   从图片，拼接在masterImage的下面
   */
- (UIImage *)generateShareImageWithMasterImage:(UIImage *)masterImage {
    //appiosdownload
    UIImage *topImage = [UIImage imageNamed:@"appiosdownload"];
    CGSize size;
    size.width = masterImage.size.width;
    size.height = masterImage.size.height + masterImage.size.width/topImage.size.width * topImage.size.height;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    
    
    //Draw masterImage
    [topImage drawInRect:CGRectMake(0, -3, masterImage.size.width, masterImage.size.width/topImage.size.width * topImage.size.height + 5)];
    
    //Draw slaveImage
    [masterImage drawInRect:CGRectMake(0, masterImage.size.width/topImage.size.width * topImage.size.height, masterImage.size.width, masterImage.size.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resultImage;
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
    _dataView.marketpricelabel.text = [NSString stringWithFormat:NSLocalizedString(@"市值 ￥    24h交易量 %.2f    换手率 ", nil),self.symbolmodel.amount];
    

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
    [self.scrollView addSubview:_bridgeContentView];
    [_bridgeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.height.equalTo(self.scrollView.contentSize);
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
    [self initStockView];
}
-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollView.backgroundColor = RGB(230, 230, 230);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 250);
        _scrollView.delegate =self;
        _scrollView.scrollsToTop = YES;
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
    [self RequestKLineData];
}

- (void)initStockView {
  
    self.stockContainerView = [UIView new];
    self.stockContainerView.backgroundColor = [UIColor whiteColor];
    [self.bridgeContentView addSubview:_stockContainerView];
    [_stockContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dataSelectView.mas_bottom).equalTo(5);
        make.left.right.equalTo(0);
        make.height.equalTo(300);
    }];
    
    
  
    [YYStockVariable setStockLineWidthArray:@[@6,@6,@6,@6]];
    
    YYStock *stock = [[YYStock alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 300) dataSource:self];
    _stock = stock;
    [_stockContainerView addSubview:stock.mainView];
    [stock.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(self.stockContainerView);
    }];

     [self.stock.containerView.subviews setValue:@1 forKeyPath:@"userInteractionEnabled"];
}




//解析KlineData数组
-(void)parseKlineData:(NSMutableArray *)kLineDataArray{
    NSMutableArray <klineData*> *parsearray = [NSMutableArray new];
    NSMutableArray <YYLineDataModel *> *array = [NSMutableArray new];
    self.linedataarray = [NSMutableArray new];
    YYLineDataModel *premodel = [YYLineDataModel new];
    int i1 = 0;
    int i2 = 1;
    for (NSDictionary *dic in kLineDataArray) {
        klineData *data = [klineData parse:dic];
        [parsearray addObject:data];
       // YYLineDataModel *model = [YYLineDataModel new];
        if (i1==3) {
            i1 = 0;
        }
        if (i2 == 10) {
            i2 = 0;
        }

       
        NSDictionary *dicmodel= @{ @"amount" : [NSNumber numberWithFloat:data.rmbAmount == 0?0:data.rmbAmount],
                                   @"close" : [NSNumber numberWithFloat:data.rmbClosePrice == 0?0:data.rmbClosePrice],
                                   @"day" : [NSString stringWithFormat:@"201808%d%d",i1,i2],
                                   @"high" : [NSNumber numberWithFloat:data.rmbHighPrice == 0?0:data.rmbHighPrice],
                                   @"id" : [NSNumber randomStringWithLength:5],
                                   @"low" : [NSNumber numberWithFloat:data.rmbLowPrice == 0?0:data.rmbLowPrice],
                                   @"open" : [NSNumber numberWithFloat:data.rmbOpenPrice == 0?0:data.rmbOpenPrice],
                                   @"volume" :[NSNumber numberWithFloat:data.rmbVol == 0?0:data.rmbVol],
                                   @"zqdm" : @111};
        i1++;
        i2++;
     
        YYLineDataModel *model = [[YYLineDataModel alloc]initWithDict:dicmodel];
        model.preDataModel = premodel;
        premodel = model;
        [array addObject:model];
        
        ////
        [model updateMA:nil index:0];
    }
    self.klineDataarray = [parsearray mutableCopy];
    self.linedataarray = [array mutableCopy];
    [self.stockDatadict setObject:array forKey:@"5minutes"];
    
    
    
    
    [self.stock.mainView layoutSubviews];
    [self.stock draw];
   
}

/*******************************************股票数据源代理*********************************************/
-(NSArray <NSString *> *) titleItemsOfStock:(YYStock *)stock {
    return self.stockTopBarTitleArray;
}

-(NSArray *) YYStock:(YYStock *)stock stockDatasOfIndex:(NSInteger)index {
    return self.stockDatadict[self.stockDataKeyArray[index]];
}

-(YYStockType)stockTypeOfIndex:(NSInteger)index {
    return YYStockTypeLine;
}

- (id<YYStockFiveRecordProtocol>)fiveRecordModelOfIndex:(NSInteger)index {
    return nil;
}
//
- (BOOL)isShowfiveRecordModelOfIndex:(NSInteger)index {
    return NO;
}


//请求数据
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
                    [self CreateTableView];
                }else{
                    [self.view showMsg:responseObj[@"message"]];
                }
                
            }else{
                [self.view showMsg:error.description];
            }
        }];
    });
}
/*******************************************getter*********************************************/
- (NSMutableDictionary *)stockDatadict {
    if (!_stockDatadict) {
        _stockDatadict = [NSMutableDictionary dictionary];
    }
    return _stockDatadict;
}

- (NSArray *)stockDataKeyArray {
    if (!_stockDataKeyArray) {
        _stockDataKeyArray = @[@"5minutes"];
    }
    return _stockDataKeyArray;
}

- (NSArray *)stockTopBarTitleArray {
    if (!_stockTopBarTitleArray) {
        _stockTopBarTitleArray = @[NSLocalizedString(@"5分", nil)];
    }
    return _stockTopBarTitleArray;
}

- (NSString *)getToday {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    return [dateFormatter stringFromDate:[NSDate date]];
}



/***************************    下方项目介绍      **********************************/

-(void)CreateTableView{
    NSMutableArray *leftarray = [NSMutableArray new];
    leftarray = [@[NSLocalizedString(@"发行时间", nil),NSLocalizedString(@"流通总量", nil),NSLocalizedString(@"众筹价格", nil),NSLocalizedString(@"全名", nil),NSLocalizedString(@"白皮书地址", nil),NSLocalizedString(@"区块查询", nil),NSLocalizedString(@"官网", nil),NSLocalizedString(@"发行总量", nil)] mutableCopy];
    
    NSString *whitepaperstring = self.coinBaseInfo.whitePaper == nil?@"":self.coinBaseInfo.whitePaper;
    NSString *whitepaperurl = [[whitepaperstring componentsSeparatedByString:@"\">"].lastObject componentsSeparatedByString:@"</a>"].firstObject;
    NSString *blockQuerystring = self.coinBaseInfo.blockQuery == nil?@"":self.coinBaseInfo.blockQuery;
    NSString *blockQueryurl = [[blockQuerystring componentsSeparatedByString:@"\">"].lastObject componentsSeparatedByString:@"</a>"].firstObject;
    NSString *officialWebsitestring = self.coinBaseInfo.officialWebsite == nil?@"":self.coinBaseInfo.officialWebsite;
    NSString *officialWebsiteurl = [[officialWebsitestring componentsSeparatedByString:@"\">"].lastObject componentsSeparatedByString:@"</a>"].firstObject;
    
    NSMutableArray *rightarray = [NSMutableArray new];
    [rightarray addObject:self.coinBaseInfo.publishTime == nil?@"":self.coinBaseInfo.publishTime];
    [rightarray addObject:self.coinBaseInfo.circulateVolume == nil?@"":self.coinBaseInfo.circulateVolume];
    [rightarray addObject:self.coinBaseInfo.crowdfundingPrice == nil?@"":self.coinBaseInfo.crowdfundingPrice];
    [rightarray addObject:self.coinBaseInfo.fullName == nil?@"":self.coinBaseInfo.fullName];
    [rightarray addObject:whitepaperurl == nil?@"":whitepaperurl];
    [rightarray addObject:blockQueryurl == nil?@"":blockQueryurl];
    [rightarray addObject:officialWebsiteurl == nil?@"":officialWebsiteurl];
    [rightarray addObject:self.coinBaseInfo.publishVolume == nil?@"":self.coinBaseInfo.publishVolume];
    
    self.leftarray = [leftarray mutableCopy];
    self.rightarray = [rightarray mutableCopy];
    
    [self tableView];
    UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    textview.font = [UIFont systemFontOfSize:15];
    textview.text = self.coinBaseInfo.summary;
    float newheight = self.bridgeContentView.height;
    CGSize oldFrame = self.scrollView.contentSize;
    [self.scrollView setContentSize:CGSizeMake(oldFrame.width, newheight)];
    [self.scrollView layoutSubviews];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= 6) {
        MarketDetailTextCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (![cell.rightLabel.text isEqualToString:@""]) {
            WebVC *webvc = [WebVC new];
            webvc.urlstring = cell.rightLabel.text;
            [self.navigationController pushViewController:webvc animated:YES];
        }
        
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


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        textview.font = [UIFont systemFontOfSize:15];
        textview.text = self.coinBaseInfo.summary;
        return  [self heightForString:textview andWidth:ScreenWidth];
    }
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MarketDetailTextCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"MarketDetailTextCell"];
        if (cell == nil) {
            cell = [MarketDetailTextCell new];
        }
        cell.leftLabel.text = NSLocalizedString(@"项目介绍", nil);
        cell.leftLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.leftLabel.textColor = [UIColor textBlackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightLabel.text = @"";
        return cell;
    }else if (indexPath.row == 1) {
        MarketDetailTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MarketDetailTextViewCell"];
        if (cell == nil) {
            cell = [MarketDetailTextViewCell new];
        }
        [cell.celltextView setText:self.coinBaseInfo.summary == nil?@"":self.coinBaseInfo.summary];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        MarketDetailTextCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"MarketDetailTextCell"];
        if (cell == nil) {
            cell = [MarketDetailTextCell new];
        }
        if (indexPath.row - 2 < self.rightarray.count - 1) {
            [cell.leftLabel setText:self.leftarray[indexPath.row - 2]];
            [cell.rightLabel setText:self.rightarray[indexPath.row - 2]];
        }
        cell.leftLabel.textColor = [UIColor grayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins  = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}




-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[MarketDetailTextCell class] forCellReuseIdentifier:@"MarketDetailTextCell"];
        [_tableView registerClass:[MarketDetailTextViewCell class] forCellReuseIdentifier:@"MarketDetailTextViewCell"];
        [self.bridgeContentView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stockContainerView.mas_bottom).equalTo(5);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
