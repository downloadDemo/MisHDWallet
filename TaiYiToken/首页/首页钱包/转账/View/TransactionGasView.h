//
//  TransactionGasView.h
//  TaiYiToken
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionGasView : UIView
@property(nonatomic)UILabel *gaspricelb;
@property(nonatomic,strong)UISlider *gasSlider;
@property(nonatomic)UILabel *valueLabel;

-(void)initUI;
-(void)updateLabelValues:(CGFloat)value;
@end
