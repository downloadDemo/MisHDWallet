
#import "ContainerViewController.h"
#import "SelfChooseVC.h"
#import "MarketVC.h"
#import "CurrencyModel.h"
#import "CurrencyModel.h"
@interface ContainerViewController ()<UIScrollViewDelegate>{
    UIScrollView *mainScrollView;
    UILabel *sliderLabel;
    UIButton *aBtn;
    UIButton *bBtn;
    UIButton *cBtn;
    UIButton *dBtn;
}

@property(nonatomic,strong)SelfChooseVC *aVC;
@property(nonatomic,strong)MarketVC *bVC;
@property(nonatomic,strong)MarketVC *cVC;
@property(nonatomic,strong)MarketVC *dVC;
@property(nonatomic)NSMutableArray <CurrencyModel*> *modelarray;
@property(nonatomic)NSNotification *iv1Response;
@property(nonatomic)NSNotification *iv2Response;
@property(nonatomic)UIButton *iv1;
@property(nonatomic)UIButton *iv2;
@property(nonatomic)BOOL isFirstClickcBtn;

@end


@implementation ContainerViewController
#pragma mark
#pragma mark 懒加载VC

-(SelfChooseVC *)aVC{
    if (_aVC==nil) {
        _aVC = [[SelfChooseVC alloc]init];
        _aVC.ifShouldRequest = YES;
        [self addChildViewController:_aVC];
    }
    return _aVC;
}
-(MarketVC *)bVC{
    if (_bVC==nil) {
        _bVC = [[MarketVC alloc]init];
        _bVC.indexName = @"b";
        [self addChildViewController:_bVC];
    }
    return _bVC;
}
-(MarketVC *)cVC{
    if (_cVC==nil) {
        _cVC = [[MarketVC alloc]init];
        _cVC.indexName = @"c";
        
        [self addChildViewController:_cVC];
    }
    return _cVC;
}
-(MarketVC *)dVC{
    if (_dVC==nil) {
        _dVC = [[MarketVC alloc]init];
        _dVC.indexName = @"d";
        [self addChildViewController:_dVC];
    }
    return _dVC;
}


#pragma mark 
#pragma mark 初始化三个UIButton和一个滑动的silderLabel，三个btn放到一个UIView（navView）上面。
-(void)initUI{
    
   
    _navView = [UIView new];
    [self.view addSubview:_navView];
    
    _navView.backgroundColor = [UIColor whiteColor];
    aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [aBtn setTitleColor:[UIColor textBlueColor] forState:UIControlStateSelected];
    [aBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    aBtn.frame = CGRectMake(0, 0, kScreenWidth/4, 35);
    aBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [aBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [aBtn setTitle:@"自选" forState:UIControlStateNormal];
    aBtn.tag = 1;
    aBtn.selected = YES;
    [_navView addSubview:aBtn];
    
    bBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bBtn.frame = CGRectMake(aBtn.frame.origin.x+aBtn.frame.size.width, aBtn.frame.origin.y, kScreenWidth/4, 35);
    [bBtn setTitleColor:[UIColor textBlueColor] forState:UIControlStateSelected];
    [bBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    bBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [bBtn setTitle:@"市值" forState:UIControlStateNormal];
    bBtn.tag = 2;
    [_navView addSubview:bBtn];
    
    cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cBtn.frame = CGRectMake(bBtn.frame.origin.x+bBtn.frame.size.width, bBtn.frame.origin.y, kScreenWidth/4, 35);
    [cBtn setTitleColor:[UIColor textBlueColor] forState:UIControlStateSelected];
    [cBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    cBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [cBtn addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventTouchUpInside];
    [cBtn setTitle:@"涨幅" forState:UIControlStateNormal];
    cBtn.tag = 3;
    //
    _iv1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_iv1 setImage:[UIImage imageNamed:@"ico_up_default"] forState:UIControlStateNormal];
    [_iv1 setImage:[UIImage imageNamed:@"ico_up_select"] forState:UIControlStateSelected];
   // [_iv1 addTarget:self action:@selector(iv1click) forControlEvents:UIControlEventTouchUpInside];
    [self.iv1 setSelected:YES];
    [cBtn addSubview:_iv1];
    [_iv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(-4);
        make.right.equalTo(-22);
        make.width.equalTo(10);
        make.height.equalTo(6);
    }];
    _iv2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_iv2 setImage:[UIImage imageNamed:@"ico_down_default"] forState:UIControlStateNormal];
    [_iv2 setImage:[UIImage imageNamed:@"ico_down_select"] forState:UIControlStateSelected];
    //[_iv2 addTarget:self action:@selector(iv2click) forControlEvents:UIControlEventTouchUpInside];
    [self.iv2 setSelected:NO];
    [cBtn addSubview:_iv2];
    [_iv2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(4);
        make.right.equalTo(-22);
        make.width.equalTo(10);
        make.height.equalTo(6);
    }];
    
    //
    [_navView addSubview:cBtn];
    
    
    dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dBtn.frame = CGRectMake(cBtn.frame.origin.x+cBtn.frame.size.width, cBtn.frame.origin.y, kScreenWidth/4, 38);
    [dBtn setTitleColor:[UIColor textBlueColor] forState:UIControlStateSelected];
    [dBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    dBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [dBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [dBtn setTitle:@"成交(24h)" forState:UIControlStateNormal];
    dBtn.tag = 4;
    [_navView addSubview:dBtn];
    
    
    sliderLabel = [UILabel new];
    sliderLabel.backgroundColor = [UIColor textBlueColor];
    [_navView addSubview:sliderLabel];
    [sliderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(28);
        make.left.equalTo(kScreenWidth/8 - 25);
        make.width.equalTo(50);
        make.height.equalTo(2);
    }];
    
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.right.equalTo(0);
        make.height.equalTo(40);
    }];
    _cVC.navView = self.view;
    _isFirstClickcBtn = YES;
    

    //*******rightitem******//
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbtn setImage:[UIImage imageNamed:@"ico_market_search"] forState:UIControlStateHighlighted];
    [rightbtn setImage:[UIImage imageNamed:@"ico_market_search"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    rightbtn.frame = CGRectMake(0, 0, 30, 40);
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
    
    //调整导航栏按钮在导航栏上的位置FixedSpace 占位用
    UIBarButtonItem *spaceitem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceitem.width = -10;
    self.navigationItem.rightBarButtonItems = @[rightitem,spaceitem];
}

-(void)searchAction{
    // 1. 创建热门搜索数组
    NSArray *hotSeaches = @[@"BTC"];
    // 2. 创建搜索控制器
    
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索编程语言" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // 开始(点击)搜索时执行以下代码
         // 如：跳转到指定控制器
        self.modelarray = self.aVC.modelarray == nil?[NSMutableArray new]:[self.aVC.modelarray mutableCopy];
        NSMutableArray *arr = [NSMutableArray new];
        arr = [self.modelarray mutableCopy];
        for (CurrencyModel *model in self.modelarray) {
            if(![model.symbol containsString:searchText]){
                [arr removeObject:model];
            }
        }
        SelfChooseVC *svc = [[SelfChooseVC alloc] init];
        svc.modelarray = [arr mutableCopy];
        svc.ifShouldRequest = NO;
        [searchViewController.navigationController pushViewController:svc animated:YES];
        
        
    }];
    // 3. 跳转到搜索控制器
    CustomizedNavigationController *nav = [[CustomizedNavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}

-(void)switchAction{
    if (_isFirstClickcBtn == YES) {
        _isFirstClickcBtn = NO;
        return;
    }
    if (self.iv1.selected == YES&&self.iv2.selected == NO) {
        [self.iv1 setSelected:NO];
        [self.iv2 setSelected:YES];
        [cBtn setTitle:@"跌幅" forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotification:self.iv1Response];
    }else{
        [[NSNotificationCenter defaultCenter] postNotification:self.iv2Response];
        [cBtn setTitle:@"涨幅" forState:UIControlStateNormal];
        [self.iv1 setSelected:YES];
        [self.iv2 setSelected:NO];
    }
}


- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    self.modelarray = [NSMutableArray new];
    [super viewDidLoad];
    [self initUI];
    [self setMainSrollView];
    //设置默认
    [self sliderWithTag:self.currentIndex+1];
    self.iv1Response = [NSNotification notificationWithName:@"iv1" object:nil];
    self.iv2Response = [NSNotification notificationWithName:@"iv2" object:nil];
  
}

#pragma mark 初始化srollView
-(void)setMainSrollView{
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, self.view.frame.size.height)];
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = [UIColor whiteColor];
    mainScrollView.pagingEnabled = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainScrollView];
    
    NSArray *views = @[self.aVC.view,self.bVC.view,self.cVC.view,self.dVC.view];
    for (NSInteger i = 0; i<views.count; i++) {
        //把vc的view依次贴到mainScrollView上面
        UIView *pageView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, mainScrollView.frame.size.width, mainScrollView.frame.size.height-100)];
        [pageView addSubview:views[i]];
        [mainScrollView addSubview:pageView];
    }
    mainScrollView.contentSize = CGSizeMake(kScreenWidth*(views.count), 0);
    //滚动到_currentIndex对应的tab
    [mainScrollView setContentOffset:CGPointMake((mainScrollView.frame.size.width)*_currentIndex, 0) animated:YES];
}
-(UIButton *)buttonWithTag:(NSInteger )tag{
    if (tag==1) {
        return aBtn;
    }else if (tag==2){
        return bBtn;
    }else if (tag==3){
        return cBtn;
    }else if (tag==4){
        return dBtn;
    }else{
        return nil;
    }
}
-(void)sliderAction:(UIButton *)sender{
    if (self.currentIndex==sender.tag) {
        return;
    }
    [self sliderAnimationWithTag:sender.tag];
    [UIView animateWithDuration:0.3 animations:^{
        self->mainScrollView.contentOffset = CGPointMake(kScreenWidth*(sender.tag-1), 0);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)sliderAnimationWithTag:(NSInteger)tag{
    self.currentIndex = tag;
    aBtn.selected = NO;
    bBtn.selected = NO;
    cBtn.selected = NO;
    dBtn.selected = NO;
    UIButton *sender = [self buttonWithTag:tag];
    sender.selected = YES;
    //动画
    [UIView animateWithDuration:0.1 animations:^{
       self->sliderLabel.frame = CGRectMake(sender.frame.origin.x + kScreenWidth/8 - 25, self->sliderLabel.frame.origin.y, 50, 2);
        
    } completion:^(BOOL finished) {
       
    }];
}
-(void)sliderWithTag:(NSInteger)tag{
    self.currentIndex = tag;
    aBtn.selected = NO;
    bBtn.selected = NO;
    cBtn.selected = NO;
    dBtn.selected = NO;
    UIButton *sender = [self buttonWithTag:tag];
    sender.selected = YES;
    //动画

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //实时计算当前位置,实现和titleView上的按钮的联动
    CGFloat contentOffSetX = scrollView.contentOffset.x;
    CGFloat X = contentOffSetX * (2*kScreenWidth/4)/kScreenWidth/2;
    CGRect frame = sliderLabel.frame;
    frame.origin.x = X+kScreenWidth/8 - 25;
    sliderLabel.frame = frame;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat contentOffSetX = scrollView.contentOffset.x;
    int index_ = contentOffSetX/kScreenWidth;
    [self sliderWithTag:index_+1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
