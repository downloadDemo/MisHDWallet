//
//  SelfChooseVC.h
//  TaiYiToken
//
//  Created by admin on 2018/8/15.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"
#import "CustomizedNavigationController.h"
@interface SelfChooseVC : UIViewController
@property(nonatomic)NSMutableArray <CurrencyModel*> *modelarray;
@property(nonatomic)UITableView *tableView;
@property(nonatomic, weak)CustomizedNavigationController *nvc;
@property(nonatomic)BOOL ifShouldRequest;//当是搜索页面时 不请求数据 NO
@end
