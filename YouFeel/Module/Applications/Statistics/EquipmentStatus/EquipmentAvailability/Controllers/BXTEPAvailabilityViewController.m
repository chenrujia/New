//
//  BXTEPAvailabilityViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/22.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEPAvailabilityViewController.h"
#import "BXTEPSummaryView.h"
#import "BXTEPSystemRateView.h"
#import "SegmentView.h"

@interface BXTEPAvailabilityViewController () <SegmentViewDelegate, UIScrollViewDelegate>
{
    UIScrollView *currentScrollView;
    SegmentView *segment;
    NSInteger currentPage;
}

@end

@implementation BXTEPAvailabilityViewController

- (void)viewDidLoad {
    // 隐藏年月日选择项
    self.hideDatePicker = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self createUI];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, 101)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, SCREEN_WIDTH-60, 30)];
    titleLabel.text = @"设备完好率统计";
    titleLabel.textColor = colorWithHexString(@"#333333");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel];
    // lineView
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = colorWithHexString(@"#d9d9d9");
    [headerView addSubview:lineView];
    
    
    // SegmentView
    segment = [[SegmentView alloc] initWithFrame:CGRectMake(0.f, 55.f, SCREEN_WIDTH, 40.f) andTitles:@[@"概述", @"各系统设备"] isWhiteBGColor:1];
    segment.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    segment.layer.masksToBounds = YES;
    segment.layer.cornerRadius = 4.f;
    segment.layer.borderWidth = 1.f;
    segment.delegate = self;
    [headerView addSubview:segment];
    
    // UIScrollView
    currentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT + 101.f, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(headerView.frame))];
    currentScrollView.delegate = self;
    currentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    currentScrollView.pagingEnabled = YES;
    [self.view addSubview:currentScrollView];
    
    // Views
    CGFloat scrollViewH = currentScrollView.frame.size.height;
    BXTEPSummaryView *firstView = [[[NSBundle mainBundle] loadNibNamed:@"BXTEPSummaryView" owner:nil options:nil] lastObject];
    firstView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 557);
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, scrollViewH)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, firstView.frame.size.height + 30);
    [scrollView addSubview:firstView];
    [currentScrollView addSubview:scrollView];
    
    
    
    
    BXTEPSystemRateView *secondView = [[BXTEPSystemRateView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, scrollViewH)];
    [currentScrollView addSubview:secondView];
    
    
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

#pragma mark -
#pragma mark - 父类点击事件
- (void)datePickerBtnClick:(UIButton *)button
{
    if (button.tag == 10001)
    {
        /**饼状图**/
        if (!selectedDate)
        {
            selectedDate = [NSDate date];
        }
        [self.rootCenterButton setTitle:[self weekdayStringFromDate:selectedDate] forState:UIControlStateNormal];
        
        NSString *timeStr = [NSString stringWithFormat:@"%@", selectedDate];
        timeStr = [timeStr substringToIndex:10];
        NSLog(@"timeStr ---- %@", timeStr);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BXTEPSummaryViewAndBXTEPSystemRateView" object:nil userInfo:@{@"timeStr": timeStr}];
    }
    [super datePickerBtnClick:button];
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
