//
//  BXTMeterReadingViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/6/27.
//  Copyright © 2016年 Jason. All rights reserved.
//

#define HeaderViewW self.headerView.frame.size.width

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
#import <math.h>
#import "BXTEnergyClassificationViewController.h"
#import "BXTEnergyReadingQuickViewController.h"
#import "MJRefresh.h"

@interface BXTMeterReadingRecordViewController () <UITableViewDelegate, UITableViewDataSource, BXTDataResponseDelegate>

@property (nonatomic, strong) UIScrollView                       *scrollView;
@property (nonatomic, strong) BXTMeterReadingHeaderView          *headerView;
@property (nonatomic, strong) BXTMeterReadingFilterView          *filterView_chart;
@property (nonatomic, strong) BXTHistogramStatisticsView         *hisView;
@property (nonatomic, strong) BXTMeterReadingFilterOFListView    *filterView_list;
@property (nonatomic, strong) UITableView                        *tableView;
@property (nonatomic, strong) NSMutableArray                     *isShowArray;
@property (nonatomic, strong) NSMutableArray                     *dataArray;
@property (nonatomic, strong) UIView                             *footerView;
@property (nonatomic, assign) BOOL                               isHideChart;
@property (nonatomic, strong) BXTMeterReadingRecordMonthListInfo *monthListInfo;
@property (nonatomic, strong) BXTMeterReadingRecordListInfo      *listInfo;

@property (nonatomic, copy) NSString *introInfo;
@property (nonatomic, assign) CGFloat maxLabelY;

/** ---- 是否已经加载一次 ---- */
@property (nonatomic, assign) BOOL isLaunched;
@property (nonatomic, assign) NSInteger      currentPage;

@property (nonatomic, strong) UILabel *noneLabel;

@end

@implementation BXTMeterReadingRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"能源抄表" andRightTitle1:nil andRightImage1:[UIImage imageNamed:@"energy_bar_graph"] andRightTitle2:nil andRightImage2:[UIImage imageNamed:@"energy_consumption"]];
    
    self.isShowArray = [[NSMutableArray alloc] init];
    self.dataArray = [[NSMutableArray alloc] init];
    self.isHideChart = YES;
    self.timeStr = @"";
    
    [self createUI];
    
    [BXTGlobal showLoadingMBP:@"加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        // 计量表 - 抄表记录，月
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request energyMeterRecordMonthListsWithAboutID:self.transID year:self.yearStr];
    });
    dispatch_async(concurrentQueue, ^{
        // 计量表 - 抄表记录，列表
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request energyMeterRecordListsWithAboutID:self.transID date:self.timeStr page:1];
    });
    
    
    self.currentPage = 1;
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf getListsResource];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf getListsResource];
    }];
}

/** ---- 计量表 - 抄表记录，月 ---- */
- (void)getMonthListsResource
{
    [BXTGlobal showLoadingMBP:@"加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request energyMeterRecordMonthListsWithAboutID:self.transID year:self.yearStr];
}

/** ---- 计量表 - 抄表记录，列表 ---- */
- (void)getListsResource
{
    [BXTGlobal showLoadingMBP:@"加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request energyMeterRecordListsWithAboutID:self.transID date:self.timeStr page:self.currentPage];
}

- (void)navigationLeftButton
{
    if (self.delegateSignal)
    {
        for (UIViewController *temp in self.navigationController.viewControllers)
        {
            if ([temp isKindOfClass:[BXTEnergyClassificationViewController class]])
            {
                [self.navigationController popToViewController:temp animated:YES];
            }
            else if ([temp isKindOfClass:[BXTEnergyReadingQuickViewController class]])
            {
                [self.delegateSignal sendNext:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)navigationRightButton1
{
    if (self.isHideChart)
    {
        self.isHideChart = NO;
        [self showChartView:YES];
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.hisView.frame) + 10);
        self.scrollView.scrollEnabled = YES;
        [self.rightButton1 setImage:[UIImage imageNamed:@"energy_list"] forState:UIControlStateNormal];
    }
    else
    {
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
#pragma mark createUI
- (void)createUI
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 70)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"BXTMeterReadingHeaderView" owner:nil options:nil] lastObject];
    [self hideBgFooterView:YES];
    @weakify(self);
    [[self.headerView.bgViewBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self hideBgFooterView:self.headerView.bgViewBtn.selected];
    }];
    [self.scrollView addSubview:self.headerView];
    
    self.filterView_chart = [[[NSBundle mainBundle] loadNibNamed:@"BXTMeterReadingFilterView" owner:nil options:nil] lastObject];
    self.filterView_chart.frame = CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20, 50);
    
    // thisMonthBtn
    [[self.filterView_chart.thisMonthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self createYearPickerView];
        [[self.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.filterView_chart.thisMonthBtn setTitle:self.yearStr forState:UIControlStateNormal];
            [self getMonthListsResource];
        }];
    }];
    
    // lastMonthBtn
    [[self.filterView_chart.lastMonthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.yearStr = [self transTimeIsAdd:NO];
        [self.filterView_chart.thisMonthBtn setTitle:self.yearStr forState:UIControlStateNormal];
        self.filterView_chart.nextMonthBtn.enabled = YES;
        self.filterView_chart.nextMonthBtn.alpha = 1.0;
        [self getMonthListsResource];
    }];
    
    // nextMonthBtn
    [[self.filterView_chart.nextMonthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.yearStr = [self transTimeIsAdd:YES];
        [self.filterView_chart.thisMonthBtn setTitle:self.yearStr forState:UIControlStateNormal];
        
        if ([self.yearStr integerValue] == [[BXTGlobal yearAndmonthAndDay][0] integerValue]) {
            self.filterView_chart.nextMonthBtn.enabled = NO;
            self.filterView_chart.nextMonthBtn.alpha = 0.4;
        }
        
        [self getMonthListsResource];
    }];
    [self.scrollView addSubview:self.filterView_chart];
    
    // filterView_list
    self.filterView_list = [[[NSBundle mainBundle] loadNibNamed:@"BXTMeterReadingFilterOFListView" owner:nil options:nil] lastObject];
    self.filterView_list.frame = CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20, 50);
    [[self.filterView_list.timeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self createDatePickerWithType:PickerTypeOFRange];
        [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            
            if (![BXTGlobal isBlankString:self.timeStr]) {
                self.filterView_list.resetBtn.hidden = NO;
                __block int count = 0;
                [[self.filterView_list.resetBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                    @strongify(self);
                    self.filterView_list.resetBtn.hidden = YES;
                    [self.filterView_list.timeBtn setTitle:@"年/月/日" forState:UIControlStateNormal];
                    self.timeStr = @"";
                    self.currentPage = 1;
                    if (count == 0) {
                        count++;
                        [self getListsResource];
                    }
                }];
            }
            
            [self.filterView_list.timeBtn setTitle:self.timeStr forState:UIControlStateNormal];
            self.currentPage = 1;
            [self getListsResource];
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
        mrvc.unlocked = self.unlocked;
        mrvc.delegateSignal = [RACSubject subject];
        [mrvc.delegateSignal subscribeNext:^(id x) {
            @strongify(self);
            self.timeStr = @"";
            [self.filterView_list.timeBtn setTitle:@"年/月/日" forState:UIControlStateNormal];
            
            self.currentPage = 1;
            [self getListsResource];
        }];
        [self.navigationController pushViewController:mrvc animated:YES];
    }];
    [self.footerView addSubview:newMeterBtn];
}

- (void)initialHisView:(NSInteger)maxNumber
{
    if (self.hisView)
    {
        [self.hisView removeFromSuperview];
    }
    self.hisView = [[BXTHistogramStatisticsView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.filterView_chart.frame) + 10, SCREEN_WIDTH - 20.f, 470.f) lists:self.monthListInfo.lists kwhMeasure:maxNumber kwhNumber:4 statisticsType:MonthType];
    self.hisView.footerView.roundView02.hidden = YES;
    self.hisView.footerView.windView.hidden = YES;
    self.hisView.backgroundColor = [UIColor whiteColor];
    self.hisView.layer.masksToBounds = YES;
    self.hisView.layer.cornerRadius = 10.f;
    self.hisView.footerView.checkDetailBtn.hidden = NO;
    @weakify(self);
    [[self.hisView.footerView.checkDetailBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTMeterReadingDailyDetailViewController *mrddvc = [[BXTMeterReadingDailyDetailViewController alloc] init];
        mrddvc.transID = self.transID;
        BXTRecordMonthListsInfo *recordInfo = self.monthListInfo.lists[self.hisView.selectIndex];
        mrddvc.showTimeStr = [NSString stringWithFormat:@"%@年%ld月", self.yearStr, (long)recordInfo.month];
        mrddvc.delegateSignal = [RACSubject subject];
        [mrddvc.delegateSignal subscribeNext:^(id x) {
            @strongify(self);
            self.timeStr = @"";
            [self.filterView_list.timeBtn setTitle:@"年/月/日" forState:UIControlStateNormal];
            
            self.currentPage = 1;
            [self getListsResource];
        }];
        [self.navigationController pushViewController:mrddvc animated:YES];
    }];
    [self.scrollView addSubview:self.hisView];
    
    // 默认值
    BXTRecordMonthListsInfo *recordInfo = self.monthListInfo.lists[self.monthListInfo.lists.count - 1];
    self.hisView.footerView.consumptionView.text = [NSString stringWithFormat:@"总能耗：%@", [BXTGlobal transNum:recordInfo.data.use_amount]];
    self.hisView.footerView.peakNumView.text = [NSString stringWithFormat:@"尖峰量：%@", [BXTGlobal transNum:recordInfo.data.peak_segment_amount]];
    self.hisView.footerView.apexNumView.text = [NSString stringWithFormat:@"峰段量：%@", [BXTGlobal transNum:recordInfo.data.peak_period_amount]];
    self.hisView.footerView.levelNumView.text = [NSString stringWithFormat:@"平段量：%@", [BXTGlobal transNum:recordInfo.data.flat_section_amount]];
    self.hisView.footerView.valleyNumView.text = [NSString stringWithFormat:@"谷段量：%@", [BXTGlobal transNum:recordInfo.data.valley_section_amount]];
    
    if (![self.monthListInfo.price_type_id isEqualToString:@"2"])
    {
        self.hisView.footerView.downView.hidden = YES;
        self.hisView.frame = CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20.f, 430.f);
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.hisView.frame) + 10);
    }
    
    if (!self.isLaunched)
    {
        [self showChartView:NO];
        self.isLaunched = YES;
    }
}

#pragma mark -
#pragma mark tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isShowArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.isShowArray[section] isEqualToString:@"1"])
    {
        return  1;
    }
    return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTMeterReadingTimeCell *cell = [BXTMeterReadingTimeCell cellWithTableView:tableView];
    
    cell.info = self.listInfo;
    cell.lists = self.dataArray[indexPath.section];
    
    if ([self.isShowArray[indexPath.section] isEqualToString:@"1"])
    {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        CGRect rect = CGRectMake(0, 0, cell.footerView.frame.size.width, [self returnSubCellHeightAtIndexPath:indexPath]);
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){10.0f, 10.0f}].CGPath;
        cell.footerView.layer.mask = maskLayer;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self returnSubCellHeightAtIndexPath:indexPath];
}

- (CGFloat)returnSubCellHeightAtIndexPath:(NSIndexPath *)indexPath
{
    // 预付费：0否 1是
    if ([self.listInfo.prepayment isEqualToString:@"1"]) {
        BXTRecordListsInfo *lists = self.dataArray[indexPath.section];
        if ([lists.remaining_energy integerValue] != 0 && [lists.remaining_money integerValue] != 0) {
            return 305;
        }
        else if ([lists.remaining_energy integerValue] != 0) {
            return 280;
        }
        else if ([lists.remaining_money integerValue] != 0) {
            return 280;
        }
    }
    return 245;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
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
    view.unit = self.listInfo.unit;
    view.lists = self.dataArray[section];
    if ([self.isShowArray[section] isEqualToString:@"1"])
    {
        view.openImage.image = [UIImage imageNamed:@"energy_open"];
    }
    else
    {
        view.openImage.image = [UIImage imageNamed:@"energy_close"];
    }
    
    if ([self.isShowArray[section] isEqualToString:@"1"])
    {
        // headerView
        view.showView.layer.masksToBounds = YES;
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        CGRect rect = CGRectMake(0, 0, view.showView.frame.size.width, 80);
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){10.0f, 10.0f}].CGPath;
        view.showView.layer.mask = maskLayer;
    }
    else
    {
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
            if(index != NSNotFound)
            {
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
#pragma mark getDataResource
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
        
        NSInteger count = self.monthListInfo.lists.count;
        if (count > 0)
        {
            //通过最大kwh推算左侧坐标最大值
            NSInteger max = 0;
            for (NSInteger i = 0; i < count; i++)
            {
                BXTRecordMonthListsInfo *recordInfo = self.monthListInfo.lists[i];
                max = recordInfo.data.use_amount > max ? recordInfo.data.use_amount : max;
            }
            CGFloat fn = max/4.f;
            NSInteger inn = floor(fn);
            NSInteger i = 0;
            do {
                i++;
                inn = floor(inn/10.f);
            } while (inn > 10);
            inn++;
            do {
                inn *= 10;
                i--;
            } while (i > 0);
            inn *= 4;
            
            //创建统计
            [self initialHisView:inn];
        }
        [self refreshUIWithData];
    }
    else if (type == EnergyMeterRecordLists && data.count > 0)
    {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [BXTMeterReadingRecordListInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"meterReadingID":@"id"};
        }];
        [BXTRecordListsInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"listInfoID":@"id"};
        }];
        
        self.listInfo = [BXTMeterReadingRecordListInfo mj_objectWithKeyValues:data[0]];
        
        if (self.currentPage == 1 && self.isShowArray)
        {
            [self.isShowArray removeAllObjects];
            [self.dataArray removeAllObjects];
        }
        
        for (int i = 0; i < self.listInfo.lists.count; i++) {
            [self.isShowArray addObject:@"0"];
        }
        [self.dataArray addObjectsFromArray:self.listInfo.lists];
        
        if (self.isShowArray.count == 0) {
            self.noneLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 120) / 2, CGRectGetMaxY(self.filterView_list.frame) + 120, 120, 30)];
            self.noneLabel.text = @"本日没有数据";
            [self.scrollView addSubview:self.noneLabel];
        }
        else if (self.noneLabel) {
            [self.noneLabel removeFromSuperview];
        }
        
        [self.tableView reloadData];
    }
    else if (type == MeterFavoriteAdd && [dic[@"returncode"] integerValue] == 0)
    {
        [BXTGlobal showText:self.introInfo completionBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHTABLEVIEWOFLIST object:nil];
        }];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

#pragma mark -
#pragma mark 方法
- (NSString *)transTimeIsAdd:(BOOL)isAdd
{
    NSInteger year = [self.yearStr integerValue];
    if (!isAdd)
    {
        year -= 1;
    }
    else
    {
        year += 1;
    }
    self.yearStr = [NSString stringWithFormat:@"%ld", (long)year];
    
    return self.yearStr;
}

- (void)refreshUIWithData
{
    // 1. 收藏按钮
    __block BOOL is_collect = [self.monthListInfo.is_collect integerValue] == 1;
    @weakify(self);
    [[self.headerView.starView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        // 收藏按钮设置
        self.introInfo = is_collect ? @"取消收藏成功" : @"收藏成功";
        NSString *imageStr = is_collect ? @"energy_favourite_unstar" : @"energy_favourite_star";
        [self.headerView.starView setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        is_collect = !is_collect;
        
        [BXTGlobal showLoadingMBP:@"加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request energyMeterFavoriteAddWithAboutID:self.monthListInfo.meterReadingID delIDs:@""];
    }];
    
    // 2. self.headerView 赋值
    NSString *imageStr = [self.monthListInfo.is_collect isEqualToString:@"1"] ? @"energy_favourite_star" : @"energy_favourite_unstar";
    [self.headerView.starView setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    self.headerView.iconImageView.image = [self returnIconImageWithCheckPriceType:self.monthListInfo.check_price_type];
    self.headerView.titleView.text = [NSString stringWithFormat:@"%@", self.monthListInfo.meter_name];
    self.headerView.codeView.text = [NSString stringWithFormat:@"编号：%@", self.monthListInfo.code_number];
    self.headerView.rateView.text = [NSString stringWithFormat:@"倍率：%@", self.monthListInfo.rate];
    
    // 3. 显示footer值
    // 1> 能源节点
    UILabel *nodeLabel =  [self createLabelWithTitle:@"能源节点：" content:self.monthListInfo.measurement_path_name labelY:10];
    
    // 2> 安装位置
    UILabel *setPlaceLabel =  [self createLabelWithTitle:@"安装位置：" content:self.monthListInfo.place_name labelY:CGRectGetMaxY(nodeLabel.frame) + 5];
    self.maxLabelY = CGRectGetMaxY(setPlaceLabel.frame);
    
    // 3> 服务位置
    if (![BXTGlobal isBlankString:self.monthListInfo.server_area])
    {
        UILabel *servicePlaceLabel =  [self createLabelWithTitle:@"服务位置：" content:self.monthListInfo.server_area labelY:CGRectGetMaxY(setPlaceLabel.frame) + 5];
        self.maxLabelY = CGRectGetMaxY(servicePlaceLabel.frame);
        if (![BXTGlobal isBlankString:self.monthListInfo.desc])
        {
            // 4> 范围说明
            UILabel *rangeIntroLabel =  [self createLabelWithTitle:@"范围说明：" content:self.monthListInfo.desc labelY:CGRectGetMaxY(servicePlaceLabel.frame) + 5];
            self.maxLabelY = CGRectGetMaxY(rangeIntroLabel.frame);
        }
    }
    else
    {
        if (![BXTGlobal isBlankString:self.monthListInfo.desc])
        {
            // 4> 范围说明
            UILabel *rangeIntroLabel =  [self createLabelWithTitle:@"范围说明：" content:self.monthListInfo.desc labelY:CGRectGetMaxY(setPlaceLabel.frame) + 5];
            self.maxLabelY = CGRectGetMaxY(rangeIntroLabel.frame);
        }
    }
    
    // 4. check_type: 1-手动   2-自动(隐藏提交按钮)
    NSString *power = [BXTGlobal getUserProperty:U_POWER];
    if (([self.monthListInfo.check_type isEqualToString:@"1"] && ![power containsString:@"80604"]) ||
        [self.monthListInfo.check_type isEqualToString:@"2"])
    {
        [self.footerView removeFromSuperview];
        self.scrollView.frame = CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT);
        [self hideBgFooterView:YES];
    }
}

- (UILabel *)createLabelWithTitle:(NSString *)titleStr content:(NSString *)content labelY:(CGFloat)labelY
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, labelY, 75, 17)];
    titleLabel.text = titleStr;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.headerView.bgFooterView addSubview:titleLabel];
    
    CGSize contentSize = MB_MULTILINE_TEXTSIZE(content, [UIFont systemFontOfSize:14], CGSizeMake(HeaderViewW - 90, CGFLOAT_MAX), NSLineBreakByWordWrapping);
    UILabel *contentIntro = [[UILabel alloc] initWithFrame:CGRectMake(80, labelY, HeaderViewW - 90, contentSize.height)];
    contentIntro.text = content;
    contentIntro.textColor = colorWithHexString(@"666666");
    contentIntro.font = [UIFont systemFontOfSize:14];
    contentIntro.numberOfLines = 0;
    [self.headerView.bgFooterView addSubview:contentIntro];
    
    return contentIntro;
}

- (void)showChartView:(BOOL)showChart
{
    if (showChart)
    {
        self.filterView_chart.hidden = NO;
        self.hisView.hidden = NO;
        self.filterView_list.hidden = YES;
        self.tableView.hidden = YES;
    }
    else
    {
        self.filterView_chart.hidden = YES;
        self.hisView.hidden = YES;
        self.filterView_list.hidden = NO;
        self.tableView.hidden = NO;
    }
}

- (void)hideBgFooterView:(BOOL)isSelected
{
    self.headerView.titleView.numberOfLines = isSelected;
    self.headerView.codeView.numberOfLines = isSelected;
    
    if (isSelected)
    {
        self.headerView.bgViewBtn.selected = NO;
        self.headerView.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, 101);
        self.headerView.bgFooterView.hidden = YES;
        self.headerView.openImage.image = [UIImage imageNamed:@"energy_close"];
    }
    else
    {
        self.headerView.bgViewBtn.selected = YES;
        self.headerView.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, CGRectGetMaxY(self.headerView.rateView.frame) + 15 + self.maxLabelY + 10);
        self.headerView.bgFooterView.hidden = NO;
        self.headerView.openImage.image = [UIImage imageNamed:@"energy_open"];
        
        [self.headerView layoutIfNeeded];
        self.headerView.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, CGRectGetMaxY(self.headerView.rateView.frame) + 15 + self.maxLabelY + 10);
    }
    
    // filterView_chart
    self.filterView_chart.frame = CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20, 50);
    CGRect chartsFrame = self.hisView.frame;
    chartsFrame.origin.y = CGRectGetMaxY(self.filterView_chart.frame) + 10;
    self.hisView.frame = chartsFrame;
    
    // filterView_list
    self.filterView_list.frame = CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20, 50);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.filterView_chart.frame), SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - CGRectGetMaxY(self.filterView_list.frame) - 70);
    
    // check_type: 1-手动   2-自动(隐藏提交按钮)
    if ([self.monthListInfo.check_type isEqualToString:@"2"])
    {
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.filterView_chart.frame), SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - CGRectGetMaxY(self.filterView_list.frame));
    }
    
    if (!self.isHideChart)
    {
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.hisView.frame) + 10);
    }
}

@end
