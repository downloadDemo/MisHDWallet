
//
//  DataView.m
//  TaiYiToken
//
//  Created by admin on 2018/8/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "DataView.h"

@implementation DataView

- (UIImageView *)iconImageView {
    if(_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.image = [UIImage imageNamed:@"ico_btc"];
        _iconImageView.tintColor = [UIColor whiteColor];
        [self addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(20);
            make.left.equalTo(20);
            make.width.height.equalTo(24);
        }];
    }
    return _iconImageView;
}
- (UILabel *)namelabel {
    if(_namelabel == nil) {
        _namelabel = [[UILabel alloc] init];
        _namelabel.textColor = [UIColor blackColor];
        _namelabel.font = [UIFont boldSystemFontOfSize:17];
        _namelabel.textAlignment = NSTextAlignmentLeft;
        _namelabel.numberOfLines = 1;
        [self addSubview:_namelabel];
        [_namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).equalTo(5);
            make.top.equalTo(20);
            make.width.equalTo(60);
            make.height.equalTo(20);
        }];
        
    }
    return _namelabel;
}
- (UILabel *)dollarlabel {
    if(_dollarlabel == nil) {
        _dollarlabel = [[UILabel alloc] init];
        _dollarlabel.textColor = [UIColor blackColor];
        _dollarlabel.font = [UIFont boldSystemFontOfSize:17];
        _dollarlabel.textAlignment = NSTextAlignmentCenter;
        _dollarlabel.numberOfLines = 1;
        [self addSubview:_dollarlabel];
        [_dollarlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(10);
            make.width.equalTo(150);
            make.height.equalTo(20);
        }];
        
    }
    return _dollarlabel;
}
- (UILabel *)rmblabel {
    if(_rmblabel == nil) {
        _rmblabel = [[UILabel alloc] init];
        _rmblabel.textColor = [UIColor textGrayColor];
        _rmblabel.font = [UIFont systemFontOfSize:13];
        _rmblabel.textAlignment = NSTextAlignmentCenter;
        _rmblabel.numberOfLines = 1;
        [self addSubview:_rmblabel];
        [_rmblabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(35);
            make.width.equalTo(150);
            make.height.equalTo(20);
        }];
    }
    return _rmblabel;
}
- (UILabel *)ratelabel {
    if(_ratelabel == nil) {
        _ratelabel = [[UILabel alloc] init];
        _ratelabel.textColor = [UIColor textOrangeColor];
        _ratelabel.font = [UIFont boldSystemFontOfSize:17];
        _ratelabel.textAlignment = NSTextAlignmentRight;
        _ratelabel.numberOfLines = 1;
        [self addSubview:_ratelabel];
        [_ratelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10);
            make.top.equalTo(25);
            make.width.equalTo(150);
            make.height.equalTo(20);
        }];
    }
    return _ratelabel;
}

- (UILabel *)openlabel {
    if(_openlabel == nil) {
        _openlabel = [[UILabel alloc] init];
        _openlabel.textColor = [UIColor blackColor];
        _openlabel.font = [UIFont boldSystemFontOfSize:13];
        _openlabel.textAlignment = NSTextAlignmentCenter;
        _openlabel.numberOfLines = 1;
        [self addSubview:_openlabel];
        [_openlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.bottom.equalTo(-35);
            make.width.equalTo(ScreenWidth/4);
            make.height.equalTo(20);
        }];
        
        UILabel *textlb = [[UILabel alloc] init];
        textlb.textColor = [UIColor textGrayColor];
        textlb.font = [UIFont systemFontOfSize:13];
        textlb.textAlignment = NSTextAlignmentCenter;
        textlb.text = @"开盘";
        textlb.numberOfLines = 1;
        [self addSubview:textlb];
        [textlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.bottom.equalTo(-10);
            make.width.equalTo(ScreenWidth/4);
            make.height.equalTo(20);
        }];
        
    }
    return _openlabel;
}
- (UILabel *)highlabel {
    if(_highlabel == nil) {
        _highlabel = [[UILabel alloc] init];
        _highlabel.textColor = [UIColor blackColor];
        _highlabel.font = [UIFont boldSystemFontOfSize:13];
        _highlabel.textAlignment = NSTextAlignmentCenter;
        _highlabel.numberOfLines = 1;
        [self addSubview:_highlabel];
        [_highlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-ScreenWidth/2+15);
            make.bottom.equalTo(-35);
            make.width.equalTo(ScreenWidth/4);
            make.height.equalTo(20);
        }];
        
        UILabel *textlb = [[UILabel alloc] init];
        textlb.textColor = [UIColor textGrayColor];
        textlb.font = [UIFont systemFontOfSize:13];
        textlb.textAlignment = NSTextAlignmentCenter;
        textlb.text = @"最高";
        textlb.numberOfLines = 1;
        [self addSubview:textlb];
        [textlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-ScreenWidth/2+15);
            make.bottom.equalTo(-10);
            make.width.equalTo(ScreenWidth/4);
            make.height.equalTo(20);
        }];
    }
    return _highlabel;
}
- (UILabel *)lowlabel {
    if(_lowlabel == nil) {
        _lowlabel = [[UILabel alloc] init];
        _lowlabel.textColor = [UIColor blackColor];
        _lowlabel.font = [UIFont boldSystemFontOfSize:13];
        _lowlabel.textAlignment = NSTextAlignmentCenter;
        _lowlabel.numberOfLines = 1;
        [self addSubview:_lowlabel];
        [_lowlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ScreenWidth/2-15);
            make.bottom.equalTo(-35);
            make.width.equalTo(ScreenWidth/4);
            make.height.equalTo(20);
        }];
        
        UILabel *textlb = [[UILabel alloc] init];
        textlb.textColor = [UIColor textGrayColor];
        textlb.font = [UIFont systemFontOfSize:13];
        textlb.textAlignment = NSTextAlignmentCenter;
        textlb.text = @"最低";
        textlb.numberOfLines = 1;
        [self addSubview:textlb];
        [textlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ScreenWidth/2-15);
            make.bottom.equalTo(-10);
            make.width.equalTo(ScreenWidth/4);
            make.height.equalTo(20);
        }];
    }
    return _lowlabel;
}
- (UILabel *)volumelabel {
    if(_volumelabel == nil) {
        _volumelabel = [[UILabel alloc] init];
        _volumelabel.textColor = [UIColor blackColor];
        _volumelabel.font = [UIFont boldSystemFontOfSize:13];
        _volumelabel.textAlignment = NSTextAlignmentCenter;
        _volumelabel.numberOfLines = 1;
        [self addSubview:_volumelabel];
        [_volumelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10);
            make.bottom.equalTo(-35);
            make.width.equalTo(ScreenWidth/4);
            make.height.equalTo(20);
        }];
        
        UILabel *textlb = [[UILabel alloc] init];
        textlb.textColor = [UIColor textGrayColor];
        textlb.font = [UIFont systemFontOfSize:13];
        textlb.textAlignment = NSTextAlignmentCenter;
        textlb.text = @"成交量";
        textlb.numberOfLines = 1;
        [self addSubview:textlb];
        [textlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10);
            make.bottom.equalTo(-10);
            make.width.equalTo(ScreenWidth/4);
            make.height.equalTo(20);
        }];
    }
    return _volumelabel;
}
@end
