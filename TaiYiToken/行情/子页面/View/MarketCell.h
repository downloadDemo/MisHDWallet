//
//  MarketCell.h
//  TaiYiToken
//
//  Created by admin on 2018/8/15.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarketCell : UITableViewCell
@property(nonatomic,strong)UILabel *coinNamelabel;//#1比特币
@property(nonatomic,strong)UILabel *namelabel;//BTC
@property(nonatomic,strong)UILabel *marketValuelabel;//市值￥8802.43亿
@property(nonatomic,strong)UILabel *pricelabel;//￥4,299,90
@property(nonatomic,strong)UILabel *ratelabel;//+2.46%

@end
