//
//  ButtonsView.h
//  TaiYiToken
//
//  Created by admin on 2018/8/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonsView : UIView
@property(nonatomic)UIButton *oneMinuteBtn;
@property(nonatomic)UIButton *sixMinuteBtn;
@property(nonatomic)UIButton *dayBtn;
@property(nonatomic)UIButton *weekBtn;
@property(nonatomic)UIButton *monthBtn;
-(void)initButtonsViewWidth:(CGFloat)width Height:(CGFloat)height;
@end
