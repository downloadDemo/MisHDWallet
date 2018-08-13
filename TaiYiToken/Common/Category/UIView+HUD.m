//
//  UIView+HUD.m
//  Day10_PodDemo
//
//  Created by tarena on 16/9/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "UIView+HUD.h"

@implementation UIView (HUD)
- (void)showHUD{
    [self hideHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    //转圈提示 最长30秒
    [hud hideAnimated:YES afterDelay:30];
}

- (void)hideHUD{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

- (void)showMsg:(NSString *)msg{
    [self hideHUD];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    [hud hideAnimated:YES afterDelay:1];
}


@end





