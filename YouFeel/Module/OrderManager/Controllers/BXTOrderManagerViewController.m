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
    CGFloat navBarHeight = valueForDevice(235.f, 213.f, 181.5f, 153.5f);
    UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, navBarHeight)];
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
    navi_titleLabel.text = [NSString stringWithFormat:@"我的工单"];
    [naviView addSubview:navi_titleLabel];
    
    UIButton * navi_leftButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 20, 44, 44)];
    navi_leftButton.backgroundColor = [UIColor clearColor];
    [navi_leftButton setImage:[UIImage imageNamed:@"arrowBack"] forState:UIControlStateNormal];
    @weakify(self);
    [[navi_leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [naviView addSubview:navi_leftButton];
    
    //logo
    [self createLogoView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0.f, navBarHeight, SCREEN_WIDTH, 40.f)];
    [backView setBackgroundColor:colorWithHexString(@"ffffff")];
    [self.view addSubview:backView];
    
    if (![BXTGlobal shareGlobal].isRepair)
    {
        segment = [[SegmentView alloc] initWithFrame:CGRectMake(10.f, 5.f, SCREEN_WIDTH - 20.f, 30.f) andTitles:@[@"等待中",@"维修中",@"已完成"] isWhiteBGColor:1];
        segment.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    }
    else
    {
        segment = [[SegmentView alloc] initWithFrame:CGRectMake(10.f, 5.f, SCREEN_WIDTH - 20.f, 30.f) andTitles:@[@"待维修",@"维修中",@"维修完成"] isWhiteBGColor:1];
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
    [self.view addSubview:currentScrollView];
    
    if (![BXTGlobal shareGlobal].isRepair)
    {
        for (NSInteger i = 1; i < 4; i++)
        {
            NSString *repairState;
            if (i == 1)
            {
                repairState = @"1";
            }
            else if (i == 2)
            {
                repairState = @"2";
            }
            else
            {
                repairState = @"";
            }
            BXTOrderListView *orderList = [[BXTOrderListView alloc] initWithFrame:CGRectMake((i - 1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(currentScrollView.bounds)) andState:repairState andRepairerIsReacive:@""];
            [currentScrollView addSubview:orderList];
        }
    }
    else
    {
        for (NSInteger i = 1; i < 4; i++)
        {
            NSString *repairState;
            if (i == 1)
            {
                repairState = @"1";
            }
            else if (i == 2)
            {
                repairState = @"2";
            }
            else
            {
                repairState = @"";
            }
            BXTOrderListView *orderList = [[BXTOrderListView alloc] initWithFrame:CGRectMake((i - 1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(currentScrollView.bounds)) andState:repairState andRepairerIsReacive:i == 1 ? @"1" : repairState];
            [currentScrollView addSubview:orderList];
        }
    }
}

- (void)createLogoView
{
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, valueForDevice(171.f, 149.f, 117.5f, 89.5f))];
    logoView.userInteractionEnabled = YES;
    [self.view addSubview:logoView];
    
    CGFloat width = valueForDevice(73.f, 73.f, 50.f, 45.f);
    UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, valueForDevice(10, 6, 6, 0), width, width)];
    headImgView.center = CGPointMake(SCREEN_WIDTH/2.f, headImgView.center.y);
    headImgView.contentMode = UIViewContentModeScaleAspectFill;
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.cornerRadius = width/2.f;
    [headImgView sd_setImageWithURL:[NSURL URLWithString:[BXTGlobal getUserProperty:U_HEADERIMAGE]] placeholderImage:[UIImage imageNamed:@"polaroid"]];
    [logoView addSubview:headImgView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headImgView.frame) + valueForDevice(15, 11, 8, 2), 200.f, 20.f)];
    nameLabel.center = CGPointMake(SCREEN_WIDTH/2.f, nameLabel.center.y);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = colorWithHexString(@"ffffff");
    nameLabel.font = [UIFont boldSystemFontOfSize:IS_IPHONE4 ? 15.f : 17.f];
    nameLabel.text = [BXTGlobal getUserProperty:U_NAME];
    [logoView addSubview:nameLabel];
    
    UILabel *groupLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame) + valueForDevice(10, 8, 4, 2), 200.f, 20.f)];
    groupLabel.center = CGPointMake(SCREEN_WIDTH/2.f, groupLabel.center.y);
    groupLabel.textAlignment = NSTextAlignmentCenter;
    groupLabel.textColor = colorWithHexString(@"ffffff");
    groupLabel.font = [UIFont boldSystemFontOfSize:IS_IPHONE4 ? 11.f : 13.f];
    BXTPostionInfo *postionInfo = [BXTGlobal getUserProperty:U_POSITION];
    BXTGroupingInfo *groupInfo = [BXTGlobal getUserProperty:U_GROUPINGINFO];
    if ([BXTGlobal shareGlobal].isRepair)
    {
        logoView.backgroundColor = colorWithHexString(@"09439c");
        groupLabel.text = [NSString stringWithFormat:@"%@-%@",groupInfo.subgroup,postionInfo.role];
    }
    else
    {
        logoView.backgroundColor = colorWithHexString(@"3cafff");
        groupLabel.text = postionInfo.role;
    }
    [logoView addSubview:groupLabel];
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
