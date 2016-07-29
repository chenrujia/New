//
//  BXTEnergySurveyView.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergySurveyView.h"
#import "BXTEnergySurveyViewCell.h"

@interface BXTEnergySurveyView () <BXTDataResponseDelegate>

@property (nonatomic, strong) BXTEnergySurveyInfo *esInfo;

@end

@implementation BXTEnergySurveyView

- (instancetype)initWithFrame:(CGRect)frame VCType:(ViewControllerType)vcType
{
    self = [super initWithFrame:frame VCType:vcType];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2" , @"3", @"4", @"5", nil];
    
    [self getResource];
    
    return self;
}

- (void)getResource
{
    if (self.vcType == ViewControllerTypeOFMonth) {
        // 建筑能效概况 - 月统计
        [BXTGlobal showLoadingMBP:@"数据加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request efficiencySurveyMonthWithDate:@""];
    }
    else {
        // 建筑能效概况 - 年统计
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request efficiencySurveyYearWithDate:@""];
    }
    
}

#pragma mark -
#pragma mark - tableView代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTEnergySurveyViewCell *cell = [BXTEnergySurveyViewCell cellWithTableView:tableView];
    
    
    switch (indexPath.section) {
        case 0:  break;
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
    if (type == EfficiencySurveyMonth)
    {
        self.esInfo = [BXTEnergySurveyInfo mj_objectWithKeyValues:dic[@"data"]];
    }
    else if (type == EfficiencySurveyYear)
    {
        self.esInfo = [BXTEnergySurveyInfo mj_objectWithKeyValues:dic[@"data"]];
    }
    
    [self.tableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

@end
