//
//  BXTFaultInfo.m
//  BXT
//
//  Created by Jason on 15/9/6.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTFaultInfo.h"

@implementation BXTFaultInfo

+ (NSDictionary *)objectClassInArray
{
    return @{@"lists" : [BXTFaultInfo class]};
}

- (void)setFaulttype:(NSString *)faulttype
{
    _faulttype = [faulttype copy];
    self.name = faulttype;
}

@end



