//
//  BXTStatisticsThirdView.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/22.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTStatisticsThirdView.h"
#import "BXTEPAvailabilityViewController.h"

@implementation BXTStatisticsThirdView

#pragma mark -
#pragma mark - 初始化
- (void)initial
{
    [super initial];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"设备完好率统计", @"设备运行计划统计", @"预防性维保情况统计", nil];
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
    BXTEPAvailabilityViewController *abvc = [[BXTEPAvailabilityViewController alloc] init];
    
    switch (indexPath.section) {
        case 0: [[self getNavigation] pushViewController:abvc animated:YES]; break;
        case 1:  break;
        case 2:  break;
        default: break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
