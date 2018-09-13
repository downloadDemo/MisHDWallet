//
//  TransactionGasView.m
//  TaiYiToken
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "TransactionGasView.h"

@implementation TransactionGasView

-(void)initUI{
    //手续费
    UILabel *namelb = [UILabel new];
    namelb.textColor = [UIColor textBlackColor];
    namelb.font = [UIFont boldSystemFontOfSize:13];
    namelb.textAlignment = NSTextAlignmentLeft;
    namelb.text = @"手续费";
    [self addSubview:namelb];
    [namelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(17);
        make.top.equalTo(10);
        make.width.equalTo(50);
        make.height.equalTo(20);
    }];
    //0.001 ether ≈ ￥0.19
    _gaspricelb = [UILabel new];
    _gaspricelb.textColor = RGBACOLOR(23, 107, 172, 1);
    _gaspricelb.font = [UIFont boldSystemFontOfSize:13];
    _gaspricelb.textAlignment = NSTextAlignmentRight;
    [self addSubview:_gaspricelb];
    [_gaspricelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.top.equalTo(10);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
}

@end
