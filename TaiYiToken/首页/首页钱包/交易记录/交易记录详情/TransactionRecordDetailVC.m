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
    [self initHeadView];
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

//点击复制地址
-(void)copyAddress:(UIButton *)btn{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = btn.tag == 0?self.toAddress:self.fromAddress;
    [self.view showMsg:NSLocalizedString(@"地址已复制", nil)];
    NSLog(@"addressBtn %ld %@",btn.tag,pasteboard.string);
}

-(void)BTCRecordToView{
    self.detailView = [TransactionDetailView new];
    [self.view addSubview:self.detailView];
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(70);
        make.left.right.equalTo(0);
        make.bottom.equalTo(-30);
    }];
    [self.detailView.iconImageView setImage:[UIImage imageNamed:@"ico_btc"]];

    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:self.btcRecord.time];
    NSString *timeStr=[_formatter stringFromDate:currentDate];
    [self.detailView.timelb setText:[NSString stringWithFormat:@"%@",timeStr]];
    
    if (self.btcRecord.selectType == FAILD_Trans) {
        self.detailView.resultlb.text = NSLocalizedString(@"失败", nil);
    }else{
        if (self.btcRecord.selectType == IN_Trans) {
            self.detailView.resultlb.text = NSLocalizedString(@"收款成功", nil);
            for (VOUT *vout in self.btcRecord.vout) {
                //别人转给自己，取自己地址的vout
                if ([vout.scriptPubKey.addresses containsObject:self.wallet.address]) {
                    _detailView.amountlb.text = [NSString stringWithFormat:@"+%.5f BTC", vout.value.floatValue];
                }
            }
        }else if(self.btcRecord.selectType == OUT_Trans){
            self.detailView.resultlb.text = NSLocalizedString(@"转账成功", nil);
            for (VOUT *vout in self.btcRecord.vout) {
                //转给别人，取别人地址的vout
                if (![vout.scriptPubKey.addresses containsObject:self.wallet.address]) {
                    _detailView.amountlb.text = [NSString stringWithFormat:@"-%.5f BTC", vout.value.floatValue];
                }
            }
        }else{
            _detailView.amountlb.text = [NSString stringWithFormat:@"0.00000  BTC"];
        }
        if(self.btcRecord.confirmations < 6){
            self.detailView.resultlb.text = NSLocalizedString(@"确认中", nil);
            
        }
    }
    //
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.8f BTC\n",self.btcRecord.fees] attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [_detailView.feelb initWithTitle:NSLocalizedString(@"旷工费用：", nil) Detail:str1];
    
    
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"ico_password"];
    attach.bounds = CGRectMake(0, 0, 10, 10);
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString * to = [[NSMutableAttributedString alloc] initWithString:self.toAddress];
    [to appendAttributedString:imageStr];
    [_detailView.tolb initWithTitle:NSLocalizedString(@"收款地址：", nil) DetailBtn:to];
    [_detailView.tolb.detailbtn addTarget:self action:@selector(copyAddress:) forControlEvents:UIControlEventTouchUpInside];
    _detailView.tolb.detailbtn.tag = 0;
    
    NSMutableAttributedString * from = [[NSMutableAttributedString alloc] initWithString:self.fromAddress];
    [from appendAttributedString:imageStr];
    [_detailView.fromlb initWithTitle:NSLocalizedString(@"付款地址：", nil) DetailBtn:from];
    [_detailView.fromlb.detailbtn addTarget:self action:@selector(copyAddress:) forControlEvents:UIControlEventTouchUpInside];
    _detailView.fromlb.detailbtn.tag = 1;
    
    [_detailView.remarklb initWithTitle:NSLocalizedString(@"备注：", nil) DetailBtn:nil];
    
    NSString *btctxid = self.btcRecord.txid;
    NSMutableAttributedString * ethtransactionHashAttr = [[NSMutableAttributedString alloc] initWithString:btctxid attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [_detailView.tranNumberlb initWithTitle:NSLocalizedString(@"交易号：", nil) Detail:ethtransactionHashAttr];
    
    NSString *blocknum = [NSString stringWithFormat:@"%ld\n", self.btcRecord.blockheight];
    NSMutableAttributedString * blocknumAttr = [[NSMutableAttributedString alloc] initWithString:blocknum attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [_detailView.blockNumberlb initWithTitle:NSLocalizedString(@"区块：", nil) Detail:blocknumAttr];
    
}



-(void)ETHRecordToView{
    self.detailView = [TransactionDetailView new];
    [self.detailView.iconImageView setImage:[UIImage imageNamed:@"ico_eth-1"]];
    [self.view addSubview:self.detailView];
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(70);
        make.left.right.equalTo(0);
        make.bottom.equalTo(-30);
    }];
    
    TransactionInfo *info = self.ethRecord.info;
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:info.timestamp];
    NSString *timeStr=[_formatter stringFromDate:currentDate];
    [self.detailView.timelb setText:[NSString stringWithFormat:@"%@",timeStr]];
    
    CGFloat amount = info.value.integerValue * 1.0 / pow(10, 18);
    if (self.ethRecord.selectType == IN_Trans) {
        self.detailView.resultlb.text = NSLocalizedString(@"收款成功", nil);
        _detailView.amountlb.text = [NSString stringWithFormat:@"+%.5f ETH", amount];
    }else if(self.ethRecord.selectType == OUT_Trans){
        self.detailView.resultlb.text = NSLocalizedString(@"转账成功", nil);
        _detailView.amountlb.text = [NSString stringWithFormat:@"-%.5f ETH", amount];
    }else{
        self.detailView.resultlb.text = NSLocalizedString(@"失败", nil);
        _detailView.amountlb.text = [NSString stringWithFormat:@"0.00000 ETH"];
    }
    //
    CGFloat gwei = self.ethRecord.info.gasPrice.integerValue *1.0 / pow(10,9);
    NSInteger gasused =  self.ethRecord.info.gasUsed.integerValue;
    CGFloat gasfee = (gwei * gasused)*1.0/pow(10,9);
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.7f ETH\n≈Gas(%ld) * GasPrice(%.2f gwei)",gasfee,gasused,gwei] attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor textLightGrayColor] range:NSMakeRange(13, str1.length - 13)];
    [_detailView.feelb initWithTitle:NSLocalizedString(@"旷工费用：", nil) Detail:str1];
    
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"ico_password"];
    attach.bounds = CGRectMake(0, 0, 10, 10);
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString * to =  [[NSMutableAttributedString alloc] initWithString:self.toAddress attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [to appendAttributedString:imageStr];
    [_detailView.tolb initWithTitle:NSLocalizedString(@"收款地址：", nil) DetailBtn:to];
    [_detailView.tolb.detailbtn addTarget:self action:@selector(copyAddress:) forControlEvents:UIControlEventTouchUpInside];
    _detailView.tolb.detailbtn.tag = 0;
    
    NSMutableAttributedString * from = [[NSMutableAttributedString alloc] initWithString:self.fromAddress attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [from appendAttributedString:imageStr];
    [_detailView.fromlb initWithTitle:NSLocalizedString(@"付款地址：", nil) DetailBtn:from];
    [_detailView.fromlb.detailbtn addTarget:self action:@selector(copyAddress:) forControlEvents:UIControlEventTouchUpInside];
    _detailView.fromlb.detailbtn.tag = 1;
    
    [_detailView.remarklb initWithTitle:NSLocalizedString(@"备注：", nil) DetailBtn:nil];
    
    NSString *ethtransactionHash = self.ethRecord.info.transactionHash.hexString;
    NSMutableAttributedString * ethtransactionHashAttr = [[NSMutableAttributedString alloc] initWithString:ethtransactionHash attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [_detailView.tranNumberlb initWithTitle:NSLocalizedString(@"交易号：", nil) Detail:ethtransactionHashAttr];
    
    NSString *blocknum = [NSString stringWithFormat:@"%ld\n", self.ethRecord.info.blockNumber];
    NSMutableAttributedString * blocknumAttr = [[NSMutableAttributedString alloc] initWithString:blocknum attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [_detailView.blockNumberlb initWithTitle:NSLocalizedString(@"区块：", nil) Detail:blocknumAttr];
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
    [_titleLabel setText:NSLocalizedString(@"交易记录详情", nil)];
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
