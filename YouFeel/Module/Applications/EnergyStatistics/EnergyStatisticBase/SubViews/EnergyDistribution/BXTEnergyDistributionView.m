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

@interface BXTEnergyDistributionView () <BXTDataResponseDelegate>

@property (nonatomic, strong) BXTEnergyDistributionInfo *edInfo;

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
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ESSHOWCOST" object:nil] subscribeNext:^(NSNotification *notification) {
        NSDictionary *dict = [notification userInfo];
        
        self.showCost = [dict[@"showCost"] integerValue] == 1;
        
        [self.tableView reloadData];
    }];
    
    return self;
}

- (void)getResource
{
    if (self.vcType == ViewControllerTypeOFMonth) {
        // 建筑能效概况 - 月统计
        [BXTGlobal showLoadingMBP:@"数据加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request efficiencyDistributionMonthWithDate:@"" ppath:@""];
    }
    else {
        // 建筑能效概况 - 年统计
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request efficiencyDistributionYearWithDate:@"" ppath:@""];
    }
}

#pragma mark -
#pragma mark - tableView代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTEnergySurveyViewCell *cell = [BXTEnergySurveyViewCell cellWithTableView:tableView];
    
    if (self.showCost) {
        cell.moneyListInfo = self.edInfo.lists[indexPath.section];
    }
    else {
        cell.energyListInfo = self.edInfo.lists[indexPath.section];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 250;
    }
    return 100;
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
    if (type == EfficiencyDistributionMonth)
    {
        [BXTEYDTListsInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"energyID":@"id"};
        }];
        self.edInfo = [BXTEnergyDistributionInfo mj_objectWithKeyValues:dic[@"data"]];
        
        self.dataArray = [[NSMutableArray alloc] initWithArray:self.edInfo.lists];
    }
    else if (type == EfficiencyDistributionYear)
    {
        [BXTEYDTListsInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"energyID":@"id"};
        }];
        self.edInfo = [BXTEnergyDistributionInfo mj_objectWithKeyValues:dic[@"data"]];
    }
    
    [self.tableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

@end
