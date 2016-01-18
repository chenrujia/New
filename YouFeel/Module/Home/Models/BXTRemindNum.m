//
//  RemindNum.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/15.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTRemindNum.h"

@implementation BXTRemindNum

+ (BXTRemindNum *)sharedManager
{
    static BXTRemindNum *ManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        ManagerInstance = [[self alloc] init];
    });
    
    return ManagerInstance;
}

- (instancetype)init
{
    if (self == [super init]) {
        self.timeStart = @"0";
    }
    return self;
}

@end
