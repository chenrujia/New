//
//  BXTStatisticsFirstView.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/22.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTStatisticsFirstView.h"
#import "BXTCompletionViewController.h"
#import "BXTProfessionViewController.h"
#import "BXTIncidenceViewController.h"
#import "BXTWorkloadViewController.h"
#import "UIView+Nav.h"

@implementation BXTStatisticsFirstView

#pragma mark -
#pragma mark - 初始化
- (void)initial
{
    [super initial];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"维修完成率统计", @"专业分组统计", @"故障发生率统计", nil];
    self.imageArray1 = [[NSMutableArray alloc] init];
    self.imageArray2 = [[NSMutableArray alloc] init];
    for (int i=1; i<=3; i++)
    {
        [self.imageArray1 addObject:[NSString stringWithFormat:@"Statistics_%d", i]];
        [self.imageArray2 addObject:[NSString stringWithFormat:@"Round_%d", i]];
    }
}

#pragma mark -
#pragma mark - tableView代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    BXTStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTStatisticsCell" owner:nil options:nil] lastObject];
    }
    
    cell.titleView.text = self.dataArray[indexPath.section];
    cell.detailView.text = self.dataArray[indexPath.section];
    [cell.imageView1 setImage:[UIImage imageNamed:self.imageArray1[indexPath.section]]];
    [cell.imageView2 setImage:[UIImage imageNamed:self.imageArray2[indexPath.section]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTCompletionViewController *clvc = [[BXTCompletionViewController alloc] init];
    BXTProfessionViewController *pfvc = [[BXTProfessionViewController alloc] init];
    BXTIncidenceViewController *idvc = [[BXTIncidenceViewController alloc] init];
    
    switch (indexPath.section) {
        case 0: [[self navigation] pushViewController:clvc animated:YES]; break;
        case 1: [[self navigation] pushViewController:pfvc animated:YES]; break;
        case 2: [[self navigation] pushViewController:idvc animated:YES]; break;
        default: break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
