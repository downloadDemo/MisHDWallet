//
//  WalletListCell.h
//  TaiYiToken
//
//  Created by admin on 2018/9/3.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
@interface WalletListCell : MGSwipeTableCell
@property(nonatomic)UIImageView *iconImageView;
@property(nonatomic)UILabel *symbolNamelb;
@property(nonatomic)UILabel *symbollb;
@property(nonatomic)UILabel *amountlb;
@property(nonatomic)UILabel *valuelb;
@property(nonatomic)UILabel *rmbvaluelb;

@end
