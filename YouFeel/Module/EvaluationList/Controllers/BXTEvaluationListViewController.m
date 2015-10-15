//
//  BXTEvaluationListViewController.m
//  YouFeel
//
//  Created by Jason on 15/10/15.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTEvaluationListViewController.h"
#import "BXTHeaderForVC.h"
#import "SegmentView.h"
#import "BXTNoneEvaluationView.h"
#import "BXTHaveEvaluationView.h"

#define NavBarHeight 100.f

@interface BXTEvaluationListViewController ()<SegmentViewDelegate,UIScrollViewDelegate>
{
    SegmentView *segment;
    NSInteger currentPage;
    UIScrollView *currentScrollView;
}
@end

@implementation BXTEvaluationListViewController

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
    naviView.image = [[UIImage imageNamed:@"Nav_Bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    naviView.userInteractionEnabled = YES;
    [self.view addSubview:naviView];
    
    UILabel *navi_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 20, SCREEN_WIDTH-128, 44)];
    navi_titleLabel.backgroundColor = [UIColor clearColor];
    navi_titleLabel.font = [UIFont systemFontOfSize:18];
    navi_titleLabel.textColor = [UIColor whiteColor];
    navi_titleLabel.textAlignment = NSTextAlignmentCenter;
    navi_titleLabel.text = [NSString stringWithFormat:@"评价"];
    [naviView addSubview:navi_titleLabel];
    
    UIButton * navi_leftButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 20, 44, 44)];
    navi_leftButton.backgroundColor = [UIColor clearColor];
    [navi_leftButton setImage:[UIImage imageNamed:@"Arrow_left"] forState:UIControlStateNormal];
    [navi_leftButton setImage:[UIImage imageNamed:@"Arrow_left_select"] forState:UIControlStateNormal];
    [navi_leftButton addTarget:self action:@selector(navigationLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:navi_leftButton];
    
    segment = [[SegmentView alloc] initWithFrame:CGRectMake(10.f, NavBarHeight - 40.f, SCREEN_WIDTH - 20.f, 30.f) andTitles:@[@"未评价",@"已评价"]];
    segment.layer.masksToBounds = YES;
    segment.layer.cornerRadius = 4.f;
    segment.delegate = self;
    [self.view addSubview:segment];
    
    currentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavBarHeight)];
    currentScrollView.delegate = self;
    currentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    currentScrollView.pagingEnabled = YES;
    [self.view addSubview:currentScrollView];
    
    BXTNoneEvaluationView *noneEV = [[BXTNoneEvaluationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(currentScrollView.bounds))];
    [currentScrollView addSubview:noneEV];
    
    BXTHaveEvaluationView *haveEV = [[BXTHaveEvaluationView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(currentScrollView.bounds))];
    [currentScrollView addSubview:haveEV];
}

#pragma mark -
#pragma mark 事件处理
- (void)navigationLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
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
