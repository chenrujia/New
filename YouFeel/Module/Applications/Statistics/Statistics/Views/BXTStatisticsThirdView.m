//
//  BXTStatisticsThirdView.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/22.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTStatisticsThirdView.h"
#import "BXTEPAvailabilityViewController.h"
#import "BXTMTPlanHeaderView.h"
#import "BXTMTStatisticsCell.h"

@implementation BXTStatisticsThirdView

#pragma mark -
#pragma mark - 初始化
- (void)initial
{
    [super initial];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"设备完好率统计", @"设备运行计划统计", @"预防性维保情况统计", nil];
    self.detailArray = [[NSMutableArray alloc] initWithObjects:@"实时设备运行情况", @"开发中，敬请期待", @"开发中，敬请期待", nil];
    
    BXTMTPlanHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"BXTMTPlanHeaderView" owner:nil options:nil] lastObject];
    self.tableView.tableHeaderView = headerView;
}

#pragma mark -
#pragma mark - tableView代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    BXTMTStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTMTStatisticsCell" owner:nil options:nil] lastObject];
    }
    
    cell.titleView.text = self.dataArray[indexPath.section];
    cell.detailView.text = self.detailArray[indexPath.section];
    
    [cell.pieChartView clearChart];
    [cell.pieChartView addDataToRepresent:60 WithColor:colorWithHexString(@"#0FCCC0")];
    [cell.pieChartView addDataToRepresent:30 WithColor:colorWithHexString(@"#0C88CC")];
    [cell.pieChartView addDataToRepresent:10 WithColor:colorWithHexString(@"#FD7070")];
    [cell.pieChartView addDataToRepresent:20 WithColor:colorWithHexString(@"#DEE7E8")];
    cell.pieChartView.userInteractionEnabled = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTEPAvailabilityViewController *abvc = [[BXTEPAvailabilityViewController alloc] init];
    
    switch (indexPath.section) {
        case 0: [[self navigation] pushViewController:abvc animated:YES]; break;
        case 1:  break;
        case 2:  break;
        default: break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
