//
//  TransactionRecordDetailVC.h
//  TaiYiToken
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTCTransactionRecordModel.h"
#import "ETHTransactionRecordModel.h"
@interface TransactionRecordDetailVC : UIViewController
//@property(nonatomic)NSString *btcTxid;
//@property(nonatomic)NSString *ethtransactionHash;

@property(nonatomic)NSString *fromAddress;
@property(nonatomic)NSString *toAddress;

@property(nonatomic,strong)BTCTransactionRecordModel *btcRecord;
@property(nonatomic,strong)ETHTransactionRecordModel *ethRecord;
@property(nonatomic)MissionWallet *wallet;
@end
