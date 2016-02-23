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

@implementation BXTStatisticsSecondView

#pragma mark -
#pragma mark - 初始化
- (void)initial
{
    [super initial];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"维保完成率统计", @"维保分专业统计", @"维保分统计", nil];
    self.imageArray1 = [[NSMutableArray alloc] init];
    self.imageArray2 = [[NSMutableArray alloc] init];
    for (int i=1; i<=3; i++)
    {
        [self.imageArray1 addObject:[NSString stringWithFormat:@"Statistics_%d", i]];
        [self.imageArray2 addObject:[NSString stringWithFormat:@"Round_%d", i]];
    }
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
