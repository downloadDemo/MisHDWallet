//
//  HomePageVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/3.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "HomePageVC.h"
#import "SwitchAccountVc.h"
#import "WalletCell.h"
#import "MissionWallet.h"
#import "WalletListCell.h"
@interface HomePageVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic)UICollectionView *collectionview;
@property(nonatomic)UITableView *tableView;
@property(nonatomic)UIButton *walletBtn;
@property(nonatomic)UIButton *scanBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)NSMutableDictionary *walletDic;
@end

@implementation HomePageVC

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ifHasAccount"] == YES) {
        self.walletDic = [NSMutableDictionary new];
        
        NSData *walletBTCdata =  [[NSUserDefaults standardUserDefaults] objectForKey:@"walletBTC"];
        MissionWallet *walletBTC =  [NSKeyedUnarchiver unarchiveObjectWithData:walletBTCdata];
        NSData *walletETHdata =  [[NSUserDefaults standardUserDefaults] objectForKey:@"walletETH"];
        MissionWallet *walletETH =  [NSKeyedUnarchiver unarchiveObjectWithData:walletETHdata];
        [self.walletDic setObject:walletBTC forKey:@"walletBTC"];
        [self.walletDic setObject:walletETH forKey:@"walletETH"];
        [self.collectionview registerClass:[WalletCell class] forCellWithReuseIdentifier:@"walletcell"];
        [self tableView];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ifHasAccount"] == YES) {
        [self CreateAccount];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.hidesBottomBarWhenPushed = YES;
}

-(void)initUI{
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textColor = [UIColor textBlackColor];
    [_titleLabel setText:@"BTC_wallet"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(30);
        make.centerX.equalTo(0);
        make.width.equalTo(100);
        make.height.equalTo(20);
    }];
    
    _walletBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_walletBtn setBackgroundImage:[UIImage imageNamed:@"ico_wallet"] forState:UIControlStateNormal];
    [_walletBtn addTarget:self action:@selector(walletBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_walletBtn];
    [_walletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(30);
        make.width.equalTo(16);
        make.height.equalTo(16);
    }];
    
    _scanBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_scanBtn setBackgroundImage:[UIImage imageNamed:@"wallet_scan"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(scanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_scanBtn];
    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.top.equalTo(30);
        make.width.equalTo(16);
        make.height.equalTo(16);
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}



//没有账号 创建/恢复账号
-(void)CreateAccount{
    SwitchAccountVc *switchvc = [SwitchAccountVc new];
    UINavigationController *navivc = [[UINavigationController alloc]initWithRootViewController:switchvc];
    [navivc.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navivc.navigationBar.shadowImage = [UIImage new];
    navivc.navigationBar.translucent = YES;
    navivc.navigationBar.alpha = 0;
    [self presentViewController:navivc animated:YES completion:^{
        
    }];
}
//上方按钮
-(void)walletBtnAction{
    
}
-(void)scanBtnAction{
    
}
//钱包cell按钮
-(void)QRCodeBtnAction{
    
}

-(void)detailBtnAction{
    
}
-(void)addressBtnAction{
    
}
#pragma tableView

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletListCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [WalletListCell new];
    }
    MissionWallet *wallet = nil;
    if (indexPath.row == 0) {//BTC
        wallet = [self.walletDic objectForKey:@"walletBTC"];
        [cell.iconImageView setImage:[UIImage imageNamed:@"ico_btc"]];
        cell.symbollb.text = @"BTC";
        cell.symbolNamelb.text = @"比特币";
        cell.amountlb.text = @"unknown";
        cell.valuelb.text = @"unknown";
        cell.rmbvaluelb.text = @"unknown";
    }else{//ETH
        wallet = [self.walletDic objectForKey:@"walletETH"];
        [cell.iconImageView setImage:[UIImage imageNamed:@"ico_eth"]];
        cell.symbollb.text = @"ETH";
        cell.symbolNamelb.text = @"以太坊";
        cell.amountlb.text = @"unknown";
        cell.valuelb.text = @"unknown";
        cell.rmbvaluelb.text = @"unknown";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)initHeadView{
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(246);
        make.height.equalTo(30);
    }];
    UILabel *alabel = [[UILabel alloc] init];
    alabel.textColor = [UIColor textGrayColor];
    alabel.font = [UIFont systemFontOfSize:12];
    alabel.textAlignment = NSTextAlignmentLeft;
    alabel.numberOfLines = 1;
    alabel.text = @"币名";
    [headView addSubview:alabel];
    [alabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(0);
        make.width.equalTo(100);
        make.height.equalTo(30);
    }];
    
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.text = @"数量";
    amountLabel.textColor = [UIColor textGrayColor];
    amountLabel.textAlignment = NSTextAlignmentLeft;
    amountLabel.font = [UIFont systemFontOfSize:12];
    [headView addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.centerX.equalTo(40);
        make.width.equalTo(100);
        make.height.equalTo(30);
    }];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.text = @"价值";
    valueLabel.textColor = [UIColor textGrayColor];
    valueLabel.textAlignment = NSTextAlignmentRight;
    valueLabel.font = [UIFont systemFontOfSize:12];
    [headView addSubview:valueLabel];
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.right.equalTo(-30);
        make.width.equalTo(40);
        make.height.equalTo(30);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [headView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(1);
    }];
    
}

#pragma collectionview *****************************

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 25, 5, 25);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(1, 1);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(1, 1);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenWidth -50 , 162);//CGSizeMake(width, 300);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WalletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"walletcell" forIndexPath:indexPath];
    MissionWallet *wallet = nil;
    UIImage *backImage = nil;
    if (indexPath.row == 0) {//BTC
        wallet = [self.walletDic objectForKey:@"walletBTC"];
        backImage = [[UIImage alloc]createImageWithSize:cell.contentView.frame.size gradientColors:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#57A8FF"]] percentage:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }else{//ETH
        wallet = [self.walletDic objectForKey:@"walletETH"];
        backImage = [[UIImage alloc]createImageWithSize:cell.contentView.frame.size gradientColors:@[[UIColor colorWithHexString:@"#54D595"],[UIColor colorWithHexString:@"#76D9A8"]] percentage:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    UIImageView *iv = [UIImageView new];
    iv.image = backImage;
    iv.layer.cornerRadius = 5;
    iv.layer.masksToBounds = YES;
    [cell.contentView addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    [cell.balancelb setText:@"¥"];
    [cell.profitlb setText:@"今日最新收益"];
    NSString *address = @"";
    if(wallet.address.length > 20){
        NSString *str1 = [wallet.address substringToIndex:9];
        NSString *str2 = [wallet.address substringFromIndex:wallet.address.length - 10];
        address = [NSString stringWithFormat:@"%@...%@",str1,str2];
    }
    [cell.addressBtn setTitle:wallet.address.length > 20?address:wallet.address forState:UIControlStateNormal];
    [cell.QRCodeBtn addTarget:self action:@selector(QRCodeBtnAction) forControlEvents:UIControlEventTouchUpOutside];
    [cell.detailBtn addTarget:self action:@selector(detailBtnAction) forControlEvents:UIControlEventTouchUpOutside];
    [cell.addressBtn addTarget:self action:@selector(addressBtnAction) forControlEvents:UIControlEventTouchUpOutside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionview selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    //滚动到中间
    [self.collectionview scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.titleLabel setText: indexPath.row == 0?@"BTC_wallet":@"ETH_wallet"];
}

#pragma lazy

-(UITableView *)tableView{
    if (!_tableView) {
        [self initHeadView];
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[WalletListCell class] forCellReuseIdentifier:@"WalletListCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(276);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _tableView;
}
-(UICollectionView *)collectionview{
    if (!_collectionview) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionview.dataSource = self;
        _collectionview.delegate = self;
        _collectionview.contentInset = UIEdgeInsetsMake(5, 5, -5, -5);
        _collectionview.backgroundColor = kRGBA(255, 255, 255, 1);
        _collectionview.showsVerticalScrollIndicator = NO;
        _collectionview.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_collectionview];
        [_collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(66);
            make.height.equalTo(180);
        }];
    }
    return _collectionview;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
