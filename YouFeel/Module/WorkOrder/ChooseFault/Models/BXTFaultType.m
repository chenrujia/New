//
//  BXTFaultType.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/22.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTFaultType.h"

@implementation BXTFaultType

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
    if ([key isEqualToString:@"id"]) {
        self.faultID = value;
    }
}


@end
