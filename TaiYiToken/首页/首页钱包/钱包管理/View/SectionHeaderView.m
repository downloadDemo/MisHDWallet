//
//  SectionHeaderView.m
//  TaiYiToken
//
//  Created by admin on 2018/9/7.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame
            ];
    if (self){
        self.backgroundColor = RGB(70, 90, 120);
    }
    return self;
}
-(UILabel *)remindlb{
    if (_remindlb == nil) {

        _remindlb = [UILabel new];
        _remindlb.textColor = [UIColor textWhiteColor];
        _remindlb.font = [UIFont boldSystemFontOfSize:12];
        _remindlb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_remindlb];
        [_remindlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.centerY.equalTo(0);
            make.right.equalTo(-20);
            make.height.equalTo(20);
        }];
    }
    return _remindlb;
}
@end
