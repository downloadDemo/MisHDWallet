//
//  CreateMnemonicVC.m
//  TaiYiToken
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "CreateMnemonicVC.h"
#import "NYMnemonic.h"

#import "VerifyMnemonicVC.h"
@interface CreateMnemonicVC ()
@property(nonatomic,strong)UILabel *headlabel;
@property(nonatomic,strong) UIButton *backBtn;

@property(nonatomic,strong) UIButton *nextBtn;
@property(nonatomic,copy)NSString *mnemonic;
@end

@implementation CreateMnemonicVC
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
    
 
    _headlabel = [[UILabel alloc] init];
    _headlabel.textColor = [UIColor blackColor];
    _headlabel.font = [UIFont systemFontOfSize:16];
    _headlabel.text = @"备份助记词";
    _headlabel.textAlignment = NSTextAlignmentLeft;
    _headlabel.numberOfLines = 1;
    [self.view addSubview:_headlabel];
    [_headlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(50);
        make.top.equalTo(30);
        make.right.equalTo(-16);
        make.height.equalTo(25);
    }];
    
    UILabel *remindlabel = [[UILabel alloc] init];
    remindlabel.textColor = [UIColor textGrayColor];
    remindlabel.font = [UIFont systemFontOfSize:13];
    remindlabel.text = @"请仔细抄写下方助记词，我们将在下一步验证";
    remindlabel.textAlignment = NSTextAlignmentCenter;
    remindlabel.numberOfLines = 1;
    [self.view addSubview:remindlabel];
    [remindlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(70);
        make.right.equalTo(-10);
        make.height.equalTo(20);
    }];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.backgroundColor = [UIColor textBlueColor];
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
    
    [self CreateMnemonic];
    
}
-(void)CreateMnemonic{
    self.mnemonic = [NYMnemonic generateMnemonicString:@128 language:@"english"];
    UILabel *mnemonicLabel = [UILabel new];
    mnemonicLabel.layer.borderColor = [UIColor grayColor].CGColor;
    mnemonicLabel.layer.borderWidth = 1;
    mnemonicLabel.textColor = [UIColor textBlackColor];
    mnemonicLabel.font = [UIFont systemFontOfSize:17];
    mnemonicLabel.text = self.mnemonic;
    mnemonicLabel.textAlignment = NSTextAlignmentCenter;
    mnemonicLabel.numberOfLines = 0;
    [self.view addSubview:mnemonicLabel];
    [mnemonicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(100);
        make.right.equalTo(-20);
        make.height.equalTo(100);
    }];
}
-(void)nextAction{
    VerifyMnemonicVC *vmvc = [VerifyMnemonicVC new];
    vmvc.mnemonic = self.mnemonic;
    [self.navigationController pushViewController:vmvc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
