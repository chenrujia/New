//
//  BXTCurrentOrderData.m
//
//  Created by 孝意 满 on 15/12/31
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "BXTCurrentOrderData.h"

@implementation BXTCurrentOrderData

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
    if ([key isEqualToString:@"id"]) {
        self.dataIdentifier = value;
    }
}

@end
