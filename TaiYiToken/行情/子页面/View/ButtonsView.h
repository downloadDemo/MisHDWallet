//
//  ButtonsView.h
//  TaiYiToken
//
//  Created by admin on 2018/8/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonsView : UIView
/*typedef enum {
 FIVE_MIN = 1,
 FIFTEEN_MIN = 2,
 ONE_HOUR = 4,
 ONE_DAY = 5,
 ONE_WEEK = 6,
 ONE_MON = 7,
 }KLineType;*/


@property(nonatomic)UIButton *FIVEMINBtn;
@property(nonatomic)UIButton *FIFTEENMINBtn;
@property(nonatomic)UIButton *ONEHOURBtn;
@property(nonatomic)UIButton *ONEDAYBtn;
@property(nonatomic)UIButton *ONEWEEKBtn;
@property(nonatomic)UIButton *ONEMONBtn;
@property(nonatomic)NSArray *btnArray;
-(void)initButtonsViewWidth:(CGFloat)width Height:(CGFloat)height;
@end
