//
//  MarketDetailVC.h
//  TaiYiToken
//
//  Created by admin on 2018/8/16.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"
#import "KLinePointModel.h"
@interface MarketDetailVC : UIViewController
@property(nonatomic)SymbolModel *symbolmodel;
@property(nonatomic,copy)NSString *mysymbol;
@end
