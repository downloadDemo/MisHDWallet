//
//  MarketDetailVC.m
//  TaiYiToken
//
//  Created by admin on 2018/8/16.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MarketDetailVC.h"
#import "KLinePointModel.h"
#import "DataView.h"
#import "ButtonsView.h"
#import "DataPointView.h"
@interface MarketDetailVC ()<ChartViewDelegate,IChartAxisValueFormatter>
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong)NSMutableArray<KLinePointModel*> *KLinePointArray;
@property(nonatomic,strong)CandleStickChartView *chartView;
@property(nonatomic)DataView *dataView;
@property(nonatomic)ButtonsView *buttonsView;
@property(nonatomic,strong)DataPointView *dataSelectView;
@end

@implementation MarketDetailVC
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
   
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)initUI{
   
    UIImageView *topBackgroundImageView = [UIImageView new];
   
    UIImage *backImage = [[UIImage alloc]createImageWithSize:CGSizeMake(ScreenWidth - 34, 45) gradientColors:@[(id)[UIColor backBlueColorA],(id)[UIColor backBlueColorB]] percentage:@[@(0.2),@(1)] gradientType:GradientFromTopToBottom];
    [topBackgroundImageView setImage:backImage];
    [self.view addSubview:topBackgroundImageView];
    [topBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(160);
    }];
    UIView *shadowView = [UIView new];
    shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(3, 3);
    shadowView.layer.shadowOpacity = 1;
    shadowView.layer.shadowRadius = 3.0;
    shadowView.layer.cornerRadius = 3.0;
    shadowView.clipsToBounds = NO;
    [self.view addSubview:shadowView];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(80);
        make.height.equalTo(130);
    }];
    _dataView = [DataView new];
    _dataView.backgroundColor = [UIColor whiteColor];
    [shadowView addSubview:_dataView];
    [_dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];

    _dataView.namelabel.text = [self.model.symbol componentsSeparatedByString:@"/"].firstObject;
    _dataView.dollarlabel.text = [NSString stringWithFormat:@"$%.2f",self.model.dollar];
    _dataView.rmblabel.text = [NSString stringWithFormat:@"≈ ￥%.2f",self.model.rmb];
    _dataView.ratelabel.text = [NSString stringWithFormat:@"%.2f%%",self.model.priceChangePercent];
    _dataView.openlabel.text = [NSString stringWithFormat:@"%.4f",self.model.openPrice];
    _dataView.highlabel.text = [NSString stringWithFormat:@"%.4f",self.model.highPrice];
    _dataView.lowlabel.text = [NSString stringWithFormat:@"%.4f",self.model.lowPrice];
    _dataView.volumelabel.text = [NSString stringWithFormat:@"%.4f",self.model.quoteVolume];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _backBtn.backgroundColor = [UIColor clearColor];
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn setImage:[UIImage imageNamed:@"ico_right_arrow"] forState:UIControlStateNormal];
    _backBtn.tintColor = RGB(255, 255, 255);
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    _backBtn.userInteractionEnabled = YES;
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(30);
        make.height.equalTo(25);
        make.left.equalTo(10);
        make.width.equalTo(30);
    }];
    
    self.buttonsView = [ButtonsView new];
    [self.view addSubview:self.buttonsView];
    [_buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.top.equalTo(shadowView.mas_bottom).equalTo(15);
        make.height.equalTo(35);
    }];
    [self.buttonsView initButtonsViewWidth:ScreenWidth - 30 Height:35];
    int i = 0;
    [self.buttonsView.oneMinuteBtn setSelected:YES];//默认
    for (UIButton *btn in self.buttonsView.btnArray) {
        btn.tag = i;
        i++;
        [btn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)switchBtnClick:(UIButton*)button{
    for (UIButton *btn in self.buttonsView.btnArray) {
        if(btn.tag != button.tag){
            [btn setSelected:NO];
        }
    }
    [button setSelected:YES];
    
    //修改数据
    
}
-(void)RequestKLineData{
    NSString *symbol = [self.model.symbol componentsSeparatedByString:@"/"].firstObject;
    [NetManager GETKLineWthType:@"m" Symbol:symbol completionHandler:^(id responseObj, NSError *error) {
        if (!error) {
            
            NSNumber* code =(NSNumber*)responseObj[@"code"];
            long codex = code.longValue;
            if (codex == 0) {
                NSArray *arr = responseObj[@"result"];
                if (arr == nil) {
                    return ;
                }
                [self.KLinePointArray removeAllObjects];
              
                for (id obj in arr) {
                    KLinePointModel *data = [KLinePointModel parse:obj];
                    [self.KLinePointArray addObject:data];
                }
                [self CreateCubeline];
            }else{
                [self.view showMsg:responseObj[@"message"]];
            }
            
        }else{
            [self.view showMsg:error.description];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.KLinePointArray = [NSMutableArray new];

    [self initUI];
    //test
    id responseObj = @{ @"code": @0,
                     @"message": @"成功",
                     @"result": @[
                                @{
                                    @"startTime": @"2018-07-16 16:00:00",
                                    @"high": @"0.07175000",
                                    @"low": @"0.07100100",
                                    @"open": @"0.07109000",
                                    @"close": @"0.07140100",
                                    @"volume": @"19245.02600000",
                                    @"endTime": @"2018-07-16 19:59:59"
                                },
                                @{
                                    @"startTime": @"2018-07-16 20:00:00",
                                    @"high": @"0.08189800",
                                    @"low": @"0.07626900",
                                    @"open": @"0.07140100",
                                    @"close": @"0.09143600",
                                    @"volume": @"20424.97400000",
                                    @"endTime": @"2018-07-16 23:59:59"
                                    }, @{
                                    @"startTime": @"2018-07-17 00:00:00",
                                    @"high": @"0.03189800",
                                    @"low": @"0.04126900",
                                    @"open": @"0.07140100",
                                    @"close": @"0.07143600",
                                    @"volume": @"20424.97400000",
                                    @"endTime": @"2018-07-16 03:59:59"
                                    }, @{
                                    @"startTime": @"2018-07-18 4:00:00",
                                    @"high": @"0.07189800",
                                    @"low": @"0.07126900",
                                    @"open": @"0.09140100",
                                    @"close": @"0.09143600",
                                    @"volume": @"20424.97400000",
                                    @"endTime": @"2018-07-16 7:59:59"
                                    }, @{
                                    @"startTime": @"2018-07-19 8:00:00",
                                    @"high": @"0.03189800",
                                    @"low": @"0.07126900",
                                    @"open": @"0.07140100",
                                    @"close": @"0.06143600",
                                    @"volume": @"20424.97400000",
                                    @"endTime": @"2018-07-16 11:59:59"
                                    }, @{
                                    @"startTime": @"2018-07-19 12:00:00",
                                    @"high": @"0.03189800",
                                    @"low": @"0.07126900",
                                    @"open": @"0.07140100",
                                    @"close": @"0.16143600",
                                    @"volume": @"20424.97400000",
                                    @"endTime": @"2018-07-16 15:59:59"
                                    }]
                     };
    NSNumber* code =(NSNumber*)responseObj[@"code"];
    long codex = code.longValue;
    if (codex == 0) {
        NSArray *arr = responseObj[@"result"];
        if (arr == nil) {
            return ;
        }
        [self.KLinePointArray removeAllObjects];
        for (id obj in arr) {
            KLinePointModel *data = [KLinePointModel parse:obj];

            [self.KLinePointArray addObject:data];
            
        }
        [self.KLinePointArray addObjectsFromArray:self.KLinePointArray];
        
        [self CreateCubeline];
    }else{
        [self.view showMsg:responseObj[@"message"]];
    }
    
   
    _dataSelectView = [DataPointView new];
    _dataSelectView.backgroundColor = RGB(250, 250, 250);
    [self.view addSubview:_dataSelectView];
    [_dataSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-16);
        make.top.equalTo(self.buttonsView.mas_bottom).equalTo(5);
        make.left.equalTo(16);
        make.height.equalTo(15);
    }];
   
}
-(void)CreateCubeline{
    self.chartView  = [[CandleStickChartView alloc] init];
    [self.view addSubview:_chartView];
    [_chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(270);
        make.height.equalTo(300);
    }];
    _chartView.delegate = self;
    
    _chartView.chartDescription.enabled = NO;
    
    _chartView.maxVisibleCount = 60;
    _chartView.pinchZoomEnabled = NO;
    _chartView.drawGridBackgroundEnabled = NO;
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.valueFormatter = self;
    xAxis.labelCount = self.KLinePointArray.count;
    xAxis.labelRotationAngle = 30.0;
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelCount = 7;
    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.drawAxisLineEnabled = NO;
    
    ChartYAxis *rightAxis = _chartView.rightAxis;
    rightAxis.enabled = NO;
    
    _chartView.legend.enabled = NO;
    [self updateChartData];

    
}
- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis{
   
    
    KLinePointModel *model = self.KLinePointArray[(int)value];
    
    NSString *hourTimestart = [[model.startTime componentsSeparatedByString:@" "].lastObject componentsSeparatedByString:@":"].firstObject;
   
    NSString *dayStart =  [[model.startTime componentsSeparatedByString:@"-"].lastObject componentsSeparatedByString:@" "].firstObject;
    NSString *yearMonthDay = [model.startTime  componentsSeparatedByString:@" "].firstObject;
    NSString *monthDay =[NSString stringWithFormat:@"%@-%@",[yearMonthDay componentsSeparatedByString:@"-"][1],[yearMonthDay componentsSeparatedByString:@"-"][2]];
    double avgTime = 0;
    
    avgTime = hourTimestart.doubleValue + 2;
    

    return [NSString stringWithFormat:@"%.0f:00",avgTime];

   
}


- (void)updateChartData
{
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    if(self.KLinePointArray != nil && self.KLinePointArray.count >0){
        for (int i = 0; i < self.KLinePointArray.count; i++) {
            //startTime 时间段的开始时间
            //high最高价*
            //low最低价*
            //open开始价
            //close结束价
            //volume交易量
            //endTime时间段的结束时间
//            @"startTime": @"2018-07-16 16:00:00",
//            @"high": @"0.07175000",
//            @"low": @"0.07100100",
//            @"open": @"0.07109000",
//            @"close": @"0.07140100",
//            @"volume": @"19245.02600000",
//            @"endTime": @"2018-07-16 19:59:59"
            KLinePointModel *model = self.KLinePointArray[i];
            
            NSString *hourTimestart = [[model.startTime componentsSeparatedByString:@" "].lastObject componentsSeparatedByString:@":"].firstObject;
            NSString *hourTimeend = [[model.endTime componentsSeparatedByString:@" "].lastObject componentsSeparatedByString:@":"].firstObject;
            double avgTime = (hourTimestart.doubleValue + hourTimeend.doubleValue)*0.5;
            double mult = 0.0;
            double val = 0 + mult;
            double high = model.high.doubleValue;
            double low = model.low.doubleValue;
            double open = model.open.doubleValue;
            double close = model.close.doubleValue;
            BOOL even = i % 2 == 0;
            [yVals1 addObject:[[CandleChartDataEntry alloc] initWithX:i shadowH:val + high shadowL:val - low open:even ? val + open : val - open close:even ? val - close : val + close icon: [UIImage imageNamed:@"icon"]]];
        }
    }
 
    
    CandleChartDataSet *set1 = [[CandleChartDataSet alloc] initWithValues:yVals1 label:@"Data Set"];
    set1.axisDependency = AxisDependencyLeft;
    [set1 setColor:[UIColor colorWithWhite:80/255.f alpha:1.f]];
    
    set1.drawIconsEnabled = NO;
    
    set1.shadowColor = UIColor.darkGrayColor;
    set1.shadowWidth = 0.7;
    set1.decreasingColor = UIColor.redColor;
    set1.decreasingFilled = YES;
    set1.increasingColor = [UIColor colorWithRed:122/255.f green:242/255.f blue:84/255.f alpha:1.f];
    set1.increasingFilled = NO;
    set1.neutralColor = UIColor.blueColor;
    
    CandleChartData *data = [[CandleChartData alloc] initWithDataSet:set1];
    
    _chartView.data = data;
}
#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
   
   [_dataSelectView initDataPointView];
    KLinePointModel *model = self.KLinePointArray[(NSInteger)entry.x];

    _dataSelectView.highLabel.text = [NSString stringWithFormat:@"高:%.2f",model.high.doubleValue];
    _dataSelectView.lowLabel.text = [NSString stringWithFormat:@"低:%.2f",model.low.doubleValue];
    _dataSelectView.openLabel.text = [NSString stringWithFormat:@"开:%.2f",model.open.doubleValue];
    _dataSelectView.closeLabel.text = [NSString stringWithFormat:@"收:%.2f",model.close.doubleValue];
    _dataSelectView.volumeLabel.text = [NSString stringWithFormat:@"交易量:%.2f",model.volume.doubleValue];
   
    NSLog(@"chartValueSelected ** %@ \n",entry);
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValue Nothing Selected");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
