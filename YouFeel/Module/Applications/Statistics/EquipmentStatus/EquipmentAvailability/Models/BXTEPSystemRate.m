//
//  BXTEPSystemRate.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEPSystemRate.h"

@implementation BXTEPSystemRate

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
