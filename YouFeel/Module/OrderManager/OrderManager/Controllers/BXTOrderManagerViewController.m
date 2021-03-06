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
#import "UIImageView+WebCache.h"

@interface BXTOrderManagerViewController ()<SegmentViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *currentScrollView;
    SegmentView *segment;
    NSInteger currentPage;
}
@end

@implementation BXTOrderManagerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting];
}

#pragma mark -
#pragma mark 初始化视图
- (void)navigationSetting
{
    if (self.isRepair)
    {
        [self navigationSetting:@"我的维修工单" andRightTitle:nil andRightImage:nil];
    }
    else
    {
        [self navigationSetting:@"我的报修工单" andRightTitle:nil andRightImage:nil];
    }
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0.f, KNAVIVIEWHEIGHT, SCREEN_WIDTH, 40.f)];
    [backView setBackgroundColor:colorWithHexString(@"ffffff")];
    [self.view addSubview:backView];
    
    segment = [[SegmentView alloc] initWithFrame:CGRectMake(10.f, 5.f, SCREEN_WIDTH - 20.f, 30.f) andTitles:@[@"进行中",@"已完成"] isWhiteBGColor:1];
    
    segment.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    segment.layer.masksToBounds = YES;
    segment.layer.cornerRadius = 4.f;
    segment.layer.borderWidth = 1.f;
    segment.delegate = self;
    [backView addSubview:segment];
    
    currentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT + 40.f, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 40.f)];
    currentScrollView.delegate = self;
    currentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    currentScrollView.pagingEnabled = YES;
    [self.view addSubview:currentScrollView];
    
    for (NSInteger i = 1; i < 3; i++)
    {
        NSString *repairState;
        if (i == 1)
        {
            repairState = @"2";
        }
        else
        {
            repairState = @"1";
        }
        
        BXTOrderListView *orderList = [[BXTOrderListView alloc] initWithFrame:CGRectMake((i - 1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(currentScrollView.bounds)) andState:repairState andIsRepair:self.isRepair];
        [currentScrollView addSubview:orderList];
    }
}

#pragma mark -
#pragma mark SegmentViewDelegate
- (void)segmentView:(SegmentView *)segmentView didSelectedSegmentAtIndex:(NSInteger)index
{
    currentPage = index;
    [currentScrollView setContentOffset:CGPointMake(currentPage * SCREEN_WIDTH, 0) animated:YES];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
