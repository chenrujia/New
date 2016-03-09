//
//  BXTFloorInfo.m
//  BXT
//
//  Created by Jason on 15/8/26.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTFloorInfo.h"

@implementation BXTFloorInfo

+ (NSDictionary *)objectClassInArray
{
    return @{@"place":[BXTAreaInfo class]};
}

@end

@implementation BXTAreaInfo

+ (NSDictionary *)objectClassInArray
{
    return @{@"stores":[BXTShopInfo class]};
}

@end

@implementation BXTShopInfo

@end


