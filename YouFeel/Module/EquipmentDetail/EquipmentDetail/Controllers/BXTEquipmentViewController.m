//
//  EquipmentViewController.m
//  YouFeel
//
//  Created by 满孝意 on 15/12/29.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTEquipmentViewController.h"
#import "BXTHeaderFile.h"
#import "SegmentView.h"
#import "BXTEquipmentInformView.h"
#import "BXTCurrentOrderView.h"
#import "BXTEquipmentFilesView.h"
#import "UIImageView+WebCache.h"

@interface BXTEquipmentViewController () <SegmentViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *currentScrollView;
    SegmentView *segment;
    NSInteger currentPage;
}

@property (nonatomic, strong) NSString *deviceID;

@end

@implementation BXTEquipmentViewController

- (instancetype)initWithDeviceID:(NSString *)device_id
{
    self = [super init];
    if (self)
    {
        self.deviceID = device_id;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent = NO;
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
    [self navigationSetting:@"设备详情" andRightTitle:nil andRightImage:nil];
    CGFloat navBarHeight = 64.f;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0.f, navBarHeight, SCREEN_WIDTH, 40.f)];
    [backView setBackgroundColor:colorWithHexString(@"ffffff")];
    [self.view addSubview:backView];
    
    if (![BXTGlobal shareGlobal].isRepair)
    {
        segment = [[SegmentView alloc] initWithFrame:CGRectMake(10.f, 5.f, SCREEN_WIDTH - 20.f, 30.f) andTitles:@[@"设备信息",@"当期工单",@"设备档案"] isWhiteBGColor:1];
        segment.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    }
    else
    {
        segment = [[SegmentView alloc] initWithFrame:CGRectMake(10.f, 5.f, SCREEN_WIDTH - 20.f, 30.f) andTitles:@[@"设备信息",@"当期工单",@"设备档案"] isWhiteBGColor:1];
        segment.layer.borderColor = colorWithHexString(@"0a4197").CGColor;
    }
    
    segment.layer.masksToBounds = YES;
    segment.layer.cornerRadius = 4.f;
    segment.layer.borderWidth = 1.f;
    segment.delegate = self;
    
    [backView addSubview:segment];
    
    currentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 40.f, SCREEN_WIDTH, SCREEN_HEIGHT - navBarHeight - 40.f)];
    currentScrollView.delegate = self;
    currentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    currentScrollView.pagingEnabled = YES;
    currentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:currentScrollView];
    
    BXTEquipmentInformView *epiView = [[BXTEquipmentInformView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(currentScrollView.bounds)) deviceID:self.deviceID];
    [currentScrollView addSubview:epiView];
    
    BXTCurrentOrderView *codView = [[BXTCurrentOrderView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(currentScrollView.bounds)) deviceID:self.deviceID];
    [currentScrollView addSubview:codView];
    
    BXTEquipmentFilesView *epfView = [[BXTEquipmentFilesView alloc] initWithFrame:CGRectMake(2*SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(currentScrollView.bounds)) deviceID:self.deviceID];
    [currentScrollView addSubview:epfView];
}

- (void)navigationLeftButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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