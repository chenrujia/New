//
//  BXTPersonInform.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/12.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTPersonInform.h"

@implementation BXTPersonInform

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
    if ([key isEqualToString:@"id"])
    {
        self.StrID = value;
    }
}

@end
