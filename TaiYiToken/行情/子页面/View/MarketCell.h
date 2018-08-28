//
//  MarketCell.h
//  TaiYiToken
//
//  Created by admin on 2018/8/15.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarketCell : UITableViewCell
@property(nonatomic,strong)UILabel *coinNamelabel;//民生币/以太坊
@property(nonatomic,strong)UILabel *namelabel;//RCC/ETH
@property(nonatomic,strong)UILabel *marketValuelabel;//比率 0.12
@property(nonatomic,strong)UILabel *pricelabel;//￥4,299,90
@property(nonatomic)UIButton *rateBtn;
@end
