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
#import "BXTMTPlanHeaderView.h"
#import "BXTMTStatisticsCell.h"
#import "UIView+Nav.h"

@interface BXTStatisticsSecondView ()

@end

@implementation BXTStatisticsSecondView

#pragma mark -
#pragma mark - 初始化
- (void)initial
{
    [super initial];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"维保完成率统计", @"维保分专业统计", @"维保分类统计", nil];
    self.detailArray = [[NSMutableArray alloc] initWithObjects:@"项目总体完成情况", @"专业分组完成情况", @"各分类完成情况", nil];
    
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
    
    NSArray *transArray = ValueFUD(@"secondViewMTPlanArray");
    NSDictionary *dataDict = transArray[indexPath.section];
    
    [cell.pieChartView clearChart];
    [cell.pieChartView addDataToRepresent:[dataDict[@"over_per"] doubleValue] WithColor:colorWithHexString(@"#0FCCC0")];
    [cell.pieChartView addDataToRepresent:[dataDict[@"working_per"] doubleValue] WithColor:colorWithHexString(@"#0C88CC")];
    [cell.pieChartView addDataToRepresent:[dataDict[@"unover_per"] doubleValue] WithColor:colorWithHexString(@"#FD7070")];
    [cell.pieChartView addDataToRepresent:[dataDict[@"unstart_per"] doubleValue] WithColor:colorWithHexString(@"#DEE7E8")];
    
    if ([dataDict[@"over_per"] doubleValue] == 0 && [dataDict[@"working_per"] doubleValue] == 0 && [dataDict[@"unover_per"] doubleValue] == 0 && [dataDict[@"unstart_per"] doubleValue] == 0) {
        [cell.pieChartView addDataToRepresent:1 WithColor:colorWithHexString(@"#DEE7E8")];
    }
    
    cell.persentView.text = [NSString stringWithFormat:@"已完成:%@%%", dataDict[@"over_per"]];
    
    cell.pieChartView.userInteractionEnabled = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTMTCompletionViewController *clvc = [[BXTMTCompletionViewController alloc] init];
    BXTMTProfessionViewController *pfvc = [[BXTMTProfessionViewController alloc] init];
    
    switch (indexPath.section) {
        case 0: [[self navigation] pushViewController:clvc animated:YES]; break;
        case 1: {
            pfvc.isSystemPush = NO;
            [[self navigation] pushViewController:pfvc animated:YES];
        } break;
        case 2: {
            pfvc.isSystemPush = YES;
            [[self navigation] pushViewController:pfvc animated:YES];
        } break;
        default: break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
