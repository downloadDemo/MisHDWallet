//
//  SwitchAccountVc.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/14.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "SwitchAccountVc.h"
#import "CreateAccountVC.h"
@interface SwitchAccountVc ()
@property(nonatomic)UIButton *createBtn;
@property(nonatomic)UIButton *importBtn;
@property(nonatomic)UIImageView *backImageView;
@property(nonatomic)CreateAccountVC *cvc;
@property(nonatomic)UIButton *quitBtn;
@end

@implementation SwitchAccountVc
-(void)viewWillDisappear:(BOOL)animated{
    [_quitBtn removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated{
    _quitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _quitBtn.backgroundColor = kRGBA(255, 255, 255, 1);
    _quitBtn.tintColor = RGB(0, 0, 0);
    [_quitBtn setImage:[UIImage imageNamed:@"IconOfflineCancel"] forState:UIControlStateNormal];
    [_quitBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_quitBtn];
    _quitBtn.userInteractionEnabled = YES;
    [_quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(25);
        make.height.width.equalTo(26);
        make.left.equalTo(20);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _backImageView = [UIImageView new];
    _backImageView.image = [UIImage imageNamed:@"picture"];
    _backImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_backImageView];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.centerY.equalTo(-80);
        make.width.height.equalTo(200);
    }];
    
    _createBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _createBtn.backgroundColor = [UIColor clearColor];
    _createBtn.tintColor = [UIColor whiteColor];
    _createBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _createBtn.layer.cornerRadius = 20;
    _createBtn.clipsToBounds = YES;
    [_createBtn setTitle:@"创建账号" forState:UIControlStateNormal];
    [_createBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 49) colorArray:@[RGB(150, 160, 240),RGB(170, 170, 240)] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    [_createBtn addTarget:self action:@selector(createAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_createBtn];
    _createBtn.userInteractionEnabled = YES;
    [_createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(60);
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
        make.centerY.equalTo(130);
        make.centerX.equalTo(0);
        make.height.equalTo(40);
        make.left.equalTo(40);
        make.right.equalTo(-40);
    }];
    
    UIImageView *bottomImageView = [UIImageView new];
    bottomImageView.image = [UIImage imageNamed:@"logo "];
    bottomImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.bottom.equalTo(-43);
        make.width.equalTo(60);
        make.height.equalTo(30);
    }];
  
}
-(void)quit{
    [self dismissViewControllerAnimated:YES completion:^{
       
    }];
}
-(void)createAccount{
    [_createBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 49) colorArray:@[RGB(150, 160, 240),RGB(170, 170, 240)] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    [_importBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    _createBtn.tintColor = [UIColor whiteColor];
    _importBtn.tintColor = [UIColor textBlueColor];
    _cvc = [CreateAccountVC new];
    [self.navigationController pushViewController:_cvc animated:YES];
}
-(void)importAccount{
    [_createBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_importBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 49) colorArray:@[RGB(150, 160, 240),RGB(170, 170, 240)] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    _createBtn.tintColor = [UIColor textBlueColor];
    _importBtn.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
