//
//  BXTEnergyStatisticBaseViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyStatisticBaseViewController.h"
#import "BXTEnergySurveyView.h"
#import "BXTEnergyDistributionView.h"
#import "BXTEnergyTrendView.h"

@interface BXTEnergyStatisticBaseViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *segmentViewBgView;
@property(nonatomic, strong) SegmentView *rootSegmentedCtr;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentPage;

/** ---- 显示费用界面 ---- */
@property (nonatomic, assign) BOOL showCost;

@end

@implementation BXTEnergyStatisticBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = colorWithHexString(@"eff3f6");
    
    if ([self.titleStr isEqualToString:@"建筑能效分布"]) {
        [self navigationSetting:self.titleStr andRightTitle:@"    费用" andRightImage:nil];
    }
    else {
        [self navigationSetting:self.titleStr andRightTitle:nil andRightImage:nil];
    }

    [self createSegmentedCtr];
}

- (void)navigationRightButton
{
    if (self.showCost) {
        self.showCost = NO;
        [self navigationSetting:@"建筑能效分布" andRightTitle:@"    费用" andRightImage:nil];
    }
    else {
        self.showCost = YES;
        [self navigationSetting:@"建筑能效分布" andRightTitle:@"    能耗" andRightImage:nil];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ESSHOWCOST" object:nil userInfo:@{@"showCost" : [NSNumber numberWithBool:self.showCost]}];
}

#pragma mark -
#pragma mark - createUI
- (void)createSegmentedCtr
{
    self.segmentViewBgView = [[UIView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, 50)];
    self.segmentViewBgView.backgroundColor = colorWithHexString(@"#3cafff");
    [self.view addSubview:self.segmentViewBgView];
    
    
    // 分页视图
    self.rootSegmentedCtr = [[SegmentView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 30) andTitles:@[@"月统计", @"年统计"] isWhiteBGColor:0];
    self.rootSegmentedCtr.layer.masksToBounds = YES;
    self.rootSegmentedCtr.layer.cornerRadius = 4.f;
    self.rootSegmentedCtr.delegate = self;
    [self.segmentViewBgView addSubview:self.rootSegmentedCtr];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentViewBgView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.segmentViewBgView.frame))];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    
    for (NSInteger i = 1; i < 3; i++)
    {
        if ([self.titleStr isEqualToString:@"建筑能效概况"]) {
            BXTEnergySurveyView *esView = [[BXTEnergySurveyView alloc] initWithFrame:CGRectMake((i - 1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(self.scrollView.bounds)) VCType:i];
            [self.scrollView addSubview:esView];
        }
        else if ([self.titleStr isEqualToString:@"建筑能效分布"]) {
            BXTEnergyDistributionView *esView = [[BXTEnergyDistributionView alloc] initWithFrame:CGRectMake((i - 1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(self.scrollView.bounds)) VCType:i];
            [self.scrollView addSubview:esView];
        }
        else if ([self.titleStr isEqualToString:@"建筑能效趋势"]) {
            BXTEnergyTrendView *esView = [[BXTEnergyTrendView alloc] initWithFrame:CGRectMake((i - 1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(self.scrollView.bounds)) VCType:i];
            [self.scrollView addSubview:esView];
        }
    }
}

#pragma mark -
#pragma mark - SegmentViewDelegate & UIScrollViewDelegate
- (void)segmentView:(SegmentView *)segmentView didSelectedSegmentAtIndex:(NSInteger)index
{
    self.currentPage = index;
    [self.scrollView setContentOffset:CGPointMake(self.currentPage * SCREEN_WIDTH, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 得到每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page == self.currentPage) return;
    self.currentPage = page;
    
    [self.rootSegmentedCtr segemtBtnChange:self.currentPage];
}

- (void)didReceiveMemoryWarning {
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
