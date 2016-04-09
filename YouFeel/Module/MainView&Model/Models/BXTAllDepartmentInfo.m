//
//  BXTAllDepartmentInfo.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/8.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTAllDepartmentInfo.h"

@implementation BXTAllDepartmentInfo

+ (NSDictionary *)objectClassInArray{
    return @{@"lists" : [BXTAllDepartmentInfo class]};
}

- (void)setDepartment:(NSString *)department
{
    _department = [department copy];
    self.name = department;
}

@end



