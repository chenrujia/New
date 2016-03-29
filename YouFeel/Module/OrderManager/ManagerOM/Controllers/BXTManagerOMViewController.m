//
//  BXTManagerOMViewController.m
//  YouFeel
//
//  Created by Jason on 15/11/26.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTManagerOMViewController.h"
#import "BXTHeaderForVC.h"
#import "SegmentView.h"
#import "BXTManagerOMView.h"
#import "BXTAllOrdersViewController.h"

@interface BXTManagerOMViewController ()<SegmentViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *currentScrollView;
    NSInteger    currentPage;
    SegmentView  *segment;
}
@end

@implementation BXTManagerOMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = colorWithHexString(@"ffffff");
    [self navigationSetting:@"特殊工单" andRightTitle:nil andRightImage:nil];
    [self createSubviews];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createSubviews
{
    segment = [[SegmentView alloc] initWithFrame:CGRectMake(10.f,KNAVIVIEWHEIGHT + 7.f, SCREEN_WIDTH - 20.f, 30.f) andTitles:@[@"待处理",@"已处理"] isWhiteBGColor:1];
    segment.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    segment.layer.masksToBounds = YES;
    segment.layer.cornerRadius = 4.f;
    segment.layer.borderWidth = 1.f;
    segment.delegate = self;
    [self.view addSubview:segment];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(segment.frame) + 7.f, SCREEN_WIDTH, 1.f)];
    lineView.backgroundColor = colorWithHexString(@"dee3e6");
    [self.view addSubview:lineView];
    
    currentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(lineView.frame))];
    currentScrollView.delegate = self;
    currentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    currentScrollView.pagingEnabled = YES;
    [self.view addSubview:currentScrollView];
    
    for (NSInteger i = 1; i < 3; i++)
    {
        BXTManagerOMView *omView = [[BXTManagerOMView alloc] initWithFrame:CGRectMake((i - 1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(currentScrollView.bounds)) andOrderType:i - 1 WithArray:nil];
        [currentScrollView addSubview:omView];
    }
}

#pragma mark -
#pragma mark 事件处理
- (void)navigationRightButton
{
    BXTAllOrdersViewController *allOrdersVC = [[BXTAllOrdersViewController alloc] init];
    [self.navigationController pushViewController:allOrdersVC animated:YES];
}

#pragma mark -
#pragma mark SegmentViewDelegate
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
