//
//  SwitchAccountVc.m
//  TaiYiToken
//
//  Created by admin on 2018/8/14.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SwitchAccountVc.h"
#import "CreateAccountVC.h"
@interface SwitchAccountVc ()
@property(nonatomic)UIButton *createBtn;
@property(nonatomic)UIButton *importBtn;
@property(nonatomic)UIImageView *backImageView;
@property(nonatomic)CreateAccountVC *cvc;
@end

@implementation SwitchAccountVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _backImageView = [UIImageView new];
    _backImageView.image = [UIImage imageNamed:@"backImg"];
    [self.view addSubview:_backImageView];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    _createBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _createBtn.backgroundColor = RGB(100, 100, 255);
    _createBtn.tintColor = [UIColor whiteColor];
    _createBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _createBtn.layer.cornerRadius = 20;
    _createBtn.clipsToBounds = YES;
    [_createBtn setTitle:@"创建账号" forState:UIControlStateNormal];
    [_createBtn addTarget:self action:@selector(createAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_createBtn];
    _createBtn.userInteractionEnabled = YES;
    [_createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(30);
        make.centerX.equalTo(0);
        make.height.equalTo(40);
        make.left.equalTo(40);
        make.right.equalTo(-40);
    }];
    
    _importBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _importBtn.backgroundColor = [UIColor clearColor];
    _importBtn.tintColor = [UIColor textBlueColor];
    _importBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _importBtn.layer.cornerRadius = 20;
    _importBtn.clipsToBounds = YES;
    [_importBtn setTitle:@"导入账号" forState:UIControlStateNormal];
    [_importBtn addTarget:self action:@selector(importAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_importBtn];
    _importBtn.userInteractionEnabled = YES;
    [_importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(100);
        make.centerX.equalTo(0);
        make.height.equalTo(40);
        make.left.equalTo(40);
        make.right.equalTo(-40);
    }];
}
-(void)createAccount{
    _createBtn.backgroundColor = RGB(100, 100, 255);
    _importBtn.backgroundColor = [UIColor clearColor];
    _createBtn.tintColor = [UIColor whiteColor];
    _importBtn.tintColor = [UIColor textBlueColor];
    _cvc = [CreateAccountVC new];
    [self.navigationController pushViewController:_cvc animated:YES];
}
-(void)importAccount{
    _createBtn.backgroundColor = [UIColor clearColor];
    _importBtn.backgroundColor = RGB(100, 100, 255);
    _createBtn.tintColor = [UIColor textBlueColor];
    _importBtn.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
