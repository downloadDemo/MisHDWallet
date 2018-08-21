//
//  VerifyMnemonicVC.m
//  TaiYiToken
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "VerifyMnemonicVC.h"
#import "CFFlowButtonView.h"
@interface VerifyMnemonicVC ()
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)NSMutableArray *mnemonicArray;
@property(nonatomic,strong)CFFlowButtonView *optionButtonView;//
@property(nonatomic,strong)CFFlowButtonView *selectedButtonView;
@property(nonatomic)NSMutableDictionary  *optionbuttonListSelect;//下方选择
@property(nonatomic)NSMutableDictionary  *optionbuttonListDeselect;//下方选择
@property(nonatomic)NSMutableDictionary  *buttonListSelect;//上方已选
@property(nonatomic)NSMutableDictionary  *buttonListDeselect;//上方已选
@property(nonatomic,strong) UIButton *nextBtn;
@end

@implementation VerifyMnemonicVC
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.hidesBottomBarWhenPushed = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.mnemonicArray = [NSMutableArray new];
    self.optionbuttonListSelect = [NSMutableDictionary new];
    //将助记词字符串分割为单词
    self.mnemonicArray = [[self.mnemonic componentsSeparatedByString:@"   "] mutableCopy];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn setImage:[UIImage imageNamed:@"ico_right_arrow"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    _backBtn.userInteractionEnabled = YES;
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(30);
        make.height.equalTo(25);
        make.left.equalTo(10);
        make.width.equalTo(30);
    }];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.backgroundColor = [UIColor textBlueColor];
    [_nextBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 35) colorArray:@[RGB(150, 160, 240),RGB(170, 170, 240)] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    _nextBtn.userInteractionEnabled = YES;
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.height.equalTo(35);
        make.left.equalTo(0);
        make.right.equalTo(0);
    }];
    
    [self initOptionsView];
    
}
-(void)nextAction{
  
}

-(NSMutableArray*)DicToArray:(NSMutableDictionary*)dic{
    __block NSMutableArray *array = [NSMutableArray new];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [array addObject:obj];
    }];
    return array;
}
-(void)selectAction:(UIButton *)button{
    [button setSelected:NO];
    
    if (button.tag == 0) {//0 表示点击下面 1 点击上面
        //删除下面的
        UIButton *btn = [UIButton new];
        for (btn in self.optionButtonView.buttonList) {
            if ([btn.titleLabel.text isEqualToString:button.titleLabel.text]) {
                break;
            }
        }
        
        [self.optionButtonView.buttonList removeObject:btn];
        
        //增加上面的
        NSString *mstr = button.titleLabel.text;
        UIButton *mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mBtn gradientButtonWithSize:CGSizeMake(mstr.length*15, 23) colorArray:@[(id)[UIColor textOrangeColor],(id)[UIColor orangeColor]] percentageArray:@[@(0.2),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        mBtn.tag = 1;
        [mBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        [mBtn setTitle:mstr forState:UIControlStateNormal];
        [mBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        mBtn.userInteractionEnabled = YES;
        [self.selectedButtonView.buttonList addObject:mBtn];
    }else{
        //删除上面的
        UIButton *btn = [UIButton new];
        for (btn in self.selectedButtonView.buttonList) {
            if ([btn.titleLabel.text isEqualToString:button.titleLabel.text]) {
                break;
            }
        }
        [self.selectedButtonView.buttonList removeObject:btn];
        
        //增加下面的
        NSString *mstr = button.titleLabel.text;
        UIButton *mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [mBtn gradientButtonWithSize:CGSizeMake(mstr.length*15, 23) colorArray:@[RGB(160, 180, 240),RGB(170, 170, 240)] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        mBtn.tag = 0;
        
        
        [mBtn setTitle:mstr forState:UIControlStateNormal];
        [mBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        mBtn.userInteractionEnabled = YES;
        [self.optionButtonView.buttonList addObject:mBtn];
    }
    //重绘
    [self.optionButtonView layoutSubviews];
    [self.selectedButtonView layoutSubviews];
}

-(void)initOptionsView{
    for (NSInteger i = 0; i<self.mnemonicArray.count; i++) {
        NSString *mstr = self.mnemonicArray[i];
        UIButton *mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mBtn.tag = 0;
        mBtn.frame = CGRectMake(0, 0, mstr.length*15, 23);
        [mBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [mBtn gradientButtonWithSize:CGSizeMake(mstr.length*15, 23) colorArray:@[RGB(150, 160, 240),RGB(170, 170, 240)] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        [mBtn setTitle:mstr forState:UIControlStateNormal];
        [mBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        mBtn.userInteractionEnabled = YES;
        [self.optionbuttonListSelect setObject:mBtn forKey:mstr];
        [self.buttonListDeselect setObject:mBtn forKey:mstr];
    }
    
    [self optionButtonView];
    [self selectedButtonView];
    
}
-(CFFlowButtonView *)selectedButtonView{
    if (_selectedButtonView == nil) {
        
        UIView *shadowView = [UIView new];
        shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
        shadowView.layer.shadowOffset = CGSizeMake(0, 0);
        shadowView.layer.shadowOpacity = 1;
        shadowView.layer.shadowRadius = 3.0;
        shadowView.layer.cornerRadius = 3.0;
        shadowView.clipsToBounds = NO;
        [self.view addSubview:shadowView];
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.right.equalTo(-10);
            make.top.equalTo(100);
            make.height.equalTo(150);
        }];
        
        _selectedButtonView = [[CFFlowButtonView alloc] initWithButtonList:nil];
        _selectedButtonView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:_selectedButtonView];
//        [_selectedButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(10);
//            make.right.equalTo(-10);
//            make.top.equalTo(100);
//            make.height.equalTo(150);
//        }];
        [shadowView addSubview:_selectedButtonView];
        [_selectedButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _selectedButtonView;
}

-(CFFlowButtonView *)optionButtonView{
    if (_optionButtonView == nil) {
        _optionButtonView = [[CFFlowButtonView alloc] initWithButtonList:self.optionbuttonListSelect];
        
        [self.view addSubview:_optionButtonView];
        [_optionButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.right.equalTo(-10);
            make.top.equalTo(270);
            make.height.equalTo(150);
        }];
    }
    return _optionButtonView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
