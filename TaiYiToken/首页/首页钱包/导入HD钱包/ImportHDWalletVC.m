//
//  ImportHDWalletVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/25.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ImportHDWalletVC.h"
#import "SetPasswordView.h"

@interface ImportHDWalletVC ()
@property(nonatomic,strong)UILabel *headlabel;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UIView *shadowView;
@property(nonatomic)UITextView *ImportContentTextView;
@property(nonatomic)SetPasswordView *setPasswordView;
@property(nonatomic,strong) UIButton *ImportBtn;
@property(nonatomic)NSString *mnemonic;
@end

@implementation ImportHDWalletVC
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
    [self initUI];
    // Do any additional setup after loading the view.
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
    
}

-(void)initUI{
    _headlabel = [[UILabel alloc] init];
    _headlabel.textColor = [UIColor blackColor];
    _headlabel.font = [UIFont systemFontOfSize:24];
    _headlabel.text = NSLocalizedString(@"输入助记词", nil);
    _headlabel.textAlignment = NSTextAlignmentLeft;
    _headlabel.numberOfLines = 1;
    [self.view addSubview:_headlabel];
    [_headlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(79);
        make.right.equalTo(-16);
        make.height.equalTo(25);
    }];
    
    _shadowView = [UIView new];
    _shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
    _shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    _shadowView.layer.shadowOpacity = 1;
    _shadowView.layer.shadowRadius = 3.0;
    _shadowView.layer.cornerRadius = 3.0;
    _shadowView.clipsToBounds = NO;
    [self.view addSubview:_shadowView];
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(120);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(120);
    }];
    
    
    _ImportContentTextView = [UITextView new];
    _ImportContentTextView.layer.shadowColor = [UIColor grayColor].CGColor;
    _ImportContentTextView.layer.shadowOffset = CGSizeMake(0, 0);
    _ImportContentTextView.layer.shadowOpacity = 1;
    _ImportContentTextView.backgroundColor = [UIColor whiteColor];
    _ImportContentTextView.font = [UIFont systemFontOfSize:12];
    _ImportContentTextView.textAlignment = NSTextAlignmentLeft;
    _ImportContentTextView.editable = YES;
    [self.shadowView addSubview:_ImportContentTextView];
    [_ImportContentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    _setPasswordView = [SetPasswordView new];
    [_setPasswordView initSetPasswordViewUI];
    [self.view addSubview:_setPasswordView];
    [_setPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ImportContentTextView.mas_bottom).equalTo(20);
        make.left.right.equalTo(0);
        make.height.equalTo(162);
    }];
    
    
    _ImportBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    _ImportBtn.titleLabel.textColor = [UIColor textBlackColor];
    _ImportBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _ImportBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_ImportBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 44) colorArray:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#57A8FF"]] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    _ImportBtn.tintColor = [UIColor textWhiteColor];
    _ImportBtn.userInteractionEnabled = YES;
    [_ImportBtn setTitle:NSLocalizedString(@"开始导入", nil) forState:UIControlStateNormal];
    [_ImportBtn addTarget:self action:@selector(ImportWalletAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ImportBtn];
    [_ImportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.bottom.equalTo(-71);
        make.height.equalTo(44);
    }];
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)ImportWalletAction{
    if ([self.ImportContentTextView.text isEqualToString:@""] || self.ImportContentTextView.text == nil) {
        [self.view showMsg:NSLocalizedString(@"请输入助记词！", nil)];
        return;
    }

    if (![self.setPasswordView.passwordTextField.text isEqualToString:self.setPasswordView.repasswordTextField.text]) {
        [self.view showMsg:NSLocalizedString(@"两次密码输入不一致！", nil)];
        return;
    }
    self.mnemonic = self.ImportContentTextView.text;
    [self.view showMsg:NSLocalizedString(@"正在创建钱包...", nil)];
    [self.view showHUD];
    [self CreateWallet];
   
    
}
-(void)CreateWallet{
    NSString *password = self.setPasswordView.passwordTextField.text;
    //512位种子 长度为128字符 64Byte
    NSString *seed = [CreateAll CreateSeedByMnemonic:self.mnemonic Password:password];
    
    NSString *xprv = [CreateAll CreateExtendPrivateKeyWithSeed:seed];
    MissionWallet *walletBTC = [CreateAll CreateWalletByXprv:xprv index:0 CoinType:BTC];
    MissionWallet *walletETH = [CreateAll CreateWalletByXprv:xprv index:0 CoinType:ETH];
 
    if (!walletBTC || !walletETH) {
        [self.view hideHUD];
        return;
    }

    if (self.setPasswordView.passwordHintTextField.text == nil) {
        walletBTC.passwordHint = @"";
        walletETH.passwordHint = @"";
    }else{
        walletBTC.passwordHint = self.setPasswordView.passwordHintTextField.text;
        walletETH.passwordHint = self.setPasswordView.passwordHintTextField.text;
        [CreateAll UpdatePasswordHint:self.setPasswordView.passwordHintTextField.text];
    }
    //根据地址存助记词
    [SAMKeychain setPassword:_mnemonic forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",walletBTC.address]];
    [SAMKeychain setPassword:_mnemonic forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",walletETH.address]];
    //创建并存KeyStore eth
    [CreateAll CreateKeyStoreByMnemonic:self.mnemonic  WalletAddress:walletETH.address Password:password callback:^(Account *account, NSError *error) {
        if (account == nil) {
            [self.view showMsg:NSLocalizedString(@"导入出错,助记词错误！", nil)];
        }else{
            [self.view showMsg:NSLocalizedString(@"导入成功！", nil)];
            [[NSUserDefaults standardUserDefaults]  setBool:YES forKey:@"ifHasAccount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [CreateAll SaveWallet:walletBTC Name:@"walletBTC" WalletType:LOCAL_WALLET Password:password];
            [CreateAll SaveWallet:walletETH Name:@"walletETH" WalletType:LOCAL_WALLET Password:password];
            
            [self dismissViewControllerAnimated:YES completion:^{
                [self.view hideHUD];
            }];
        }
    }];

}

@end
