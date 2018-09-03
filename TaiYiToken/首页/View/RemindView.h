//
//  RemindView.h
//  TaiYiToken
//
//  Created by Frued on 2018/8/14.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 提示弹窗
 */
@interface RemindView : UIView
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UILabel *messageLabel;
@property(nonatomic)UIButton *quitBtn;
-(void)initRemainViewWithTitle:(NSString*)title message:(NSString*)message;
@end
