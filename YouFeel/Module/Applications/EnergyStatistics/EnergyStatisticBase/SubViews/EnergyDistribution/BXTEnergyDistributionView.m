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

@interface BXTEnergyDistributionView () <BXTDataResponseDelegate>

@property (nonatomic, strong) BXTEnergyDistributionInfo *edInfo;

@property (nonatomic, strong) NSMutableArray *chartDataArray;
@property (nonatomic, strong) NSArray *colorArray;

/** ---- 显示费用 ---- */
@property (nonatomic, assign) BOOL showCost;

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
        [BXTGlobal showLoadingMBP:@"数据加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request efficiencyDistributionMonthWithDate:nowTime ppath:@""];
        
    }
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.edInfo.lists.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BXTEnergyDistributionViewChartCell *cell = [BXTEnergyDistributionViewChartCell cellWithTableView:tableView];
        
        if (self.vcType == ViewControllerTypeOFYear) {
            cell.similarView.hidden = YES;
            cell.similarImageView.hidden = YES;
            cell.similarNumView.hidden = YES;
        }
        
        [self reloadChartDataWithCell:cell];
        cell.unit = self.edInfo.unit;
        if (self.showCost) {
            cell.moneyListInfo = self.edInfo.total;
        }
        else {
            cell.energyListInfo = self.edInfo.total;
        }
        
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
    if (self.vcType == ViewControllerTypeOFYear) {
        if (indexPath.section == 0) {
            return 370;
        }
        return 70;
    }
    
    if (indexPath.section == 0) {
        return 400;
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)reloadChartDataWithCell:(BXTEnergyDistributionViewChartCell *)cell
{
    //  ---------- 饼状图 ----------
    // 1. create pieView
    cell.pieView.layer.minRadius = 0;
    
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
    
    // 4. didClick
    //    __weak typeof(self) weakSelf = self;
    //    cell.pieView.transSelected = ^(NSInteger index) {
    //        NSLog(@"index -- %ld", index);
    //
    //    };
    
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
    
    [self.tableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

@end
