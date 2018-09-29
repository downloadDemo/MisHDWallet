//
//  UserInfoHeadView.m
//  TaiYiToken
//
//  Created by admin on 2018/9/25.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "UserInfoHeadView.h"

@implementation UserInfoHeadView
-(UIImageView *)iconiv{
    if (!_iconiv) {
        _iconiv = [UIImageView new];
        _iconiv.layer.cornerRadius = 27;
        _iconiv.layer.masksToBounds = YES;
        _iconiv.layer.borderWidth = 0;
        _iconiv.layer.borderColor = [UIColor blackColor].CGColor;
        [self addSubview:_iconiv];
        [_iconiv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(54);
            make.left.equalTo(16);
            make.centerY.equalTo(0);
        }];
    }
    return _iconiv;
}
-(UILabel *)usernamelb{
    if (!_usernamelb) {
        _usernamelb = [UILabel new];
        _usernamelb.textColor = [UIColor textBlackColor];
        _usernamelb.font = [UIFont systemFontOfSize:15];
        _usernamelb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_usernamelb];
        [_usernamelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(90);
            make.centerY.equalTo(0);
            make.right.equalTo(-20);
            make.height.equalTo(20);
        }];
        
    }
    return _usernamelb;
}
-(UILabel *)titlelb{
    if (!_titlelb) {
        _titlelb = [UILabel new];
        _titlelb.textColor = [UIColor textGrayColor];
        _titlelb.font = [UIFont systemFontOfSize:10];
        _titlelb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titlelb];
        [_titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(90);
            make.top.equalTo(70);
            make.right.equalTo(-20);
            make.height.equalTo(20);
        }];
        
    }
    return _titlelb;
}


@end
