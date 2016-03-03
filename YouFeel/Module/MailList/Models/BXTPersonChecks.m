//
//  BXTPersonChecks.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/12.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTPersonChecks.h"

@implementation BXTPersonChecks

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
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
    
}

@end
