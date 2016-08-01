//
//  BXTEnergySurveyView.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergySurveyView.h"
#import "BXTEnergySurveyViewCell.h"
#import "BXTEnergySurveyViewChartCell.h"

@interface BXTEnergySurveyView () <BXTDataResponseDelegate>

@property (nonatomic, strong) BXTEnergySurveyInfo *esInfo;

@property (nonatomic, strong) NSMutableArray *chartDataArray;

@end

@implementation BXTEnergySurveyView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame VCType:(ViewControllerType)vcType
{
    self = [super initWithFrame:frame VCType:vcType];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2" , @"3", @"4", @"5", nil];
    
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
        [request efficiencySurveyYearWithDate:self.timeStr];
    }
    else {
        NSString *year = [self.timeStr substringToIndex:4];
        NSString *month = [self.timeStr substringWithRange:NSMakeRange(5, self.timeStr.length - 6)];
        NSString *nowTime = [NSString stringWithFormat:@"%@-%02ld", year, (long)[month integerValue]];
        
        // 建筑能效概况 - 月统计
        [BXTGlobal showLoadingMBP:@"数据加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request efficiencySurveyMonthWithDate:nowTime];
    }
    
}

#pragma mark -
#pragma mark - tableView代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BXTEnergySurveyViewChartCell *cell = [BXTEnergySurveyViewChartCell cellWithTableView:tableView];
        
        if (self.vcType == ViewControllerTypeOFYear) {
            cell.similarView.hidden = YES;
            cell.similarImageView.hidden = YES;
            cell.similarNumView.hidden = YES;
        }
        
        cell.totalInfo = self.esInfo.total;
        
        [self reloadChartDataWithCell:cell];
        
        return cell;
    }
    
    BXTEnergySurveyViewCell *cell = [BXTEnergySurveyViewCell cellWithTableView:tableView];
    
    if (self.vcType == ViewControllerTypeOFYear) {
        cell.similarView.hidden = YES;
        cell.similarImageView.hidden = YES;
        cell.similarNumView.hidden = YES;
    }
    
    switch (indexPath.section) {
        case 1: cell.eleInfo = self.esInfo.ele; break;
        case 2: cell.watInfo = self.esInfo.wat; break;
        case 3: cell.theInfo = self.esInfo.the; break;
        case 4: cell.gasInfo = self.esInfo.gas; break;
        default: break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.vcType == ViewControllerTypeOFYear) {
        if (indexPath.section == 0) {
            return 303;
        }
        return 70;
    }
    
    if (indexPath.section == 0) {
        return 330;
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)reloadChartDataWithCell:(BXTEnergySurveyViewChartCell *)cell
{
    //  ---------- 饼状图 ----------
    // 1. create pieView
    cell.pieView.layer.minRadius = 0;
    
    // 2. fill data
    NSArray *colorArray = [[NSArray alloc] initWithObjects:@"#E99390", @"#6DA9E8", @"#FBF56B", @"#F2B56F", nil];
    NSMutableArray *oldDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *pieArray = [[NSMutableArray alloc] init];
    NSInteger sumNum = 0;
    for(int i=0; i<self.chartDataArray.count; i++)
    {
        MYPieElement *elem = [MYPieElement pieElementWithValue:[self.chartDataArray[i] floatValue] color:colorWithHexString(colorArray[i])];
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
        MYPieElement *elem = [MYPieElement pieElementWithValue:1 color:colorWithHexString(colorArray[0])];
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
    if (type == EfficiencySurveyMonth)
    {
        self.esInfo = [BXTEnergySurveyInfo mj_objectWithKeyValues:dic[@"data"]];
        
        self.chartDataArray = [[NSMutableArray alloc] initWithObjects:
                               [NSString stringWithFormat:@"%.2f", self.esInfo.ele.per],
                               [NSString stringWithFormat:@"%.2f", self.esInfo.wat.per],
                               [NSString stringWithFormat:@"%.2f", self.esInfo.the.per],
                               [NSString stringWithFormat:@"%.2f", self.esInfo.gas.per], nil];
        
    }
    else if (type == EfficiencySurveyYear)
    {
        if ([dic[@"returncode"] isEqualToString:@"002"]) {
            [MYAlertAction showAlertWithTitle:@"暂无选定时间的统计数据" msg:nil chooseBlock:^(NSInteger buttonIdx) {
                [self initializeTime];
            } buttonsStatement:@"确定", nil];
            return;
        }
        self.esInfo = [BXTEnergySurveyInfo mj_objectWithKeyValues:dic[@"data"]];
        
        self.chartDataArray = [[NSMutableArray alloc] initWithObjects:
                               [NSString stringWithFormat:@"%.2f", self.esInfo.ele.per],
                               [NSString stringWithFormat:@"%.2f", self.esInfo.wat.per],
                               [NSString stringWithFormat:@"%.2f", self.esInfo.the.per],
                               [NSString stringWithFormat:@"%.2f", self.esInfo.gas.per], nil];
        
    }
    
    [self.tableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

@end
