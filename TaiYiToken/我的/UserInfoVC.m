//
//  UserInfoVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/21.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "UserInfoVC.h"
#import "SwitchAccountVc.h"
@interface UserInfoVC ()
@property(nonatomic)UIButton *btn;
@end

@implementation UserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btn = [UIButton new];
    _btn.backgroundColor = [UIColor whiteColor];
    [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [_btn setTitle:@"click" forState:UIControlStateNormal];
    [self.view addSubview:_btn];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(10);
        make.height.equalTo(30);
    }];
    
    
}
-(void)click{
    SwitchAccountVc *switchvc = [SwitchAccountVc new];
    UINavigationController *navivc = [[UINavigationController alloc]initWithRootViewController:switchvc];
    [navivc.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navivc.navigationBar.shadowImage = [UIImage new];
    navivc.navigationBar.translucent = YES;
    navivc.navigationBar.alpha = 0;
    
    [self presentViewController:navivc animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
