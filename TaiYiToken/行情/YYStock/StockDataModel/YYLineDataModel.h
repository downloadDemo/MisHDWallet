//
//  YYLineDataModel.h
//  投融宝
//
//  Created by WillkYang on 16/10/5.
//  Copyright © 2016年 yeeyuntech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "YYStockDataProtocol.h"

/**
 外部实现
 */
@interface YYLineDataModel : NSObject <YYLineDataModelProtocol>

- (void)updateMA:(NSArray *)parentDictArray index:(NSInteger)index;


//@property (nonatomic, assign) BOOL isShowDay;
@property (nonatomic, strong) id<YYLineDataModelProtocol> preDataModel;
@property (nonatomic, strong) NSString *showDay;
@property (nonatomic, strong) NSNumber *Close;
@property (nonatomic, strong) NSNumber *Open;
@property (nonatomic, strong) NSNumber *Low;
@property (nonatomic, strong) NSNumber *High;
@property (nonatomic, assign) CGFloat Volume;
@property (nonatomic, strong) NSNumber *MA5;
@property (nonatomic, strong) NSNumber *MA10;
@property (nonatomic, strong) NSNumber *MA20;
@property (nonatomic, strong) NSDictionary *dict;

@end
