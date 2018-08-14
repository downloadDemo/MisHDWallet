//
//  RemindView.h
//  TaiYiToken
//
//  Created by admin on 2018/8/14.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemindView : UIView
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UILabel *messageLabel;
@property(nonatomic)UIButton *quitBtn;
-(void)initRemainViewWithTitle:(NSString*)title message:(NSString*)message;
@end
