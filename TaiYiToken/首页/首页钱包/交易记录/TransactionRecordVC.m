//
//  TransactionRecordVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "TransactionRecordVC.h"
#import "ControlBtnsView.h"
#import "TransactionRecordCell.h"
#import "BTCTransactionRecordModel.h"
#import "ETHTransactionRecordModel.h"
#import "TransactionRecordDetailVC.h"
@interface TransactionRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)ControlBtnsView *buttonView;
@property(nonatomic)UITableView *tableView;
@property(nonatomic)int page;
@property(nonatomic)NSMutableArray <BTCTransactionRecordModel *>*btcRecordArray;
@property(nonatomic)NSMutableArray <BTCTransactionRecordModel *>*btcSelectRecordArray;
@property(nonatomic)NSMutableArray <ETHTransactionRecordModel *>*ethRecordArray;
@property(nonatomic)NSMutableArray <ETHTransactionRecordModel *>*ethSelectRecordArray;
@property(nonatomic)NSDateFormatter* formatter;
@end

@implementation TransactionRecordVC
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
    self.view.backgroundColor = [UIColor ExportBackgroundColor];
    self.btcRecordArray = [NSMutableArray new];
    self.ethRecordArray = [NSMutableArray new];
    self.btcSelectRecordArray = [NSMutableArray new];
    self.ethSelectRecordArray = [NSMutableArray new];
    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateStyle:NSDateFormatterMediumStyle];
    [_formatter setTimeStyle:NSDateFormatterShortStyle];
    [_formatter setDateFormat:@"yyyy/MM/dd HH:MM:ss"];

    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        MJWeakSelf
        [self.tableView addHeaderRefresh:^{
            weakSelf.page = 0;
            [NetManager GetTXListBTCAdress:weakSelf.wallet.address pageNum:weakSelf.page completionHandler:^(id responseObj, NSError *error) {
                [weakSelf.tableView endHeaderRefresh];
                [weakSelf.btcRecordArray removeAllObjects];
                if (error) {
                    [weakSelf.view showAlert:@"error!" DetailMsg:error.description];
                }else{
                    NSDictionary *dic = [NSDictionary new];
                    dic = responseObj;
                    if ([dic containsObjectForKey:@"pagesTotal"]) {
                        NSString *pagesTotal = [dic objectForKey:@"pagesTotal"];
                        if (weakSelf.page < pagesTotal.intValue) {
                            weakSelf.page++;
                        }
                    }
                    if ([dic containsObjectForKey:@"txs"]) {
                        NSMutableArray *array = [NSMutableArray new];
                        array = [dic objectForKey:@"txs"];
                        for (id obj in array) {
                            BTCTransactionRecordModel *model = [BTCTransactionRecordModel parse:obj];
                            int vinaddr = 0;
                            for(VIN *vin in model.vin){
                                //自己转出
                                if ([vin.addr isEqualToString:weakSelf.wallet.address]) {
                                    model.selectType = OUT_Trans;
                                    break;
                                }
                                vinaddr ++;
                            }
                            //别人转出
                            if(vinaddr >= model.vin.count) {
                                model.selectType = IN_Trans;
                            }
                            int voutaddr = 0;
                            for (VOUT *vout in model.vout) {
                                //转给别人
                                if (![vout.scriptPubKey.addresses containsObject:weakSelf.wallet.address]) {
                                    break;
                                }
                                voutaddr ++;
                            }
                             //自己转自己
                            if (vinaddr < model.vin.count && voutaddr >= model.vout.count) {
                                model.selectType = SELF_Trans;
                            }
                            
                            if ( model.valueIn < 0 || model.valueOut <= 0) {
                                model.selectType = FAILD_Trans;
                            }
                            [weakSelf.btcRecordArray addObject:model];
                        }
                    }
                    weakSelf.btcSelectRecordArray = [weakSelf.btcRecordArray mutableCopy];
                    [weakSelf.tableView reloadData];
 
                }
            }];
        }];
        [self.tableView addFooterRefresh:^{
            [NetManager GetTXListBTCAdress:weakSelf.wallet.address pageNum:weakSelf.page completionHandler:^(id responseObj, NSError *error) {
                [weakSelf.tableView endFooterRefresh];
                if (error) {
                    [weakSelf.view showAlert:@"error!" DetailMsg:error.description];
                    
                }else{
                    if ([responseObj containsObject:@"pagesTotal"]) {
                        NSString *pagesTotal = [responseObj objectForKey:@"pagesTotal"];
                        if (weakSelf.page < pagesTotal.intValue) {
                            weakSelf.page++;
                        }
                    }
                    if ([responseObj containsObject:@"txs"]) {
                        NSMutableArray *array = [NSMutableArray new];
                        array = [responseObj objectForKey:@"txs"];
                        for (id obj in array) {
                            BTCTransactionRecordModel *model = [BTCTransactionRecordModel parse:obj];
                            int vinaddr = 0;
                            for(VIN *vin in model.vin){
                                //自己转出
                                if ([vin.addr isEqualToString:weakSelf.wallet.address]) {
                                    model.selectType = OUT_Trans;
                                    break;
                                }
                                vinaddr ++;
                            }
                            //别人转出
                            if(vinaddr >= model.vin.count) {
                                model.selectType = IN_Trans;
                            }
                            int voutaddr = 0;
                            for (VOUT *vout in model.vout) {
                                //转给别人
                                if (![vout.scriptPubKey.addresses containsObject:weakSelf.wallet.address]) {
                                    model.selectType = OUT_Trans;
                                    break;
                                }
                                voutaddr ++;
                            }
                            //自己转自己
                            if (vinaddr >= model.vin.count && voutaddr >= model.vout.count) {
                                model.selectType = SELF_Trans;
                            }
                            
                            if ( model.valueIn < 0 || model.valueOut <= 0) {
                                model.selectType = FAILD_Trans;
                            }
                            [weakSelf.btcRecordArray addObject:model];
                        }
                    }
                    weakSelf.btcSelectRecordArray = [weakSelf.btcRecordArray mutableCopy];
                    [weakSelf.tableView reloadData];
                }
            }];
        }];
        [self.tableView beginHeaderRefresh];
    }else if (self.wallet.coinType == ETH){
        MJWeakSelf
        [self.tableView addHeaderRefresh:^{
            //weakSelf.wallet.address
            
            [CreateAll GetTransactionsForAddress:weakSelf.wallet.address startBlockTag:BLOCK_TAG_LATEST Callback:^(ArrayPromise *promiseArray) {
                [weakSelf.tableView endHeaderRefresh];
                [weakSelf.ethRecordArray removeAllObjects];
                if (!promiseArray.error) {
                    for (TransactionInfo *info in promiseArray.value) {
                        ETHTransactionRecordModel *model = [ETHTransactionRecordModel new];
                        model.info = info;
                        if ([info.fromAddress.checksumAddress isEqual:weakSelf.wallet.address]) {
                            model.selectType = OUT_Trans;
                        }
                        if ([info.toAddress.checksumAddress isEqual:weakSelf.wallet.address]){
                            model.selectType = IN_Trans;
                        }
                        if ([info.fromAddress.checksumAddress isEqual:weakSelf.wallet.address] && [info.toAddress.checksumAddress isEqual:weakSelf.wallet.address]) {
                            model.selectType = SELF_Trans;
                        }
                        if (info.gasLimit.integerValue * info.gasPrice.integerValue <= 0 || info.gasUsed.integerValue <= 0) {
                            model.selectType = FAILD_Trans;
                        }
                        [weakSelf.ethRecordArray addObject:model];
                        
                    }
//                    [weakSelf.ethRecordArray addObjectsFromArray:promiseArray.value];
                    weakSelf.ethSelectRecordArray = [weakSelf.ethRecordArray mutableCopy];
                    [weakSelf.tableView reloadData];
                }else{
                    [weakSelf.view showAlert:@"error!" DetailMsg:promiseArray.error.description];
                }
            }];
           
        }];
       
        [self.tableView beginHeaderRefresh];
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
    [_titleLabel setText:self.wallet.walletName];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(33);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];

    _buttonView = [ControlBtnsView new];
    [_buttonView initButtonsViewWithTitles:@[@"全部",@"转出",@"转入",@"失败"] Width:ScreenWidth Height:44];
    for (UIButton *btn in _buttonView.btnArray) {
        [btn addTarget:self action:@selector(selectRecordStatus:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:_buttonView];
    [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(64);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
}

-(void)selectRecordStatus:(UIButton *)btn{
    [_buttonView setBtnSelected:btn];
    
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        NSMutableArray *array = [self.btcRecordArray mutableCopy];
        if (btn.tag == 0) {//全部
            self.btcSelectRecordArray = [self.btcRecordArray mutableCopy];
        }else{
            self.btcSelectRecordArray = [self.btcRecordArray mutableCopy];
            for (BTCTransactionRecordModel *model in array) {
                NSLog(@"\n\n\n %ld - %u \n\n\n",btn.tag,model.selectType);
                if (model.selectType != btn.tag) {
                    if ((btn.tag == IN_Trans || btn.tag == OUT_Trans)&& model.selectType == SELF_Trans) {
                        
                    }else{
                        [self.btcSelectRecordArray removeObject:model];
                    }
                }
            }
            
        }
    }else if(self.wallet.coinType == ETH){
        NSMutableArray *array = [self.ethRecordArray mutableCopy];
        if (btn.tag == 0) {//全部
            self.ethSelectRecordArray = [self.ethRecordArray mutableCopy];
        }else{
            self.ethSelectRecordArray = [self.ethRecordArray mutableCopy];
            for (ETHTransactionRecordModel *model in array) {
                if (model.selectType != btn.tag) {
                    if ((btn.tag == IN_Trans || btn.tag == OUT_Trans)&& model.selectType == SELF_Trans) {
                        
                    }else{
                        [self.ethSelectRecordArray removeObject:model];
                    }
                }
            }
           
        }
    }
    [self.tableView reloadData];
}




#pragma tableView - delegate
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
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        return self.btcSelectRecordArray.count;
    }else if(self.wallet.coinType == ETH){
        return self.ethSelectRecordArray.count;
    }else{
        return 0;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TransactionRecordDetailVC *dvc = [TransactionRecordDetailVC new];
    dvc.wallet = self.wallet;
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        BTCTransactionRecordModel *model = self.btcSelectRecordArray[indexPath.row];
        dvc.btcRecord = model;
        NSString *addr = nil;
        for (VOUT *vout in model.vout) {
            ScriptPubKey *pubkey = vout.scriptPubKey;
            if (![pubkey.addresses containsObject:self.wallet.address]) {
                addr = pubkey.addresses.firstObject;
            }
        }
        if (model.selectType == IN_Trans) {
            dvc.fromAddress = addr;
            dvc.toAddress = self.wallet.address;
        }else if (model.selectType == OUT_Trans){
            dvc.fromAddress = self.wallet.address;
            dvc.toAddress = self.wallet.address;
        }else if (model.selectType == SELF_Trans){
            dvc.fromAddress = addr;
            dvc.toAddress = self.wallet.address;
        }
    }else if(self.wallet.coinType == ETH){
        ETHTransactionRecordModel *model = self.ethSelectRecordArray[indexPath.row];
        dvc.ethRecord = model;
        dvc.fromAddress = model.info.fromAddress.checksumAddress;
        dvc.toAddress = model.info.toAddress.checksumAddress;
    }
    [self.navigationController pushViewController:dvc animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransactionRecordCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"TransactionRecordCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (cell == nil) {
        cell = [TransactionRecordCell new];
    }
    
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        [cell.iconImageView setImage:[UIImage imageNamed:@"ico_btc"]];
        BTCTransactionRecordModel *model = self.btcSelectRecordArray[indexPath.row];
        NSString *addr = nil;
        for (VOUT *vout in model.vout) {
            ScriptPubKey *pubkey = vout.scriptPubKey;
            if (![pubkey.addresses containsObject:self.wallet.address]) {
                addr = pubkey.addresses.firstObject;
            }
        }
        if (addr == nil) {
            addr = self.wallet.address;
        }
        NSString *str1 = [addr substringToIndex:9];
        NSString *str2 = [addr substringFromIndex:addr.length - 10];
        cell.addresslb.text = [NSString stringWithFormat:@"%@...%@",str1,str2];
        
        NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:model.time];
        NSString *timeStr=[_formatter stringFromDate:currentDate];
        [cell.timelb setText:[NSString stringWithFormat:@"%@",timeStr]];
        
        if (model.selectType == FAILD_Trans) {
            cell.resultlb.text = @"失败";
            [cell.amountlb setTextColor:[UIColor redColor]];
            [cell.resultlb setTextColor:[UIColor textBlackColor]];
        }else{
            if(model.confirmations < 6){
                cell.resultlb.text = @"确认中";
            }else{
                cell.resultlb.text = @"成功";
            }
            [cell.amountlb setTextColor:[UIColor textBlueColor]];
            [cell.resultlb setTextColor:[UIColor textLightGrayColor]];
            if (model.selectType == IN_Trans) {
                for (VOUT *vout in model.vout) {
                    //别人转给自己，取自己地址的vout
                    if ([vout.scriptPubKey.addresses containsObject:self.wallet.address]) {
                        cell.amountlb.text = [NSString stringWithFormat:@"+%.5f", vout.value.floatValue];
                    }
                }
            }else if(model.selectType == OUT_Trans){
                for (VOUT *vout in model.vout) {
                    //转给别人，取别人地址的vout
                    if (![vout.scriptPubKey.addresses containsObject:self.wallet.address]) {
                        cell.amountlb.text = [NSString stringWithFormat:@"-%.5f", vout.value.floatValue];
                    }
                }
            }else{
                cell.amountlb.text = [NSString stringWithFormat:@"0.00000"];
            }
        }
        
    }else if(self.wallet.coinType == ETH){
        [cell.iconImageView setImage:[UIImage imageNamed:@"ico_eth-1"]];
        ETHTransactionRecordModel *model = [ETHTransactionRecordModel new];
        model = self.ethSelectRecordArray[indexPath.row];
        TransactionInfo *info = [TransactionInfo new];
        info = model.info;
        NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:info.timestamp];
        NSString *timeStr=[_formatter stringFromDate:currentDate];
        [cell.timelb setText:[NSString stringWithFormat:@"%@",timeStr]];
        CGFloat amount = info.value.integerValue * 1.0 / pow(10, 18);
        if (model.selectType == IN_Trans) {
            cell.amountlb.text = [NSString stringWithFormat:@"+%.5f", amount];
        }else if(model.selectType == OUT_Trans){
            cell.amountlb.text = [NSString stringWithFormat:@"-%.5f", amount];
        }else{
            cell.amountlb.text = [NSString stringWithFormat:@"0.00000"];
        }
        cell.addresslb.text = info.toAddress.checksumAddress;
        //判断交易是否有错
        if (info.gasLimit.integerValue * info.gasPrice.integerValue == 0 || info.gasUsed == 0) {
            cell.resultlb.text = @"失败";
        }else{
            cell.resultlb.text = @"成功";
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins  = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[TransactionRecordCell class] forCellReuseIdentifier:@"TransactionRecordCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.buttonView.mas_bottom).equalTo(10);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
