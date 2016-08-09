//
//  BXTEnergyDistributionView.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyDistributionView.h"
#import "BXTEnergyDistributionInfo.h"
#import "BXTEnergySurveyViewCell.h"
#import "BXTEnergyDistributionViewChartCell.h"
#import "BXTEnergyReadingFilterInfo.h"

@interface BXTEnergyDistributionView () <BXTDataResponseDelegate>

@property (nonatomic, strong) BXTEnergyDistributionInfo *edInfo;

@property (nonatomic, strong) NSMutableArray *chartDataArray;
@property (nonatomic, strong) NSArray *colorArray;

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

@implementation BXTEnergyDistributionView

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
        [self.tableView reloadData];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"SelectYearMonthString" object:nil] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        
        NSDictionary *dict = [notification userInfo];
        if (self.vcType != ViewControllerTypeOFYear) {
            self.timeStr = dict[@"time"];
            [self getResource];
        }
    }];
    
    return self;
}

#pragma mark -
#pragma mark - getResource
- (void)getResource
{
    self.selectedBtn = 0;
    self.allDataArray = [[NSMutableArray alloc] init];
    self.selectedNumArray = [[NSMutableArray alloc] initWithObjects:@"-1", @"-1", @"-1", @"-1", @"-1", nil];
    self.showInfoStr = @"层级：电能";
    self.showInfoArray = [[NSMutableArray alloc] initWithObjects:self.showInfoStr, @"", @"", @"", @"", nil];
    self.showInfoID = @"1";
    
    
    [BXTGlobal showLoadingMBP:@"数据加载中..."];
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        if (self.vcType == ViewControllerTypeOFYear) {
            // 建筑能效概况 - 年统计
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request efficiencyDistributionYearWithDate:self.timeStr ppath:@""];
        }
        else {
            NSString *year = [self.timeStr substringToIndex:4];
            NSString *month = [self.timeStr substringWithRange:NSMakeRange(5, self.timeStr.length - 6)];
            NSString *nowTime = [NSString stringWithFormat:@"%@-%02ld", year, (long)[month integerValue]];
            
            // 建筑能效概况 - 月统计
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request efficiencyDistributionMonthWithDate:nowTime ppath:@""];
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
    if (self.selectedBtn != 0) {
        [BXTGlobal showLoadingMBP:@"数据加载中..."];
    }
    if (self.vcType == ViewControllerTypeOFYear) {
        // 建筑能效概况 - 年统计
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request efficiencyDistributionYearWithDate:self.timeStr ppath:self.showInfoID];
    }
    else {
        NSString *year = [self.timeStr substringToIndex:4];
        NSString *month = [self.timeStr substringWithRange:NSMakeRange(5, self.timeStr.length - 6)];
        NSString *nowTime = [NSString stringWithFormat:@"%@-%02ld", year, (long)[month integerValue]];
        
        // 建筑能效概况 - 月统计
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request efficiencyDistributionMonthWithDate:nowTime ppath:self.showInfoID];
    }
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.selectTableView) {
        return 1;
    }
    return self.edInfo.lists.count + 1;
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
    
    
    if (indexPath.section == 0) {
        BXTEnergyDistributionViewChartCell *cell = [BXTEnergyDistributionViewChartCell cellWithTableView:tableView];
        
        if (self.vcType == ViewControllerTypeOFYear) {
            cell.similarView.hidden = YES;
            cell.similarImageView.hidden = YES;
            cell.similarNumView.hidden = YES;
        }
        
        [self reloadChartDataWithCell:cell];
        if (self.edInfo.lists.count != 0) {
            cell.unit = self.edInfo.unit;
            if (self.showCost) {
                cell.moneyListInfo = self.edInfo.total;
            }
            else {
                cell.energyListInfo = self.edInfo.total;
            }
        }
        
        if (self.selectedBtn == 3 && [self.showInfoArray[3] isEqualToString:@">公区"]) {
            if (self.vcType == ViewControllerTypeOFYear) {
                cell.similarView.hidden = NO;
                cell.similarView.text = @"仅公区显示以下值：";
            }
            cell.trueNumView.hidden = NO;
            cell.statisticErrorView.hidden = NO;
        }
        
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
        
        
        // 刷新按钮
        cell.buildingBtn.enabled = self.selectedBtn >= 1;
        cell.areaBtn.enabled = self.selectedBtn >= 2;
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
        }
        
        cell.showLevelView.text = self.showInfoStr;
        
        return cell;
    }
    
    
    BXTEnergySurveyViewCell *cell = [BXTEnergySurveyViewCell cellWithTableView:tableView];
    
    if (self.vcType == ViewControllerTypeOFYear) {
        cell.similarView.hidden = YES;
        cell.similarImageView.hidden = YES;
        cell.similarNumView.hidden = YES;
    }
    
    UIColor *elemColor = [BXTGlobal randomColor];
    if (indexPath.section - 1 < 15) {
        elemColor = colorWithHexString(self.colorArray[indexPath.section - 1]);
    }
    cell.roundView.backgroundColor = elemColor;
    
    cell.unit = self.edInfo.unit;
    if (self.showCost) {
        cell.moneyListInfo = self.edInfo.lists[indexPath.section-1];
    }
    else {
        cell.energyListInfo = self.edInfo.lists[indexPath.section-1];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectTableView) {
        return 50;
    }
    
    if (self.vcType == ViewControllerTypeOFYear) {
        if (indexPath.section == 0) {
            if (self.selectedBtn == 3 && [self.showInfoArray[3] isEqualToString:@">公区"]) {
                return 450;
            }
            return 370;
        }
        return 70;
    }
    
    if (indexPath.section == 0) {
        if (self.selectedBtn == 3 && [self.showInfoArray[3] isEqualToString:@">公区"]) {
            return 450;
        }
        return 400;
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectTableView) {
        
        if (self.selectedBtn == 0) {
            NSString *showStr = [NSString stringWithFormat:@"层级：%@", self.selectArray[indexPath.row]];
            [self.showInfoArray replaceObjectAtIndex:0 withObject:showStr];
            self.showInfoID = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
            
            [BXTGlobal showLoadingMBP:@"数据加载中..."];
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
    if (type == EfficiencyDistributionMonth)
    {
        [BXTEYDTListsInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"energyID":@"id"};
        }];
        self.edInfo = [BXTEnergyDistributionInfo mj_objectWithKeyValues:dic[@"data"]];
        
        self.chartDataArray = [[NSMutableArray alloc] init];
        for (BXTEYDTListsInfo *list in self.edInfo.lists) {
            [self.chartDataArray addObject:[NSString stringWithFormat:@"%.2f", list.energy_consumption_per]];
        }
    }
    else if (type == EfficiencyDistributionYear)
    {
        [BXTEYDTListsInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"energyID":@"id"};
        }];
        self.edInfo = [BXTEnergyDistributionInfo mj_objectWithKeyValues:dic[@"data"]];
        
        self.chartDataArray = [[NSMutableArray alloc] init];
        for (BXTEYDTListsInfo *list in self.edInfo.lists) {
            [self.chartDataArray addObject:[NSString stringWithFormat:@"%.2f", list.energy_consumption_per]];
        }
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
#pragma mark - Other
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

- (void)reloadChartDataWithCell:(BXTEnergyDistributionViewChartCell *)cell
{
    //  ---------- 饼状图 ----------
    // 1. create pieView
    cell.pieView.layer.minRadius = 45;
    
    // 2. fill data
    self.colorArray = [[NSArray alloc] initWithObjects:@"#f484a8", @"#7a9cef", @"#f8a049", @"#f86b3d", @"#9171f3", @"#f9bd34", @"#d251d8", @"#49e3ea", @"#d8505c", @"#f25a8b", @"#45a74f", @"#52b7ce", @"#fd6468", @"#48d2be", @"#5b91d3", nil];
    NSMutableArray *oldDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *pieArray = [[NSMutableArray alloc] init];
    NSInteger sumNum = 0;
    for(int i=0; i<self.chartDataArray.count; i++)
    {
        UIColor *elemColor = [BXTGlobal randomColor];
        if (i<15)
        {
            elemColor = colorWithHexString(self.colorArray[i]);
        }
        MYPieElement *elem = [MYPieElement pieElementWithValue:[self.chartDataArray[i] floatValue] color:elemColor];
        elem.title = [NSString stringWithFormat:@"%@%%", self.chartDataArray[i]];
        if ([self.chartDataArray[i] isEqualToString:@"0%"]) {
            elem.title = @"";
        }
        [cell.pieView.layer addValues:@[elem] animated:NO];
        
        [oldDataArray addObject:elem];
        [pieArray addObject:self.chartDataArray[i]];
        
        sumNum += [self.chartDataArray[i] integerValue];
    }
    
    BOOL isAllZero = YES;
    for (NSString *elem in pieArray) {
        if ([elem intValue] != 0) {
            isAllZero = NO;
            break;
        }
    }
    // 无参数处理
    if (isAllZero)
    {
        [cell.pieView.layer deleteValues:oldDataArray animated:YES];
        MYPieElement *elem = [MYPieElement pieElementWithValue:1 color:colorWithHexString(self.colorArray[0])];
        elem.title = @"";
        [cell.pieView.layer addValues:@[elem] animated:NO];
    }
    
    // 3. transform tilte
    cell.pieView.layer.transformTitleBlock = ^(PieElement *elem, float percent){
        //NSLog(@"percent -- %f", percent);
        return [(MYPieElement *)elem title];
    };
    cell.pieView.layer.showTitles = ShowTitlesAlways;
    
    
    if (self.showCost) {
        cell.sumShowView.text = [NSString stringWithFormat:@"总金额\r%ld元", (long)self.edInfo.total.money];
    }
    else {
        cell.sumShowView.text = [NSString stringWithFormat:@"总能耗\r%ldKwh", (long)self.edInfo.total.energy_consumption];
    }
    
    
    // 4. didClick
    //    __weak typeof(self) weakSelf = self;
    //    cell.pieView.transSelected = ^(NSInteger index) {
    //        NSLog(@"index -- %ld", index);
    //
    //    };
    
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

@end
