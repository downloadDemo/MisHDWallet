//
//  CurrencyModel.h
//  TaiYiToken
//
//  Created by admin on 2018/8/15.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyModel : NSObject
@property (nonatomic, assign) NSInteger circulation;
@property (nonatomic, strong) NSString * describe;
@property (nonatomic, assign) CGFloat dollar;
@property (nonatomic, assign) CGFloat highPrice;
@property (nonatomic, assign) CGFloat lastPrice;
@property (nonatomic, assign) CGFloat lowPrice;
@property (nonatomic, assign) CGFloat marketValue;
@property (nonatomic, assign) CGFloat openPrice;
@property (nonatomic, assign) CGFloat priceChangePercent;
@property (nonatomic, assign) CGFloat quoteVolume;
@property (nonatomic, assign) CGFloat rmb;
@property (nonatomic, strong) NSString * symbol;
@property (nonatomic, assign) CGFloat turnover;
@end

