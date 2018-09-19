//
//  TransactionVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 admin. All rights reserved.
//

#define MIN_ETH_GAS 0.0001

#import "TransactionVC.h"
#import "WBQRCodeVC.h"
#import "TransactionAmountView.h"
#import "TransactionAddressView.h"
#import "TransactionGasView.h"
#import "BTCBalanceModel.h"


@interface TransactionVC ()<UIImagePickerControllerDelegate>
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UIButton *scanBtn;
@property(nonatomic,strong)TransactionAmountView *amountView;
@property(nonatomic,strong)TransactionAddressView *addressView;
@property(nonatomic,strong)TransactionGasView *gasView;
@property(nonatomic)UIButton *transactionBtn;

@property(nonatomic)BTCBalanceModel *BTCbalance;
@property(nonatomic)CGFloat BTCCurrency;//btc 美元汇率
@property(nonatomic)NSInteger satPerBit;//默认 35sat/b

@property(nonatomic)BigNumber *ETHbalance;
@property(nonatomic)CGFloat ETHCurrency;
@property(nonatomic)BigNumber *GasLimit;
@end

@implementation TransactionVC
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
    if (self.wallet.coinType == BTC_TESTNET) {
//        self.wallet.privateKey = @"cSFqECb6f2nCvRVSEsQBEo4ETG61sPGQbZRFYBQt8zFNQ1zHmZd8";
//        self.wallet.publicKey = @"03b0a1a1136d89f1ac1a8bd4a1bca52deb3791f22b31ddbe5f915de30961a80ff9";
//        self.wallet.address = @"n1AhnRa7mgmkbkmMzeZsP9pGZbHBAV92JC";
    }else{//当前ETH钱包即为测试账号
        
    }
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestData];
        sleep(3);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadDataToView];
        });
    });
    self.view.backgroundColor = [UIColor ExportBackgroundColor];
    [self initHeadView];
    [self initUI];
    
    _transactionBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    _transactionBtn.titleLabel.textColor = [UIColor whiteColor];
    _transactionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _transactionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _transactionBtn.userInteractionEnabled = YES;
    [_transactionBtn setTitle:@"转账" forState:UIControlStateNormal];
    [_transactionBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 44) colorArray:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#57A8FF"]] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    [_transactionBtn addTarget:self action:@selector(transactionAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_transactionBtn];
    [_transactionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(44);
    }];
}
-(void)transactionAction{
    //如果超额
    if ([self checkAmount] == NO) {
        [self.view showMsg:@"转账金额错误！"];
        return;
    }
    if ([self.addressView.toAddressTextField.text isEqualToString:@""]) {
        [self.view showMsg:@"请填写转账地址！"];
        return;
    }
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        [self transactionBTCToAddress:self.addressView.toAddressTextField.text];
    }else if (self.wallet.coinType == ETH){
        [self transactionETHToAddress:self.addressView.toAddressTextField.text];
    }
}
//检查金额？
-(void)transactionBTCToAddress:(NSString *)address{
    __block MissionWallet *walletBTC = self.wallet;
    NSString *amount = self.amountView.amountTextField.text;
    BTCAmount amountvalue = amount.floatValue * pow(10,8);
    BTCAmount fee = self.satPerBit;
    [CreateAll BTCTransactionFromWallet:walletBTC ToAddress:address Amount:amountvalue
                                    Fee:fee Api:BTCAPIBlockchain callback:^(NSString *result, NSError *error) {
                                        if (result == nil) {
                                            [self.view showMsg:@"转账失败"];
                                        }else{
                                            [self.view showMsg:@"交易已广播"];
                                        }
                                    }];
}



-(void)transactionETHToAddress:(NSString *)address{
    __block MissionWallet *walletETH = self.wallet;
    NSString *amount = self.amountView.amountTextField.text;
    __block BigNumber *value = [BigNumber bigNumberWithDecimalString:[NSString stringWithFormat:@"%ld",(NSInteger)(amount.floatValue * pow(10,18))]];
    [CreateAll CreateETHTransactionFromWallet:walletETH ToAddress:address Value:value callback:^(Transaction *transactionresult) {
        __block Transaction *transaction = transactionresult;
        if (transaction) {
            [CreateAll GetBalanceETHForWallet:walletETH callback:^(BigNumber *balance) {
                transaction.value = value;
                NSLog(@"value = %@ bal = %@",value,balance);
                CGFloat gwei = self.gasView.gasSlider.value;
                NSInteger gasvalue = (NSInteger)(gwei * pow(10, 9));
                BigNumber *gasbignumber = [BigNumber bigNumberWithDecimalString:[NSString stringWithFormat:@"%ld",gasvalue]];
                [CreateAll ETHTransaction:transaction Wallet:walletETH GasPrice:gasbignumber GasLimit:self.GasLimit callback:^(HashPromise *promise) {
                    if (promise.error) {
                        if ([promise.error.userInfo containsObjectForKey:@"response"]) {
                            NSString *responsedata = promise.error.userInfo[@"response"];
                            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responsedata.dataValue options:kNilOptions error:nil];
                            if ([response containsObjectForKey:@"error"]) {
                                NSDictionary *err = response[@"error"];
                                if ([err containsObjectForKey:@"message"]) {
                                    [self.view showAlert:@"error!" DetailMsg:err[@"message"]];
                                }
                            }
                        } 
                    }else{
                        [self.view showMsg:@"交易已广播"];
                    }
                    NSLog(@"result = %@",promise.value);
                }];
            }];
        }else{
            [self.view showMsg:@"交易创建失败！"];
        }
    }];
}


-(BOOL)checkAmount{
    NSString *amount = self.amountView.amountTextField.text;
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        //转账金额不能大于余额+最低手续费
        if (amount.floatValue > self.BTCbalance.balance) {
            [self.transactionBtn setEnabled:NO];
            return NO;
        }else{
            [self.transactionBtn setEnabled:YES];
            return YES;
        }
    }else if (self.wallet.coinType == ETH){
        //不能过大或过小
        if (amount.floatValue > self.ETHbalance.integerValue*1.0/pow(10,18) + MIN_ETH_GAS || amount.floatValue < MIN_ETH_GAS) {
            [self.transactionBtn setEnabled:NO];
            return NO;
        }else{
            [self.transactionBtn setEnabled:YES];
            return YES;
        }
    }
    return NO;
}

-(void)requestData{
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        //余额
        [NetManager GetBalanceForBTCAdress:self.wallet.address noTxList:-1 completionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                self.BTCbalance = [BTCBalanceModel parse:responseObj];
            }
        }];
        //btc 美元汇率
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
        self.satPerBit = 35;
    }else if (self.wallet.coinType == ETH){
        [CreateAll GetBalanceETHForWallet:self.wallet callback:^(BigNumber *balance) {
            self.ETHbalance = balance;
            BigNumber *valuenumber =  [balance div:[BigNumber bigNumberWithInteger:4]];
            [CreateAll CreateETHTransactionFromWallet:self.wallet ToAddress:self.wallet.address Value:valuenumber callback:^(Transaction *transaction) {
                [CreateAll GetGasLimitPriceForTransaction:transaction callback:^(BigNumber *gasLimitPrice) {
                    self.GasLimit = gasLimitPrice;
                    [self loadDataToView];
                }];
            }];
        }];
       
        [CreateAll GetETHCurrencyCallback:^(FloatPromise *etherprice) {
            self.ETHCurrency = etherprice.value;
        }];
    }
}

-(void)loadDataToView{
    NSString *amount = self.amountView.amountTextField.text;
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        [self.amountView.balancelb setText:[NSString stringWithFormat:@"余额：%.5fBTC",self.BTCbalance.balance]];
        [self.amountView.pricelb setText:[NSString stringWithFormat:@"≈$%.2f",amount.floatValue * self.BTCCurrency]];
        [self.gasView.gaspricelb setText:[NSString stringWithFormat:@"%ld sat/b",self.satPerBit]];
    }else if (self.wallet.coinType == ETH){
        CGFloat ethbalance = self.ETHbalance.integerValue*1.0/pow(10,18);
        [self.amountView.balancelb setText:[NSString stringWithFormat:@"余额：%.5fETH",ethbalance]];
        [self.amountView.pricelb setText:[NSString stringWithFormat:@"≈$%.2f ",amount.floatValue * self.ETHCurrency]];
        //ETH矿工费 = Gas Limit * Gas Price
        self.gasView.gasSlider.value = self.gasView.gasSlider.minimumValue;
        CGFloat gwei = self.gasView.gasSlider.value;
        CGFloat gasvalue = (gwei * self.GasLimit.integerValue)*1.0/pow(10,9);
        CGFloat dollarvalue = gasvalue * _ETHCurrency;
        NSLog(@"gwei = %lf    GasPrice = %ld",gwei,self.GasLimit.integerValue);
        [self.gasView.gaspricelb setText:[NSString stringWithFormat:@"%.4f ether ≈ $%.4f",gasvalue,dollarvalue]];
    }
   
}

-(void)sliderValueChanged:(UISlider *)sender{
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        if (sender.value >= 40) {
            [sender setValue:sender.maximumValue];
            self.satPerBit = 45;
        }else{
            [sender setValue:sender.minimumValue];
            self.satPerBit = 35;
        }
        [self.gasView.gaspricelb setText:[NSString stringWithFormat:@"%ld sat/b",self.satPerBit]];
    }else if (self.wallet.coinType == ETH){
        CGFloat gwei = sender.value;
        CGFloat gasvalue = (gwei * self.GasLimit.integerValue)*1.0/pow(10,9);
        CGFloat dollarvalue = gasvalue * _ETHCurrency;
        [self.gasView.gaspricelb setText:[NSString stringWithFormat:@"%.4f ether ≈ $%.4f",gasvalue,dollarvalue]];
        [self.gasView updateLabelValues:gwei];
    }
   
}
- (void)textFieldDidChange{
    NSString *amount = self.amountView.amountTextField.text;
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
         [self.amountView.pricelb setText:[NSString stringWithFormat:@"≈$%.2f",amount.floatValue * self.BTCCurrency]];
        //转账金额不能大于余额+最低手续费
        if (amount.floatValue > self.BTCbalance.balance) {
            [self.transactionBtn setEnabled:NO];
        }else{
            [self.transactionBtn setEnabled:YES];
        }
    }else if (self.wallet.coinType == ETH){
         [self.amountView.pricelb setText:[NSString stringWithFormat:@"≈$%.2f",amount.floatValue * self.ETHCurrency]];
        if (amount.floatValue > self.ETHbalance.integerValue*1.0/pow(10,18) + MIN_ETH_GAS) {
            [self.transactionBtn setEnabled:NO];
        }else{
            [self.transactionBtn setEnabled:YES];
        }
    }
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
    [_titleLabel setText:[NSString stringWithFormat:@"转账"]];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(33);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
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

-(void)initUI{
    _amountView = [TransactionAmountView new];
    [_amountView initUI];
    switch (self.wallet.coinType) {
        case BTC:
            _amountView.namelb.text = @"BTC";
            break;
        case BTC_TESTNET:
            _amountView.namelb.text = @"BTC_TESTNET";
            break;
        case ETH:
            _amountView.namelb.text = @"ETH";
            break;
        default:
            _amountView.namelb.text = @"unknown Wallet coinType";
            break;
    }
   [_amountView.amountTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_amountView];
    [_amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(70);
        make.left.right.equalTo(0);
        make.height.equalTo(110);
    }];
    
    _addressView = [TransactionAddressView new];
    [_addressView initUI];
    [self.view addSubview:_addressView];
    [_addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountView.mas_bottom).equalTo(10);
        make.left.right.equalTo(0);
        make.height.equalTo(110);
    }];
    
    _gasView = [TransactionGasView new];
    [_gasView initUI];
    [_gasView.gasSlider setValue:-1];
    [self.view addSubview:_gasView];
    [_gasView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_bottom).equalTo(10);
        make.left.right.equalTo(0);
        make.height.equalTo(150);
    }];
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        _gasView.gasSlider.maximumValue = 45;
        _gasView.gasSlider.minimumValue = 35;
    }else if (self.wallet.coinType == ETH){
        _gasView.gasSlider.maximumValue = 42;
        _gasView.gasSlider.minimumValue = 4.2;
    }
    [_gasView.gasSlider setValue:_gasView.gasSlider.minimumValue];
    [_gasView.gasSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    [_addressView.fromAddressTextField setText:self.wallet.address];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//扫描二维码
-(void)scanBtnAction{
    WBQRCodeVC *WBVC = [[WBQRCodeVC alloc] init];
    [self QRCodeScanVC:WBVC];
    [WBVC setGetQRCodeResult:^(NSString *string) {
        [self.addressView.toAddressTextField setText:string];
    }];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
