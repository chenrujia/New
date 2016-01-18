//
//  BXTApplicationsViewController.m
//  YouFeel
//
//  Created by Jason on 15/12/24.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTApplicationsViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTHomeCollectionViewCell.h"
#import "BXTNoticeListViewController.h"
#import "UIButton+WebCache.h"
#import "BXTNoticeInformViewController.h"
#import "BXTStatisticsViewController.h"

@interface BXTApplicationsViewController () <BXTDataResponseDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) UIButton *headImageView;

@end

@implementation BXTApplicationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"应用" andRightTitle:nil andRightImage:nil];
    
    self.titleArray = @[@"项目通告", @"业务统计", @"敬请期待", @""];
    self.imageArray = @[@"app_book", @"app_statistics", @"app_symbol", @""];
    
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request appVCAdvertisement];
    
    [self createUI];
}

- (void)createUI
{
    // UIImageView
    CGFloat Ratio = SCREEN_WIDTH / 375  ;
    self.headImageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 180 * Ratio)];
    [self.view addSubview:self.headImageView];
    
    // UICollectionView
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.minimumInteritemSpacing = 0.f;
    UICollectionView *itemsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + 180 * Ratio, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.headImageView.frame) - 50) collectionViewLayout:flowLayout];
    itemsCollectionView.backgroundColor = colorWithHexString(@"eff3f5");
    [itemsCollectionView registerClass:[BXTHomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    itemsCollectionView.showsVerticalScrollIndicator = NO;
    itemsCollectionView.delegate = self;
    itemsCollectionView.dataSource = self;
    [self.view addSubview:itemsCollectionView];
}

#pragma mark -
#pragma mark - UICollectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BXTHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = colorWithHexString(@"ffffff");
    
    cell.namelabel.text = self.titleArray[indexPath.row];
    cell.iconImage = [UIImage imageNamed:self.imageArray[indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger width = floor(SCREEN_WIDTH/4.f);
    
    if (IS_IPHONE6)
    {
        if (indexPath.row%4 == 1 || indexPath.row%4 == 2)
        {
            return CGSizeMake(width+1, width);
        }
        return CGSizeMake(width, width);
    }
    else
    {
        return CGSizeMake(width, width);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BXTNoticeListViewController *nlvc = [[BXTNoticeListViewController alloc] init];
    nlvc.hidesBottomBarWhenPushed = YES;
    BXTStatisticsViewController *epvc = [[BXTStatisticsViewController alloc] init];
    epvc.hidesBottomBarWhenPushed = YES;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0: [self.navigationController pushViewController:nlvc animated:YES]; break;
            case 1: [self.navigationController pushViewController:epvc animated:YES]; break;
            default: break;
        }
    }
    
    
    NSLog(@"%ld -- %ld", (long)indexPath.section, (long)indexPath.row);
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (data.count > 0)
    {
        NSDictionary *dict = data[0];
        
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"pic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"backgroundIphone4s"]];
        @weakify(self);
        [[self.headImageView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            BXTNoticeInformViewController *nivc = [[BXTNoticeInformViewController alloc] init];
            nivc.urlStr = dict[@"url"];
            nivc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nivc animated:YES];
        }];
    }
}

- (void)requestError:(NSError *)error
{
    [BXTGlobal showText:@"请求失败，请重试" view:self.view completionBlock:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end