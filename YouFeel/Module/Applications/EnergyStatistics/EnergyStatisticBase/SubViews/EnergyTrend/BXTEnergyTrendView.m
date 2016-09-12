//
//  BXTEnergyTrendView.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyTrendView.h"
#import "BXTEnergyTrendHeaderCell.h"
#import "BXTEnergyTrendLegendCell.h"
#import "BXTEnergyTrendCell.h"
#import "BXTEnergyTrendHiddenCell.h"
#import "BXTEnergyTrendBudgetCell.h"
#import "BXTEnergyTrendInfo.h"
#import "BXTHistogramStatisticsView.h"
#import "BXTEnergyReadingFilterInfo.h"

@interface BXTEnergyTrendView () <BXTDataResponseDelegate>

@property (nonatomic, strong) BXTHistogramStatisticsView *hisView;
@property (nonatomic, strong) NSMutableArray *energyArray;
@property (nonatomic, assign) NSInteger inn;
@property (nonatomic, assign) NSInteger maxNum;

/** ---- 选中的柱状图 ---- */
@property (nonatomic, assign) NSInteger selectedFirstIndex;
@property (nonatomic, assign) NSInteger selectedSecondIndex;

/** ---- 显示费用 ---- */
@property (nonatomic, assign) BOOL showCost;


/** ---- 选择 ---- */
@property (nonatomic, strong) UIView *selectBgView;
@property (nonatomic, strong) UITableView *selectTableView;
@property (nonatomic, strong) NSMutableArray *selectArray;

/** ---- 选中的按钮 ---- */
@property (nonatomic, assign) NSInteger selectedBtn;
/** ---- 存值 ---- */
@property (nonatomic, strong) NSMutableArray *allDataArray;
/** ---- 选中index数组 ---- */
@property (nonatomic, strong) NSMutableArray *selectedNumArray;

/** ---- 存储显示值 ---- */
@property (nonatomic, strong) NSMutableArray *showInfoArray;
/** ---- 存储显示值ID ---- */
@property (nonatomic, copy) NSString *showInfoID;
///** ---- 显示逻辑 ---- */
@property (nonatomic, copy) NSString *showInfoStr;

@end

@implementation BXTEnergyTrendView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame VCType:(ViewControllerType)vcType
{
    self = [super initWithFrame:frame VCType:vcType];
    
    [self getResource];
    
    
    // thisTimeBtn
    @weakify(self);
    [[self.filterView.thisTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [[self.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSLog(@"thisTimeBtn，%@", self.timeStr);
            [self getResource];
        }];
    }];
    
    // lastTimeBtn
    [[self.filterView.lastTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"lastTimeBtn，%@", self.timeStr);
        [self getResource];
    }];
    
    // nextTimeBtn
    [[self.filterView.nextTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"nextTimeBtn，%@", self.timeStr);
        [self getResource];
    }];
    
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ESSHOWCOST" object:nil] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        
        NSDictionary *dict = [notification userInfo];
        self.showCost = [dict[@"showCost"] integerValue] == 1;
        [self dealDataSourceIsShowCost:self.showCost];
        
        [self.tableView reloadData];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"BXTHistogramViewSelectIndex" object:nil] subscribeNext:^(NSNotification *notify) {
        @strongify(self);
        
        NSDictionary *dict = [notify userInfo];
        StatisticsType statisticsType = [dict[@"s_type"] integerValue];
        if (statisticsType == BudgetYearType || statisticsType == EnergyYearType) {
            self.selectedSecondIndex = [dict[@"index"] integerValue];
        }
        else if (statisticsType == BudgetMonthType || statisticsType == EnergyMonthType) {
            self.selectedFirstIndex = [dict[@"index"] integerValue];
        }
        
        [self.tableView reloadData];
    }];
    
    return self;
}

#pragma mark -
#pragma mark - getResource
- (void)getResource
{
    self.selectedBtn = 0;
    self.selectedFirstIndex = 0;
    self.selectedSecondIndex = 0;
    self.allDataArray = [[NSMutableArray alloc] init];
    self.selectedNumArray = [[NSMutableArray alloc] initWithObjects:@"-1", @"-1", @"-1", @"-1", @"-1", nil];
    self.showInfoStr = @"层级：电能";
    self.showInfoArray = [[NSMutableArray alloc] initWithObjects:self.showInfoStr, @"", @"", @"", @"", nil];
    self.showInfoID = @"1";
    
    // TODO: -----------------  月统计 - ViewControllerTypeOFYear -----------------
    // TODO: -----------------  年统计 - ViewControllerTypeOFNone -----------------
    [BXTGlobal showLoadingMBP:@"加载中..."];
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        if (self.vcType == ViewControllerTypeOFNone) {
            // 建筑能效概况 - 年统计
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request efficiencyTrendYearWithDate:@"" ppath:@""];
        }
        else {
            // 建筑能效概况 - 月统计
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request efficiencyTrendMonthWithDate:self.timeStr ppath:@""];
        }
    });
    dispatch_async(concurrentQueue, ^{
        /**筛选条件**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request energyMeasuremenLevelListsWithType:@"1"];
    });
}

- (void)getResourceOnlyList
{
    self.selectedFirstIndex = 0;
    self.selectedSecondIndex = 0;
    if (self.selectedBtn != 0)
    {
        [BXTGlobal showLoadingMBP:@"加载中..."];
    }
    if (self.vcType == ViewControllerTypeOFNone)
    {
        // 建筑能效概况 - 年统计
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request efficiencyTrendYearWithDate:@"" ppath:self.showInfoID];
    }
    else
    {
        // 建筑能效概况 - 月统计
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request efficiencyTrendMonthWithDate:self.timeStr ppath:self.showInfoID];
    }
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.selectTableView) {
        return 1;
    }
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.selectTableView) {
        return self.selectArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectTableView)
    {
        static NSString *cellID = @"cellSelect";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        
        if (self.selectedBtn == 0) {
            cell.textLabel.text = self.selectArray[indexPath.row];
        }
        else {
            BXTEnergyReadingFilterInfo *info = self.selectArray[indexPath.row];
            cell.textLabel.text = info.name;
        }
        
        return cell;
    }
    
    
    BXTEnergyTrendInfo *trendInfo;
    if (self.vcType == ViewControllerTypeOFNone) {
        trendInfo = self.energyArray[self.selectedSecondIndex];
    }
    else {
        trendInfo = self.energyArray[self.selectedFirstIndex];
    }
    
    if (indexPath.section == 0)
    {
        BXTEnergyTrendHeaderCell *cell = [BXTEnergyTrendHeaderCell cellWithTableView:tableView];
        
        if (self.hisView) {
            [self.hisView removeFromSuperview];
            self.hisView = nil;
        }
        
        if (self.vcType == ViewControllerTypeOFNone) {
            if (self.showCost) {
                self.hisView = [[BXTHistogramStatisticsView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20.f, 370) lists:self.energyArray kwhMeasure:self.inn kwhNumber:4 statisticsType:BudgetYearType];
            }
            else {
                self.hisView = [[BXTHistogramStatisticsView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20.f, 370) lists:self.energyArray kwhMeasure:self.inn kwhNumber:4 statisticsType:EnergyYearType];
            }
            cell.timeView.text = [NSString stringWithFormat:@"时间：%@年", trendInfo.year];
        }
        else {
            
            if (self.showCost) {
                self.hisView = [[BXTHistogramStatisticsView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20.f, 370) lists:self.energyArray kwhMeasure:self.inn kwhNumber:4 statisticsType:BudgetMonthType];
            }
            else {
                self.hisView = [[BXTHistogramStatisticsView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20.f, 370) lists:self.energyArray kwhMeasure:self.inn kwhNumber:4 statisticsType:EnergyMonthType];
            }
            cell.timeView.text = [NSString stringWithFormat:@"时间：%@年%@月", trendInfo.year, trendInfo.month];
        }
        
        self.hisView.backgroundColor = [UIColor whiteColor];
        self.hisView.layer.masksToBounds = YES;
        self.hisView.layer.cornerRadius = 10.f;
        self.hisView.footerView.hidden = YES;
        [cell.hisBgView addSubview:self.hisView];
        
        // 按钮点击事件
        @weakify(self);
        [[cell.energyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            self.selectedBtn = 0;
            self.selectArray = [[NSMutableArray alloc] initWithObjects:@"电能", @"水", @"燃气", @"热能", nil];
            [self createSelectTableView];
        }];
        [[cell.formatBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            self.selectedBtn = 1;
            [self reloadDataWithIndexOFSelectedRow:self.selectedBtn];
            [self createSelectTableView];
        }];
        [[cell.buildingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            self.selectedBtn = 2;
            [self reloadDataWithIndexOFSelectedRow:self.selectedBtn];
            [self createSelectTableView];
        }];
        [[cell.areaBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            self.selectedBtn = 3;
            [self reloadDataWithIndexOFSelectedRow:self.selectedBtn];
            [self createSelectTableView];
        }];
        [[cell.systemBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            self.selectedBtn = 4;
            [self reloadDataWithIndexOFSelectedRow:self.selectedBtn];
            if (self.selectArray.count == 0) {
                [BXTGlobal showText:@"租区无数据" view:self completionBlock:^{
                    return ;
                }];
            } else {
                [self createSelectTableView];
            }
        }];
        
        // 刷新按钮
        cell.buildingBtn.enabled = self.selectedBtn >= 1;
        cell.areaBtn.enabled = self.selectedBtn >= 2;
        cell.systemBtn.enabled = self.selectedBtn >= 3;
        if (self.selectedBtn == 1) {
            cell.formatBtn.backgroundColor = colorWithHexString(@"#5DAFF9");
            [cell.formatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else if (self.selectedBtn == 2) {
            cell.formatBtn.backgroundColor = colorWithHexString(@"#5DAFF9");
            [cell.formatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.buildingBtn.backgroundColor = colorWithHexString(@"#5DAFF9");
            [cell.buildingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else if (self.selectedBtn == 3) {
            cell.formatBtn.backgroundColor = colorWithHexString(@"#5DAFF9");
            [cell.formatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.buildingBtn.backgroundColor = colorWithHexString(@"#5DAFF9");
            [cell.buildingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.areaBtn.backgroundColor = colorWithHexString(@"#5DAFF9");
            [cell.areaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else if (self.selectedBtn == 4) {
            cell.formatBtn.backgroundColor = colorWithHexString(@"#5DAFF9");
            [cell.formatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.buildingBtn.backgroundColor = colorWithHexString(@"#5DAFF9");
            [cell.buildingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.areaBtn.backgroundColor = colorWithHexString(@"#5DAFF9");
            [cell.areaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.systemBtn.backgroundColor = colorWithHexString(@"#5DAFF9");
            [cell.systemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        cell.showLevelView.text = self.showInfoStr;
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        BXTEnergyTrendLegendCell *cell = [BXTEnergyTrendLegendCell cellWithTableView:tableView];
        cell.temperatureView.text = [NSString stringWithFormat:@"气温：%@℃", trendInfo.temperature];
        cell.humidityView.text = [NSString stringWithFormat:@"湿度：%.2f%%", [trendInfo.humidity floatValue]];
        if ([trendInfo.temperature isEqualToString:@"-"]) {
            cell.temperatureView.text = @"气温：-";
        }
        if ([trendInfo.humidity isEqualToString:@"-"]) {
            cell.humidityView.text = @"湿度：-";
        }
        
        return cell;
    }
    else if (indexPath.section == 2)
    {
        if (self.selectedBtn >= 3) {
            BXTEnergyTrendHiddenCell *cell = [BXTEnergyTrendHiddenCell cellWithTableView:tableView];
            
            if (self.vcType == ViewControllerTypeOFNone) {
                cell.similarView.hidden = YES;
                cell.similarImageView.hidden = YES;
                cell.similarNumView.hidden = YES;
            }
            
            if (self.showCost) {
                cell.moneyTrendInfo = trendInfo;
            } else {
                cell.energyTrendInfo = trendInfo;
            }
            
            if (self.selectedBtn == 3 && [self.showInfoArray[3] isEqualToString:@">公区"]) {
                if (self.vcType == ViewControllerTypeOFNone) {
                    cell.similarView.hidden = NO;
                    cell.similarView.text = @"仅公区显示以下值：";
                }
                cell.trueNumView.hidden = NO;
                cell.statisticErrorView.hidden = NO;
            } else {
                cell.trueNumView.hidden = YES;
                cell.statisticErrorView.hidden = YES;
            }
            
            return cell;
        }
        
        BXTEnergyTrendCell *cell = [BXTEnergyTrendCell cellWithTableView:tableView];
        
        if (self.selectedBtn == 3 && [self.showInfoArray[3] isEqualToString:@">公区"]) {
            cell.trueNumView.hidden = NO;
            cell.statisticErrorView.hidden = NO;
        } else {
            cell.trueNumView.hidden = YES;
            cell.statisticErrorView.hidden = YES;
        }
        
        if (self.vcType == ViewControllerTypeOFNone) {
            cell.similarView.hidden = YES;
            cell.similarImageView.hidden = YES;
            cell.similarNumView.hidden = YES;
        }
        
        if (self.showCost) {
            cell.moneyTrendInfo = trendInfo;
        } else {
            cell.energyTrendInfo = trendInfo;
        }
        
        return cell;
    }
    
    BXTEnergyTrendBudgetCell *cell = [BXTEnergyTrendBudgetCell cellWithTableView:tableView];
    
    if (self.showCost) {
        cell.moneyTrendInfo = trendInfo;
    } else {
        cell.energyTrendInfo = trendInfo;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectTableView) {
        return 50;
    }
    
    if (indexPath.section == 0) {
        return 485;
    }
    else if (indexPath.section == 1) {
        return 50;
    }
    else if (indexPath.section == 2) {
        if (self.selectedBtn == 3 && [self.showInfoArray[3] isEqualToString:@">公区"]) {
            if (self.selectedBtn >= 3) {
                if (self.vcType == ViewControllerTypeOFNone) {
                    return 145;
                }
                return 150;
            }
            
            if (self.vcType == ViewControllerTypeOFNone) {
                return 145;
            }
            return 175;
        }
        
        if (self.selectedBtn >= 3) {
            if (self.vcType == ViewControllerTypeOFNone) {
                return 65;
            }
            return 95;
        }
        
        if (self.vcType == ViewControllerTypeOFNone) {
            return 95;
        }
        return 125;
    }
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectTableView) {
        
        if (self.selectedBtn == 0) {
            NSString *showStr = [NSString stringWithFormat:@"层级：%@", self.selectArray[indexPath.row]];
            [self.showInfoArray replaceObjectAtIndex:0 withObject:showStr];
            self.showInfoID = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
            
            [BXTGlobal showLoadingMBP:@"加载中..."];
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request energyMeasuremenLevelListsWithType:[NSString stringWithFormat:@"%ld", (long)indexPath.row + 1]];
        }
        else {
            [self.selectedNumArray replaceObjectAtIndex:self.selectedBtn withObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
            
            BXTEnergyReadingFilterInfo *info = self.selectArray[indexPath.row];
            NSString *showStr = [NSString stringWithFormat:@">%@", info.name];
            [self.showInfoArray replaceObjectAtIndex:self.selectedBtn withObject:showStr];
            self.showInfoID = info.ppath;
        }
        
        [self removeSelectTableView];
        
        // 更新列表
        [self getResourceOnlyList];
        
        // 层级显示
        NSString *showStr = @"";
        for (int i = 0; i <= self.selectedBtn; i++) {
            showStr = [NSString stringWithFormat:@"%@%@", showStr, self.showInfoArray[i]];
        }
        self.showInfoStr = showStr;
        
        [self.tableView reloadData];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = dic[@"data"];
    if (type == EfficiencyTrendMonth)
    {
        self.energyArray = [[NSMutableArray alloc] init];
        [self.energyArray addObjectsFromArray:[BXTEnergyTrendInfo mj_objectArrayWithKeyValuesArray:data]];
        
        [self dealDataSourceIsShowCost:NO];
    }
    else if (type == EfficiencyTrendYear)
    {
        self.energyArray = [[NSMutableArray alloc] init];
        [self.energyArray addObjectsFromArray:[BXTEnergyTrendInfo mj_objectArrayWithKeyValuesArray:data]];
        
        [self dealDataSourceIsShowCost:NO];
    }
    else if (type == EnergyMeasuremenLevelLists)
    {
        NSMutableArray *listArray = [[NSMutableArray alloc] init];
        [BXTEnergyReadingFilterInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"filterID":@"id"};
        }];
        [listArray addObjectsFromArray:[BXTEnergyReadingFilterInfo mj_objectArrayWithKeyValuesArray:dic[@"data"]]];
        
        self.allDataArray = listArray;
    }
    
    [self.tableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

#pragma mark -
#pragma mark - other
- (void)reloadDataWithIndexOFSelectedRow:(NSInteger)selectedRow
{
    if (selectedRow == 4) {
        NSInteger index1 = [self.selectedNumArray[self.selectedBtn -3] integerValue];
        BXTEnergyReadingFilterInfo *firstList = self.allDataArray[index1];
        NSInteger index2 = [self.selectedNumArray[self.selectedBtn - 2] integerValue];
        BXTEnergyReadingFilterInfo *secondList = firstList.lists[index2];
        NSInteger index3 = [self.selectedNumArray[self.selectedBtn - 1] integerValue];
        BXTEnergyReadingFilterInfo *thirdList = secondList.lists[index3];
        
        NSMutableArray *forthArray = [[NSMutableArray alloc] init];
        for (BXTEnergyReadingFilterInfo *forthList in thirdList.lists) {
            [forthArray addObject:forthList];
        }
        self.selectArray = forthArray;
    }
    else if (selectedRow == 3) {
        NSInteger index1 = [self.selectedNumArray[self.selectedBtn - 2] integerValue];
        BXTEnergyReadingFilterInfo *firstList = self.allDataArray[index1];
        NSInteger index2 = [self.selectedNumArray[self.selectedBtn - 1] integerValue];
        BXTEnergyReadingFilterInfo *secondList = firstList.lists[index2];
        NSMutableArray *thirdArray = [[NSMutableArray alloc] init];
        for (BXTEnergyReadingFilterInfo *thirdList in secondList.lists) {
            [thirdArray addObject:thirdList];
        }
        self.selectArray = thirdArray;
    }
    else if (selectedRow == 2) {
        NSInteger index1 = [self.selectedNumArray[self.selectedBtn - 1] integerValue];
        BXTEnergyReadingFilterInfo *firstList = self.allDataArray[index1];
        NSMutableArray *secondArray = [[NSMutableArray alloc] init];
        for (BXTEnergyReadingFilterInfo *secondList in firstList.lists) {
            [secondArray addObject:secondList];
        }
        self.selectArray = secondArray;
    }
    else if (selectedRow == 1) {
        NSMutableArray *firstArray = [[NSMutableArray alloc] init];
        for (BXTEnergyReadingFilterInfo *firstList in self.allDataArray) {
            [firstArray addObject:firstList];
        }
        self.selectArray = firstArray;
    }
}

- (void)createSelectTableView
{
    self.selectBgView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    self.selectBgView.tag = 102;
    [self addSubview:self.selectBgView];
    
    // selectTableView
    CGFloat tableViewH = self.selectArray.count * 50 + 10;
    if (self.selectArray.count >= 6)
    {
        tableViewH = 6 * 50 + 10;
    }
    self.selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - tableViewH - 50, SCREEN_WIDTH, tableViewH) style:UITableViewStylePlain];
    self.selectTableView.delegate = self;
    self.selectTableView.dataSource = self;
    [self addSubview:self.selectTableView];
    
    // toolView
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 50, SCREEN_WIDTH, 50)];
    toolView.backgroundColor = colorWithHexString(@"#EEF3F6");
    [self.selectBgView addSubview:toolView];
    
    // sure
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [sureBtn setTitle:@"取消" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    [[sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.selectedBtn -= 1;
        [self removeSelectTableView];
    }];
    sureBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    sureBtn.layer.borderWidth = 0.5;
    [toolView addSubview:sureBtn];
}

- (void)removeSelectTableView
{
    [self.selectTableView removeFromSuperview];
    self.selectTableView = nil;
    [self.selectBgView removeFromSuperview];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 102)
    {
        if (_selectTableView)
        {
            self.selectedBtn -= 1;
            [self.selectTableView removeFromSuperview];
            self.selectTableView = nil;
        }
        [view removeFromSuperview];
    }
}

- (void)dealDataSourceIsShowCost:(BOOL)showCost
{
    NSInteger count = self.energyArray.count;
    if (count > 0)
    {
        //通过最大kwh推算左侧坐标最大值
        NSInteger max = 0;
        for (NSInteger i = 0; i < count; i++)
        {
            BXTEnergyTrendInfo *recordInfo = self.energyArray[i];
            if (showCost) {
                max = recordInfo.money > max ? recordInfo.money : max;
                max = recordInfo.money_budget > max ? recordInfo.money_budget : max;
            } else {
                max = recordInfo.energy_consumption > max ? recordInfo.energy_consumption : max;
                max = recordInfo.energy_consumption_budget > max ? recordInfo.energy_consumption_budget : max;
            }
        }
        CGFloat fn = max/4.f;
        self.inn = floor(fn);
        NSInteger i = 0;
        do {
            i++;
            self.inn = floor(self.inn/10.f);
        } while (self.inn > 10);
        self.inn++;
        do {
            self.inn *= 10;
            i--;
        } while (i > 0);
        self.inn *= 4;
    }
}

@end
