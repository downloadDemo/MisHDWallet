#import "CustomizedNavigationController.h"
#import "ContainerViewController.h"
#import "MarketVC.h"


@interface ContainerViewController ()<UIScrollViewDelegate>{
    UIScrollView *mainScrollView;
    UILabel *sliderLabel;
    UIButton *aBtn;
    UIButton *bBtn;
    UIButton *cBtn;
    UIButton *dBtn;
    UIButton *eBtn;
}

@property(nonatomic,strong)MarketVC *aVC;
@property(nonatomic,strong)MarketVC *bVC;
@property(nonatomic,strong)MarketVC *cVC;
@property(nonatomic,strong)MarketVC *dVC;
@property(nonatomic,strong)MarketVC *eVC;

@property(nonatomic,strong)MarketVC *searchVC;
/*
 编辑自选
 */
@property(nonatomic)UIButton *editMySymbolBtn;
@property(nonatomic)UIButton *exitEditBtn;
@property(nonatomic)UIButton *deleteMySymbolBtn;
@property(nonatomic,strong)NSArray *editingItemArray;
@property(nonatomic,strong)NSArray *normalItemArray;
@end


@implementation ContainerViewController
#pragma mark
#pragma mark 懒加载VC

-(MarketVC *)aVC{
    if (_aVC==nil) {
        _aVC = [[MarketVC alloc]init];
        _aVC.indexName = SELF_CHOOSE;
        _aVC.ifNeedRequestData = YES;
        [self addChildViewController:_aVC];
    }
    return _aVC;
}
-(MarketVC *)bVC{
    if (_bVC==nil) {
        _bVC = [[MarketVC alloc]init];
        _bVC.indexName = BTC_CHOOSE;
        _bVC.ifNeedRequestData = YES;
        [self addChildViewController:_bVC];
    }
    return _bVC;
}
-(MarketVC *)cVC{
    if (_cVC==nil) {
        _cVC = [[MarketVC alloc]init];
        _cVC.indexName = ETH_CHOOSE;
        _cVC.ifNeedRequestData = YES;
        [self addChildViewController:_cVC];
    }
    return _cVC;
}
-(MarketVC *)dVC{
    if (_dVC==nil) {
        _dVC = [[MarketVC alloc]init];
        _dVC.indexName = HT_CHOOSE;
        _dVC.ifNeedRequestData = YES;
        [self addChildViewController:_dVC];
    }
    return _dVC;
}
-(MarketVC *)eVC{
    if (_eVC==nil) {
        _eVC = [[MarketVC alloc]init];
        _eVC.indexName = USDT_CHOOSE;
        _eVC.ifNeedRequestData = YES;
        [self addChildViewController:_eVC];
    }
    return _eVC;
}
-(MarketVC *)searchVC{
    if (_searchVC==nil) {
        _searchVC = [[MarketVC alloc]init];
        _searchVC.indexName = SEARCH_CHOOSE;
        _searchVC.ifNeedRequestData = NO;
        _searchVC.modelarray = [NSMutableArray new];
        [self addChildViewController:_eVC];
    }
    return _searchVC;
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
    
    aBtn.frame = CGRectMake(0, 0, kScreenWidth/5, 35);
    aBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [aBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [aBtn setTitle:@"自选" forState:UIControlStateNormal];
    aBtn.tag = 1;
    aBtn.selected = YES;
    [_navView addSubview:aBtn];
    
    bBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bBtn.frame = CGRectMake(aBtn.frame.origin.x+aBtn.frame.size.width, aBtn.frame.origin.y, kScreenWidth/5, 35);
    [bBtn setTitleColor:[UIColor textBlueColor] forState:UIControlStateSelected];
    [bBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    bBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [bBtn setTitle:@"BTC" forState:UIControlStateNormal];
    bBtn.tag = 2;
    [_navView addSubview:bBtn];
    
    cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cBtn.frame = CGRectMake(bBtn.frame.origin.x+bBtn.frame.size.width, bBtn.frame.origin.y, kScreenWidth/5, 35);
    [cBtn setTitleColor:[UIColor textBlueColor] forState:UIControlStateSelected];
    [cBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    cBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [cBtn setTitle:@"ETH" forState:UIControlStateNormal];
    cBtn.tag = 3;
    [_navView addSubview:cBtn];    
    
    
    dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dBtn.frame = CGRectMake(cBtn.frame.origin.x+cBtn.frame.size.width, cBtn.frame.origin.y, kScreenWidth/5, 38);
    [dBtn setTitleColor:[UIColor textBlueColor] forState:UIControlStateSelected];
    [dBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    dBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [dBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [dBtn setTitle:@"HT" forState:UIControlStateNormal];
    dBtn.tag = 4;
    [_navView addSubview:dBtn];
    
    
    eBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    eBtn.frame = CGRectMake(dBtn.frame.origin.x+dBtn.frame.size.width, dBtn.frame.origin.y, kScreenWidth/5, 38);
    [eBtn setTitleColor:[UIColor textBlueColor] forState:UIControlStateSelected];
    [eBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    eBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [eBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [eBtn setTitle:@"USDT" forState:UIControlStateNormal];
    eBtn.tag = 5;
    [_navView addSubview:eBtn];
    
    
    
    sliderLabel = [UILabel new];
    sliderLabel.backgroundColor = [UIColor textBlueColor];
    [_navView addSubview:sliderLabel];
    [sliderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(28);
        make.left.equalTo(kScreenWidth/10 - 15);
        make.width.equalTo(30);
        make.height.equalTo(2);
    }];
    
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.right.equalTo(0);
        make.height.equalTo(40);
    }];

    
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
    
    
    //左边编辑按钮
    [self editMySymbolBtn];
}

-(void)searchAction{
    // 1. 创建热门搜索数组
    NSArray *hotSeaches = @[@"BTC",@"ETH"];
    // 2. 创建搜索控制器
    self.currency = self.bVC.currency == nil?[CurrencyModel new]:self.bVC.currency;
    __block NSMutableArray *arrx = [NSMutableArray new];
    __block NSMutableArray *arr = [NSMutableArray new];
    __block NSMutableArray *arrcopy = [NSMutableArray new];
    self.currency = self.bVC.currency == nil?[CurrencyModel new]:self.bVC.currency;
    [arrx addObjectsFromArray:[self.currency.btcMarket mutableCopy]];
    [arrx addObjectsFromArray:[self.currency.ethMarket mutableCopy]];
    [arrx addObjectsFromArray:[self.currency.htMarket mutableCopy]];
    [arrx addObjectsFromArray:[self.currency.usdtMarket mutableCopy]];
   
    self.searchVC.ifNeedRequestData = NO;
   
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索交易对" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // 开始(点击)搜索时执行以下代码
//        [arr removeAllObjects];
//        [arrcopy removeAllObjects];
        arr = [arrx mutableCopy];
        arrcopy = [arr copy];
        self.searchVC.ifNeedRequestData = NO;
         // 如：跳转到指定控制器
        [self.searchVC.modelarray removeAllObjects];
        [self.searchVC.tableView reloadData];
        for (SymbolModel *dic in arrcopy) {
            SymbolModel *model = [SymbolModel parse:dic];
            NSString *symbol = model.symbol;
            if(![symbol containsString:[searchText uppercaseString]]){
                [arr removeObject:dic];
            }
        }
        
        self.searchVC.modelarray = [arr mutableCopy];
        [self.searchVC.tableView reloadData];
        [searchViewController.navigationController pushViewController:self.searchVC animated:YES];
    }];
    // 3. 跳转到搜索控制器
    CustomizedNavigationController *nav = [[CustomizedNavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}




- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    self.currency = [CurrencyModel new];
    [super viewDidLoad];
    [self initUI];
    [self setMainSrollView];
    //设置默认
    [self sliderWithTag:self.currentIndex+1];
   
}
-(void)EditBtnClicked{
    
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
    
    NSArray *views = @[self.aVC.view,self.bVC.view,self.cVC.view,self.dVC.view,self.eVC.view];
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
    }else if (tag==5){
        return eBtn;
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

/*
 点击编辑按钮，发送通知
 */
-(UIButton *)editMySymbolBtn{
    if (_editMySymbolBtn == nil) {
        _editMySymbolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editMySymbolBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editMySymbolBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_editMySymbolBtn setTintColor:[UIColor textWhiteColor]];
        [_editMySymbolBtn addTarget:self action:@selector(editMySymbolAction) forControlEvents:UIControlEventTouchUpInside];
        _editMySymbolBtn.frame = CGRectMake(0, 0, 40, 40);
        UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithCustomView:_editMySymbolBtn];
        _editMySymbolBtn.hidden = NO;
        //调整导航栏按钮在导航栏上的位置FixedSpace 占位用
        UIBarButtonItem *spaceitem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceitem.width = -10;
        self.navigationItem.leftBarButtonItems = @[spaceitem,leftitem];
        self.normalItemArray = @[spaceitem,leftitem];
    }
    return _editMySymbolBtn;
}

-(void)CreateEditingBtn{
    if (_exitEditBtn == nil) {
        _exitEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitEditBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_exitEditBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_exitEditBtn setTintColor:[UIColor textWhiteColor]];
        [_exitEditBtn addTarget:self action:@selector(exitEditBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _exitEditBtn.frame = CGRectMake(0, 0, 40, 40);
       
    }
    if(_deleteMySymbolBtn == nil){
        _deleteMySymbolBtn.hidden = NO;
        _deleteMySymbolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteMySymbolBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteMySymbolBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_deleteMySymbolBtn setTintColor:[UIColor textWhiteColor]];
        [_deleteMySymbolBtn addTarget:self action:@selector(deleteMySymbolBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _deleteMySymbolBtn.frame = CGRectMake(0, 0, 40, 40);
        _deleteMySymbolBtn.hidden = NO;
    }
    UIBarButtonItem *leftitem1 = [[UIBarButtonItem alloc]initWithCustomView:_exitEditBtn];
    UIBarButtonItem *leftitem2 = [[UIBarButtonItem alloc]initWithCustomView:_deleteMySymbolBtn];
    //调整导航栏按钮在导航栏上的位置FixedSpace 占位用
    UIBarButtonItem *spaceitem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceitem.width = -10;
    self.editingItemArray = @[leftitem1,leftitem2];;
}
//开始编辑
-(void)editMySymbolAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EditMYSymbol" object:self userInfo:nil];
    [self.editMySymbolBtn setHidden:YES];
    if(self.exitEditBtn == nil||self.deleteMySymbolBtn == nil){
        [self CreateEditingBtn];
    }
    [self.exitEditBtn setHidden:NO];                  
    [self.deleteMySymbolBtn setHidden:NO];
    self.navigationItem.leftBarButtonItems = self.editingItemArray;
}
//取消编辑
-(void)exitEditBtnAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitEditMySymbol" object:self userInfo:nil];
    [self.editMySymbolBtn setHidden:NO];
    [self.exitEditBtn setHidden:YES];
    [self.deleteMySymbolBtn setHidden:YES];
    self.navigationItem.leftBarButtonItems = self.normalItemArray;
}
//删除选中
-(void)deleteMySymbolBtnAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteSelectMySymbol" object:self userInfo:nil];
    [self.editMySymbolBtn setHidden:NO];
    [self.exitEditBtn setHidden:YES];
    [self.deleteMySymbolBtn setHidden:YES];
    self.navigationItem.leftBarButtonItems = self.normalItemArray;
}




-(void)sliderAnimationWithTag:(NSInteger)tag{
    self.currentIndex = tag;
    aBtn.selected = NO;
    bBtn.selected = NO;
    cBtn.selected = NO;
    dBtn.selected = NO;
    eBtn.selected = NO;
    UIButton *sender = [self buttonWithTag:tag];
    sender.selected = YES;
    //动画
    [UIView animateWithDuration:0.1 animations:^{
       self->sliderLabel.frame = CGRectMake(sender.frame.origin.x + kScreenWidth/10 - 15, self->sliderLabel.frame.origin.y, 30, 2);
        
    } completion:^(BOOL finished) {
       
    }];
    /*
     编辑按钮只在自选页显示
     */
    if(self.currentIndex - 1 == SELF_CHOOSE ){
        [self.editMySymbolBtn setHidden:NO];
        [self.exitEditBtn setHidden:YES];
        [self.deleteMySymbolBtn setHidden:YES];
        self.navigationItem.leftBarButtonItems = self.normalItemArray;
    }else{
        [self.editMySymbolBtn setHidden:YES];
        [self.exitEditBtn setHidden:YES];
        [self.deleteMySymbolBtn setHidden:YES];
    }
}
-(void)sliderWithTag:(NSInteger)tag{
    self.currentIndex = tag;
    aBtn.selected = NO;
    bBtn.selected = NO;
    cBtn.selected = NO;
    dBtn.selected = NO;
    eBtn.selected = NO;
    UIButton *sender = [self buttonWithTag:tag];
    sender.selected = YES;
    //动画

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //实时计算当前位置,实现和titleView上的按钮的联动
    CGFloat contentOffSetX = scrollView.contentOffset.x;
    CGFloat X = contentOffSetX * (2*kScreenWidth/5)/kScreenWidth/2;
    CGRect frame = sliderLabel.frame;
    frame.origin.x = X+kScreenWidth/10 - 15;
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
