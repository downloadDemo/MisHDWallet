//
//  ImportETHWalletVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/7.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ImportETHWalletVC.h"
#import "ControlBtnsView.h"
#import "SetPasswordView.h"
#define KEYSTORE_REMIND_TEXT  @"复制粘贴以太坊钱包Keystore文件内容至输入框，或通过扫描Keystore内容生成的二维码录入"
#define PRIVATEKEY_REMIND_TEXT  @"输入private Key文件内容至输入框。或通过扫描PrivateKey内容生成的二维码录入。请留意字符大小写。"
#define MNEMONIC_REMIND_TEXT    @"使用助记词导入的同时可以修改钱包密码"
typedef enum {
    KEYSTORE_IMPORT = 0,
    PRIVATEKEY_IMPORT = 1,
    MNEMONIC_IMPORT = 2,
}ETHWALLET_IMPORT_TYPE;
@interface ImportETHWalletVC ()
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UILabel *remindLabel;
@property(nonatomic)UITextView *ImportContentTextView;
@property(nonatomic)ControlBtnsView *buttonView;
@property(nonatomic)SetPasswordView *setPasswordView;
@property(nonatomic,strong) UIButton *ImportBtn;
@property(nonatomic)UIView *shadowView;
@property(nonatomic)ETHWALLET_IMPORT_TYPE importType;
@end

@implementation ImportETHWalletVC
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
    [self selectImportWay:self.buttonView.btnArray[0]];
    self.importType = KEYSTORE_IMPORT;
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
    [_titleLabel setText:[NSString stringWithFormat:@"导入ETHEREUM钱包"]];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(33);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
}

-(void)selectImportWay:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
            self.importType = KEYSTORE_IMPORT;
            self.remindLabel.text = KEYSTORE_REMIND_TEXT;
            [self.setPasswordView.passwordTextField setPlaceholder:@"确认密码"];
            self.setPasswordView.repasswordTextField.hidden = YES;
            self.setPasswordView.passwordHintTextField.hidden = YES;
            break;
        case 1:
            self.importType = MNEMONIC_IMPORT;
            self.remindLabel.text = MNEMONIC_REMIND_TEXT;
            [self.setPasswordView.passwordTextField setPlaceholder:@"钱包密码"];
            self.setPasswordView.repasswordTextField.hidden = NO;
            self.setPasswordView.passwordHintTextField.hidden = NO;
            break;
        case 2:
            self.importType = PRIVATEKEY_IMPORT;
            self.remindLabel.text = PRIVATEKEY_REMIND_TEXT;
            [self.setPasswordView.passwordTextField setPlaceholder:@"钱包密码"];
            self.setPasswordView.repasswordTextField.hidden = NO;
            self.setPasswordView.passwordHintTextField.hidden = NO;
            break;
        default:
            break;
    }
    [_buttonView setBtnSelected:btn];
    
}
-(void)initUI{
    _buttonView = [ControlBtnsView new];
    [_buttonView initButtonsViewWithTitles:@[@"Keystore",@"助记词",@"私钥"] Width:ScreenWidth Height:44];
    for (UIButton *btn in _buttonView.btnArray) {
        [btn addTarget:self action:@selector(selectImportWay:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:_buttonView];
    [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(64);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    
    _remindLabel = [UILabel new];
    _remindLabel.font = [UIFont boldSystemFontOfSize:12];
    _remindLabel.textColor = [UIColor textGrayColor];
    _remindLabel.numberOfLines = 0;
    [_remindLabel setText:MNEMONIC_REMIND_TEXT];
    _remindLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_remindLabel];
    [_remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(130);
        make.left.equalTo(30);
        make.right.equalTo(-30);
        make.height.equalTo(35);
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
        make.top.equalTo(180);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(100);
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
    [_ImportBtn setTitle:@"开始导入" forState:UIControlStateNormal];
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
//导入
-(void)ImportWalletAction{
    if (![self.setPasswordView.passwordTextField.text isEqualToString:self.setPasswordView.repasswordTextField.text]) {
        if(self.importType == KEYSTORE_IMPORT){
            
        }else{
            [self.view showMsg:@"两次密码输入不一致！"];
            return;
        }
    }
    if (self.importType == MNEMONIC_IMPORT) {
        [self.view showHUD];
        [CreateAll ImportWalletByMnemonic:self.ImportContentTextView.text CoinType:ETH Password:self.setPasswordView.passwordTextField.text PasswordHint:self.setPasswordView.passwordHintTextField.text callback:^(MissionWallet *wallet, NSError *error) {
            [self.view hideHUD];
            if (wallet == nil) {
                if (error) {
                    [self.view showMsg:@"导入失败！钱包已存在！"];
                }else{
                    [self.view showMsg:@"导入失败！"];
                }
            }else{
                [self.view showMsg:@"导入成功！"];
            }
        }];
        
        
    }else if(self.importType == PRIVATEKEY_IMPORT){
        Account *account = [Account accountWithPrivateKey:[NSData dataWithHexString:self.ImportContentTextView.text]];
        if (account == nil) {
            [self.view showMsg:@"请输入正确的私钥！"];
            return;
        }
        
        [self.view showHUD];
        MissionWallet *wallet = [CreateAll ImportWalletByPrivateKey:self.ImportContentTextView.text CoinType:ETH Password:self.setPasswordView.passwordTextField.text PasswordHint:self.setPasswordView.passwordHintTextField.text];
        [self.view hideHUD];
        if (wallet == nil) {
            [self.view showMsg:@"导入失败！"];
        }else{
            [self.view showMsg:@"导入成功！"];
        }
    }else if(self.importType == KEYSTORE_IMPORT){
        [self.view showHUD];
        [CreateAll ImportWalletByKeyStore:self.ImportContentTextView.text CoinType:ETH Password:self.setPasswordView.passwordTextField.text PasswordHint:self.setPasswordView.passwordHintTextField.text callback:^(MissionWallet *wallet, NSError *error) {
             [self.view hideHUD];
            if (wallet == nil) {
                [self.view showMsg:@"导入失败！"];
            }else{
                [self.view showMsg:@"导入成功！"];
            }
        }];
       
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
