//
//  BXTStatisticsSecondView.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/22.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTStatisticsSecondView.h"
#import "BXTMTCompletionViewController.h"
#import "BXTMTProfessionViewController.h"
#import "BXTMTSystemViewController.h"
#import "BXTMTPlanHeaderView.h"
#import "BXTMTStatisticsCell.h"

@implementation BXTStatisticsSecondView

#pragma mark -
#pragma mark - 初始化
- (void)initial
{
    [super initial];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"维保完成率统计", @"维保分专业统计", @"维保分统计", nil];
    self.detailArray = [[NSMutableArray alloc] initWithObjects:@"项目总体完成情况", @"专业分组完成情况", @"各系统完成情况", nil];
    
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
    BXTMTCompletionViewController *clvc = [[BXTMTCompletionViewController alloc] init];
    BXTMTProfessionViewController *pfvc = [[BXTMTProfessionViewController alloc] init];
    BXTMTSystemViewController *stvc = [[BXTMTSystemViewController alloc] init];
    
    switch (indexPath.section) {
        case 0: [[self getNavigation] pushViewController:clvc animated:YES]; break;
        case 1: [[self getNavigation] pushViewController:pfvc animated:YES]; break;
        case 2: [[self getNavigation] pushViewController:stvc animated:YES]; break;
        default: break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
