//
//  UIImage+BaseToImage.h
//  AdMoProduct
//
//  Created by admin on 2018/7/27.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BaseToImage)
+ (UIImage *) dataURLToImage: (NSString *) base64String;
+ (NSString *) imageToDataURL: (UIImage *) image;
@end
