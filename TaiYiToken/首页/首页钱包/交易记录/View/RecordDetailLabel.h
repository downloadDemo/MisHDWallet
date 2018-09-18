//
//  RecordDetailLabel.h
//  TaiYiToken
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordDetailLabel : UIView
@property(nonatomic)UILabel *titlelb;
@property(nonatomic)UILabel *detaillb;
-(void)initWithTitle:(NSString *)title Detail:(NSAttributedString *)detail;
@end
