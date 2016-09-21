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
#import "BXTEnergyClassificationViewController.h"
#import "BXTEnergyReadingQuickViewController.h"
#import "BXTEnergyStatisticViewController.h"

@interface BXTApplicationsViewController () <BXTDataResponseDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *itemsCollectionView;
@property (nonatomic, strong) NSMutableArray   *titleArray;
@property (nonatomic, strong) NSMutableArray   *imageArray;
@property (nonatomic, strong) UIButton         *headImageView;
@property (nonatomic, copy  ) NSString         *transURL;

@end

@implementation BXTApplicationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"应用" andRightTitle:nil andRightImage:nil];
    
    NSString *power = [BXTGlobal getUserProperty:U_POWER];
    
    //如果包含业务统计
    if ([power containsString:@"40101"] || [power containsString:@"40102"] || [power containsString:@"40103"] ||
        [power containsString:@"40201"] || [power containsString:@"40202"] || [power containsString:@"40203"] ||
        [power containsString:@"40300"] || [power containsString:@"40403"] || [power containsString:@"40404"])
    {
        self.titleArray = [[NSMutableArray alloc] initWithArray:@[@"业务统计", @"敬请期待"]];
        self.imageArray = [[NSMutableArray alloc] initWithArray:@[@"app_statistics", @"app_symbol"]];
        
        if ([power containsString:@"80700"])
        {
            self.titleArray = [[NSMutableArray alloc] initWithArray:@[@"业务统计", @"能源统计", @"敬请期待"]];
            self.imageArray = [[NSMutableArray alloc] initWithArray:@[@"app_statistics", @"app_chart", @"app_symbol"]];
            
            if ([power containsString:@"80601"])
            {
                self.titleArray = [[NSMutableArray alloc] initWithArray:@[@"业务统计", @"能源抄表", @"能源统计", @"快捷抄表", @"敬请期待"]];
                self.imageArray = [[NSMutableArray alloc] initWithArray:@[@"app_statistics", @"app_metering", @"app_chart", @"app_quick", @"app_symbol"]];
            }
        }
    }
    else
    {
        self.titleArray = [[NSMutableArray alloc] initWithArray:@[@"敬请期待"]];
        self.imageArray = [[NSMutableArray alloc] initWithArray:@[@"app_symbol"]];
        
        if ([power containsString:@"80601"])
        {
            self.titleArray = [[NSMutableArray alloc] initWithArray:@[@"能源抄表", @"快捷抄表", @"敬请期待"]];
            self.imageArray = [[NSMutableArray alloc] initWithArray:@[@"app_metering", @"app_quick", @"app_symbol"]];
        }
    }
    
    //如果包含项目公告
    if ([power containsString:@"50100"])
    {
        [self.titleArray insertObject:@"项目公告" atIndex:0];
        [self.imageArray insertObject:@"app_book" atIndex:0];
    }
    
    [BXTGlobal showLoadingMBP:@"加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**广告位图片展示**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request appVCAdvertisement];
    });
    dispatch_async(concurrentQueue, ^{
        /**请求是否显示OA**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request informOFOA];
    });
    
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
}

- (void)createUI
{
    // UIImageView
    CGFloat scale = 123.f/320.f;
    self.headImageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH * scale)];
    [self.view addSubview:self.headImageView];
    
    // UICollectionView
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.minimumInteritemSpacing = 0.f;
    self.itemsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + SCREEN_WIDTH * scale, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.headImageView.frame) - 50) collectionViewLayout:flowLayout];
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
    NSString *title = self.titleArray[indexPath.row];
    if ([title isEqualToString:@"项目公告"])
    {
        BXTNoticeListViewController *nlVC = [[BXTNoticeListViewController alloc] init];
        nlVC.hidesBottomBarWhenPushed = YES;
        // 点击去掉参数
        [BXTRemindNum sharedManager].announcementNum = @"0";
        // 存储点击时间
        [BXTRemindNum sharedManager].timeStart_Announcement = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        SaveValueTUD(@"timeStart_Announcement", [BXTRemindNum sharedManager].timeStart_Announcement);
        
        nlVC.delegateSignal = [RACSubject subject];
        [nlVC.delegateSignal subscribeNext:^(id x) {
            [BXTRemindNum sharedManager].app_show = 0;
        }];
        
        [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
        [self.navigationController pushViewController:nlVC animated:YES];
    }
    else if ([title isEqualToString:@"业务统计"])
    {
        BXTStatisticsViewController *epVC = [[BXTStatisticsViewController alloc] init];
        epVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:epVC animated:YES];
    }
    else if ([title isEqualToString:@"OA系统"])
    {
        BXTNoticeInformViewController *niVC = [[BXTNoticeInformViewController alloc] init];
        niVC.urlStr = self.transURL;
        niVC.titleStr = @"OA系统";
        niVC.pushType = PushType_OA;
        niVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:niVC animated:YES];
    }
    else if ([title isEqualToString:@"能源抄表"])
    {
        BXTEnergyClassificationViewController *energyVC = [[BXTEnergyClassificationViewController alloc] init];
        energyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:energyVC animated:YES];
    }
    else if ([title isEqualToString:@"快捷抄表"])
    {
        BXTEnergyReadingQuickViewController *energyVC = [[BXTEnergyReadingQuickViewController alloc] init];
        energyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:energyVC animated:YES];
    }
    else if ([title isEqualToString:@"能源统计"])
    {
        BXTEnergyStatisticViewController *energyVC = [[BXTEnergyStatisticViewController alloc] init];
        energyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:energyVC animated:YES];
    }
    else if ([title isEqualToString:@"酒店入住率"])
    {
        [BXTGlobal showText:@"功能完善中..." completionBlock:nil];
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (data.count > 0 && type == AppVCAdvertisement)
    {
        NSDictionary *dict = data[0];
        [self.headImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:dict[@"pic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"allDefault"]];
        @weakify(self);
        [[self.headImageView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            BXTNoticeInformViewController *nivc = [[BXTNoticeInformViewController alloc] init];
            nivc.urlStr = dict[@"url"];
            nivc.titleStr = dict[@"name"];
            nivc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nivc animated:YES];
        }];
    }
    if (type == InformOFOA)
    {
        [BXTGlobal hideMBP];
        
        if ([dic[@"returncode"] integerValue] != 0)
        {
            return;
        }
        
        [self.titleArray insertObject:@"OA系统" atIndex:self.titleArray.count - 1];
        [self.imageArray insertObject:@"app_OA" atIndex:self.imageArray.count - 1];
        
        NSDictionary *dict = data[0];
        self.transURL = [NSString stringWithFormat:@"%@", dict[@"other_login_url"]];
        
        [self.itemsCollectionView reloadData];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    [BXTGlobal showText:@"请求失败，请重试" completionBlock:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
