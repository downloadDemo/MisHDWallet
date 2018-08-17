//
//  ButtonsView.m
//  TaiYiToken
//
//  Created by admin on 2018/8/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ButtonsView.h"

@implementation ButtonsView
-(void)initButtonsViewWidth:(CGFloat)width Height:(CGFloat)height{
    _oneMinuteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _oneMinuteBtn.backgroundColor = [UIColor whiteColor];
    _oneMinuteBtn.tintColor = [UIColor blackColor];
    _oneMinuteBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _oneMinuteBtn.layer.borderWidth = 1;
    _oneMinuteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_oneMinuteBtn setTitle:@"1分钟" forState:UIControlStateNormal];
    [self addSubview:_oneMinuteBtn];
    _oneMinuteBtn.userInteractionEnabled = YES;
    [_oneMinuteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(0);
        make.width.equalTo(width/5);
        make.height.equalTo(height);
    }];
    
    _sixMinuteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _sixMinuteBtn.backgroundColor = [UIColor whiteColor];
    _sixMinuteBtn.tintColor = [UIColor blackColor];
    _sixMinuteBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _sixMinuteBtn.layer.borderWidth = 1;
    _sixMinuteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_sixMinuteBtn setTitle:@"6分钟" forState:UIControlStateNormal];
    [self addSubview:_sixMinuteBtn];
    _sixMinuteBtn.userInteractionEnabled = YES;
    [_sixMinuteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(width/5);
        make.width.equalTo(width/5);
        make.height.equalTo(height);
    }];
    
    _dayBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _dayBtn.backgroundColor = [UIColor whiteColor];
    _dayBtn.tintColor = [UIColor blackColor];
    _dayBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _dayBtn.layer.borderWidth = 1;
    _dayBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_dayBtn setTitle:@"日" forState:UIControlStateNormal];
    [self addSubview:_dayBtn];
    _dayBtn.userInteractionEnabled = YES;
    [_dayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(width/5*2);
        make.width.equalTo(width/5);
        make.height.equalTo(height);
    }];
    
    _weekBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _weekBtn.backgroundColor = [UIColor whiteColor];
    _weekBtn.tintColor = [UIColor blackColor];
    _weekBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _weekBtn.layer.borderWidth = 1;
    _weekBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_weekBtn setTitle:@"周" forState:UIControlStateNormal];
    [self addSubview:_weekBtn];
    _weekBtn.userInteractionEnabled = YES;
    [_weekBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(width/5*3);
        make.width.equalTo(width/5);
        make.height.equalTo(height);
    }];
    
    _monthBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _monthBtn.backgroundColor = [UIColor whiteColor];
    _monthBtn.tintColor = [UIColor blackColor];
    _monthBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _monthBtn.layer.borderWidth = 1;
    _monthBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_monthBtn setTitle:@"月" forState:UIControlStateNormal];
    [self addSubview:_monthBtn];
    _monthBtn.userInteractionEnabled = YES;
    [_monthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(width/5*4);
        make.width.equalTo(width/5);
        make.height.equalTo(height);
    }];
 
}


@end
