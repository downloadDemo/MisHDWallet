//
//  SelfChooseVC.h
//  TaiYiToken
//
//  Created by admin on 2018/8/15.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"
@interface SelfChooseVC : UIViewController
@property(nonatomic)NSMutableArray <CurrencyModel*> *modelarray;
@property(nonatomic)UITableView *tableView;
@end
