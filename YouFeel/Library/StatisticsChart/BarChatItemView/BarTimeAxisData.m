//
//  BarTimeAxisData.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/26.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "BarTimeAxisData.h"

@implementation BarTimeAxisData

+ (BarTimeAxisData *)dataWithDate:(NSDate *)date andNumber:(NSNumber *)number {
    BarTimeAxisData *data = [[BarTimeAxisData alloc] init];
    data.date = date;
    data.number = number;
    return data;
}

@end
