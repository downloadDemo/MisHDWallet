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
#import <AVFoundation/AVFoundation.h>
#import "WBQRCodeVC.h"
#import "CustomizedNavigationController.h"
#import "ReceiptQRCodeVC.h"
#import "WalletManagerVC.h"

#import "Customlayout.h"
@interface HomePageVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic)UICollectionView *collectionview;
@property(nonatomic)UITableView *tableView;
@property(nonatomic)UIButton *walletBtn;
@property(nonatomic)UIButton *scanBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)NSMutableDictionary *walletDic;
@property(nonatomic)NSInteger selectedIndex;
@end

@implementation HomePageVC

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ifHasAccount"] == YES) {
        self.walletDic = [NSMutableDictionary new];
        
        MissionWallet *walletBTC = [CreateAll GetMissionWalletByName:@"walletBTC"];
        MissionWallet *walletETH = [CreateAll GetMissionWalletByName:@"walletETH"];
        
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
        make.top.equalTo(35);
        make.width.equalTo(16);
        make.height.equalTo(16);
    }];
    
    _scanBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_scanBtn setBackgroundImage:[UIImage imageNamed:@"wallet_scan"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(scanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_scanBtn];
    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.top.equalTo(35);
        make.width.equalTo(16);
        make.height.equalTo(16);
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.selectedIndex = 0;
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
//点击进入钱包管理
-(void)walletBtnAction{
    NSArray *walletarray = [CreateAll GetWalletNameArray];
    NSMutableArray *array = [NSMutableArray array];
    if (walletarray != nil) {
        for (NSString *walletname in walletarray) {
            MissionWallet *wallet = [CreateAll GetMissionWalletByName:walletname];
            //只显示主钱包
            if(wallet.index == 0){
                 [array addObject:wallet];
            }
        }
       
        WalletManagerVC *walletVC = [WalletManagerVC new];
        walletVC.walletArray = [array mutableCopy];
        [self.navigationController pushViewController:walletVC animated:YES];
    }
}
//扫描二维码
-(void)scanBtnAction{
    WBQRCodeVC *WBVC = [[WBQRCodeVC alloc] init];
    [self QRCodeScanVC:WBVC];
    [WBVC setGetQRCodeResult:^(NSString *string) {
        NSLog(@"QRCode result = %@",string);
    }];
}
/*
 钱包cell按钮
 */
//点击进入收款码界面
-(void)QRCodeBtnAction:(UIButton *)btn{
    ReceiptQRCodeVC *revc = [ReceiptQRCodeVC new];
    revc.wallet = btn.tag == 0 ? [self.walletDic objectForKey:@"walletBTC"]:[self.walletDic objectForKey:@"walletETH"];
    [self.navigationController pushViewController:revc animated:YES];
}
//点击进入钱包详情
-(void)detailBtnAction:(UIButton *)btn{
    //******   test
   // [CreateAll RemoveAllWallet];
    
    //*********  testnet BTC tran
//    MissionWallet *walletBTC = [self.walletDic objectForKey:@"walletBTC"];
//    walletBTC.privateKey = @"cSFqECb6f2nCvRVSEsQBEo4ETG61sPGQbZRFYBQt8zFNQ1zHmZd8";
//    walletBTC.publicKey = @"03b0a1a1136d89f1ac1a8bd4a1bca52deb3791f22b31ddbe5f915de30961a80ff9";
//    walletBTC.address = @"n1AhnRa7mgmkbkmMzeZsP9pGZbHBAV92JC";
//    [CreateAll BTCTransactionFromWallet:walletBTC ToAddress:@"mmJjyBKuV4RWnAhHx1w3Wpb11idWUifbSF" Amount:40000
//                                    Fee:10000 Api:BTCAPIChain callback:^(NSString *result, NSError *error) {
//                                        NSLog(@"result = %@",result);
//                                        NSLog(@"error = %@",error);
//                                    }];
    
    //********* ETH tran //0x4b118B4E0b0129A3DEA1165ae742F8B9653fFB74
    //40000000000000
    //400000000000000
    MissionWallet *walletETH = [self.walletDic objectForKey:@"walletETH"];
    [CreateAll ETHTransactionFromWallet:walletETH ToAddress:@"0x4b118B4E0b0129A3DEA1165ae742F8B9653fFB74" GasPrice:40000000000000 GasLimit:48543504586392 Value:400000000000000];
}
//点击复制地址
-(void)addressBtnAction:(UIButton *)btn{
    MissionWallet *wallet = btn.tag == 0 ? [self.walletDic objectForKey:@"walletBTC"]:[self.walletDic objectForKey:@"walletETH"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = wallet.address;
    [self.view showMsg:@"地址已复制"];
    NSLog(@"addressBtn %ld %@",btn.tag,pasteboard.string);
}
//扫码判断权限
- (void)QRCodeScanVC:(UIViewController *)scanVC {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                           // [self.navigationController pushViewController:scanVC animated:YES];
                            UINavigationController *navisc = [[UINavigationController alloc]initWithRootViewController:scanVC];
                            [self presentViewController:navisc animated:YES completion:^{
                                
                            }];
                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
               // [self.navigationController pushViewController:scanVC animated:YES];
                UINavigationController *navisc = [[UINavigationController alloc]initWithRootViewController:scanVC];
                [self presentViewController:navisc animated:YES completion:^{
                    
                }];
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
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
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletListCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [WalletListCell new];
    }
    MissionWallet *wallet = nil;
    if (self.selectedIndex == 0) {//BTC
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
    cell.QRCodeBtn.tag = indexPath.row;
    cell.detailBtn.tag = indexPath.row;
    cell.addressBtn.tag = indexPath.row;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];

    [cell.QRCodeBtn addTarget:self action:@selector(QRCodeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.detailBtn addTarget:self action:@selector(detailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addressBtn addTarget:self action:@selector(addressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionview selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    //滚动到中间
    [self.collectionview scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.titleLabel setText: indexPath.row == 0?@"BTC_wallet":@"ETH_wallet"];
    self.selectedIndex = indexPath.row;
    [self.tableView reloadData];
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
        Customlayout *layout = [Customlayout new];
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
