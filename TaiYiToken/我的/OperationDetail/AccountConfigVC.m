//
//  AccountConfigVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/25.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AccountConfigVC.h"
#import "UserConfigCell.h"
#import "SelectCurrencyTypeVC.h"
@interface AccountConfigVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UITableView *tableView;
@property(nonatomic,strong)NSArray *titleArray1;
@property(nonatomic,strong)NSArray *titleArray2;
@property(nonatomic,strong)NSArray *titleArray3;
@property(nonatomic,strong) UIButton *quitAccountBtn;
@end

@implementation AccountConfigVC
-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
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
    self.titleArray1 = @[NSLocalizedString(@"当前账号", nil),NSLocalizedString(@"多语言", nil),NSLocalizedString(@"货币单位", nil)];
    self.titleArray2 = @[NSLocalizedString(@"涨红跌绿", nil),NSLocalizedString(@"消息推送", nil),NSLocalizedString(@"隐私模式", nil)];
    self.titleArray3 = @[NSLocalizedString(@"邮箱绑定", nil),NSLocalizedString(@"手机绑定", nil),NSLocalizedString(@"关于我们", nil)];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"rmb" forKey:@"CurrentCurrencySelected"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self tableView];
    [self initQuitBtn];
}

-(void)quitAccountBtnAction{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *alertB = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [CreateAll RemoveAllWallet];
        [self.tableView reloadData];
    }];
    
    [alertC addAction:alertA];
    [alertC addAction:alertB];
    [self presentViewController:alertC animated:YES completion:nil];
}
-(void)initQuitBtn{
    _quitAccountBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    _quitAccountBtn.titleLabel.textColor = [UIColor redColor];
    _quitAccountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _quitAccountBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _quitAccountBtn.backgroundColor = [UIColor whiteColor];
    _quitAccountBtn.tintColor = [UIColor redColor];
    _quitAccountBtn.userInteractionEnabled = YES;
    [_quitAccountBtn setTitle:NSLocalizedString(@"退出当前身份", nil) forState:UIControlStateNormal];
    [_quitAccountBtn addTarget:self action:@selector(quitAccountBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_quitAccountBtn];
    [_quitAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(44);
    }];
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
    [_titleLabel setText:NSLocalizedString(@"账户设置", nil)];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(33);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];

}
#pragma configOptions
-(void)selectCurrency{
    SelectCurrencyTypeVC *svc = [SelectCurrencyTypeVC new];
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0&&indexPath.row == 2) {
        [self selectCurrency];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserConfigCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell.textlb setText:self.titleArray1[indexPath.row]];
        if (indexPath.row == 0) {
            [cell.detailtextlb setText:@"MissionWallet"];
        }else if(indexPath.row == 1){
            [cell.detailtextlb setText:NSLocalizedString(@"选择", nil)];
            [cell rightIconIv];
        }else{
            NSString *current = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
            if ([current isEqualToString:@"rmb"]) {
                [cell.detailtextlb setText:NSLocalizedString(@"人民币", nil)];
            }else{
                [cell.detailtextlb setText:NSLocalizedString(@"美元", nil)];
            }
            [cell rightIconIv];
        }
        
    }else if(indexPath.section == 1){
        [cell.textlb setText:self.titleArray2[indexPath.row]];
        [cell.detailtextlb setText:@""];
        [cell switchBtn];
    }else{
        [cell.textlb setText:self.titleArray3[indexPath.row]];
        if(indexPath.row == 2){
            [cell.detailtextlb setText:@""];
        }else{
            [cell.detailtextlb setText:NSLocalizedString(@"未绑定", nil)];
        }
        [cell rightIconIv];
        [cell rightIconIv];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins  = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

#pragma lazy
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[UserConfigCell class] forCellReuseIdentifier:@"UserConfigCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(64);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
