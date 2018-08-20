
#import "CFFlowButtonView.h"
#import "UIView+Extension.h"
@implementation CFFlowButtonView

- (instancetype)initWithButtonList:(NSMutableDictionary *)buttonDic {
   
    if (self = [super init]) {
        _buttonDic = buttonDic;
        self.buttonList = [NSMutableArray new];
        [buttonDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self addSubview:(UIButton*)obj];
            [self.buttonList addObject:(UIButton *)obj];
        }];

    }
    return self;
}

- (void)layoutSubviews {
    self.backgroundColor = [UIColor backBlueColorA];
   if (_buttonList == nil||_buttonList.count == 0) {
        return;
    }
    //已经加上view的button
    NSMutableArray *oldButtons = [NSMutableArray array];
    // 对第一个Button进行设置
    UIButton *button0 = self.buttonList[0];
    [self addSubview:button0];
    [button0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(10);
        make.width.equalTo(button0.titleLabel.text.length*15);
        make.height.equalTo(20);
    }];
    
    [oldButtons addObject:button0];
    
    

    for (int i = 1; i < self.buttonList.count; i++) {
        UIButton *button = self.buttonList[i];
        UIButton *lastButton = self.buttonList[i - 1];
        CGFloat sumWidth = lastButton.x+lastButton.width+10+button.width+10;
        if (sumWidth > self.width) {//换行
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10);
                make.top.equalTo(lastButton.mas_top).equalTo(lastButton.height+10);
                make.width.equalTo(button.titleLabel.text.length*15);
                make.height.equalTo(20);
            }];
            
        }else{
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastButton.mas_right).equalTo(10);
                make.top.equalTo(lastButton.mas_top);
                make.width.equalTo(button.titleLabel.text.length*15);
                make.height.equalTo(20);
            }];
        }
        [oldButtons addObject:button];

        
    }
    


}


@end
