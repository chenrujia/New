//
//  StatisticsViewController.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/24.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "BXTStatisticsViewController.h"
#import "SegmentView.h"
#import "BXTHeaderForVC.h"
#import "BXTStatisticsFirstView.h"
#import "BXTStatisticsSecondView.h"
#import "BXTStatisticsThirdView.h"
#import "BXTStatisticsForthView.h"
#import "BXTAllOrdersViewController.h"
#import "BXTMaintenanceListViewController.h"
#import "BXTEquipmentListViewController.h"

@interface BXTStatisticsViewController () <SegmentViewDelegate, UIScrollViewDelegate, BXTDataResponseDelegate>
{
    UIScrollView *currentScrollView;
    SegmentView *segment;
    NSInteger currentPage;
}

@property (nonatomic, strong) NSMutableArray *MTPlanArray;
@property (nonatomic, strong) NSMutableArray *EPStateArray;

@end

@implementation BXTStatisticsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"业务统计" andRightTitle:@"全部工单" andRightImage:nil];
    
    self.MTPlanArray = [[NSMutableArray alloc] init];
    self.EPStateArray = [[NSMutableArray alloc] init];
    
    [self showLoadingMBP:@"数据加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request inspectionPlanOverview];
    
}

- (void)navigationRightButton
{
    // 全部工单
    BXTAllOrdersViewController *allOrdersVC = [[BXTAllOrdersViewController alloc] init];
    // 全部维保
    BXTMaintenanceListViewController *mtListVC = [[BXTMaintenanceListViewController alloc] init];
    // 全部设备
    BXTEquipmentListViewController *equipmentVC = [[BXTEquipmentListViewController alloc] init];
    
    switch (currentPage) {
        case 0: [self.navigationController pushViewController:allOrdersVC animated:YES]; break;
        case 1: [self.navigationController pushViewController:mtListVC animated:YES]; break;
        case 2: [self.navigationController pushViewController:equipmentVC animated:YES]; break;
        default: break;
    }
}

- (void)createUI
{
    // backView
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0.f, KNAVIVIEWHEIGHT, SCREEN_WIDTH, 40.f)];
    [backView setBackgroundColor:colorWithHexString(@"ffffff")];
    [self.view addSubview:backView];
    
    // SegmentView
    segment = [[SegmentView alloc] initWithFrame:CGRectMake(0.f, 5.f, SCREEN_WIDTH, 30.f) andTitles:@[@"日常工单", @"维保计划", @"设备状态", @"工作情况"] isWhiteBGColor:1];
    segment.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    segment.layer.masksToBounds = YES;
    segment.layer.cornerRadius = 4.f;
    segment.layer.borderWidth = 1.f;
    segment.delegate = self;
    [backView addSubview:segment];
    
    // UIScrollView
    currentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT + 40.f, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(backView.frame))];
    currentScrollView.delegate = self;
    currentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, 0);
    currentScrollView.pagingEnabled = YES;
    [self.view addSubview:currentScrollView];
    
    
    // Views
    CGFloat scrollViewH = currentScrollView.frame.size.height;
    BXTStatisticsFirstView *firstView = [[BXTStatisticsFirstView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0, 0, SCREEN_WIDTH, scrollViewH)];
    [currentScrollView addSubview:firstView];
    
    BXTStatisticsSecondView *secondView = [[BXTStatisticsSecondView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 1, 0, SCREEN_WIDTH, scrollViewH)];
    [currentScrollView addSubview:secondView];
    
    BXTStatisticsThirdView *thirdView = [[BXTStatisticsThirdView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, scrollViewH)];
    [currentScrollView addSubview:thirdView];
    
    BXTStatisticsForthView *forthView = [[BXTStatisticsForthView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, scrollViewH)];
    [currentScrollView addSubview:forthView];
}

#pragma mark -
#pragma mark SegmentViewDelegate
- (void)segmentView:(SegmentView *)segmentView didSelectedSegmentAtIndex:(NSInteger)index
{
    currentPage = index;
    [currentScrollView setContentOffset:CGPointMake(currentPage * SCREEN_WIDTH, 0) animated:YES];
    
    // 右上角按钮
    [self selectedSegmentedOfIndex:currentPage];
}

#pragma mark -
#pragma mark SegmentViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 得到每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page == currentPage) return;
    currentPage = page;
    
    [segment segemtBtnChange:currentPage];
    
    // 右上角按钮
    [self selectedSegmentedOfIndex:currentPage];
}

- (void)selectedSegmentedOfIndex:(NSInteger)index
{
    switch (index) {
        case 0: [self navigationSetting:@"业务统计" andRightTitle:@"全部工单" andRightImage:nil]; break;
        case 1: [self navigationSetting:@"业务统计" andRightTitle:@"全部维保" andRightImage:nil]; break;
        case 2: [self navigationSetting:@"业务统计" andRightTitle:@"全部设备" andRightImage:nil]; break;
        case 3: [self navigationSetting:@"业务统计" andRightTitle:nil andRightImage:nil]; break;
        default: break;
    }
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    if (type == InspectionPlanOverview && [[NSString stringWithFormat:@"%@", dic[@"returncode"]] integerValue] == 0)
    {
        NSArray *data = dic[@"data"];
        for (NSDictionary *dataDict in data)
        {
            [self.MTPlanArray addObject:dataDict];
            SaveValueTUD(@"secondViewMTPlanArray", self.MTPlanArray);
        }
        
        NSArray *device_data = dic[@"device_data"];
        for (NSDictionary *dataDict in device_data)
        {
            [self.EPStateArray addObject:dataDict];
            SaveValueTUD(@"thirdViewEPStateArray", self.EPStateArray);
        }
    }
    
    [self createUI];
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
    
    [self createUI];
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
