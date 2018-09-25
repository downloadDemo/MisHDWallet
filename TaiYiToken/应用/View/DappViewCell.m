//
//  DappViewCell.m
//  TaiYiToken
//
//  Created by admin on 2018/9/25.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "DappViewCell.h"

@implementation DappViewCell
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        _shadowView = [UIView new];
        _shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
        _shadowView.layer.shadowOffset = CGSizeMake(0, 0);
        _shadowView.layer.shadowOpacity = 1;
        _shadowView.layer.shadowRadius = 3.0;
        _shadowView.layer.cornerRadius = 3.0;
        _shadowView.clipsToBounds = NO;
        [self addSubview:_shadowView];
        [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        
        _iconImageView = [UIImageView new];
        [self.shadowView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(16);
            make.centerX.equalTo(0);
            make.width.height.equalTo(32);
        }];
    }
    return _iconImageView;
}
-(UILabel *)namelb{
    if (!_namelb) {
        _namelb = [UILabel new];
        _namelb.textColor = [UIColor textBlackColor];
        _namelb.font = [UIFont systemFontOfSize:12];
        _namelb.textAlignment = NSTextAlignmentCenter;
        [self.shadowView addSubview:_namelb];
        [_namelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.bottom.equalTo(-16);
            make.height.equalTo(15);
        }];
    }
    return _namelb;
}
@end
