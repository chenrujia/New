//
//  BXTMeterReadingViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/6/27.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMeterReadingRecordViewController.h"
#import "BXTMeterReadingHeaderView.h"
#import "BXTMeterReadingFilterView.h"
#import "BXTMeterReadingFilterOFListView.h"
#import "BXTMeterReadingTimeView.h"
#import "BXTMeterReadingTimeCell.h"
#import "BXTEnergyConsumptionViewController.h"
#import "BXTMeterReadingViewController.h"

@interface BXTMeterReadingRecordViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) BXTMeterReadingHeaderView *headerView;
@property (nonatomic, strong) BXTMeterReadingFilterView *filterView_chart;
@property (nonatomic, strong) UIView *chartsView;
@property (nonatomic, strong) BXTMeterReadingFilterOFListView *filterView_list;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *isShowArray;

@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, assign) BOOL isHideChart;

@end

@implementation BXTMeterReadingRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetting:@"能源抄表" andRightTitle1:nil andRightImage1:[UIImage imageNamed:@"energy_list"] andRightTitle2:@"能耗计算" andRightImage2:nil];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"111", @"222", @"333", @"111", @"222", @"333", nil];
    self.isShowArray = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", nil];
    
    [self createUI];
}

- (void)navigationRightButton1
{
    if (self.isHideChart) {
        self.isHideChart = NO;
        [self showChartView:YES];
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.chartsView.frame) + 10);
        [self.rightButton1 setImage:[UIImage imageNamed:@"energy_list"] forState:UIControlStateNormal];
    }
    else {
        self.isHideChart = YES;
        [self showChartView:NO];
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.tableView.frame) + 10);
        [self.rightButton1 setImage:[UIImage imageNamed:@"energy_bar_graph"] forState:UIControlStateNormal];
    }
}

- (void)navigationRightButton2
{
    BXTEnergyConsumptionViewController *ecvc = [[BXTEnergyConsumptionViewController alloc] init];
    [self.navigationController pushViewController:ecvc animated:YES];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 70)];
    [self.view addSubview:self.scrollView];
    
    
    // headerView
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"BXTMeterReadingHeaderView" owner:nil options:nil] lastObject];
    [self hideBgFooterView:YES];
    @weakify(self);
    [[self.headerView.bgViewBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self hideBgFooterView:self.headerView.bgViewBtn.selected];
    }];
    [self.scrollView addSubview:self.headerView];
    
    
    // filterView_chart
    self.filterView_chart = [[[NSBundle mainBundle] loadNibNamed:@"BXTMeterReadingFilterView" owner:nil options:nil] lastObject];
    self.filterView_chart.frame = CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20, 50);
    [self.scrollView addSubview:self.filterView_chart];
    // chartsView
    self.chartsView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.filterView_chart.frame) + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - CGRectGetMaxY(self.filterView_chart.frame) - 90)];
    self.chartsView.backgroundColor = [UIColor whiteColor];
    self.chartsView.layer.cornerRadius = 10;
    [self.scrollView addSubview:self.chartsView];
    
    
    // filterView_list
    self.filterView_list = [[[NSBundle mainBundle] loadNibNamed:@"BXTMeterReadingFilterOFListView" owner:nil options:nil] lastObject];
    self.filterView_list.frame = CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20, 50);
    [self.scrollView addSubview:self.filterView_list];
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.filterView_chart.frame), SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - CGRectGetMaxY(self.filterView_list.frame) - 70) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.scrollView addSubview:self.tableView];
    
    
    // footerView
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70, SCREEN_WIDTH, 70)];
    self.footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footerView];
    
    UIButton *newMeterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newMeterBtn.frame = CGRectMake((SCREEN_WIDTH - 180) / 2, 10, 180, 50);
    [newMeterBtn setBackgroundColor:colorWithHexString(@"#5DAFF9")];
    [newMeterBtn setTitle:@"新建抄表" forState:UIControlStateNormal];
    newMeterBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    newMeterBtn.layer.cornerRadius = 5;
    [[newMeterBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTMeterReadingViewController *mrvc = [[BXTMeterReadingViewController alloc] init];
        [self.navigationController pushViewController:mrvc animated:YES];
    }];
    [self.footerView addSubview:newMeterBtn];
    
    [self showChartView:YES];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.isShowArray[section] isEqualToString:@"1"]) {
        return  1;
    }
    return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTMeterReadingTimeCell *cell = [BXTMeterReadingTimeCell cellWithTableView:tableView];
    
    if ([self.isShowArray[indexPath.section] isEqualToString:@"1"]) {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:cell.footerView.bounds byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){10.0f, 10.0f}].CGPath;
        cell.footerView.layer.mask = maskLayer;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"headerTitle";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BXTMeterReadingTimeView *view = [BXTMeterReadingTimeView viewForMeterReadingTime];
    view.showViewBtn.tag = section;
    
    if ([self.isShowArray[section] isEqualToString:@"1"]) {
        // headerView
        view.showView.layer.masksToBounds = YES;
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:view.showView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){10.0f, 10.0f}].CGPath;
        view.showView.layer.mask = maskLayer;
    }
    else {
        view.showView.layer.cornerRadius = 10;
    }
    
    @weakify(self);
    [[view.showViewBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        // 改变组的显示状态
        if ([self.isShowArray[section] isEqualToString:@"1"])
        {
            [self.isShowArray replaceObjectAtIndex:section withObject:@"0"];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            NSUInteger index = [self.isShowArray indexOfObject:@"1"];
            if(index != NSNotFound) {
                [self.isShowArray replaceObjectAtIndex:index withObject:@"0"];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
            }
            
            [self.isShowArray replaceObjectAtIndex:section withObject:@"1"];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
    
    return view;
}

#pragma mark -
#pragma mark - 方法
- (void)showChartView:(BOOL)showChart
{
    if (showChart) {
        self.filterView_chart.hidden = NO;
        self.chartsView.hidden = NO;
        self.filterView_list.hidden = YES;
        self.tableView.hidden = YES;
    } else {
        self.filterView_chart.hidden = YES;
        self.chartsView.hidden = YES;
        self.filterView_list.hidden = NO;
        self.tableView.hidden = NO;
    }
}

- (void)hideBgFooterView:(BOOL)isSelected
{
    if (isSelected) {
        self.headerView.bgViewBtn.selected = NO;
        self.headerView.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, 100);
        self.headerView.bgFooterView.hidden = YES;
        self.headerView.openImage.image = [UIImage imageNamed:@"energy_close"];
    } else {
        self.headerView.bgViewBtn.selected = YES;
        self.headerView.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, 200);
        self.headerView.bgFooterView.hidden = NO;
        self.headerView.openImage.image = [UIImage imageNamed:@"energy_open"];
    }
    
    // filterView_chart
    self.filterView_chart.frame = CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20, 50);
    CGRect chartsFrame = self.chartsView.frame;
    chartsFrame.origin.y = CGRectGetMaxY(self.filterView_chart.frame) + 10;
    self.chartsView.frame = chartsFrame;
    
    // filterView_list
    self.filterView_list.frame = CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20, 50);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.filterView_chart.frame), SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - CGRectGetMaxY(self.filterView_list.frame) - 70);
    
    if (!self.isHideChart) {
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.chartsView.frame) + 10);
    }
}

@end
