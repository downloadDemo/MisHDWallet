//
//  TransactionRecordDetailVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "TransactionRecordDetailVC.h"
#import "TransactionDetailView.h"
@interface TransactionRecordDetailVC ()
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)TransactionDetailView *detailView;
@property(nonatomic)NSDateFormatter* formatter;
@end

@implementation TransactionRecordDetailVC
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor ExportBackgroundColor];
    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateStyle:NSDateFormatterMediumStyle];
    [_formatter setTimeStyle:NSDateFormatterShortStyle];
    [_formatter setDateFormat:@"yyyy/MM/dd \nHH:MM:ss"];
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        [self BTCRecordToView];
    }else if (self.wallet.coinType == ETH){
        [self ETHRecordToView];
    }
}
-(void)BTCRecordToView{
    self.detailView = [TransactionDetailView new];
    [self.detailView.iconImageView setImage:[UIImage imageNamed:@"ico_btc"]];

    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:self.btcRecord.time];
    NSString *timeStr=[_formatter stringFromDate:currentDate];
    [self.detailView.timelb setText:[NSString stringWithFormat:@"%@",timeStr]];
    
    if (self.btcRecord.selectType == FAILD_Trans) {
        self.detailView.resultlb.text = @"失败";
        [self.detailView.amountlb setTextColor:[UIColor redColor]];
        [self.detailView.resultlb setTextColor:[UIColor textBlackColor]];
    }else{
        if(self.btcRecord.confirmations < 6){
            self.detailView.resultlb.text = @"确认中";
        }else{
            if (self.btcRecord.selectType == IN_Trans) {
                self.detailView.resultlb.text = @"收款成功";
                for (VOUT *vout in self.btcRecord.vout) {
                    //别人转给自己，取自己地址的vout
                    if ([vout.scriptPubKey.addresses containsObject:self.wallet.address]) {
                        _detailView.amountlb.text = [NSString stringWithFormat:@"+%.5f BTC", vout.value.floatValue];
                    }
                }
            }else if(self.btcRecord.selectType == OUT_Trans){
                self.detailView.resultlb.text = @"转账成功";
                for (VOUT *vout in self.btcRecord.vout) {
                    //转给别人，取别人地址的vout
                    if (![vout.scriptPubKey.addresses containsObject:self.wallet.address]) {
                        _detailView.amountlb.text = [NSString stringWithFormat:@"-%.5f BTC", vout.value.floatValue];
                    }
                }
            }else{
                _detailView.amountlb.text = [NSString stringWithFormat:@"0.00000  BTC"];
            }
        }
    }
    //
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.lf BTC",self.btcRecord.fees] attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [_detailView.feelb initWithTitle:@"旷工费用：" Detail:str1];
    
}

-(void)ETHRecordToView{
    self.detailView = [TransactionDetailView new];
    [self.detailView.iconImageView setImage:[UIImage imageNamed:@"ico_eth-1"]];
    
    TransactionInfo *info = self.ethRecord.info;
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:info.timestamp];
    NSString *timeStr=[_formatter stringFromDate:currentDate];
    [self.detailView.timelb setText:[NSString stringWithFormat:@"%@",timeStr]];
    
    CGFloat amount = info.value.integerValue * 1.0 / pow(10, 18);
    if (self.ethRecord.selectType == IN_Trans) {
        _detailView.amountlb.text = [NSString stringWithFormat:@"+%.5f ETH", amount];
    }else if(self.ethRecord.selectType == OUT_Trans){
        _detailView.amountlb.text = [NSString stringWithFormat:@"-%.5f ETH", amount];
    }else{
        _detailView.amountlb.text = [NSString stringWithFormat:@"0.00000 ETH"];
    }
    //
    CGFloat gwei = self.ethRecord.info.gasPrice.integerValue *1.0 / pow(10,9);
    NSInteger gas =  self.ethRecord.info.gasLimit.integerValue;
    CGFloat gasfee = (gwei * gas)*1.0/pow(10,9);
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lf ETH ≈Gas(%ld) * GasPrice(%.2f gwei)",gasfee,gas,gasfee] attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor textLightGrayColor] range:NSMakeRange(12, 40)];
    [_detailView.feelb initWithTitle:@"旷工费用：" Detail:str1];
}



-(void)initHeadView{
    UIView *headBackView = [UIView new];
    headBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headBackView];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(64);
    }];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    _backBtn.tintColor = [UIColor whiteColor];
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn setImage:[UIImage imageNamed:@"ico_right_arrow"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    _backBtn.userInteractionEnabled = YES;
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(30);
        make.height.equalTo(25);
        make.left.equalTo(10);
        make.width.equalTo(30);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [UIColor textBlackColor];
    [_titleLabel setText:@"交易记录详情"];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(33);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
