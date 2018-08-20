//
//  ButtonsView.m
//  TaiYiToken
//
//  Created by admin on 2018/8/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ButtonsView.h"
#define BtnColor RGB(250, 250, 250)
#define SelectColor [UIColor textBlueColor]
#define DeSelectColor [UIColor textGrayColor]
@implementation ButtonsView
-(void)initButtonsViewWidth:(CGFloat)width Height:(CGFloat)height{
    _oneMinuteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _oneMinuteBtn.backgroundColor = BtnColor;
    _oneMinuteBtn.tintColor = [UIColor blackColor];
    _oneMinuteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_oneMinuteBtn setTitleColor:SelectColor forState:UIControlStateSelected];
    [_oneMinuteBtn setTitleColor:DeSelectColor forState:UIControlStateNormal];
    [_oneMinuteBtn setTitle:@"1分钟" forState:UIControlStateNormal];
    [_oneMinuteBtn setTitle:@"1分钟" forState:UIControlStateSelected];
    [self addSubview:_oneMinuteBtn];
    _oneMinuteBtn.userInteractionEnabled = YES;
    [_oneMinuteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(0);
        make.width.equalTo(width/5);
        make.height.equalTo(height);
    }];
    
    _sixMinuteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sixMinuteBtn.backgroundColor = BtnColor;
    _sixMinuteBtn.tintColor = [UIColor blackColor];
    _sixMinuteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_sixMinuteBtn setTitleColor:SelectColor forState:UIControlStateSelected];
    [_sixMinuteBtn setTitleColor:DeSelectColor forState:UIControlStateNormal];
    [_sixMinuteBtn setTitle:@"6分钟" forState:UIControlStateNormal];
    [self addSubview:_sixMinuteBtn];
    _sixMinuteBtn.userInteractionEnabled = YES;
    [_sixMinuteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.left.equalTo(width/5);
        make.width.equalTo(width/5);
        make.height.equalTo(height);
    }];
    
    _dayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _dayBtn.backgroundColor = BtnColor;
    _dayBtn.tintColor = [UIColor blackColor];

    _dayBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_dayBtn setTitle:@"日" forState:UIControlStateNormal];
    [_dayBtn setTitleColor:SelectColor forState:UIControlStateSelected];
    [_dayBtn setTitleColor:DeSelectColor forState:UIControlStateNormal];
    [self addSubview:_dayBtn];
    _dayBtn.userInteractionEnabled = YES;
    [_dayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(width/5*2);
        make.width.equalTo(width/5);
        make.height.equalTo(height);
    }];
    
    _weekBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _weekBtn.backgroundColor = BtnColor;
    _weekBtn.tintColor = [UIColor blackColor];
//    _weekBtn.layer.borderColor = [UIColor grayColor].CGColor;
//    _weekBtn.layer.borderWidth = 1;
    _weekBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_weekBtn setTitle:@"周" forState:UIControlStateNormal];
    [_weekBtn setTitleColor:SelectColor forState:UIControlStateSelected];
    [_weekBtn setTitleColor:DeSelectColor forState:UIControlStateNormal];
    [self addSubview:_weekBtn];
    _weekBtn.userInteractionEnabled = YES;
    [_weekBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(width/5*3);
        make.width.equalTo(width/5);
        make.height.equalTo(height);
    }];
    
    _monthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _monthBtn.backgroundColor = BtnColor;
    _monthBtn.tintColor = [UIColor blackColor];
//    _monthBtn.layer.borderColor = [UIColor grayColor].CGColor;
//    _monthBtn.layer.borderWidth = 1;
    _monthBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_monthBtn setTitle:@"月" forState:UIControlStateNormal];
    [_monthBtn setTitleColor:SelectColor forState:UIControlStateSelected];
    [_monthBtn setTitleColor:DeSelectColor forState:UIControlStateNormal];
    [self addSubview:_monthBtn];
    _monthBtn.userInteractionEnabled = YES;
    [_monthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(width/5*4);
        make.width.equalTo(width/5);
        make.height.equalTo(height);
    }];
    
    self.btnArray = [NSArray arrayWithObjects:_oneMinuteBtn,_sixMinuteBtn,_dayBtn,_weekBtn,_monthBtn, nil];
}


@end
