//
//  CreateAccountVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/14.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "CreateAccountVC.h"
#import "UIButton+Gradient.h"
#import "RemindView.h"
#import "CreateMnemonicVC.h"
@interface CreateAccountVC ()
@property(nonatomic,strong)UILabel *headlabel;
@property(nonatomic,strong) JVFloatLabeledTextField *accountTextField;
@property(nonatomic,strong) JVFloatLabeledTextField *passwordTextField;
@property(nonatomic,strong) JVFloatLabeledTextField *repasswordTextField;
@property(nonatomic)UIButton *createBtn;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)RemindView *remindView;
@property(nonatomic)UIView *shadowView;
@end

@implementation CreateAccountVC
-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor whiteColor];
    self.accountTextField.backgroundColor =[UIColor whiteColor];
    self.passwordTextField.backgroundColor = [UIColor whiteColor];
    self.repasswordTextField.backgroundColor = [UIColor whiteColor];
    self.createBtn.alpha = 1.0;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    
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
    
    _headlabel = [[UILabel alloc] init];
    _headlabel.textColor = [UIColor blackColor];
    _headlabel.font = [UIFont systemFontOfSize:24];
    _headlabel.text = @"创建账号";
    _headlabel.textAlignment = NSTextAlignmentLeft;
    _headlabel.numberOfLines = 1;
    [self.view addSubview:_headlabel];
    [_headlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(79);
        make.right.equalTo(-16);
        make.height.equalTo(25);
    }];
    
    _accountTextField = [JVFloatLabeledTextField new];
    _accountTextField.borderStyle = UITextBorderStyleNone;
    _accountTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: @"请输入名称"];
    _accountTextField.keepBaseline = YES;
    _accountTextField.backgroundColor = [UIColor whiteColor];
    _accountTextField.textAlignment = NSTextAlignmentLeft;
    _accountTextField.textColor = [UIColor darkGrayColor];
    _accountTextField.font = [UIFont systemFontOfSize:16];
    _accountTextField.floatingLabelYPadding = 3;
    [self.view addSubview:_accountTextField];
    [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headlabel.mas_bottom).equalTo(30);
        make.height.equalTo(45);
        make.left.equalTo(17);
        make.right.equalTo(-16);
    }];
    
    _passwordTextField = [JVFloatLabeledTextField new];
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: @"请设置密码"];
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    _passwordTextField.textColor = [UIColor darkGrayColor];
    _passwordTextField.font = [UIFont systemFontOfSize:16];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.floatingLabelYPadding = 3;
    [self.view addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountTextField.mas_bottom).equalTo(20);
        make.height.equalTo(45);
        make.left.equalTo(17);
        make.right.equalTo(-16);
    }];
    
    _repasswordTextField = [JVFloatLabeledTextField new];
    _repasswordTextField.borderStyle = UITextBorderStyleNone;
    _repasswordTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: @"请再次输入密码"];
    
    _repasswordTextField.backgroundColor = [UIColor whiteColor];
    _repasswordTextField.textAlignment = NSTextAlignmentLeft;
    _repasswordTextField.textColor = [UIColor darkGrayColor];
    _repasswordTextField.font = [UIFont systemFontOfSize:16];
    _repasswordTextField.secureTextEntry = YES;
    _repasswordTextField.floatingLabelYPadding = 3;
    [self.view addSubview:_repasswordTextField];
    [_repasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).equalTo(20);
        make.height.equalTo(45);
        make.left.equalTo(17);
        make.right.equalTo(-16);
    }];
    
    _createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _createBtn.backgroundColor = [UIColor whiteColor];
    _createBtn.tintColor = [UIColor whiteColor];
    _createBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _createBtn.layer.cornerRadius = 4;
    _createBtn.clipsToBounds = YES;
    [_createBtn gradientButtonWithSize:CGSizeMake(ScreenWidth - 34, 45) colorArray:@[RGB(150, 160, 240),RGB(170, 170, 240)] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    [_createBtn setTitle:@"创建" forState:UIControlStateNormal];
    [_createBtn addTarget:self action:@selector(createAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_createBtn];
    _createBtn.userInteractionEnabled = YES;
    [_createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(30);
        make.height.equalTo(45);
        make.left.equalTo(17);
        make.right.equalTo(-16);
    }];

    
}


-(void)createAccount{
    if (([_accountTextField.text isEqualToString:@""])||(_accountTextField.text == nil)) {
        [self.view showMsg:@"请输入名称！"];
        return;
    }
    if (([_passwordTextField.text isEqualToString:@""])||(_passwordTextField.text == nil)) {
        [self.view showMsg:@"请输入密码！"];
        return;
    }
    if (![_repasswordTextField.text isEqualToString:_passwordTextField.text]) {
        [self.view showMsg:@"两次密码输入不一致！"];
        return;
    }

    [[NSUserDefaults standardUserDefaults] setObject:self.accountTextField.text forKey:@"account"];

    
    _shadowView = [UIView new];
    _shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
    _shadowView.layer.shadowOffset = CGSizeMake(5, 5);
    _shadowView.layer.shadowOpacity = 1;
    _shadowView.layer.shadowRadius = 5.0;
    _shadowView.layer.cornerRadius = 5.0;
    _shadowView.clipsToBounds = NO;
    _shadowView.alpha = 0;
    [self.view addSubview:_shadowView];
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
        make.width.equalTo(ScreenWidth-100);
        make.height.equalTo(140);
    }];

    self.view.backgroundColor = [UIColor lightGrayColor];
    self.accountTextField.backgroundColor =[UIColor lightGrayColor];
    self.passwordTextField.backgroundColor = [UIColor lightGrayColor];
    self.repasswordTextField.backgroundColor = [UIColor lightGrayColor];
    self.createBtn.alpha = 0.6;
    
    _remindView = [RemindView new];
    [_shadowView addSubview:_remindView];
    [_remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(0);
    }];
    [_remindView initRemainViewWithTitle:@"备份钱包" message:@"  没有妥善备份就无法保障资产安全。删除程序或钱包后，您需要备份文件恢复钱包。"];
    [_remindView.quitBtn addTarget:self action:@selector(quitRemindView) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.shadowView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)quitRemindView{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.shadowView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
        [self.remindView removeFromSuperview];
    }];
    CreateMnemonicVC *cmvc = [CreateMnemonicVC new];
    cmvc.password = self.passwordTextField.text;
    [self.navigationController pushViewController:cmvc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
