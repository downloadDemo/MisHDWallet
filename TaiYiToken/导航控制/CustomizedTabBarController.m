//
//  CustomizedTabBarController.m
//  TRProject
//
//  Created by tarena on 16/10/9.
//  Copyright © 2016年 Tedu. All rights reserved.
//

#import "CustomizedTabBarController.h"
#import "CustomTabBar.h"
#import "CustomizedNavigationController.h"

#import "ContainerViewController.h"
#import "UserInfoVC.h"
#import "HomePageVC.h"
#import "JavascriptWebViewController.h"
#import "DappVC.h"
@interface CustomizedTabBarController ()<CustomTabBarDelegate>
@property(nonatomic)double anglesec;
@property(nonatomic)double angle;
@property(nonatomic)double anglehour;
@property(nonatomic)NSInteger num;
@property(nonatomic)NSInteger t;
@property(nonatomic)UIImageView *iv2;
@property(nonatomic)UIImageView *iv3;
@property(nonatomic)UIImageView *iv4;
@property(nonatomic)UIImageView *iv5;
@property(nonatomic)UIView *vi;
@property(nonatomic)UIImageView *imv;
@property(nonatomic)CGFloat alp;

@property(nonatomic)NSArray *imageHelightArr;
@end

@implementation CustomizedTabBarController
static CustomizedTabBarController* _customizedTabBarController;
+(CustomizedTabBarController*)sharedCustomizedTabBarController{
    if (_customizedTabBarController == nil) {
        _customizedTabBarController = [CustomizedTabBarController new];
    }
    return _customizedTabBarController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadViewController];
   
    
}

- (void)loadViewController
{
    HomePageVC *manVC = [HomePageVC new];
    manVC.view.backgroundColor = kRGBA(255, 255, 255, 1);
    CustomizedNavigationController *manNaVC = [[CustomizedNavigationController alloc] initWithRootViewController:manVC];
    

    ContainerViewController *manVC1 = [ContainerViewController new];
    manVC1.view.backgroundColor = kRGBA(255, 255, 255, 1);
    CustomizedNavigationController *manNaVC1 = [[CustomizedNavigationController alloc] initWithRootViewController:manVC1];
    [manNaVC1.titlelb setText:@"行情"];

    DappVC *manVC11 = [DappVC new];
    manVC11.view.backgroundColor = kRGBA(255, 255, 255, 1);
    CustomizedNavigationController *manNaVC11 = [[CustomizedNavigationController alloc] initWithRootViewController:manVC11];
    [manNaVC11.titlelb setText:@"应用"];
    
    UserInfoVC *manVC111 = [UserInfoVC new];
    manVC111.view.backgroundColor = kRGBA(255, 255, 255, 1);
    CustomizedNavigationController *manNaVC111 = [[CustomizedNavigationController alloc] initWithRootViewController:manVC111];
    [manNaVC111.titlelb setText:@"我的"];
    
    self.viewControllers = @[manNaVC,manNaVC1,manNaVC11,manNaVC111];
    self.selectedIndex = 0;
    [self setupTabBar];
    
}


- (void)setupTabBar
{
    NSArray *titleArr = @[@"首页",@"行情",@"应用",@"我的"];
    NSArray *imageArr = @[@"wallet_default",@"hp_market_default",@"apps_default",@"own_default"];
    NSArray *imageHelightArr = @[@"hp_asset_select",@"hp_market_select",@"apps_select",@"own_select"];
    for (int i = 0 ; i < 4; i++) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width/4.0;
        CustomTabBar *bar = [[CustomTabBar alloc] initWithFrame:CGRectMake(0 + width * i, 0, width, 49) WithImage:[UIImage imageNamed:imageArr[i]] WithTitle:titleArr[i]];
        
        bar.imageHelight = [UIImage imageNamed:imageHelightArr[i]];
        bar.imageDefault = [UIImage imageNamed:imageArr[i]];
        [bar.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
        bar.index = i;
        bar.delegate = self;
       
        [self.tabBar addSubview:bar];
            
        if (i == 0) {
            bar.selected = YES;
            [bar.iv setImage:bar.imageHelight];
            [bar.lb setTextColor:[UIColor blueColor]];
        }
    }
}


-(void)didSelectBarItemAtIndex:(NSInteger)index{
    [self resignBatState];
    if (index == 0) {
        
    }
    
    self.selectedViewController = self.viewControllers[index];
}

-(void)resignBatState{
    NSArray *arr = [self.tabBar subviews];
    for (CustomTabBar *bar in arr) {
        if ([bar isKindOfClass:[CustomTabBar class]]) {
            bar.selected = NO;
            [bar.lb setTextColor:[UIColor lightGrayColor]];
            [bar.iv setImage:bar.imageDefault];
        }
    }
}

- (void)changeViewController:(UIButton *)button
{
    self.selectedIndex = button.tag;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIView *)vi {
    if(_vi == nil) {
        _vi = [[UIView alloc] init];
        _vi.backgroundColor = [UIColor whiteColor];
        _imv = [UIImageView new];
        _imv.image = [UIImage imageNamed:@"LaunchImage"];
        [_vi addSubview:_imv];
        [_imv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        
        [self.view addSubview:_vi];
        [_vi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(0);
            make.bottom.equalTo(49);
        }];
    }
    return _vi;
}

@end
