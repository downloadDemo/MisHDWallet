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
    self.backgroundColor = [UIColor whiteColor];
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
    
    // 滑动条slider
    _gasSlider = [UISlider new];
    [self addSubview:_gasSlider];
    [_gasSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(50);
        make.centerX.equalTo(0);
        make.width.equalTo(250);
        make.height.equalTo(20);
    }];

    // 当前值label
    _valueLabel = [UILabel new];
    _valueLabel.font = [UIFont systemFontOfSize:15];
    _valueLabel.textColor = [UIColor textLightGrayColor];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_valueLabel];
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.gasSlider.mas_bottom).equalTo(5);
        make.height.equalTo(20);
    }];
    
    // 最小值label
    UILabel *minLabel = [UILabel new];
    minLabel.font = [UIFont systemFontOfSize:15];
    minLabel.textColor = [UIColor textBlackColor];
    minLabel.textAlignment = NSTextAlignmentRight;
    minLabel.text = [NSString stringWithFormat:@"慢"];
    [self addSubview:minLabel];
    [minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(self.gasSlider.mas_left);
        make.height.equalTo(20);
        make.top.equalTo(self.gasSlider.mas_top);
    }];
    
    // 最大值label
    UILabel *maxLabel = [UILabel new];
    maxLabel.textAlignment = NSTextAlignmentLeft;
    maxLabel.font = [UIFont systemFontOfSize:15];
    maxLabel.textColor = [UIColor textBlackColor];
    maxLabel.text = [NSString stringWithFormat:@"快"];
    [self addSubview:maxLabel];
    [maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.left.equalTo(self.gasSlider.mas_right);
        make.height.equalTo(20);
        make.top.equalTo(self.gasSlider.mas_top);
    }];
}
-(void)updateLabelValues:(CGFloat)value{
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f gwei",value];
}
@end
