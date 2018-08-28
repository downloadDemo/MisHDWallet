//
//  MarketVC.h
//  TaiYiToken
//
//  Created by admin on 2018/8/15.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"
#import "ContainerViewController.h"
@interface MarketVC : UIViewController
@property(nonatomic)NSString *indexName;
@property(nonatomic)CurrencyModel *currency;
@property (nonatomic, strong) NSMutableArray <SymbolModel *>* modelarray;
@property(nonatomic)UITableView *tableView;
@property(nonatomic,strong)UIView *navView;;
@property(nonatomic)BOOL ifNeedRequestData;
@end
