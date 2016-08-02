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
#import "BXTEnergyTrendBudgetCell.h"
#import "BXTEnergyTrendInfo.h"
#import "BXTHistogramStatisticsView.h"

@interface BXTEnergyTrendView () <BXTDataResponseDelegate>

@property (nonatomic, strong) BXTHistogramStatisticsView *hisView;
@property (nonatomic, strong) NSMutableArray *energyArray;
@property (nonatomic, assign) NSInteger inn;

@end

@implementation BXTEnergyTrendView

- (instancetype)initWithFrame:(CGRect)frame VCType:(ViewControllerType)vcType
{
    self = [super initWithFrame:frame VCType:vcType];
    
    [self getResource];
    
    return self;
}

#pragma mark -
#pragma mark - getResource
- (void)getResource
{
    // TODO: -----------------  月统计 - ViewControllerTypeOFYear -----------------
    // TODO: -----------------  年统计 - ViewControllerTypeOFNone -----------------
    if (self.vcType == ViewControllerTypeOFNone) {
        // 建筑能效概况 - 年统计
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request efficiencyTrendYearWithDate:@"" ppath:@""];
    }
    else
    {
        // 建筑能效概况 - 月统计
        [BXTGlobal showLoadingMBP:@"数据加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request efficiencyTrendMonthWithDate:@"" ppath:@""];
    }
}

#pragma mark -
#pragma mark - tableView代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        BXTEnergyTrendHeaderCell *cell = [BXTEnergyTrendHeaderCell cellWithTableView:tableView];
//        cell.hisView = [[BXTHistogramStatisticsView alloc] initWithFrame:CGRectMake(10, + 10, SCREEN_WIDTH - 20.f, 470.f) lists:self.energyArray kwhMeasure:20000 kwhNumber:6 statisticsType:BudgetType];
//        cell.hisView.backgroundColor = [UIColor whiteColor];
//        cell.hisView.layer.masksToBounds = YES;
//        cell.hisView.layer.cornerRadius = 10.f;

        return cell;
    }
    else if (indexPath.section == 1)
    {
        BXTEnergyTrendLegendCell *cell = [BXTEnergyTrendLegendCell cellWithTableView:tableView];
        
        return cell;
    }
    else if (indexPath.section == 2)
    {
        BXTEnergyTrendCell *cell = [BXTEnergyTrendCell cellWithTableView:tableView];
        
        return cell;
    }
    
    BXTEnergyTrendBudgetCell *cell = [BXTEnergyTrendBudgetCell cellWithTableView:tableView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 500;
    } else if (indexPath.section == 1) {
        return 50;
    } else if (indexPath.section == 2) {
        return 125;
    }
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        
        NSLog(@"self.energyArray ---- %@", self.energyArray);
        
    }
    else if (type == EfficiencyTrendYear)
    {
        //        self.esInfo = [BXTEnergySurveyInfo mj_objectWithKeyValues:dic[@"data"]];
    }
    
    [self.tableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

@end
