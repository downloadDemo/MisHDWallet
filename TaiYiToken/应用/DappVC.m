//
//  DappVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/25.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "DappVC.h"
#import "Customlayout.h"
#import "DappViewCell.h"
@interface DappVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic)UICollectionView *collectionview;
@property(nonatomic,strong)NSArray *titleArray1;
@property(nonatomic,strong)NSArray *imageNameArray1;
@end

@implementation DappVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray1 = @[NSLocalizedString(@"魔力试用", nil),NSLocalizedString(@"广告监测", nil),NSLocalizedString(@"奇点空间", nil),@"NEC"];
    self.imageNameArray1 = @[@"ico_logo _ml",@"ico_logo_ad",@"ico_logo_qd",@"ico_logo_nec_"];
    [self.collectionview registerClass:[DappViewCell class] forCellWithReuseIdentifier:@"DappViewCell"];
}

#pragma collectionview *****************************

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 25, 5, 25);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(1, 1);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(1, 1);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(75 , 90);//CGSizeMake(width, 300);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleArray1.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DappViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DappViewCell" forIndexPath:indexPath];
    [cell.iconImageView setImage:[UIImage imageNamed:self.imageNameArray1[indexPath.row]]];
    [cell.namelb setText:self.titleArray1[indexPath.row]];
    return cell;
}

-(UICollectionView *)collectionview{
    if (!_collectionview) {
        Customlayout *layout = [Customlayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionview.dataSource = self;
        _collectionview.delegate = self;
        _collectionview.contentInset = UIEdgeInsetsMake(5, 5, -5, -5);
        _collectionview.backgroundColor = kRGBA(255, 255, 255, 1);
        _collectionview.showsVerticalScrollIndicator = NO;
        _collectionview.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_collectionview];
        [_collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(0);
            make.height.equalTo(130);
        }];
    }
    return _collectionview;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
