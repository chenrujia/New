//
//  BXTUserInfo.m
//  BXT
//
//  Created by Jason on 15/8/21.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTUserInfo.h"

@implementation BXTUserInfo

@end

@implementation BXTAbroadUserInfo

+ (NSDictionary *)objectClassInArray
{
    return @{@"my_shop" : [BXTResignedShopInfo class]};
}

@end

@implementation BXTBranchUserInfo

@end

@implementation BXTResignedShopInfo

@end


