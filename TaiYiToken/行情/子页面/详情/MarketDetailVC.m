//
//  MarketDetailVC.m
//  TaiYiToken
//
//  Created by admin on 2018/8/16.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MarketDetailVC.h"
//#import "KLinePointModel.h"
#import "DataView.h"
#import "ButtonsView.h"
#import "DataPointView.h"
@interface MarketDetailVC ()
//
@property(nonatomic,strong) UIButton *backBtn;
//@property(nonatomic,strong)NSMutableArray<KLinePointModel*> *KLinePointArray;
//@property(nonatomic,strong)CandleStickChartView *chartView;
@property(nonatomic)DataView *dataView;
@property(nonatomic)ButtonsView *buttonsView;
@property(nonatomic,strong)DataPointView *dataSelectView;
@property(nonatomic,strong)UIView *headBackgroundView;
@property(nonatomic,strong)UIButton *collectBtn;


@end

@implementation MarketDetailVC
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    if ([_mysymbol containsString:self.symbolmodel.symbol]) {
        [self.collectBtn setSelected:YES];
    }else{
        [self.collectBtn setSelected:NO];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    //离开页面时 存储
  
    _mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
    if (_mysymbol == nil) {
        _mysymbol = @"";    //qqq,
    }
    if (self.collectBtn.selected == YES) {
        _mysymbol = [NSString stringWithFormat:@"%@%@,",_mysymbol,self.symbolmodel.symbol];
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


-(void)initUI{
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
    [_headBackgroundView addSubview:symbolLabel];
    [symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.centerY.equalTo(-15);
    }];
    UILabel *symbolNameLabel = [UILabel new];
    symbolNameLabel.font = [UIFont systemFontOfSize:10];
    symbolNameLabel.textColor = [UIColor textWhiteColor];
    symbolNameLabel.text = self.symbolmodel.symbolName;
    symbolNameLabel.textAlignment = NSTextAlignmentCenter;
    [_headBackgroundView addSubview:symbolNameLabel];
    [symbolNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.centerY.equalTo(5);
    }];
  
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [_collectBtn setImage:[UIImage imageNamed:@"ico_focus_default"] forState:UIControlStateNormal];
    [_collectBtn setImage:[UIImage imageNamed:@"ico_focus_select"] forState:UIControlStateSelected];
    [_collectBtn addTarget:self action:@selector(collectToMySymbol) forControlEvents:UIControlEventTouchUpInside];
    [_headBackgroundView addSubview:_collectBtn];
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.centerY.equalTo(5);
        make.width.height.equalTo(30);
    }];
    
    
    //基本数据
    _dataView = [DataView new];
    _dataView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_dataView];
    [_dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(80);
        make.height.equalTo(100);
    }];
    
    _dataView.dollarlabel.text = [NSString stringWithFormat:@"%.2f", self.symbolmodel.dollarClosePrice];
    _dataView.rmblabel.text = [NSString stringWithFormat:@"≈￥%.2f",self.symbolmodel.rmbClosePrice];
    _dataView.ratelabel.text = self.symbolmodel.priceChange > 0? [NSString stringWithFormat:@"+%.2f",self.symbolmodel.priceChange]: [NSString stringWithFormat:@"%.2f",self.symbolmodel.priceChange];
    _dataView.marketpricelabel.text = [NSString stringWithFormat:@"市值￥  24h交易量%.2f  换手率",self.symbolmodel.amount];
    

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
        make.top.equalTo(self.dataView.mas_bottom).equalTo(15);
        make.height.equalTo(35);
    }];
    [self.buttonsView initButtonsViewWidth:ScreenWidth - 30 Height:35];
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
    
    //修改数据
    
}
-(void)RequestKLineData{
//    NSString *symbol = [self.model.symbol componentsSeparatedByString:@"/"].firstObject;
//    [NetManager GETKLineWthType:@"m" Symbol:symbol completionHandler:^(id responseObj, NSError *error) {
//        if (!error) {
//            
//            NSNumber* code =(NSNumber*)responseObj[@"code"];
//            long codex = code.longValue;
//            if (codex == 0) {
//                NSArray *arr = responseObj[@"result"];
//                if (arr == nil) {
//                    return ;
//                }
//              //  [self.KLinePointArray removeAllObjects];
//              
//                for (id obj in arr) {
//                  //  KLinePointModel *data = [KLinePointModel parse:obj];
//                  //  [self.KLinePointArray addObject:data];
//                }
//              //  [self CreateCubeline];
//            }else{
//                [self.view showMsg:responseObj[@"message"]];
//            }
//            
//        }else{
//            [self.view showMsg:error.description];
//        }
//    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.KLinePointArray = [NSMutableArray new];

    [self initUI];
   
//    NSNumber* code =(NSNumber*)responseObj[@"code"];
//    long codex = code.longValue;
//    if (codex == 0) {
//        NSArray *arr = responseObj[@"result"];
//        if (arr == nil) {
//            return ;
//        }
//        [self.KLinePointArray removeAllObjects];
//        for (id obj in arr) {
//            KLinePointModel *data = [KLinePointModel parse:obj];
//
//            [self.KLinePointArray addObject:data];
//
//        }
//        [self.KLinePointArray addObjectsFromArray:self.KLinePointArray];
//
//      //  [self CreateCubeline];
//    }else{
//        [self.view showMsg:responseObj[@"message"]];
//    }
//
   
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
