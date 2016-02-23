//
//  RemindNum.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/15.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTRemindNum.h"
#import "BXTHeaderForVC.h"

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
    self = [super init];
    if (self)
    {
        self.timeStart_Daily = @"0";
        self.timeStart_Inspectio = @"0";
        
        if ([ValueFUD(@"timeStart_Daily") integerValue] != 0)
        {
            self.timeStart_Daily = ValueFUD(@"timeStart_Daily");
        }
        if ([ValueFUD(@"timeStart_Inspectio") integerValue] != 0) {
            self.timeStart_Inspectio = ValueFUD(@"timeStart_Inspectio");
        }
    }
    return self;
}

@end
