//
//  UserInfoVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/21.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "UserInfoVC.h"
#import "UserInfoHeadView.h"
#import "ImageTextCell.h"
#import "AccountConfigVC.h"
#import "JavascriptWebViewController.h"

@interface UserInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UserInfoHeadView *headView;
@property(nonatomic)UITableView *tableView;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic,strong)NSArray *titleArray1;
@property(nonatomic,strong)NSArray *imageNameArray1;
@property(nonatomic,strong)NSArray *titleArray2;
@property(nonatomic,strong)NSArray *imageNameArray2;
@property(nonatomic,strong)JavascriptWebViewController *jvc;
@end

@implementation UserInfoVC

-(void)initUI{

    _headView = [UserInfoHeadView new];
    [_headView.iconiv setImage:[UIImage imageNamed:@"own_pic"]];
    [_headView.usernamelb setText:@"MissionWallet"];
    [self.view addSubview:_headView];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(100);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor ExportBackgroundColor];
    [self initUI];
    self.titleArray1 = @[NSLocalizedString(@"我的数据", nil),NSLocalizedString(@"信用评分", nil)];
    self.titleArray2 = @[NSLocalizedString(@"实名认证", nil),NSLocalizedString(@"交易记录", nil),NSLocalizedString(@"消息推送", nil),NSLocalizedString(@"帮助中心", nil),NSLocalizedString(@"账户设置", nil)];
    self.imageNameArray1 = @[@"own_contact",@"own_wallet-ss"];
    self.imageNameArray2 = @[@"own_record-jj",@"own_record",@"own_push",@"own_help",@"own_set"];
    [self tableView];
   
}
#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0?2 : 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 4) {
            AccountConfigVC *vc = [AccountConfigVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    _jvc = [JavascriptWebViewController new];
    [_jvc viewDidLoad];
   
    [CreateAll EOStransactionByJvc:_jvc callback:^(id response) {
        NSLog(@"response = %@",response);
    }];
//    NSString *str = @"once crawl machine nuclear wall firm holiday dismiss common fall note frozen";
//    NSString *seed = [CreateAll CreateSeedByMnemonic:str Password:nil];
//
//    NSString *eosPriOwner = [CreateAll CreateEOSPrivateKeyBySeed:seed Index:0];
    
    
//    [CreateAll isValidPrivateJvc:_jvc PrivateKey:eosPriOwner callback:^(id response) {
//        NSString *str = [(NSString *)response componentsSeparatedByString:@","].lastObject;
//        if ([str isEqualToString:@"true"]) {
//            [CreateAll EOSPrivateKeyToPublicKeyJvc:self.jvc PrivateKey:eosPriOwner callback:^(id response) {
//                NSLog(@"pub = %@",response);
//            }];
//        }else{
//            //Error
//        }
//
//    }];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageTextCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell.imageView setImage:[UIImage imageNamed:self.imageNameArray1[indexPath.row]]];
        [cell.textlb setText:self.titleArray1[indexPath.row]];
    }else{
        [cell.imageView setImage:[UIImage imageNamed:self.imageNameArray2[indexPath.row]]];
        [cell.textlb setText:self.titleArray2[indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins  = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

#pragma lazy
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[ImageTextCell class] forCellReuseIdentifier:@"ImageTextCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(100);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
