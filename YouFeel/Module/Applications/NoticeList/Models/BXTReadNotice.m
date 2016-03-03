//
//  BXTReadNotice.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/15.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTReadNotice.h"

@implementation BXTReadNotice

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

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        self.noticeID = value;
    }
}

@end
