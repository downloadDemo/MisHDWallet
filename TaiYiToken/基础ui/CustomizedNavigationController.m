//
//  CustomizedNavigationController.m
//  YJFVideo
//
//  Created by Summer on 14-10-23.
//  Copyright (c) 2014年 Personal. All rights reserved.
//

#import "CustomizedNavigationController.h"

@interface CustomizedNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation CustomizedNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
    }
    return self;
}
-(void)play{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.interactivePopGestureRecognizer.delegate = self;
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = kRGBA(40, 40, 40, 1.0);
   
    UIBarButtonItem *playItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play)];
    //barMetrics:横竖屏区别
    [playItem setBackgroundImage:[UIImage imageNamed:@"ButtonListHighlighted"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [playItem setBackgroundImage:[UIImage imageNamed:@"ButtonList"]  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [playItem setImage:[UIImage imageNamed:@"ButtonList"]];
    
    self.navigationItem.rightBarButtonItem = playItem;

    

}
//设置状态条的样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
