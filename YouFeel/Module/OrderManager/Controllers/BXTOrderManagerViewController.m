//
//  BXTOrderManagerViewController.m
//  BXT
//
//  Created by Jason on 15/9/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTOrderManagerViewController.h"
#import "BXTHeaderFile.h"
#import "SegmentView.h"
#import "BXTOrderListView.h"
#import "BXTRepairViewController.h"

#define NavBarHeight 100.f

@interface BXTOrderManagerViewController ()<SegmentViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *currentScrollView;
    SegmentView *segment;
    NSInteger currentPage;
}
@end

@implementation BXTOrderManagerViewController

- (instancetype)initWithControllerType:(ControllerType)type
{
    self = [super init];
    if (self)
    {
        self.vcType = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting];
}

#pragma mark -
#pragma mark 初始化视图
- (void)navigationSetting
{
    UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavBarHeight)];
    if ([BXTGlobal shareGlobal].isRepair)
    {
        naviView.image = [[UIImage imageNamed:@"Nav_Bars"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    }
    else
    {
        naviView.image = [[UIImage imageNamed:@"Nav_Bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    }    naviView.userInteractionEnabled = YES;
    [self.view addSubview:naviView];
    
    UILabel *navi_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 20, SCREEN_WIDTH-128, 44)];
    navi_titleLabel.backgroundColor = [UIColor clearColor];
    navi_titleLabel.font = [UIFont systemFontOfSize:18];
    navi_titleLabel.textColor = [UIColor whiteColor];
    navi_titleLabel.textAlignment = NSTextAlignmentCenter;
    navi_titleLabel.text = [NSString stringWithFormat:@"工单管理"];
    [naviView addSubview:navi_titleLabel];
    
    UIButton * navi_leftButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 20, 44, 44)];
    navi_leftButton.backgroundColor = [UIColor clearColor];
    [navi_leftButton setImage:[UIImage imageNamed:@"Aroww_left"] forState:UIControlStateNormal];
    [navi_leftButton setImage:[UIImage imageNamed:@"Aroww_left_selected"] forState:UIControlStateNormal];
    [navi_leftButton addTarget:self action:@selector(navigationLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:navi_leftButton];
    
    if (_vcType == RepairType)
    {
        segment = [[SegmentView alloc] initWithFrame:CGRectMake(10.f, NavBarHeight - 40.f, SCREEN_WIDTH - 20.f, 30.f) andTitles:@[@"等待中",@"维修中",@"已完成"]];
    }
    else if (_vcType == MaintenanceManType)
    {
        UIButton * navi_rightButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 20, 44, 44)];
        navi_rightButton.backgroundColor = [UIColor clearColor];
        [navi_rightButton setImage:[UIImage imageNamed:@"Small_round"] forState:UIControlStateNormal];
        [navi_rightButton setImage:[UIImage imageNamed:@"Small_ronud_selected"] forState:UIControlStateNormal];
        [navi_rightButton addTarget:self action:@selector(navigationrightButton) forControlEvents:UIControlEventTouchUpInside];
        [naviView addSubview:navi_rightButton];
        
        segment = [[SegmentView alloc] initWithFrame:CGRectMake(10.f, NavBarHeight - 40.f, SCREEN_WIDTH - 20.f, 30.f) andTitles:@[@"维修中",@"已完成"]];
    }
    segment.layer.masksToBounds = YES;
    segment.layer.cornerRadius = 4.f;
    segment.delegate = self;
    [self.view addSubview:segment];
    
    currentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavBarHeight)];
    currentScrollView.delegate = self;
    if (_vcType == RepairType)
    {
        currentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    }
    else if (_vcType == MaintenanceManType)
    {
        currentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    }
    currentScrollView.pagingEnabled = YES;
    [self.view addSubview:currentScrollView];
    
    if (_vcType == RepairType)
    {
        for (NSInteger i = 1; i < 4; i++)
        {
            NSString *repairState = @"1";
            if (i == 2)
            {
                repairState = @"2";
            }
            else if (i == 3)
            {
                repairState = @"";
            }
            BXTOrderListView *orderList = [[BXTOrderListView alloc] initWithFrame:CGRectMake((i - 1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(currentScrollView.bounds)) andState:repairState andListViewType:_vcType == MaintenanceManViewType ? MaintenanceManViewType : RepairViewType];
            [currentScrollView addSubview:orderList];
        }
    }
    else if (_vcType == MaintenanceManType)
    {
        for (NSInteger i = 1; i < 3; i++)
        {
            NSString *repairState = @"2";
            if (i == 2)
            {
                repairState = @"";
            }
            BXTOrderListView *orderList = [[BXTOrderListView alloc] initWithFrame:CGRectMake((i - 1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(currentScrollView.bounds)) andState:repairState andListViewType:_vcType == MaintenanceManViewType ? MaintenanceManViewType : RepairViewType];
            [currentScrollView addSubview:orderList];
        }
    }
}

#pragma mark -
#pragma mark 事件处理
- (void)navigationLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationrightButton
{
    BXTRepairViewController *workOderVC = [[BXTRepairViewController alloc] initWithVCType:MMVCType];
    [self.navigationController pushViewController:workOderVC animated:YES];
}

#pragma mark -
#pragma mark 代理
/**
 *  SegmentViewDelegate
 */
- (void)segmentView:(SegmentView *)segmentView didSelectedSegmentAtIndex:(NSInteger)index
{
    currentPage = index;
    [currentScrollView setContentOffset:CGPointMake(currentPage * SCREEN_WIDTH, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 得到每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page == currentPage) return;
    currentPage = page;
    
    [segment segemtBtnChange:currentPage];
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
