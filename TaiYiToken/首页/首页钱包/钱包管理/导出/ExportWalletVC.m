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
@interface ExportWalletVC ()<UITableViewDelegate ,UITableViewDataSource>
@property(nonatomic)UITableView *tableView;
@property(nonatomic)NSArray *iconImageNameArray;
@property(nonatomic)NSArray *titleArray;
@property(nonatomic)InputPasswordView *ipview;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
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
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.wallet.coinType == BTC) {
        self.iconImageNameArray = @[@"ico_wallet_adress",@"ico_export_pub",@"ico_password",@"ico_export_pub"];
        self.titleArray = @[@"钱包地址",@"切换地址类型",@"密码提示信息",@"导出助记词"];
    }else if (self.wallet.coinType == ETH){
        self.iconImageNameArray = @[@"ico_key",@"ico_export_pub",@"ico_password",@"ico_export_pub"];
        self.titleArray = @[@"导出Keystore",@"导出私钥",@"密码提示信息",@"导出助记词"];
    }
    [self tableView];
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
    _titleLabel.textAlignment = NSTextAlignmentCenter;
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
    return 4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIView *shadowView = [UIView new];
    shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    shadowView.layer.shadowOpacity = 1;
    shadowView.layer.shadowRadius = 3.0;
    shadowView.layer.cornerRadius = 3.0;
    shadowView.clipsToBounds = NO;
    [self.tableView addSubview:shadowView];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
        make.width.equalTo(300);
        make.height.equalTo(120);
    }];
    _ipview = [InputPasswordView new];
    [_ipview initUI];
    [_ipview.confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [shadowView addSubview:_ipview];
    [_ipview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

-(void)confirmBtnAction{
    NSLog(@" 88 %@",self.ipview.passwordTextField.text);
    [_ipview removeFromSuperview];
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
            make.bottom.equalTo(0);
        }];
    }
    return _tableView;
}

@end
