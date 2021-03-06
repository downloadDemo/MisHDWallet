//
//  VerifyMnemonicVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/20.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "VerifyMnemonicVC.h"
#import "CFFlowButtonView.h"
//#import "PBKDF2.h"
#import "CreateAll.h"

@interface VerifyMnemonicVC ()
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)NSMutableArray *mnemonicArray;
@property(nonatomic,strong)CFFlowButtonView *optionButtonView;//
@property(nonatomic,strong)CFFlowButtonView *selectedButtonView;
@property(nonatomic)NSMutableDictionary  *optionbuttonListSelect;//下方选择,只用于初始化
@property(nonatomic,strong) UIButton *nextBtn;
@property(nonatomic,strong)UILabel *headlabel;
@end

@implementation VerifyMnemonicVC
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.mnemonicArray = [NSMutableArray new];
    self.optionbuttonListSelect = [NSMutableDictionary new];
    //将助记词字符串分割为单词,因使用dic初始化optionView时通过枚举已经打乱了顺序 故无需专门打破顺序
    self.mnemonicArray = [[self.mnemonic componentsSeparatedByString:@" "] mutableCopy];

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
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.backgroundColor = [UIColor textBlueColor];
    [_nextBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 49) colorArray:@[RGB(150, 160, 240),RGB(170, 170, 240)] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    [_nextBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    _nextBtn.userInteractionEnabled = YES;
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.height.equalTo(49);
        make.left.equalTo(0);
        make.right.equalTo(0);
    }];
    
    
    _headlabel = [[UILabel alloc] init];
    _headlabel.textColor = [UIColor blackColor];
    _headlabel.font = [UIFont systemFontOfSize:16];
    _headlabel.text = NSLocalizedString(@"确认助记词", nil);
    _headlabel.textAlignment = NSTextAlignmentLeft;
    _headlabel.numberOfLines = 1;
    [self.view addSubview:_headlabel];
    [_headlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(50);
        make.top.equalTo(30);
        make.right.equalTo(-16);
        make.height.equalTo(25);
    }];

    UILabel *remindlabel = [[UILabel alloc] init];
    remindlabel.textColor = [UIColor textGrayColor];
    remindlabel.font = [UIFont systemFontOfSize:13];
    remindlabel.text = NSLocalizedString(@"请按顺序点击助记词，以确认您正确备份", nil);
    remindlabel.textAlignment = NSTextAlignmentCenter;
    remindlabel.numberOfLines = 1;
    [self.view addSubview:remindlabel];
    [remindlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(70);
        make.right.equalTo(-10);
        make.height.equalTo(20);
    }];
    //
    [self initOptionsView];
    
}
-(void)nextAction{
   //正式版本移到后面
  //  [self CreateWallet];
    
    if (self.selectedButtonView.buttonList == nil||self.selectedButtonView.buttonList.count < 12) {
        [self.view showMsg:NSLocalizedString(@"请按顺序选择所有单词！", nil)];
        return;
    }
   
    for (NSInteger i = 0; i < self.mnemonicArray.count; i++) {
        UIButton *btn = self.selectedButtonView.buttonList[i];
        if (![btn.titleLabel.text isEqualToString:self.mnemonicArray[i]]) {
            [self.view showMsg:NSLocalizedString(@"顺序错误，请重新选择！", nil)];
            return;
        }
    }

    [self dismissViewControllerAnimated:YES completion:^{
        [self.view showMsg:NSLocalizedString(@"正在创建钱包...", nil)];
        [self.view showHUD];
        [self CreateWallet];
        [self.view hideHUD];
    }];
}

-(void)CreateWallet{
    
    //512位种子 长度为128字符 64Byte
    NSString *seed = [CreateAll CreateSeedByMnemonic:self.mnemonic Password:self.password];
    
    NSString *xprv = [CreateAll CreateExtendPrivateKeyWithSeed:seed];
    MissionWallet *walletBTC = [CreateAll CreateWalletByXprv:xprv index:0 CoinType:BTC];
    MissionWallet *walletETH = [CreateAll CreateWalletByXprv:xprv index:0 CoinType:ETH];
    if (!walletBTC || !walletETH) {
        [self.view hideHUD];
        return;
    }
    
    //根据地址存助记词
    [SAMKeychain setPassword:_mnemonic forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",walletBTC.address]];
    [SAMKeychain setPassword:_mnemonic forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",walletETH.address]];
    //创建并存KeyStore eth
    [CreateAll CreateKeyStoreByMnemonic:self.mnemonic  WalletAddress:walletETH.address Password:self.password callback:^(Account *account, NSError *error) {
        if (account == nil) {
            [self.view showMsg:NSLocalizedString(@"创建出错！", nil)];
        }else{
            [self.view showMsg:NSLocalizedString(@"创建成功！", nil)];
            [[NSUserDefaults standardUserDefaults]  setBool:YES forKey:@"ifHasAccount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [CreateAll SaveWallet:walletBTC Name:@"walletBTC" WalletType:LOCAL_WALLET Password:self.password];
            [CreateAll SaveWallet:walletETH Name:@"walletETH" WalletType:LOCAL_WALLET Password:self.password];
            
            [self dismissViewControllerAnimated:YES completion:^{
                [self.view hideHUD];
            }];
        }
    }];

}


-(NSMutableArray*)DicToArray:(NSMutableDictionary*)dic{
    __block NSMutableArray *array = [NSMutableArray new];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [array addObject:obj];
    }];
    return array;
}
-(void)selectAction:(UIButton *)button{
    [button setSelected:NO];
    
    if (button.tag == 0) {//0 表示点击下面 1 点击上面
        //删除下面的
        UIButton *btn = [UIButton new];
        for (btn in self.optionButtonView.buttonList) {
            if ([btn.titleLabel.text isEqualToString:button.titleLabel.text]) {
                break;
            }
        }
        
        [self.optionButtonView.buttonList removeObject:btn];
        
        //增加上面的
        NSString *mstr = button.titleLabel.text;
        UIButton *mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mBtn gradientButtonWithSize:CGSizeMake(mstr.length*15, 23) colorArray:@[(id)[UIColor textOrangeColor],(id)[UIColor orangeColor]] percentageArray:@[@(0.2),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        mBtn.tag = 1;
        [mBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        [mBtn setTitle:mstr forState:UIControlStateNormal];
        [mBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        mBtn.userInteractionEnabled = YES;
        [self.selectedButtonView.buttonList addObject:mBtn];
    }else{
        //删除上面的
        UIButton *btn = [UIButton new];
        for (btn in self.selectedButtonView.buttonList) {
            if ([btn.titleLabel.text isEqualToString:button.titleLabel.text]) {
                break;
            }
        }
        [self.selectedButtonView.buttonList removeObject:btn];
        
        //增加下面的
        NSString *mstr = button.titleLabel.text;
        UIButton *mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [mBtn gradientButtonWithSize:CGSizeMake(mstr.length*15, 23) colorArray:@[RGB(160, 180, 240),RGB(170, 170, 240)] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        mBtn.tag = 0;
        
        
        [mBtn setTitle:mstr forState:UIControlStateNormal];
        [mBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        mBtn.userInteractionEnabled = YES;
        [self.optionButtonView.buttonList addObject:mBtn];
    }
    //重绘
    [self.optionButtonView layoutSubviews];
    [self.selectedButtonView layoutSubviews];
}

-(void)initOptionsView{
    for (NSInteger i = 0; i<self.mnemonicArray.count; i++) {
        NSString *mstr = self.mnemonicArray[i];
        UIButton *mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mBtn.tag = 0;
        mBtn.frame = CGRectMake(0, 0, mstr.length*15, 23);
        [mBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [mBtn gradientButtonWithSize:CGSizeMake(mstr.length*15, 23) colorArray:@[RGB(150, 160, 240),RGB(170, 170, 240)] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        [mBtn setTitle:mstr forState:UIControlStateNormal];
        [mBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        mBtn.userInteractionEnabled = YES;
        [self.optionbuttonListSelect setObject:mBtn forKey:mstr];
    }
    
    [self optionButtonView];
    [self selectedButtonView];
    
}
-(CFFlowButtonView *)selectedButtonView{
    if (_selectedButtonView == nil) {
        
        UIView *shadowView = [UIView new];
        shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
        shadowView.layer.shadowOffset = CGSizeMake(0, 0);
        shadowView.layer.shadowOpacity = 1;
        shadowView.layer.shadowRadius = 3.0;
        shadowView.layer.cornerRadius = 3.0;
        shadowView.clipsToBounds = NO;
        [self.view addSubview:shadowView];
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.right.equalTo(-10);
            make.top.equalTo(100);
            make.height.equalTo(150);
        }];
        
        _selectedButtonView = [[CFFlowButtonView alloc] initWithButtonList:nil];
        _selectedButtonView.backgroundColor = [UIColor whiteColor];

        [shadowView addSubview:_selectedButtonView];
        [_selectedButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _selectedButtonView;
}

-(CFFlowButtonView *)optionButtonView{
    if (_optionButtonView == nil) {
        _optionButtonView = [[CFFlowButtonView alloc] initWithButtonList:self.optionbuttonListSelect];
        
        [self.view addSubview:_optionButtonView];
        [_optionButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.right.equalTo(-10);
            make.top.equalTo(270);
            make.height.equalTo(150);
        }];
    }
    return _optionButtonView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
