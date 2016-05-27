//
//  BXTStatisticsThirdView.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/22.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTStatisticsThirdView.h"
#import "BXTEPAvailabilityViewController.h"
#import "BXTEPHeaderView.h"
#import "BXTMTStatisticsCell.h"
#import "UIView+Nav.h"

@implementation BXTStatisticsThirdView

#pragma mark -
#pragma mark - 初始化
- (void)initial
{
    [super initial];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"设备完好率统计", @"设备运行计划统计", @"预防性维保统计", nil];
    self.detailArray = [[NSMutableArray alloc] initWithObjects:@"实时设备运行情况", @"开发中，敬请期待", @"开发中，敬请期待", nil];
    
    BXTEPHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"BXTEPHeaderView" owner:nil options:nil] lastObject];
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

    
    if (indexPath.section == 0) {
        NSArray *transArray = ValueFUD(@"thirdViewEPStateArray");
        NSDictionary *dataDict = transArray[0];
        
        
        
        [cell.pieChartView clearChart];
        [cell.pieChartView addDataToRepresent:[dataDict[@"working_per"] doubleValue] WithColor:colorWithHexString(@"#34B47E")];
        [cell.pieChartView addDataToRepresent:[dataDict[@"fault_per"] doubleValue] WithColor:colorWithHexString(@"#EA3622")];
        [cell.pieChartView addDataToRepresent:[dataDict[@"stop_per"] doubleValue] WithColor:colorWithHexString(@"#D6AD5B")];
        
        if ([dataDict[@"working_per"] doubleValue] == 0 && [dataDict[@"fault_per"] doubleValue] == 0 && [dataDict[@"stop_per"] doubleValue] == 0) {
            [cell.pieChartView addDataToRepresent:1 WithColor:colorWithHexString(@"#DEE7E8")];
        }
        
        cell.pieChartView.userInteractionEnabled = NO;
        
        cell.persentView.text = [NSString stringWithFormat:@"运行:%.2f%%", [dataDict[@"working_per"] doubleValue]];
    }
    else {
        [cell.pieChartView addDataToRepresent:1 WithColor:colorWithHexString(@"#DEE7E8")];
    }
    
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
