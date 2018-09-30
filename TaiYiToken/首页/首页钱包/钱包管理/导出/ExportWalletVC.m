//
//  ExportWalletVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ExportWalletVC.h"
#import "ExportWalletCell.h"
#import "InputPasswordView.h"
#import "ExportKeyStoreVC.h"
#import "ExportPrivateKeyOrMnemonicVC.h"
#import "ExportWalletAddressVC.h"
#import "ExportPasswordHintVC.h"
@interface ExportWalletVC ()<UITableViewDelegate ,UITableViewDataSource>
@property(nonatomic)UITableView *tableView;
@property(nonatomic)NSArray *iconImageNameArray;
@property(nonatomic)NSArray *titleArray;
@property(nonatomic)UIView *shadowView;
@property(nonatomic)InputPasswordView *ipview;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)NSInteger selectedIndex;
@property(nonatomic,copy)NSString *password;

@property(nonatomic)UIButton *deleteWalletBtn;
@end

@implementation ExportWalletVC
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
    [self initHeadView];
    self.selectedIndex = -1;
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.wallet.coinType == BTC) {
        if ((self.wallet.importType == IMPORT_BY_MNEMONIC) || (self.wallet.walletType == LOCAL_WALLET)) {//助记词导入的才能导出助记词
            self.iconImageNameArray = @[@"ico_wallet_adress",@"ico_export_pub",@"ico_password",@"ico_export_pub"];
            self.titleArray = @[@"钱包地址",@"切换地址类型",@"密码提示信息",@"导出助记词"];
        }else{
            self.iconImageNameArray = @[@"ico_wallet_adress",@"ico_export_pub",@"ico_password"];
            self.titleArray = @[@"钱包地址",@"切换地址类型",@"密码提示信息"];
        }
        
    }else if (self.wallet.coinType == ETH){
        if ((self.wallet.importType == IMPORT_BY_MNEMONIC) || (self.wallet.walletType == LOCAL_WALLET)) {
            self.iconImageNameArray = @[@"ico_key",@"ico_export_pub",@"ico_password",@"ico_export_pub"];
            self.titleArray = @[@"导出Keystore",@"导出私钥",@"密码提示信息",@"导出助记词"];
        }else{
            self.iconImageNameArray = @[@"ico_key",@"ico_export_pub",@"ico_password"];
            self.titleArray = @[@"导出Keystore",@"导出私钥",@"密码提示信息"];
        }
    }
    [self tableView];
    //导入的钱包可删除
    if (self.wallet.walletType == IMPORT_WALLET) {
        _deleteWalletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteWalletBtn.backgroundColor = [UIColor redColor];
        _deleteWalletBtn.tintColor = [UIColor whiteColor];
        [_deleteWalletBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_deleteWalletBtn setTitle:@"删除钱包" forState:UIControlStateNormal];
        _deleteWalletBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_deleteWalletBtn addTarget:self action:@selector(deleteWalletAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_deleteWalletBtn];
        _deleteWalletBtn.userInteractionEnabled = YES;
        [_deleteWalletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom);
            make.height.equalTo(40);
            make.left.equalTo(0);
            make.right.equalTo(0);
        }];
    }
    
}

-(void)deleteWalletAction{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"此操作将会移除导入的钱包，请提前做好备份！" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *alertB = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSString *result = [CreateAll RemoveImportedWallet:self.wallet];
        [self.view showMsg:result];
    }];
    [alertC addAction:alertA];
    [alertC addAction:alertB];
    [self presentViewController:alertC animated:YES completion:nil];
}


-(void)initHeadView{
 
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
    NSString *title = @"";
    if (self.wallet.coinType == BTC) {
        title = [NSString stringWithFormat:@"BTC_wallet-%d 导出",self.wallet.index];
    }else if (self.wallet.coinType == ETH){
        title = [NSString stringWithFormat:@"ETH_wallet-%d 导出",self.wallet.index];
    }
    [_titleLabel setText:title];
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
#pragma tableView

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    lineview.backgroundColor = kRGBA(230, 230, 230, 1);
    return lineview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //比特币导出地址 不用密码
    if (self.wallet.coinType == BTC && indexPath.row == 0) {
        [self ExportAddress];
        return;
    }
    //比特币切换地址类型 不用密码
    if (self.wallet.coinType == BTC && indexPath.row == 1) {
        [self ChangeBTCAddressType];
        return;
    }
    //密码提示信息 不用密码
    if (indexPath.row == 2) {
        [self ExportPasswordHint];
        return;
    }
    
    _shadowView = [UIView new];
    _shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
    _shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    _shadowView.layer.shadowOpacity = 1;
    _shadowView.layer.shadowRadius = 3.0;
    _shadowView.layer.cornerRadius = 3.0;
    _shadowView.clipsToBounds = NO;
    _shadowView.alpha = 0;
    [self.tableView addSubview:_shadowView];
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
        make.width.equalTo(300);
        make.height.equalTo(120);
    }];
    _ipview = [InputPasswordView new];
    [_ipview initUI];
    [_ipview.confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_shadowView addSubview:_ipview];
    [_ipview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    self.selectedIndex = indexPath.row;
    [UIView animateWithDuration:0.5 animations:^{
        self.shadowView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)confirmBtnAction{
    
    [UIView animateWithDuration:0.5 animations:^{
       self.shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        self.password = self.ipview.passwordTextField.text;
        [self.ipview removeFromSuperview];
        [self GoToExportPage];
    }];
   
}
-(void)GoToExportPage{
    if (self.selectedIndex == -1) {
        return;
    }
    if (self.password == nil || [self.password isEqualToString:@""]) {
        [self.view showMsg:@"请输入密码"];
        return;
    }
   
    //self.titleArray = @[@"钱包地址",@"切换地址类型",@"密码提示信息",@"导出助记词"];
    //self.titleArray = @[@"导出Keystore",@"导出私钥",@"密码提示信息",@"导出助记词"];
    switch (self.selectedIndex) {
        case 0:
            if (self.wallet.coinType == ETH) {
                [self ExportKeyStore];
            }
            break;
        case 1:
            if (self.wallet.coinType == ETH) {
                [self ExportPrivateKey];
            }
            break;
//        case 2:
//            [self ExportPasswordHint];
//            break;
        case 3:
            [self ExportMnemonic];
            break;
        default:
            break;
    }
}
//导出地址 不验证密码
-(void)ExportAddress{
    ExportWalletAddressVC *wadvc = [ExportWalletAddressVC new];
    wadvc.wallet = self.wallet;
    [self.navigationController pushViewController:wadvc animated:YES];
}
//ETH 导出KeyStore
-(void)ExportKeyStore{
    
    [self.view showHUD];
    [CreateAll ExportKeyStoreByPassword:self.password WalletAddress:self.wallet.address callback:^(NSString *address, NSError *error) {
        [self.view hideHUD];
        if (!error) {
            if ([self.wallet.address isEqualToString:address]) {
                ExportKeyStoreVC *ekvc = [ExportKeyStoreVC new];
                ekvc.keystore = [[NSUserDefaults standardUserDefaults]  objectForKey:[NSString stringWithFormat:@"keystore%@",address]];
                [self.navigationController pushViewController:ekvc animated:YES];
            } else{
                [self.view showMsg:@"密码错误"];
            }
        }else{
            [self.view showMsg:@"密码错误"];
        }
    }];
}
//ETH 导出私钥
-(void)ExportPrivateKey{
    [self.view showHUD];
    [CreateAll ExportPrivateKeyByPassword:self.password  CoinType:self.wallet.coinType WalletAddress:self.wallet.address index:self.wallet.index callback:^(NSString *privateKey, NSError *error) {
        [self.view hideHUD];
        if (!error && privateKey != nil) {
            ExportPrivateKeyOrMnemonicVC *epmvc = [ExportPrivateKeyOrMnemonicVC new];
            epmvc.privateKey = privateKey;
            epmvc.isExportPrivateKey = YES;
            epmvc.isExportMnemonic = NO;
            [self.navigationController pushViewController:epmvc animated:YES];
        }else{
             [self.view showMsg:@"密码错误"];
        }
    }];
}
//BTC ETH导出Mnemonic
-(void)ExportMnemonic{
    [self.view showHUD];
    MissionWallet *ethwallet = [CreateAll GetMissionWalletByName:@"walletETH"];
    [CreateAll ExportMnemonicByPassword:self.password  WalletAddress:ethwallet.address callback:^(NSString *mnemonic, NSError *error) {
        [self.view hideHUD];
        if (!error && mnemonic != nil) {
            ExportPrivateKeyOrMnemonicVC *epmvc = [ExportPrivateKeyOrMnemonicVC new];
            epmvc.mnemonic = mnemonic;
            epmvc.isExportPrivateKey = NO;
            epmvc.isExportMnemonic = YES;
            [self.navigationController pushViewController:epmvc animated:YES];
        }else{
            [self.view showMsg:@"密码错误"];
        }
    }];
}
//BTC  ETH 密码提示
-(void)ExportPasswordHint{
    ExportPasswordHintVC *passhintvc = [ExportPasswordHintVC new];
    if (self.wallet.walletType == IMPORT_WALLET) {
        passhintvc.passwordHint = self.wallet.passwordHint;
    }else{
        passhintvc.passwordHint = [CreateAll GetPasswordHint];
    }
    passhintvc.wallet = self.wallet;
    [self.navigationController pushViewController:passhintvc animated:YES];
}
//切换BTC地址类型
-(void)ChangeBTCAddressType{
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExportWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExportWalletCell" forIndexPath:indexPath];
    [cell.imageViewLeft setImage:[UIImage imageNamed:self.iconImageNameArray[indexPath.row]]];
    [cell.namelb setText:self.titleArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma lazy

-(UITableView *)tableView{
    if (!_tableView) {
       
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[ExportWalletCell class] forCellReuseIdentifier:@"ExportWalletCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(64);
            make.left.right.equalTo(0);
            make.height.equalTo(300);
        }];
    }
    return _tableView;
}

@end
