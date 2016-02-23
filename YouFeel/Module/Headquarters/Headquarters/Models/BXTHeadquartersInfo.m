//
//  BXTHeadquartersInfo.m
//  BXT
//
//  Created by Jason on 15/8/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTHeadquartersInfo.h"

@implementation BXTHeadquartersInfo

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.company_id = value;
    }
}

@end
