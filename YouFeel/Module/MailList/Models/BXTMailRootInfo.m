//
//  BXTMailRootInfo.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMailRootInfo.h"

@implementation BXTMailRootInfo

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
