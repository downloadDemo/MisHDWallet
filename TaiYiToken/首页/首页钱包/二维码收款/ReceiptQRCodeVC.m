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
@property(nonatomic,strong) UIButton *shareBtn;
@property(nonatomic)MySwitch *addressSwitch;
@property(nonatomic)UIButton *addressBtn;
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
-(void)shareAction{
    UIImage *shareImage = self.QRCodeiv.image;
    NSArray *activityItemsArray = @[shareImage];
    
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItemsArray applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop];
    activityVC.completionWithItemsHandler = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
    {
        NSLog(@"%@", activityType);
        
        if (completed) { // 确定分享
            NSLog(@"分享成功");
        }
        else {
            NSLog(@"分享失败");
        }
    };
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
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
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.backgroundColor = [UIColor clearColor];
    _shareBtn.tintColor = [UIColor whiteColor];
    [_shareBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_shareBtn setImage:[UIImage imageNamed:@"ico_share"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareBtn];
    _shareBtn.userInteractionEnabled = YES;
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(30);
        make.height.equalTo(25);
        make.right.equalTo(-10);
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
        _addressSwitch=[[MySwitch alloc] initWithFrame:CGRectMake(0, 0, 144, 34) withGap:2.0];
        [_addressSwitch setBackgroundImage:[UIImage imageNamed:@"rectxx"]];
        [_addressSwitch setLeftBlockImage:[UIImage imageNamed:@"rectbtn"]];
        [_addressSwitch setRightBlockImage:[UIImage imageNamed:@"rectbtn"]];
        _addressSwitch.delegate=self;
        _addressSwitch.OnStatus = YES;
        _addressSwitch.userInteractionEnabled = YES;
        [_addressSwitch setLeftLabelText:NSLocalizedString(@"主地址", nil)];
        [_addressSwitch setRightLabelText:NSLocalizedString(@"子地址", nil)];
        [self.view addSubview:_addressSwitch];
        [_addressSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(iv.mas_top).equalTo(80);
            make.width.equalTo(144);
            make.height.equalTo(34);
        }];
        
       //
    }
    
    _addressBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    _addressBtn.userInteractionEnabled = YES;
    _addressBtn.titleLabel.textColor = [UIColor textWhiteColor];
    _addressBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    _addressBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [_addressBtn addTarget:self action:@selector(addressBtnAction) forControlEvents:UIControlEventTouchUpInside];
    NSString *address = @"";
    if(_wallet.address.length > 20){
        NSString *str1 = [_wallet.address substringToIndex:9];
        NSString *str2 = [_wallet.address substringFromIndex:_wallet.address.length - 10];
        address = [NSString stringWithFormat:@"%@...%@",str1,str2];
    }
    [_addressBtn setTitle:address forState:UIControlStateNormal];
    [iv addSubview:_addressBtn];
    [_addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(-10);
        make.top.equalTo(121);
        make.width.equalTo(140);
        make.height.equalTo(20);
    }];
    UIImageView *copyiv = [UIImageView new];
    copyiv.image = [UIImage imageNamed:@"ico_backups"];
    [iv addSubview:copyiv];
    [copyiv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressBtn.mas_right).equalTo(0);
        make.top.equalTo(125);
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


//点击复制地址
-(void)addressBtnAction{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (_wallet.coinType == ETH || self.addressSwitch == nil) {
        pasteboard.string = _wallet.address;
    }else{
        pasteboard.string = _addressSwitch.OnStatus == YES ? self.wallet.address : self.wallet.addressarray[1];
    }
   [self.view showMsg:NSLocalizedString(@"地址已复制", nil)];
}

- (void)onStatusDelegate{
    if (_addressSwitch.OnStatus == YES) {
        [_QRCodeiv setImage:[CreateAll CreateQRCodeForAddress:_wallet == nil? @"": _wallet.address]];
        NSString *address = @"";
        if(_wallet.address.length > 20){
            NSString *str1 = [_wallet.address substringToIndex:9];
            NSString *str2 = [_wallet.address substringFromIndex:_wallet.address.length - 10];
            address = [NSString stringWithFormat:@"%@...%@",str1,str2];
        }
        [_addressBtn setTitle:address forState:UIControlStateNormal];
    }else{
        NSString *address2 = @"";
        if ([_wallet.selectedBTCAddress isEqualToString:_wallet.address]&&_wallet.addressarray&&_wallet.addressarray.count>1) {
            address2 = _wallet.addressarray[1];
        }else{
            address2 = _wallet.selectedBTCAddress;
        }
        [_QRCodeiv setImage:[CreateAll CreateQRCodeForAddress:address2]];
        NSString *address = @"";
        if(address2.length > 20){
            NSString *str1 = [address2 substringToIndex:9];
            NSString *str2 = [address2 substringFromIndex:address2.length - 10];
            address = [NSString stringWithFormat:@"%@...%@",str1,str2];
        }
        [_addressBtn setTitle:address forState:UIControlStateNormal];
    }
}

    
    
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
