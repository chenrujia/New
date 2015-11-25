//
//  BXTAuthenticationViewController.m
//  BXT
//
//  Created by Jason on 15/8/25.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTAuthenticationViewController.h"
#import "BXTHeaderForVC.h"
#import "SegmentView.h"
#import "BXTRepairerView.h"
#import "BXTPropertyView.h"

#define NavBarHeight 105.f

@interface BXTAuthenticationViewController () <SegmentViewDelegate,UIScrollViewDelegate>
{
    NSInteger currentPage;
    UIScrollView *currentScrollView;
    BXTRepairerView *repairerView;
    BXTPropertyView *propertyView;
    SegmentView *segment;
}
@end

@implementation BXTAuthenticationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetting];
    [self scrollerViewSetting];
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
    }
    naviView.userInteractionEnabled = YES;
    [self.view addSubview:naviView];
    
    UIButton * nav_leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 44)];
    nav_leftButton.backgroundColor = [UIColor clearColor];
    [nav_leftButton setImage:[UIImage imageNamed:@"aroww_left"] forState:UIControlStateNormal];
    [nav_leftButton addTarget:self action:@selector(navigationLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:nav_leftButton];
    
    UILabel *navi_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 20, SCREEN_WIDTH-128, 44)];
    navi_titleLabel.backgroundColor = [UIColor clearColor];
    navi_titleLabel.font = [UIFont systemFontOfSize:18];
    navi_titleLabel.textColor = [UIColor whiteColor];
    navi_titleLabel.textAlignment = NSTextAlignmentCenter;
    navi_titleLabel.text = [NSString stringWithFormat:@"身份验证"];
    [naviView addSubview:navi_titleLabel];
    
    segment = [[SegmentView alloc] initWithFrame:CGRectMake(10.f, NavBarHeight - 40.f, SCREEN_WIDTH - 20.f, 30.f) andTitles:@[@"我要报修",@"我是维修员"]];
    segment.layer.masksToBounds = YES;
    segment.layer.cornerRadius = 4.f;
    segment.delegate = self;
    [naviView addSubview:segment];
}

- (void)scrollerViewSetting
{
    currentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavBarHeight)];
    currentScrollView.delegate = self;
    currentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    currentScrollView.pagingEnabled = YES;
    currentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:currentScrollView];
    
    repairerView = [[BXTRepairerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(currentScrollView.frame)) andViewType:RepairType];
    [currentScrollView addSubview:repairerView];
    
    propertyView = [[BXTPropertyView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(currentScrollView.frame)) andViewType:PropertyType];
    [currentScrollView addSubview:propertyView];
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

/**
 *  UIScrollViewDelegate
 */
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
