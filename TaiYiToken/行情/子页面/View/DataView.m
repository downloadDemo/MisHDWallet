
//
//  DataView.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/17.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "DataView.h"
#define TITLETEXTCOLOR [UIColor colorWithHexString:@"#F32727"]
#define DATATEXTCOLOR  [UIColor colorWithHexString:@"#706F6F"]
@implementation DataView

- (UILabel *)dollarlabel {
    if(_dollarlabel == nil) {
        _dollarlabel = [[UILabel alloc] init];
        _dollarlabel.textColor = TITLETEXTCOLOR;
        _dollarlabel.font = [UIFont boldSystemFontOfSize:24];
        _dollarlabel.textAlignment = NSTextAlignmentLeft;
        _dollarlabel.numberOfLines = 1;
        [self addSubview:_dollarlabel];
        [_dollarlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(20);
            make.width.equalTo(130);
            make.height.equalTo(30);
        }];
    }
    return _dollarlabel;
}
- (UILabel *)rmblabel {
    if(_rmblabel == nil) {
        _rmblabel = [[UILabel alloc] init];
        _rmblabel.textColor = TITLETEXTCOLOR;
        _rmblabel.font = [UIFont systemFontOfSize:12];
        _rmblabel.textAlignment = NSTextAlignmentLeft;
        _rmblabel.numberOfLines = 1;
        [self addSubview:_rmblabel];
        [_rmblabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(self.dollarlabel.mas_bottom);
            make.width.equalTo(150);
            make.height.equalTo(20);
        }];
    }
    return _rmblabel;
}
- (UILabel *)ratelabel {
    if(_ratelabel == nil) {
        _ratelabel = [[UILabel alloc] init];
        _ratelabel.textColor = TITLETEXTCOLOR;
        _ratelabel.font = [UIFont systemFontOfSize:14];
        _ratelabel.textAlignment = NSTextAlignmentLeft;
        _ratelabel.numberOfLines = 1;
        [self addSubview:_ratelabel];
        [_ratelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dollarlabel.mas_right).equalTo(5);
            make.bottom.equalTo(self.dollarlabel.mas_bottom);
            make.width.equalTo(150);
            make.height.equalTo(20);
        }];
    }
    return _ratelabel;
}
- (UILabel *)marketpricelabel {
    if(_marketpricelabel == nil) {
        _marketpricelabel = [[UILabel alloc] init];
        _marketpricelabel.textColor = DATATEXTCOLOR;
        _marketpricelabel.font = [UIFont boldSystemFontOfSize:11];
        _marketpricelabel.textAlignment = NSTextAlignmentLeft;
        _marketpricelabel.numberOfLines = 1;
        [self addSubview:_marketpricelabel];
        [_marketpricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.bottom.equalTo(-10);
            make.right.equalTo(-20);
            make.height.equalTo(20);
        }];
    }
    return _marketpricelabel;
}

@end
