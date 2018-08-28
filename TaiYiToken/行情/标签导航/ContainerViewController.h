
#import <UIKit/UIKit.h>
#import "CurrencyModel.h"
@interface ContainerViewController : UIViewController

@property (nonatomic , assign) NSInteger currentIndex;
@property(nonatomic,strong)UIView *navView;
@property(nonatomic)UIButton *searchBtn;
@property(nonatomic,strong)CurrencyModel *currency;
@end
