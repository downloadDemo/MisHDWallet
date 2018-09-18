//
//  TransactionDetailView.m
//  TaiYiToken
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "TransactionDetailView.h"

@implementation TransactionDetailView
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.layer.cornerRadius = 12;
        _iconImageView.layer.masksToBounds = YES;
        [self addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(20);
            make.left.equalTo(30);
            make.width.height.equalTo(24);
        }];
    }
    return _iconImageView;
}

-(UILabel *)timelb{
    if (!_timelb) {
        _timelb = [UILabel new];
        _timelb.textColor = [UIColor textLightGrayColor];
        _timelb.font = [UIFont systemFontOfSize:12];
        _timelb.numberOfLines = 2;
        _timelb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_timelb];
        [_timelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(30);
            make.top.equalTo(75);
            make.width.equalTo(80);
            make.height.equalTo(30);
        }];

    }
    return _timelb;
}

-(UILabel *)amountlb{
    if (!_amountlb) {
        _amountlb = [UILabel new];
        _amountlb.textColor = [UIColor textBlackColor];
        _amountlb.font = [UIFont boldSystemFontOfSize:24];
        _amountlb.textAlignment = NSTextAlignmentRight;
        [self addSubview:_amountlb];
        [_amountlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-30);
            make.top.equalTo(20);
            make.width.equalTo(150);
            make.height.equalTo(30);
        }];
        
        UILabel *label = [UILabel new];
        label.text = @"金额";
        label.textColor = [UIColor textGrayColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-30);
            make.top.equalTo(50);
            make.width.equalTo(150);
            make.height.equalTo(20);
        }];
    }
    return _amountlb;
}

-(UILabel *)resultlb{
    if (!_resultlb) {
        _resultlb = [UILabel new];
        _resultlb.textColor = [UIColor textBlackColor];
        _resultlb.font = [UIFont boldSystemFontOfSize:9];
        _resultlb.textAlignment = NSTextAlignmentRight;
        [self addSubview:_resultlb];
        [_resultlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-30);
            make.top.equalTo(90);
            make.width.equalTo(150);
            make.height.equalTo(20);
        }];
    }
    return _resultlb;
}

/*
 @property(nonatomic,strong)RecordDetailLabel *feelb;
 @property(nonatomic,strong)RecordDetailLabel *tolb;
 @property(nonatomic,strong)RecordDetailLabel *fromlb;
 @property(nonatomic,strong)RecordDetailLabel *remarklb;
 @property(nonatomic,strong)RecordDetailLabel *tranNumberlb;
 @property(nonatomic,strong)RecordDetailLabel *blockNumberlb;
 */
-(RecordDetailLabel *)feelb{
    if (!_feelb) {
        _feelb = [RecordDetailLabel new];
        [self addSubview:_feelb];
        [_feelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(150);
            make.height.equalTo(40);
        }];
    }
    return _feelb;
}

-(RecordDetailLabel *)tolb{
    if (!_tolb) {
        _tolb = [RecordDetailLabel new];
        [self addSubview:_tolb];
        [_tolb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(150);
            make.height.equalTo(40);
        }];
    }
    return _tolb;
}
-(RecordDetailLabel *)fromlb{
    if (!_fromlb) {
        _fromlb = [RecordDetailLabel new];
        [self addSubview:_fromlb];
        [_fromlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(150);
            make.height.equalTo(40);
        }];
    }
    return _fromlb;
}
-(RecordDetailLabel *)remarklb{
    if (!_remarklb) {
        _remarklb = [RecordDetailLabel new];
        [self addSubview:_remarklb];
        [_remarklb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(150);
            make.height.equalTo(40);
        }];
    }
    return _remarklb;
}
-(RecordDetailLabel *)tranNumberlb{
    if (!_tranNumberlb) {
        _tranNumberlb = [RecordDetailLabel new];
        [self addSubview:_tranNumberlb];
        [_tranNumberlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(150);
            make.height.equalTo(40);
        }];
    }
    return _tranNumberlb;
}
-(RecordDetailLabel *)blockNumberlb{
    if (!_blockNumberlb) {
        _blockNumberlb = [RecordDetailLabel new];
        [self addSubview:_blockNumberlb];
        [_blockNumberlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(150);
            make.height.equalTo(40);
        }];
    }
    return _blockNumberlb;
}
@end
