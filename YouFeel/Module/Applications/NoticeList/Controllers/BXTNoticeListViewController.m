//
//  BXTNoticeListViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTNoticeListViewController.h"
#import "SegmentView.h"
#import "BXTReadNoticeView.h"
#import "BXTUnReadNoticeView.h"

@interface BXTNoticeListViewController () <SegmentViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) SegmentView *segmentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation BXTNoticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"项目公告" andRightTitle:nil andRightImage:nil];
    
    
    [self createUI];
}

- (void)createUI
{
    // UIView
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 64, SCREEN_WIDTH, 50.f)];
    [backView setBackgroundColor:colorWithHexString(@"ffffff")];
    backView.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    backView.layer.borderWidth = 0.5;
    [self.view addSubview:backView];
    
    // SegmentView
    self.segmentView = [[SegmentView alloc] initWithFrame:CGRectMake(10.f, 10.f, SCREEN_WIDTH - 20.f, 30.f) andTitles:@[@"未读", @"已读"] isWhiteBGColor:1];
    self.segmentView.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    self.segmentView.layer.masksToBounds = YES;
    self.segmentView.layer.cornerRadius = 4.f;
    self.segmentView.layer.borderWidth = 1.f;
    self.segmentView.delegate = self;
    [backView addSubview:self.segmentView];
    
    
    // UIScrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 50.f, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50.f)];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    // BXTUnReadNoticeView
    BXTUnReadNoticeView *unReadView = [[BXTUnReadNoticeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(backView.frame))];
    [self.scrollView addSubview:unReadView];
    
    // BXTReadNoticeView
    BXTReadNoticeView *readView = [[BXTReadNoticeView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(backView.frame))];
    [self.scrollView addSubview:readView];
    
}

#pragma mark -
#pragma mark SegmentViewDelegate
- (void)segmentView:(SegmentView *)segmentView didSelectedSegmentAtIndex:(NSInteger)index
{
    self.currentPage = index;
    [self.scrollView setContentOffset:CGPointMake(self.currentPage * SCREEN_WIDTH, 0) animated:YES];
}

#pragma mark -
#pragma mark SegmentViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 得到每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page == self.currentPage) return;
    self.currentPage = page;
    
    [self.segmentView segemtBtnChange:self.currentPage];
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
