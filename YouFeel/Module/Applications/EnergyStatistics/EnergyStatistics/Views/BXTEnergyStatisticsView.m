//
//  BXTEnergyStatisticsView.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyStatisticsView.h"

@implementation BXTEnergyStatisticsView

+ (instancetype)viewForEnergyStatisticsView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"BXTEnergyStatisticsView" owner:nil options:nil] lastObject];
}

@end
