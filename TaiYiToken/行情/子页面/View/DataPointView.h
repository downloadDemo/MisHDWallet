//
//  DataPointView.h
//  TaiYiToken
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataPointView : UIView
@property(nonatomic)UILabel *highLabel;
@property(nonatomic)UILabel *lowLabel;
@property(nonatomic)UILabel *openLabel;
@property(nonatomic)UILabel *closeLabel;
@property(nonatomic)UILabel *volumeLabel;

-(void)initDataPointView;
@end
