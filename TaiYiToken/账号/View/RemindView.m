//
//  RemindView.m
//  TaiYiToken
//
//  Created by admin on 2018/8/14.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "RemindView.h"

@implementation RemindView
-(void)initRemainViewWithTitle:(NSString*)title message:(NSString*)message{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    _titleLabel = [UILabel new];
    _titleLabel.text = title;
    _titleLabel.backgroundColor = [UIColor whiteColor];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(5);
        make.right.equalTo(-5);
        make.height.equalTo(20);
    }];
    
    
    _messageLabel = [UILabel new];
    _messageLabel.text = message;
    _messageLabel.backgroundColor = [UIColor whiteColor];
    _messageLabel.textColor = [UIColor blackColor];
    _messageLabel.font = [UIFont systemFontOfSize:15];
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    _messageLabel.numberOfLines = 0;
    [self addSubview:_messageLabel];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(60);
        make.left.equalTo(5);
        make.right.equalTo(-5);
        make.height.equalTo(80);
    }];
    
    
    
    _quitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _quitBtn.backgroundColor = [UIColor whiteColor];
    _quitBtn.tintColor = [UIColor textBlueColor];
    _quitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_quitBtn setTitle:@"备份助记词" forState:UIControlStateNormal];
    [self addSubview:_quitBtn];
    _quitBtn.userInteractionEnabled = YES;
    [_quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.left.right.equalTo(0);
        make.height.equalTo(39);
    }];
    UIView *line = [UIView new];
    line.backgroundColor =[UIColor lineGrayColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-39);
        make.left.equalTo(5);
        make.right.equalTo(-5);
        make.height.equalTo(1);
    }];
    UIView *line1 = [UIView new];
    line1.backgroundColor =[UIColor lineGrayColor];
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(50);
        make.left.equalTo(5);
        make.right.equalTo(-5);
        make.height.equalTo(1);
    }];
}


@end
