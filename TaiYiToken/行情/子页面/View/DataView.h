//
//  DataView.h
//  TaiYiToken
//
//  Created by admin on 2018/8/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataView : UIView
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *namelabel;//BTC
@property(nonatomic,strong)UILabel *dollarlabel;
@property(nonatomic,strong)UILabel *rmblabel;
@property(nonatomic,strong)UILabel *ratelabel;//+2.46%

@property(nonatomic,strong)UILabel *openlabel;//
@property(nonatomic,strong)UILabel *highlabel;//
@property(nonatomic,strong)UILabel *lowlabel;//
@property(nonatomic,strong)UILabel *volumelabel;//

@end
