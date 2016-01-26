//
//  BXTDeviceList.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/26.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTDeviceList.h"

@implementation BXTDeviceList

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
        self.deviceID = value;
    }
}

@end
