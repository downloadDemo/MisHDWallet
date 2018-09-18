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
#import "TransactionVC.h"
#import "TransactionRecordVC.h"
#import "BTCBalanceModel.h"
@interface HomePageVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate,MGSwipeTableCellDelegate>
@property(nonatomic)UICollectionView *collectionview;
@property(nonatomic)UITableView *tableView;
@property(nonatomic)UIButton *walletBtn;
@property(nonatomic)UIButton *scanBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)NSMutableDictionary *walletDic;
@property(nonatomic)NSInteger selectedIndex;

@property (nonatomic, strong)dispatch_source_t time;
@property(nonatomic)float TimeInterval;
//余额
@property(nonatomic)BTCBalanceModel *BTCbalance;
@property(nonatomic)BigNumber *ETHbalance;
@property(nonatomic)CGFloat BTCCurrency;//btc 美元汇率
@property(nonatomic)CGFloat ETHCurrency;
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
        [self InitTimerRequest];
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
    self.TimeInterval = 5.0;
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
    TransactionRecordVC *trvc = [TransactionRecordVC new];
    trvc.wallet = btn.tag == 0 ? [self.walletDic objectForKey:@"walletBTC"]:[self.walletDic objectForKey:@"walletETH"];
    [self.navigationController pushViewController:trvc animated:YES];
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

-(void) swipeTableCell:(WalletListCell*) cell didChangeSwipeState:(MGSwipeState) state gestureIsActive:(BOOL) gestureIsActive{
    NSLog(@"swipe  state = %ld",state);
    if (state == MGSwipeStateSwipingLeftToRight) {//收款
        ReceiptQRCodeVC *revc = [ReceiptQRCodeVC new];
        revc.wallet =  [cell.symbollb.text isEqualToString:@"BTC"]? [self.walletDic objectForKey:@"walletBTC"]:[self.walletDic objectForKey:@"walletETH"];
        [self.navigationController pushViewController:revc animated:YES];
    }
    if(state == MGSwipeStateSwipingRightToLeft){//转账
        TransactionVC *tranvc = [TransactionVC new];
        tranvc.wallet = [cell.symbollb.text isEqualToString:@"BTC"]? [self.walletDic objectForKey:@"walletBTC"]:[self.walletDic objectForKey:@"walletETH"];
        [self.navigationController pushViewController:tranvc animated:YES];
    }
    
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
    cell.delegate = self;
    MGSwipeButton *leftBtn = [MGSwipeButton buttonWithTitle:@"收款" backgroundColor:[UIColor appBlueColor] padding:30];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    cell.leftButtons = @[leftBtn];
    cell.leftSwipeSettings.transition = MGSwipeTransitionDrag;
    
    //configure right buttons
    MGSwipeButton *rightBtn = [MGSwipeButton buttonWithTitle:@"转账" backgroundColor:[UIColor redColor] padding:30];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    cell.rightButtons = @[rightBtn];
    cell.rightSwipeSettings.transition = MGSwipeTransitionDrag;
    
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
-(void)InitTimerRequest{
    //获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个定时器
    self.time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(self.TimeInterval* NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(self.time, start, interval, 0);
    //设置回调
    dispatch_source_set_event_handler(self.time, ^{
        [self requestBalance];
    });
    //由于定时器默认是暂停的所以我们启动一下
    //启动定时器
    dispatch_resume(self.time);
}
-(void)requestBalance{
    MissionWallet *walletBTC = [self.walletDic objectForKey:@"walletBTC"];
    MissionWallet *walletETH = [self.walletDic objectForKey:@"walletETH"];
    if (walletBTC == nil ) {
        return;
    }
    [NetManager GetBalanceForBTCAdress:walletBTC.address noTxList:-1 completionHandler:^(id responseObj, NSError *error) {
        if (!error) {
            self.BTCbalance = [BTCBalanceModel parse:responseObj];
            [self.collectionview reloadData];
            self.TimeInterval = 5.0;
        }else{
            self.TimeInterval += 10.0;
        }
    }];
    if (walletETH == nil ) {
        return;
    }
    [CreateAll GetBalanceETHForWallet:walletETH callback:^(BigNumber *balance) {
        self.ETHbalance = balance;
        [self.collectionview reloadData];
    }];
    //汇率只获取一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NetManager GetCurrencyCompletionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                NSDictionary *dic = [NSDictionary new];
                if ([responseObj containsObjectForKey:@"data"]) {
                    dic = responseObj[@"data"];
                    if ([dic containsObjectForKey:@"bitstamp"]) {
                        self.BTCCurrency = ((NSString *)[dic objectForKey:@"bitstamp"]).doubleValue;
                    }
                }
            }
        }];
        [CreateAll GetETHCurrencyCallback:^(FloatPromise *etherprice) {
            self.ETHCurrency = etherprice.value;
        }];
    });
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
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.5fBTC ≈$%.2f",self.BTCbalance.balance,self.BTCbalance.balance * self.BTCCurrency] attributes:@{NSForegroundColorAttributeName:[UIColor textWhiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:35]}];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(7, 3)];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(11, 6)];
        cell.balancelb.attributedText = str1;
    }else{//ETH
        wallet = [self.walletDic objectForKey:@"walletETH"];
        backImage = [[UIImage alloc]createImageWithSize:cell.contentView.frame.size gradientColors:@[[UIColor colorWithHexString:@"#54D595"],[UIColor colorWithHexString:@"#76D9A8"]] percentage:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        CGFloat ethbalance = self.ETHbalance.integerValue*1.0/pow(10,18);
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.5fETH ≈$%.2f",ethbalance,ethbalance * self.ETHCurrency] attributes:@{NSForegroundColorAttributeName:[UIColor textWhiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:35]}];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(7, 3)];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(11, 6)];
        cell.balancelb.attributedText = str1;
    }
    UIImageView *iv = [UIImageView new];
    iv.image = backImage;
    iv.layer.cornerRadius = 5;
    iv.layer.masksToBounds = YES;
    [cell.contentView addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
//    [cell.balancelb setText:@"¥"];
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
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor whiteColor];
   
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
