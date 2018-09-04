//
//  ReceiptQRCodeVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ReceiptQRCodeVC.h"
#import "MySwitch.h"
@interface ReceiptQRCodeVC ()<MySwitchDelegate>
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)MySwitch *addressSwitch;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UIImageView *QRCodeiv;
@end

@implementation ReceiptQRCodeVC
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#434343"];
    [self initUI];
   
    
}
-(void)initUI{
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    _backBtn.tintColor = [UIColor whiteColor];
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn setImage:[UIImage imageNamed:@"ico_right_arrow1"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    _backBtn.userInteractionEnabled = YES;
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(30);
        make.height.equalTo(25);
        make.left.equalTo(10);
        make.width.equalTo(30);
    }];
    
    
    UIImage *backImage = [[UIImage alloc]createImageWithSize:CGSizeMake(312, 155) gradientColors:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#57A8FF"]] percentage:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    UIImageView *iv = [UIImageView new];
    iv.image = backImage;
    iv.layer.cornerRadius = 10;
    iv.layer.masksToBounds = YES;
    [self.view addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(120);
        make.width.equalTo(312);
        make.height.equalTo(155);
    }];
    
   
    UIView *roundrectView = [UIView new];
    roundrectView.backgroundColor = [UIColor whiteColor];
    roundrectView.layer.cornerRadius = 10;
    roundrectView.layer.masksToBounds = YES;
    [self.view addSubview:roundrectView];
    [roundrectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(iv.mas_bottom).equalTo(220);
        make.width.equalTo(312);
        make.height.equalTo(50);
    }];
    
    
    UIView *rectView = [UIView new];
    rectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rectView];
    [rectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(iv.mas_bottom).equalTo(-10);
        make.width.equalTo(312);
        make.height.equalTo(236);
    }];
    
    UIImageView *logoiv = [UIImageView new];
    logoiv.image = [UIImage imageNamed:@"misslogo3"];
    [self.view addSubview:logoiv];
    [logoiv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.centerY.equalTo(iv.mas_top);
        make.width.equalTo(54);
        make.height.equalTo(54);
    }];
    
    UILabel *coinTypeLabel = [UILabel new];
    coinTypeLabel.font = [UIFont boldSystemFontOfSize:18];
    coinTypeLabel.textColor = [UIColor textWhiteColor];
    coinTypeLabel.textAlignment = NSTextAlignmentCenter;
    coinTypeLabel.text =  _wallet.coinType == BTC ?@"BTC_wallet":@"ETH_wallet";
    [iv addSubview:coinTypeLabel];
    [coinTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(52);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
    if (_wallet.coinType == BTC) {
        NSData *walletBTCdata2 =  [[NSUserDefaults standardUserDefaults] objectForKey:@"walletBTC2"];
        MissionWallet *walletBTC2 =  [NSKeyedUnarchiver unarchiveObjectWithData:walletBTCdata2];
        self.BTCWallet2 = walletBTC2;
        _addressSwitch=[[MySwitch alloc] initWithFrame:CGRectMake(0, 0, 144, 34) withGap:2.0];
        [_addressSwitch setBackgroundImage:[UIImage imageNamed:@"rectxx"]];
        [_addressSwitch setLeftBlockImage:[UIImage imageNamed:@"rectbtn"]];
        [_addressSwitch setRightBlockImage:[UIImage imageNamed:@"rectbtn"]];
        _addressSwitch.delegate=self;
        _addressSwitch.OnStatus = YES;
        _addressSwitch.userInteractionEnabled = YES;
        [_addressSwitch setLeftLabelText:@"主地址"];
        [_addressSwitch setRightLabelText:@"子地址"];
        [self.view addSubview:_addressSwitch];
        [_addressSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(iv.mas_top).equalTo(80);
            make.width.equalTo(144);
            make.height.equalTo(34);
        }];
        
       //
    }
    _addressLabel = [UILabel new];
    _addressLabel.font = [UIFont boldSystemFontOfSize:10];
    _addressLabel.textColor = [UIColor textWhiteColor];
    _addressLabel.textAlignment = NSTextAlignmentRight;
    NSString *address = @"";
    if(_wallet.address.length > 20){
        NSString *str1 = [_wallet.address substringToIndex:9];
        NSString *str2 = [_wallet.address substringFromIndex:_wallet.address.length - 10];
        address = [NSString stringWithFormat:@"%@...%@",str1,str2];
    }
    _addressLabel.text =  address;
    [iv addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(-20);
        make.top.equalTo(121);
        make.width.equalTo(160);
        make.height.equalTo(20);
    }];
    UIImageView *copyiv = [UIImageView new];
    copyiv.image = [UIImage imageNamed:@"ico_backups"];
    [iv addSubview:copyiv];
    [copyiv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLabel.mas_right).equalTo(3);
        make.top.equalTo(121);
        make.width.equalTo(10);
        make.height.equalTo(12);
    }];
    
    _QRCodeiv = [UIImageView new];
    _QRCodeiv.image = [CreateAll CreateQRCodeForAddress:_wallet.address];
    [rectView addSubview:_QRCodeiv];
    [_QRCodeiv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(50);
        make.width.equalTo(145);
        make.height.equalTo(145);
    }];

}
- (void)onStatusDelegate{
    NSLog(@"*****");
    if (_addressSwitch.OnStatus == YES) {
        [_QRCodeiv setImage:[CreateAll CreateQRCodeForAddress:_wallet == nil? @"": _wallet.address]];
        [_addressLabel setText:_wallet == nil? @"": _wallet.address];
        NSLog(@"打开");
    }else{
        [_QRCodeiv setImage:[CreateAll CreateQRCodeForAddress:_BTCWallet2 == nil?@"":_BTCWallet2.address]];
        [_addressLabel setText:_wallet == nil? @"": _BTCWallet2.address];
        NSLog(@"关闭");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
