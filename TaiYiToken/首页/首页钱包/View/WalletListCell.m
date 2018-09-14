//
//  WalletListCell.m
//  TaiYiToken
//
//  Created by admin on 2018/9/3.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "WalletListCell.h"

@implementation WalletListCell
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        [self.swipeContentView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.centerY.equalTo(0);
            make.width.height.equalTo(20);
        }];
    }
    return _iconImageView;
}
-(UILabel *)symbolNamelb{
    if (!_symbolNamelb) {
        _symbolNamelb = [UILabel new];
        _symbolNamelb.textColor = [UIColor textLightGrayColor];
        _symbolNamelb.font = [UIFont systemFontOfSize:10];
        _symbolNamelb.textAlignment = NSTextAlignmentLeft;
        [self.swipeContentView addSubview:_symbolNamelb];
        [_symbolNamelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(40);
            make.top.equalTo(17);
            make.width.equalTo(50);
            make.height.equalTo(12);
        }];
    }
    return _symbolNamelb;
}
- (UILabel *)symbollb {
    if(_symbollb == nil) {
        _symbollb = [[UILabel alloc] init];
        _symbollb.textColor = [UIColor textBlackColor];
        _symbollb.font = [UIFont systemFontOfSize:15];
        _symbollb.textAlignment = NSTextAlignmentLeft;
        _symbollb.numberOfLines = 1;
        [self.swipeContentView addSubview:_symbollb];
        [_symbollb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(40);
            make.bottom.equalTo(-20);
            make.width.equalTo(50);
            make.height.equalTo(18);
        }];
        
    }
    return _symbollb;
}
- (UILabel *)amountlb {
    if(_amountlb == nil) {
        _amountlb = [[UILabel alloc] init];
        _amountlb.textColor = [UIColor blackColor];
        _amountlb.font = [UIFont boldSystemFontOfSize:15];
        _amountlb.textAlignment = NSTextAlignmentLeft;
        _amountlb.numberOfLines = 1;
        [self.swipeContentView addSubview:_amountlb];
        [_amountlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(30);
            make.centerY.equalTo(0);
            make.width.equalTo(90);
            make.height.equalTo(20);
        }];
        
    }
    return _amountlb;
}
- (UILabel *)valuelb {
    if(_valuelb == nil) {
        _valuelb = [[UILabel alloc] init];
        _valuelb.textColor = [UIColor textBlackColor];
        _valuelb.font = [UIFont systemFontOfSize:15];
        _valuelb.textAlignment = NSTextAlignmentRight;
        _valuelb.numberOfLines = 1;
        [self.swipeContentView addSubview:_valuelb];
        [_valuelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(17);
            make.right.equalTo(-10);
            make.width.equalTo(90);
            make.height.equalTo(12);
        }];
        
    }
    return _valuelb;
}
- (UILabel *)rmbvaluelb {
    if(_rmbvaluelb == nil) {
        _rmbvaluelb = [[UILabel alloc] init];
        _rmbvaluelb.textColor = [UIColor textGrayColor];
        _rmbvaluelb.font = [UIFont boldSystemFontOfSize:10];
        _rmbvaluelb.textAlignment = NSTextAlignmentRight;
        _rmbvaluelb.numberOfLines = 1;
        [self.swipeContentView addSubview:_rmbvaluelb];
        [_rmbvaluelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-20);
            make.right.equalTo(-10);
            make.width.equalTo(90);
            make.height.equalTo(12);
        }];
        
    }
    return _rmbvaluelb;
}

@end
