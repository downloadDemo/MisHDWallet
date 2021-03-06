//
//  Constant.h
//  TaiYiToken
//
//  Created by Frued on 2018/8/13.
//  Copyright © 2018年 Frued. All rights reserved.
//

#ifndef Constant_h
#define Constant_h
/**
 *  window object
 */
#define WINDOW [[[UIApplication sharedApplication] delegate] window]


/**
 *  object is not nil and null
 */
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))

/**
 *  object is nil or null
 */
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isEqual:[NSNull class]]))

/**
 *  string is nil or null or empty
 */
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))

/**
 *  Array is nil or null or empty
 */
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

/**
 *  validate string
 */
#define VALIDATE_STRING(str) (IsNilOrNull(str) ? @"" : str)

/**
 *  update string
 */
#define UPDATE_STRING(old, new) ((IsNilOrNull(new) || IsStrEmpty(new)) ? old : new)

/**
 *  validate NSNumber
 */
#define VALIDATE_NUMBER(number) (IsNilOrNull(number) ? @0 : number)

/**
 *  update NSNumber
 */
#define UPDATE_NUMBER(old, new) (IsNilOrNull(new) ? old : new)

/**
 *  validate NSArray
 */
#define VALIDATE_ARRAY(arr) (IsNilOrNull(arr) ? [NSArray array] : arr)


/**
 *  validate NSMutableArray
 */
#define VALIDATE_MUTABLEARRAY(arr) (IsNilOrNull(arr) ? [NSMutableArray array] :     [NSMutableArray arrayWithArray: arr])
/**
 *  statusbar height
 */
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define TABBAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define NAVIGATIONBAR_HEIGHT (STATUSBAR_HEIGHT + kNavBarHeight)
#define kIs_iPhoneX (SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f)
typedef enum {
    BTC = 0,
    BTC_TESTNET = 1,
    ETH = 60
}CoinType;


typedef enum {
    FIVE_MIN = 1,
    FIFTEEN_MIN = 2,
    ONE_HOUR = 4,
    ONE_DAY = 5,
    ONE_WEEK = 6,
    ONE_MON = 7,
}KLineType;

typedef enum {
    SELF_CHOOSE = 0,
    BTC_CHOOSE = 1,
    ETH_CHOOSE = 2,
    HT_CHOOSE = 3,
    USDT_CHOOSE = 4,
    SEARCH_CHOOSE = 5,
}MarketSelectType;

typedef enum : NSUInteger {
    BTCAPIChain,
    BTCAPIBlockchain,
} BTCAPI;

typedef enum : NSUInteger {
    IMPORT_WALLET = 0,
    LOCAL_WALLET = 1,
} WALLET_TYPE;

typedef enum : NSUInteger {
    LOCAL_CREATED_WALLET = 0,
    IMPORT_BY_MNEMONIC = 1,
    IMPORT_BY_KEYSTORE = 2,
    IMPORT_BY_PRIVATEKEY = 3,
} IMPORT_WALLET_TYPE;

typedef enum {
    OUT_Trans   = 1,
    IN_Trans    = 2,
    FAILD_Trans = 3,
    SELF_Trans  = 4,
}TranResultSelectType;

typedef enum {
    EOS_ACTIVE_KEY   = 1,
    EOS_OWNER_KEY    = 2,
}EOSKeyType;
#define BTNRISECOLOR [UIColor colorWithHexString:@"#E53A32"]
#define BTNFALLCOLOR [UIColor colorWithHexString:@"#26B13D"]


#endif /* Constant_h */
