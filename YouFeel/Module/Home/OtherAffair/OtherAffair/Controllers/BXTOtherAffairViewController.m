//
//  BXTOtherAffairViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTOtherAffairViewController.h"
#import "BXTHeaderForVC.h"
#import "SegmentView.h"
#import "BXTOtherAffairView.h"

@interface BXTOtherAffairViewController () <SegmentViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *currentScrollView;
    NSInteger    currentPage;
    SegmentView  *segment;
}

@end

@implementation BXTOtherAffairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"其他事务" andRightTitle:nil andRightImage:nil];
    
    [self createSubviews];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createSubviews
{
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
        BXTOtherAffairView *oaView = [[BXTOtherAffairView alloc] initWithFrame:CGRectMake((i - 1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(currentScrollView.bounds)) HandleState:[NSString stringWithFormat:@"%ld", (long)i]];
        [currentScrollView addSubview:oaView];
    }
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
