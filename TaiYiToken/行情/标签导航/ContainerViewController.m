
#import "ContainerViewController.h"
#import "SelfChooseVC.h"
@interface ContainerViewController ()<UIScrollViewDelegate>{
    SelfChooseVC *aVC;
    SelfChooseVC *bVC;
    SelfChooseVC *cVC;
    SelfChooseVC *dVC;
    
    UIScrollView *mainScrollView;
    UIView *navView;
    UILabel *sliderLabel;
    UIButton *aBtn;
    UIButton *bBtn;
    UIButton *cBtn;
    UIButton *dBtn;
}

@end


@implementation ContainerViewController
#pragma mark
#pragma mark 懒加载VC

-(SelfChooseVC *)aVC{
    if (aVC==nil) {
        aVC = [[SelfChooseVC alloc]init];
        [self addChildViewController:aVC];
    }
    return aVC;
}
-(SelfChooseVC *)bVC{
    if (bVC==nil) {
        bVC = [[SelfChooseVC alloc]init];
        [self addChildViewController:bVC];
    }
    return bVC;
}
-(SelfChooseVC *)cVC{
    if (cVC==nil) {
        cVC = [[SelfChooseVC alloc]init];
        [self addChildViewController:cVC];
    }
    return cVC;
}
-(SelfChooseVC *)dVC{
    if (dVC==nil) {
        dVC = [[SelfChooseVC alloc]init];
        [self addChildViewController:dVC];
    }
    return dVC;
}


#pragma mark 
#pragma mark 初始化三个UIButton和一个滑动的silderLabel，三个btn放到一个UIView（navView）上面。
-(void)initUI{
    
   
    navView = [UIView new];
    [self.view addSubview:navView];
    
    navView.backgroundColor = [UIColor whiteColor];
    aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [aBtn setTitleColor:[UIColor textBlueColor] forState:UIControlStateSelected];
    [aBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    aBtn.frame = CGRectMake(0, 0, kScreenWidth/4, 35);
    aBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [aBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [aBtn setTitle:@"自选" forState:UIControlStateNormal];
    aBtn.tag = 1;
    aBtn.selected = YES;
    [navView addSubview:aBtn];
    
    bBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bBtn.frame = CGRectMake(aBtn.frame.origin.x+aBtn.frame.size.width, aBtn.frame.origin.y, kScreenWidth/4, 35);
    [bBtn setTitleColor:[UIColor textBlueColor] forState:UIControlStateSelected];
    [bBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    bBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [bBtn setTitle:@"市值" forState:UIControlStateNormal];
    bBtn.tag = 2;
    [navView addSubview:bBtn];
    
    cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cBtn.frame = CGRectMake(bBtn.frame.origin.x+bBtn.frame.size.width, bBtn.frame.origin.y, kScreenWidth/4, 35);
    [cBtn setTitleColor:[UIColor textBlueColor] forState:UIControlStateSelected];
    [cBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    cBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [cBtn setTitle:@"涨跌" forState:UIControlStateNormal];
    cBtn.tag = 3;
    //
    UIImageView *iv1 = [UIImageView new];
    iv1.image = [UIImage imageNamed:@"ico_up_default"];
    [cBtn addSubview:iv1];
    [iv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(-4);
        make.right.equalTo(-23);
        make.width.equalTo(7);
        make.height.equalTo(5);
    }];
    UIImageView *iv2 = [UIImageView new];
    iv2.image = [UIImage imageNamed:@"ico_down_default"];
    [cBtn addSubview:iv2];
    [iv2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(4);
        make.right.equalTo(-23);
        make.width.equalTo(7);
        make.height.equalTo(5);
    }];
    
    //
    [navView addSubview:cBtn];
    
    
    dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dBtn.frame = CGRectMake(cBtn.frame.origin.x+cBtn.frame.size.width, cBtn.frame.origin.y, kScreenWidth/4, 38);
    [dBtn setTitleColor:[UIColor textBlueColor] forState:UIControlStateSelected];
    [dBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    dBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [dBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [dBtn setTitle:@"成交(24h)" forState:UIControlStateNormal];
    dBtn.tag = 4;
    [navView addSubview:dBtn];
    
    
    sliderLabel = [UILabel new];
    sliderLabel.backgroundColor = [UIColor textBlueColor];
    [navView addSubview:sliderLabel];
    [sliderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(28);
        make.left.equalTo(kScreenWidth/8 - 25);
        make.width.equalTo(50);
        make.height.equalTo(2);
    }];
    
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.right.equalTo(0);
        make.height.equalTo(40);
    }];
    
 
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    [self initUI];
    [self setMainSrollView];
    //设置默认
    [self sliderWithTag:self.currentIndex+1];

}
#pragma mark
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

-(void)dealloc{
    
}

@end
