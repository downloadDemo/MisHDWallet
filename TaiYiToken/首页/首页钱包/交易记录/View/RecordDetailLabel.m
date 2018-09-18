//
//  RecordDetailLabel.m
//  TaiYiToken
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "RecordDetailLabel.h"

@implementation RecordDetailLabel

-(void)initWithTitle:(NSString *)title Detail:(NSAttributedString *)detail{
    if (!_titlelb) {
        _titlelb = [UILabel new];
        _titlelb.textColor = [UIColor textGrayColor];
        _titlelb.textAlignment = NSTextAlignmentLeft;
        _titlelb.font = [UIFont systemFontOfSize:13 weight:0];
        _titlelb.text = title;
        [self addSubview:_titlelb];
        [_titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(30);
            make.height.equalTo(20);
            make.width.equalTo(100);
        }];
    }
   
    if (!_detaillb) {
        _detaillb = [UILabel new];
        _detaillb.textColor = [UIColor textBlackColor];
        _detaillb.textAlignment = NSTextAlignmentCenter;
        _detaillb.font = [UIFont systemFontOfSize:13 weight:0];
        _detaillb.numberOfLines = 0;
        _detaillb.attributedText = detail;
        [self addSubview:_detaillb];
        [_detaillb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(140);
            make.height.equalTo(40);
            make.right.equalTo(-30);
        }];
    }

}

@end
