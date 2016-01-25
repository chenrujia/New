//
//  BXTAreaInfo.m
//  BXT
//
//  Created by Jason on 15/8/26.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTAreaInfo.h"

@implementation BXTAreaInfo

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
