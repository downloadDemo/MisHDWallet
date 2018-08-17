//
//  MarketCell.m
//  TaiYiToken
//
//  Created by admin on 2018/8/15.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MarketCell.h"

@implementation MarketCell
- (UILabel *)namelabel {
    if(_namelabel == nil) {
        _namelabel = [[UILabel alloc] init];
        _namelabel.textColor = [UIColor grayColor];
        _namelabel.font = [UIFont systemFontOfSize:10];
        _namelabel.textAlignment = NSTextAlignmentLeft;
        _namelabel.numberOfLines = 1;
        [self.contentView addSubview:_namelabel];
        [_namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.top.equalTo(8);
            make.width.equalTo(90);
            make.height.equalTo(12);
        }];
        
    }
    return _namelabel;
}
- (UILabel *)coinNamelabel {
    if(_coinNamelabel == nil) {
        _coinNamelabel = [[UILabel alloc] init];
        _coinNamelabel.textColor = [UIColor blackColor];
        _coinNamelabel.font = [UIFont boldSystemFontOfSize:15];
        _coinNamelabel.textAlignment = NSTextAlignmentLeft;
        _coinNamelabel.numberOfLines = 1;
        [self.contentView addSubview:_coinNamelabel];
        [_coinNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.top.equalTo(20);
            make.width.equalTo(90);
            make.height.equalTo(20);
        }];
        
    }
    return _coinNamelabel;
}
- (UILabel *)marketValuelabel {
    if(_marketValuelabel == nil) {
        _marketValuelabel = [[UILabel alloc] init];
        _marketValuelabel.textColor = [UIColor grayColor];
        _marketValuelabel.font = [UIFont systemFontOfSize:10];
        _marketValuelabel.textAlignment = NSTextAlignmentLeft;
        _marketValuelabel.numberOfLines = 1;
        [self addSubview:_marketValuelabel];
        [_marketValuelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.top.equalTo(self.coinNamelabel.mas_bottom).equalTo(5);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }];
        
    }
    return _marketValuelabel;
}
- (UILabel *)pricelabel {
    if(_pricelabel == nil) {
        _pricelabel = [[UILabel alloc] init];
        _pricelabel.textColor = [UIColor blackColor];
        _pricelabel.font = [UIFont boldSystemFontOfSize:15];
        _pricelabel.textAlignment = NSTextAlignmentLeft;
        _pricelabel.numberOfLines = 1;
        [self addSubview:_pricelabel];
        [_pricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(160);
            make.centerY.equalTo(0);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }];
        
    }
    return _pricelabel;
}

- (UILabel *)ratelabel {
    if(_ratelabel == nil) {
        _ratelabel = [[UILabel alloc] init];
        _ratelabel.textColor = [UIColor textOrangeColor];
        _ratelabel.font = [UIFont boldSystemFontOfSize:15];
        _ratelabel.textAlignment = NSTextAlignmentRight;
        _ratelabel.numberOfLines = 1;
        [self addSubview:_ratelabel];
        [_ratelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10);
            make.centerY.equalTo(0);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }];
        
    }
    return _ratelabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
