/*
 作者：  WillkYang
 文件：  UIColor+YYStockTheme.m
 版本：  1.0 <2016.10.05>
 */

#import "UIColor+YYStockTheme.h"

@implementation UIColor (YYStockTheme)

//+ (UIColor *)colorWithHex:(UInt32)hex {
//    return [UIColor colorWithHex:hex alpha:1.f];
//}

+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
}

/************************************K线颜色配置***************************************/

/**
 *  整体背景颜色
 */
+(UIColor *)YYStock_bgColor {
    return [UIColor whiteColor];
}

/**
 *  K线图背景辅助线颜色
 */
+(UIColor *)YYStock_bgLineColor {
    return RGB(240, 240, 240);
}

/**
 *  主文字颜色
 */
+(UIColor *)YYStock_textColor {
    return RGB(100, 100, 100);
}


/**
 *  MA5线颜色
 */
+(UIColor *)YYStock_MA5LineColor {
    return RGB(255, 200, 100);
}

/**
 *  MA10线颜色
 */
+(UIColor *)YYStock_MA10LineColor {
    return RGB(100, 220, 255);
}

/**
 *  MA20线颜色
 */
+(UIColor *)YYStock_MA20LineColor {
    return RGB(100, 255, 180);
}

/**
 *  长按线颜色
 */
+(UIColor *)YYStock_selectedLineColor {
    return RGB(180, 200, 230);
}

/**
 *  长按出现的圆点的颜色
 */
+(UIColor *)YYStock_selectedPointColor {
    return RGB(255, 235, 230);
}

/**
 *  长按出现的方块背景颜色
 */
+(UIColor *)YYStock_selectedRectBgColor {
    return RGB(220, 220, 220);
}

/**
 *  长按出现的方块文字颜色
 */
+(UIColor *)YYStock_selectedRectTextColor {
    return RGB(0, 0, 0);
}

/**
 *  分时线颜色
 */
+(UIColor *)YYStock_TimeLineColor {
    return RGB(255, 255, 200);
}

/**
 *  分时均线颜色
 */
+(UIColor *)YYStock_averageTimeLineColor {
    return RGB(255, 0, 255);
}

/**
 *  分时线下方背景色
 */
+(UIColor *)YYStock_timeLineBgColor {
    return RGB(230, 230, 230);
}

/**
 *  涨的颜色
 */
+(UIColor *)YYStock_increaseColor {
    return RGB(255, 100, 100);
}

/**
 *  跌的颜色
 */
+(UIColor *)YYStock_decreaseColor {
    return RGB(100, 255, 100);
}


/************************************TopBar颜色配置***************************************/

/**
 *  顶部TopBar文字默认颜色
 */
+(UIColor *)YYStock_topBarNormalTextColor {
    return RGB(255, 180, 180);
}

/**
 *  顶部TopBar文字选中颜色
 */
+(UIColor *)YYStock_topBarSelectedTextColor {
    return RGB(255, 220, 220);
}

/**
 *  顶部TopBar选中块辅助线颜色
 */
+(UIColor *)YYStock_topBarSelectedLineColor {
    return RGB(190, 190, 190);
}

@end
