//
//  WalletManagerCell.m
//  TaiYiToken
//
//  Created by admin on 2018/9/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "WalletManagerCell.h"

@implementation WalletManagerCell
-(UILabel *)namelb{
    if (!_namelb) {
        _namelb = [UILabel new];
        _namelb.textColor = [UIColor textWhiteColor];
        _namelb.font = [UIFont boldSystemFontOfSize:18];
        _namelb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_namelb];
        [_namelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(26);
            make.top.equalTo(22);
            make.right.equalTo(-30);
            make.height.equalTo(20);
        }];
    }
    return _namelb;
}
-(UIButton *)addressBtn{
    if (!_addressBtn) {
        _addressBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _addressBtn.userInteractionEnabled = YES;
        _addressBtn.titleLabel.textColor = [UIColor textWhiteColor];
        _addressBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _addressBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView  addSubview:_addressBtn];
        [_addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(self.namelb.mas_bottom).equalTo(5);
            make.width.equalTo(180);
            make.height.equalTo(15);
        }];
        
        UIImageView *iv = [UIImageView new];
        iv.image = [UIImage imageNamed:@"ico_backups"];
        [self.contentView addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(160);
            make.width.equalTo(10);
            make.height.equalTo(12);
            make.top.equalTo(self.namelb.mas_bottom).equalTo(5);
        }];
    }
    return _addressBtn;
}
-(UIButton *)exportBtn{
    if (!_exportBtn) {
        _exportBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _exportBtn.titleLabel.textColor = [UIColor textWhiteColor];
        _exportBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _exportBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        _exportBtn.userInteractionEnabled = YES;
        [_exportBtn setTitle:@"导出" forState:UIControlStateNormal];
        [self.contentView addSubview:_exportBtn];
        [_exportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(self.addressBtn.mas_bottom).equalTo(5);
            make.width.equalTo(40);
            make.height.equalTo(20);
        }];
    }
    return _exportBtn;
}
-(UIImageView *)backImageViewLeft{
    if (!_backImageViewLeft) {
        self.contentView.backgroundColor = [UIColor clearColor];
        _backImageViewLeft = [UIImageView new];
        _backImageViewLeft.layer.cornerRadius = 5;
        _backImageViewLeft.layer.masksToBounds = YES;
        [self.contentView addSubview:_backImageViewLeft];
        [_backImageViewLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(0);
        }];
        _backImageViewRight = [UIImageView new];
        [self.contentView addSubview:_backImageViewRight];
        [_backImageViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(0);
            make.width.equalTo(136);
        }];
    }
    return _backImageViewLeft;
}
@end
