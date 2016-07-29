//
//  BXTEnergyTrendView.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyTrendView.h"
#import "BXTEnergyTrendLegendCell.h"
#import "BXTEnergyTrendCell.h"
#import "BXTEnergyTrendBudgetCell.h"

@interface BXTEnergyTrendView () <BXTDataResponseDelegate>

@end

@implementation BXTEnergyTrendView

- (instancetype)initWithFrame:(CGRect)frame VCType:(ViewControllerType)vcType
{
    self = [super initWithFrame:frame VCType:vcType];
    
    [self getResource];
    
    return self;
}

- (void)getResource
{
//    if (self.vcType == ViewControllerTypeOFMonth) {
//        // 建筑能效概况 - 月统计
//        [BXTGlobal showLoadingMBP:@"数据加载中..."];
//        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
//        [request efficiencySurveyMonthWithDate:@""];
//    }
//    else {
//        // 建筑能效概况 - 年统计
//        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
//        [request efficiencySurveyYearWithDate:@""];
//    }
    
}

#pragma mark -
#pragma mark - tableView代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BXTEnergyTrendCell *cell = [BXTEnergyTrendCell cellWithTableView:tableView];
        
        
        return cell;
    }
    else if (indexPath.section == 1) {
        BXTEnergyTrendLegendCell *cell = [BXTEnergyTrendLegendCell cellWithTableView:tableView];
        
        
        return cell;
    }
    else if (indexPath.section == 2) {
        BXTEnergyTrendCell *cell = [BXTEnergyTrendCell cellWithTableView:tableView];
        
        
        return cell;
    }
    
    BXTEnergyTrendBudgetCell *cell = [BXTEnergyTrendBudgetCell cellWithTableView:tableView];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 250;
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
    
//    NSDictionary *dic = (NSDictionary *)response;
//    if (type == EfficiencySurveyMonth)
//    {
//        self.esInfo = [BXTEnergySurveyInfo mj_objectWithKeyValues:dic[@"data"]];
//    }
//    else if (type == EfficiencySurveyYear)
//    {
//        self.esInfo = [BXTEnergySurveyInfo mj_objectWithKeyValues:dic[@"data"]];
//    }
//    
    [self.tableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

@end
