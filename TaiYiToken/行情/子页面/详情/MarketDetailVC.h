//
//  MarketDetailVC.h
//  TaiYiToken
//
//  Created by Frued on 2018/8/16.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"
#import "KLinePointModel.h"
@interface MarketDetailVC : UIViewController
@property(nonatomic)SymbolModel *symbolmodel;
@property(nonatomic,copy)NSString *mysymbol;
//@property(nonatomic)xKLinePointModel *klinemodel;
/* KLinePointModel */
@property (nonatomic) CoinBaseInfo * coinBaseInfo;
@property (nonatomic) NSMutableArray <klineData *> * klineDataarray;
@property (nonatomic, copy) NSString * rmbMarketValue;
@property (nonatomic) SymbolInfo * symbolInfo;
@end
