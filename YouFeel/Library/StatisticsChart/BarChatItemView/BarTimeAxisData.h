//
//  BarTimeAxisData.h
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/26.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarTimeAxisData : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *number;
+ (BarTimeAxisData *)dataWithDate:(NSDate *)date andNumber:(NSNumber *)number;

@end
