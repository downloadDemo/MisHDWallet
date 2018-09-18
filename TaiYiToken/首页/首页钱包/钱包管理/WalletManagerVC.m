//
//  WalletManagerVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "WalletManagerVC.h"
#import "WalletManagerCell.h"
#import "ExportWalletVC.h"
#import "ImportWalletSwitchVC.h"
#import "SectionHeaderView.h"
#import "SwitchAccountVc.h"
@interface WalletManagerVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic)UICollectionView *collectionview;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UIButton *addAccountBtn;
@property(nonatomic)UIButton *addWalletBtn;
@property(nonatomic)NSMutableArray <MissionWallet*> *importWalletArray;
@end

@implementation WalletManagerVC
-(void)RefreshImportWalletList{
    NSArray *importwalletarray = [CreateAll GetImportWalletNameArray];
    self.importWalletArray = [NSMutableArray array];
    for (NSString *importwalletname in importwalletarray) {
        MissionWallet *wallet = [CreateAll GetMissionWalletByName:importwalletname];
        [self.importWalletArray addObject:wallet];
    }
    [self.collectionview reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self RefreshImportWalletList];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.importWalletArray = [NSMutableArray new];
    [self RefreshImportWalletList];
    [self initHeadView];


    [self.collectionview registerClass:[WalletManagerCell class] forCellWithReuseIdentifier:@"WalletManagerCell"];
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
//导入钱包
- (void)addWalletBtnAction{
    ImportWalletSwitchVC *isvc = [ImportWalletSwitchVC new];
    [self.navigationController pushViewController:isvc animated:YES];
}
//创建新账户
- (void)createNewAccountBtnAction{

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *alertB = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        SwitchAccountVc *switchvc = [SwitchAccountVc new];
        UINavigationController *navivc = [[UINavigationController alloc]initWithRootViewController:switchvc];
        [navivc.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        navivc.navigationBar.shadowImage = [UIImage new];
        navivc.navigationBar.translucent = YES;
        navivc.navigationBar.alpha = 0;
        [self presentViewController:navivc animated:YES completion:^{
            
        }];
    }];
    
    [alertC addAction:alertA];
    [alertC addAction:alertB];
    [self presentViewController:alertC animated:YES completion:nil];
    

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
    
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [UIColor textBlackColor];
    [_titleLabel setText:@"钱包管理"];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(33);
        make.left.equalTo(45);
        make.width.equalTo(100);
        make.height.equalTo(20);
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
    
    _addWalletBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_addWalletBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_addWalletBtn addTarget:self action:@selector(addWalletBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addWalletBtn];
    [_addWalletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.top.equalTo(35);
        make.width.equalTo(16);
        make.height.equalTo(16);
    }];
    
    _addAccountBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    _addAccountBtn.titleLabel.textColor = [UIColor textBlackColor];
    _addAccountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _addAccountBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _addAccountBtn.backgroundColor = [UIColor whiteColor];
    _addAccountBtn.tintColor = [UIColor textBlackColor];
    _addAccountBtn.userInteractionEnabled = YES;
    [_addAccountBtn setTitle:@"创建新账户" forState:UIControlStateNormal];
    [_addAccountBtn addTarget:self action:@selector(createNewAccountBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addAccountBtn];
    [_addAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(44);
    }];
    
    
}

#pragma collectionview *****************************
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    SectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerV" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [view.remindlb setText:@"当前身份下钱包"];
    }else{
        [view.remindlb setText:@"导入的钱包"];
    }
    return view;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, 20);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(1, 1);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenWidth -36 , 120);//CGSizeMake(width, 300);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.walletArray == nil? 0:self.walletArray.count;
    }else{
        return self.importWalletArray == nil? 0:self.importWalletArray.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WalletManagerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WalletManagerCell" forIndexPath:indexPath];
    MissionWallet *wallet = nil;
    if (indexPath.section == 0) {
        wallet = self.walletArray[indexPath.row];
    }else{
        wallet = self.importWalletArray[indexPath.row];
    }
    NSString *address = @"";
    if(wallet.address.length > 20){
        NSString *str1 = [wallet.address substringToIndex:9];
        NSString *str2 = [wallet.address substringFromIndex:wallet.address.length - 10];
        address = [NSString stringWithFormat:@"%@...%@",str1,str2];
    }
    if (wallet && (wallet.coinType == BTC || wallet.coinType == BTC_TESTNET)) {
        UIImage *backImage = [[UIImage alloc]createImageWithSize:CGSizeMake(312, 155) gradientColors:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#57A8FF"]] percentage:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        [cell.backImageViewLeft setImage:backImage];
        [cell.backImageViewRight setImage:[UIImage imageNamed:@"bglogo1"]];
        cell.namelb.text = @"BTC_wallet";
        [cell.addressBtn setTitle:address forState:UIControlStateNormal];
        cell.addressBtn.tag =  indexPath.section * 100 + indexPath.row;
        [cell.addressBtn addTarget:self action:@selector(addressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }else if(wallet && wallet.coinType == ETH){
        UIImage *backImage = [[UIImage alloc]createImageWithSize:CGSizeMake(312, 155) gradientColors:@[[UIColor colorWithHexString:@"#54D595"],[UIColor colorWithHexString:@"#76D9A8"]] percentage:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        [cell.backImageViewLeft setImage:backImage];
        [cell.backImageViewRight setImage:[UIImage imageNamed:@"bglogo2"]];
        cell.namelb.text = @"ETH_wallet";
        [cell.addressBtn setTitle:address forState:UIControlStateNormal];
        cell.addressBtn.tag = indexPath.section  * 100 + indexPath.row;
        [cell.addressBtn addTarget:self action:@selector(addressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.exportBtn.tag =  indexPath.section * 100  + indexPath.row;
    [cell.exportBtn addTarget:self action:@selector(exportBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

//导出钱包
-(void)exportBtnAction:(UIButton *)btn{
    ExportWalletVC *evc = [ExportWalletVC new];
    MissionWallet *wallet = nil;
    if (btn.tag < 100) {
        wallet = self.walletArray[btn.tag];
    }else{
        wallet = self.importWalletArray[btn.tag - 100];
    }
    evc.wallet = wallet;
    [self.navigationController pushViewController:evc animated:YES];
}


//点击复制地址
-(void)addressBtnAction:(UIButton *)btn{
    MissionWallet *wallet = nil;
    if (btn.tag < 100) {
        wallet = self.walletArray[btn.tag];
    }else{
        wallet = self.importWalletArray[btn.tag - 100];
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = wallet.address;
    [self.view showMsg:@"地址已复制"];
    NSLog(@"addressBtn %ld %@",btn.tag,pasteboard.string);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionview selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self.collectionview scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma lazy

-(UICollectionView *)collectionview{
    if (!_collectionview) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionview.dataSource = self;
        _collectionview.delegate = self;
        _collectionview.contentInset = UIEdgeInsetsMake(5, 5, -5, -5);
        _collectionview.backgroundColor = [UIColor colorWithHexString:@"#2B3041"];
        _collectionview.showsVerticalScrollIndicator = NO;
        _collectionview.showsHorizontalScrollIndicator = NO;
        [_collectionview registerClass:[SectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerV"];
        [self.view addSubview:_collectionview];
        [_collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.width.equalTo(ScreenWidth);
            make.top.equalTo(64);
            make.bottom.equalTo(-40);
        }];
    }
    return _collectionview;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
