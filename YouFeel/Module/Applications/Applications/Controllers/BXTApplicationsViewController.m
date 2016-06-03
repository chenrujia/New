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
#import "BXTRemindNum.h"
#import "BXTProjectManageViewController.h"
#import "ANKeyValueTable.h"
#import "BXTMailUserListSimpleInfo.h"
#import "UITabBar+badge.h"

@interface BXTApplicationsViewController () <BXTDataResponseDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *itemsCollectionView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) UIButton *headImageView;

@end

@implementation BXTApplicationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"应用" andRightTitle:nil andRightImage:nil];
    
    NSString *permissonKeys = [BXTGlobal getUserProperty:PERMISSIONKEYS];
    //如果不包含业务统计
    if ([permissonKeys containsString:@"9995"])
    {
        self.titleArray = @[@"项目公告", @"业务统计", @"敬请期待"];
        self.imageArray = @[@"app_book", @"app_statistics", @"app_symbol"];
    }
    else
    {
        self.titleArray = @[@"项目公告", @"敬请期待"];
        self.imageArray = @[@"app_book", @"app_symbol"];
    }
    
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request appVCAdvertisement];
    
    [self createUI];
    NSArray *listArray = [[ANKeyValueTable userDefaultTable] valueWithKey:YMAILLISTSAVE];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *listDict in listArray)
    {
        for (NSDictionary *subListDict in listDict[@"lists"])
        {
            BXTMailUserListSimpleInfo *userInfo = [BXTMailUserListSimpleInfo modelWithDict:subListDict];
            [dataArray addObject:userInfo];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BXTRepairButtonOther" object:nil];
    [self.itemsCollectionView reloadData];
    
    [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
}

- (void)createUI
{
    // UIImageView
    self.headImageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, valueForDevice(240, 145, 123, 123))];
    [self.view addSubview:self.headImageView];
    
    // UICollectionView
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.minimumInteritemSpacing = 0.f;
    self.itemsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + valueForDevice(240, 145, 123, 123), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.headImageView.frame) - 50) collectionViewLayout:flowLayout];
    self.itemsCollectionView.backgroundColor = colorWithHexString(@"eff3f5");
    [self.itemsCollectionView registerClass:[BXTHomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    self.itemsCollectionView.showsVerticalScrollIndicator = NO;
    self.itemsCollectionView.delegate = self;
    self.itemsCollectionView.dataSource = self;
    [self.view addSubview:self.itemsCollectionView];
}

#pragma mark -
#pragma mark - UICollectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.titleArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BXTHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = colorWithHexString(@"ffffff");
    cell.namelabel.text = self.titleArray[indexPath.row];
    cell.iconImage = [UIImage imageNamed:self.imageArray[indexPath.row]];
    [cell newsRedNumber:0];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [cell newsRedNumber:[[BXTRemindNum sharedManager].announcementNum integerValue]];
    }
    
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
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
            {
                BXTNoticeListViewController *nlvc = [[BXTNoticeListViewController alloc] init];
                nlvc.hidesBottomBarWhenPushed = YES;
                // 点击去掉参数
                [BXTRemindNum sharedManager].announcementNum = @"0";
                // 存储点击时间
                [BXTRemindNum sharedManager].timeStart_Announcement = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
                SaveValueTUD(@"timeStart_Announcement", [BXTRemindNum sharedManager].timeStart_Announcement);
                
                nlvc.delegateSignal = [RACSubject subject];
                [nlvc.delegateSignal subscribeNext:^(id x) {
                    [BXTRemindNum sharedManager].app_show = 0;
                }];
                
                [self.navigationController pushViewController:nlvc animated:YES];
            }
                break;
            case 1:
            {
                NSString *permissonKeys = [BXTGlobal getUserProperty:PERMISSIONKEYS];
                if ([permissonKeys containsString:@"9995"]) {
                    BXTStatisticsViewController *epvc = [[BXTStatisticsViewController alloc] init];
                    epvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:epvc animated:YES];
                }
                
            }
                break;
            default: break;
        }
    }
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
        [self.headImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:dict[@"pic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"allDefault"]];
        @weakify(self);
        [[self.headImageView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            BXTNoticeInformViewController *nivc = [[BXTNoticeInformViewController alloc] init];
            nivc.urlStr = dict[@"url"];
            nivc.titleStr = dict[@"name"];
            nivc.pushType = PushType_Project;
            nivc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nivc animated:YES];
        }];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal showText:@"请求失败，请重试" view:self.view completionBlock:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
