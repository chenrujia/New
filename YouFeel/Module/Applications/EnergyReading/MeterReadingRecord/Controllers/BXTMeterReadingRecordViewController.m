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
#import "BXTHistogramStatisticsView.h"
#import "BXTMeterReadingTimeView.h"
#import "BXTMeterReadingTimeCell.h"
#import "BXTEnergyConsumptionViewController.h"
#import "BXTMeterReadingViewController.h"
#import "BXTMeterReadingDailyDetailViewController.h"
#import "BXTDataRequest.h"
#import "BXTMeterReadingRecordMonthListInfo.h"
#import "BXTMeterReadingRecordListInfo.h"

@interface BXTMeterReadingRecordViewController () <UITableViewDelegate, UITableViewDataSource, BXTDataResponseDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) BXTMeterReadingHeaderView *headerView;
@property (nonatomic, strong) BXTMeterReadingFilterView *filterView_chart;
@property (nonatomic, strong) BXTHistogramStatisticsView *hisView;
@property (nonatomic, strong) BXTMeterReadingFilterOFListView *filterView_list;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *isShowArray;

@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, assign) BOOL isHideChart;

@property (nonatomic, strong) BXTMeterReadingRecordMonthListInfo *monthListInfo;
@property (nonatomic, strong) BXTMeterReadingRecordListInfo *listInfo;

@end

@implementation BXTMeterReadingRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetting:@"能源抄表" andRightTitle1:nil andRightImage1:[UIImage imageNamed:@"energy_list"] andRightTitle2:@"能耗计算" andRightImage2:nil];
    
    self.isShowArray = [[NSMutableArray alloc] init];
    
    [self createUI];
    [self getResource];
}

- (void)getResource
{
    [BXTGlobal showLoadingMBP:@"数据加载中..."];
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        // 计量表 - 抄表记录，月
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request energyMeterRecordMonthListsWithAboutID:self.transID year:@""];
    });
    dispatch_async(concurrentQueue, ^{
        // 计量表 - 抄表记录，列表
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request energyMeterRecordListsWithAboutID:self.transID date:@""];
    });
}

- (void)getResourceShowMonthChartView:(BOOL)showChart
{
    [BXTGlobal showLoadingMBP:@"数据加载中..."];
    if (showChart) {
        // 计量表 - 抄表记录，月
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request energyMeterRecordMonthListsWithAboutID:self.transID year:self.yearStr];
    }
    else {
        // 计量表 - 抄表记录，列表
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request energyMeterRecordListsWithAboutID:self.transID date:self.timeStr];
    }
}

- (void)navigationRightButton1
{
    if (self.isHideChart) {
        self.isHideChart = NO;
        [self showChartView:YES];
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.hisView.frame) + 10);
        self.scrollView.scrollEnabled = YES;
        [self.rightButton1 setImage:[UIImage imageNamed:@"energy_list"] forState:UIControlStateNormal];
    }
    else {
        self.isHideChart = YES;
        [self showChartView:NO];
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.tableView.frame) + 10);
        self.scrollView.scrollEnabled = NO;
        [self.rightButton1 setImage:[UIImage imageNamed:@"energy_bar_graph"] forState:UIControlStateNormal];
    }
}

- (void)navigationRightButton2
{
    BXTEnergyConsumptionViewController *ecvc = [[BXTEnergyConsumptionViewController alloc] init];
    ecvc.transID = self.transID;
    [self.navigationController pushViewController:ecvc animated:YES];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 70)];
    self.scrollView.showsVerticalScrollIndicator = NO;
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
    
    
    // BXTHistogramStatisticsView
    self.filterView_chart = [[[NSBundle mainBundle] loadNibNamed:@"BXTMeterReadingFilterView" owner:nil options:nil] lastObject];
    self.filterView_chart.frame = CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20, 50);
    // thisMonthBtn
    [[self.filterView_chart.thisMonthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self createYearPickerView];
        [[self.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.filterView_chart.thisMonthBtn setTitle:self.yearStr forState:UIControlStateNormal];
            [self getResourceShowMonthChartView:YES];
        }];
    }];
    // lastMonthBtn
    [[self.filterView_chart.lastMonthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.filterView_chart.thisMonthBtn setTitle:[self transTimeIsAdd:NO] forState:UIControlStateNormal];
        self.filterView_chart.nextMonthBtn.enabled = YES;
        self.filterView_chart.nextMonthBtn.alpha = 1.0;
    }];
    // nextMonthBtn
    [[self.filterView_chart.nextMonthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.filterView_chart.thisMonthBtn setTitle:[self transTimeIsAdd:YES] forState:UIControlStateNormal];
        if ([self.yearStr integerValue] == [[BXTGlobal yearAndmonthAndDay][0] integerValue]) {
            self.filterView_chart.nextMonthBtn.enabled = NO;
            self.filterView_chart.nextMonthBtn.alpha = 0.4;
        }
    }];
    [self.scrollView addSubview:self.filterView_chart];
    
    // BXTHistogramStatisticsView
    //50° ~ -50°
    NSArray *temperatureArray = @[@(20.f),@(45.f),@(-40.f),@(-10.f),@(-30.f),@(30.f),@(20.f),@(45.f),@(-40.f),@(-10.f),@(-30.f),@(30.f),@(20.f),@(45.f),@(-40.f),@(-10.f),@(-30.f),@(30.f),@(20.f),@(45.f),@(-40.f),@(-10.f),@(-30.f),@(30.f),@(20.f),@(45.f),@(-40.f),@(-10.f),@(-30.f),@(30.f)];
    //0 ~ 100%rh
    NSArray *humidityArray = @[@(30.f),@(80.f),@(40.f),@(70.f),@(20.f),@(50.f),@(30.f),@(80.f),@(40.f),@(70.f),@(20.f),@(50.f),@(30.f),@(80.f),@(40.f),@(70.f),@(20.f),@(50.f),@(30.f),@(80.f),@(40.f),@(70.f),@(20.f),@(50.f),@(30.f),@(80.f),@(40.f),@(70.f),@(20.f),@(50.f)];
    //0 ~ 10级
    NSArray *windPowerArray = @[@(8.f),@(2.f),@(6.f),@(1.f),@(7.f),@(5.f),@(8.f),@(2.f),@(6.f),@(1.f),@(7.f),@(5.f),@(8.f),@(2.f),@(6.f),@(1.f),@(7.f),@(5.f),@(8.f),@(2.f),@(6.f),@(1.f),@(7.f),@(5.f),@(8.f),@(2.f),@(6.f),@(1.f),@(7.f),@(5.f)];
    //0 ~ 1000kwh
    NSArray *totalEnergyArray = @[@[@(800.f),@(600.f),@(400.f)],
                                  @[@(500.f),@(300.f),@(200.f)],
                                  @[@(700.f),@(500.f),@(200.f)],
                                  @[@(900.f),@(700.f),@(500.f)],
                                  @[@(600.f),@(300.f),@(200.f)],
                                  @[@(1000.f),@(600.f),@(300.f)],
                                  @[@(800.f),@(600.f),@(400.f)],
                                  @[@(500.f),@(300.f),@(200.f)],
                                  @[@(700.f),@(500.f),@(200.f)],
                                  @[@(900.f),@(700.f),@(500.f)],
                                  @[@(600.f),@(300.f),@(200.f)],
                                  @[@(1000.f),@(600.f),@(300.f)],
                                  @[@(800.f),@(600.f),@(400.f)],
                                  @[@(500.f),@(300.f),@(200.f)],
                                  @[@(700.f),@(500.f),@(200.f)],
                                  @[@(900.f),@(700.f),@(500.f)],
                                  @[@(600.f),@(300.f),@(200.f)],
                                  @[@(1000.f),@(600.f),@(300.f)],
                                  @[@(800.f),@(600.f),@(400.f)],
                                  @[@(500.f),@(300.f),@(200.f)],
                                  @[@(700.f),@(500.f),@(200.f)],
                                  @[@(900.f),@(700.f),@(500.f)],
                                  @[@(600.f),@(300.f),@(200.f)],
                                  @[@(1000.f),@(600.f),@(300.f)],
                                  @[@(800.f),@(600.f),@(400.f)],
                                  @[@(500.f),@(300.f),@(200.f)],
                                  @[@(700.f),@(500.f),@(200.f)],
                                  @[@(900.f),@(700.f),@(500.f)],
                                  @[@(600.f),@(300.f),@(200.f)],
                                  @[@(1000.f),@(600.f),@(300.f)]];
    
    self.hisView = [[BXTHistogramStatisticsView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.filterView_chart.frame) + 10, SCREEN_WIDTH - 20.f, 470.f) temperatureArray:temperatureArray humidityArray:humidityArray windPowerArray:windPowerArray totalEnergyArray:totalEnergyArray];
    self.hisView.backgroundColor = [UIColor whiteColor];
    self.hisView.layer.masksToBounds = YES;
    self.hisView.layer.cornerRadius = 10.f;
    [[self.hisView.footerView.checkDetailBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTMeterReadingDailyDetailViewController *mrddvc = [[BXTMeterReadingDailyDetailViewController alloc] init];
        mrddvc.transID = self.transID;
        [self.navigationController pushViewController:mrddvc animated:YES];
    }];
    [self.scrollView addSubview:self.hisView];
    
    
    // filterView_list
    self.filterView_list = [[[NSBundle mainBundle] loadNibNamed:@"BXTMeterReadingFilterOFListView" owner:nil options:nil] lastObject];
    self.filterView_list.frame = CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20, 50);
    [[self.filterView_list.timeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self createDatePickerWithType:PickerTypeOFRange];
        [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.filterView_list.timeBtn setTitle:self.timeStr forState:UIControlStateNormal];
            [self getResourceShowMonthChartView:NO];
        }];
    }];
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
        mrvc.transID = self.transID;
        mrvc.delegateSignal = [RACSubject subject];
        [mrvc.delegateSignal subscribeNext:^(id x) {
            @strongify(self);
            self.timeStr = @"";
            [self.filterView_list.timeBtn setTitle:@"年/月/日" forState:UIControlStateNormal];
            [self getResourceShowMonthChartView:NO];
        }];
        [self.navigationController pushViewController:mrvc animated:YES];
    }];
    [self.footerView addSubview:newMeterBtn];
    
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.hisView.frame) + 10);
    [self showChartView:YES];
}

#pragma mark -
#pragma mark - 处理时间
- (NSString *)transTimeIsAdd:(BOOL)isAdd
{
    NSInteger year = [self.yearStr integerValue];
    if (!isAdd) { // 减法
        year -= 1;
    } else {
        year += 1;
    }
    
    self.yearStr = [NSString stringWithFormat:@"%ld", (long)year];
    NSLog(@"self.yearStr -------- %@", self.yearStr);
    //    [self getResource];
    
    return self.yearStr;
}

- (void)refreshUIWithData
{
    // self.headerView 赋值
    self.headerView.iconImageView.image = [self returnIconImageWithCheckPriceType:self.monthListInfo.check_price_type];
    self.headerView.titleView.text = [NSString stringWithFormat:@"%@", self.monthListInfo.meter_name];
    self.headerView.codeView.text = [NSString stringWithFormat:@"编号：%@", self.monthListInfo.code_number];
    self.headerView.rateView.text = [NSString stringWithFormat:@"倍率：%@", self.monthListInfo.rate];
    
    self.headerView.setPlaceView.text = [NSString stringWithFormat:@"%@", self.monthListInfo.place_name];
    self.headerView.serviceView.text = [NSString stringWithFormat:@"%@", self.monthListInfo.server_area];
    self.headerView.rangeView.text = [NSString stringWithFormat:@"%@", self.monthListInfo.desc];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isShowArray.count;
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
    
    cell.lists = self.listInfo.lists[indexPath.section];
    
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
    view.lists = self.listInfo.lists[section];
    
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
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    
    if (type == EnergyMeterRecordMonthLists && data.count > 0)
    {
        [BXTMeterReadingRecordMonthListInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"meterReadingID":@"id"};
        }];
        self.monthListInfo = [BXTMeterReadingRecordMonthListInfo mj_objectWithKeyValues:data[0]];
        
        [self refreshUIWithData];
    }
    if (type == EnergyMeterRecordLists && data.count > 0)
    {
        [BXTMeterReadingRecordListInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"meterReadingID":@"id"};
        }];
        [BXTRecordListsInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"listInfoID":@"id"};
        }];
        self.listInfo = [BXTMeterReadingRecordListInfo mj_objectWithKeyValues:data[0]];
        
        if (self.isShowArray) {
            [self.isShowArray removeAllObjects];
        }
        for (int i = 0; i < self.listInfo.lists.count; i++) {
            [self.isShowArray addObject:@"0"];
        }
        
        [self.tableView reloadData];
    }
    
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

#pragma mark -
#pragma mark - 方法
- (void)showChartView:(BOOL)showChart
{
    if (showChart) {
        self.filterView_chart.hidden = NO;
        self.hisView.hidden = NO;
        self.filterView_list.hidden = YES;
        self.tableView.hidden = YES;
    } else {
        self.filterView_chart.hidden = YES;
        self.hisView.hidden = YES;
        self.filterView_list.hidden = NO;
        self.tableView.hidden = NO;
    }
}

- (void)hideBgFooterView:(BOOL)isSelected
{
    if (isSelected) {
        self.headerView.bgViewBtn.selected = NO;
        self.headerView.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, 101);
        self.headerView.bgFooterView.hidden = YES;
        self.headerView.openImage.image = [UIImage imageNamed:@"energy_close"];
    } else {
        self.headerView.bgViewBtn.selected = YES;
        self.headerView.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, 180);
        self.headerView.bgFooterView.hidden = NO;
        self.headerView.openImage.image = [UIImage imageNamed:@"energy_open"];
    }
    
    // filterView_chart
    self.filterView_chart.frame = CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20, 50);
    CGRect chartsFrame = self.hisView.frame;
    chartsFrame.origin.y = CGRectGetMaxY(self.filterView_chart.frame) + 10;
    self.hisView.frame = chartsFrame;
    
    // filterView_list
    self.filterView_list.frame = CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20, 50);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.filterView_chart.frame), SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - CGRectGetMaxY(self.filterView_list.frame) - 70);
    
    if (!self.isHideChart) {
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.hisView.frame) + 10);
    }
}

@end
