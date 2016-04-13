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
        self.timeStart_Daily = @"";
        self.timeStart_Inspection = @"";
        self.timeStart_Repair = @"";
        self.timeStart_Report = @"";
        self.timeStart_Object = @"";
        self.timeStart_Announcement = @"";
        
        if ([ValueFUD(@"timeStart_Daily") integerValue] != 0)
        {
            self.timeStart_Daily = ValueFUD(@"timeStart_Daily");
        }
        if ([ValueFUD(@"timeStart_Inspectio") integerValue] != 0) {
            self.timeStart_Inspection = ValueFUD(@"timeStart_Inspectio");
        }
        if ([ValueFUD(@"timeStart_Repair") integerValue] != 0)
        {
            self.timeStart_Daily = ValueFUD(@"timeStart_Repair");
        }
        if ([ValueFUD(@"timeStart_Report") integerValue] != 0) {
            self.timeStart_Inspection = ValueFUD(@"timeStart_Report");
        }
        if ([ValueFUD(@"timeStart_Object") integerValue] != 0)
        {
            self.timeStart_Daily = ValueFUD(@"timeStart_Object");
        }
        if ([ValueFUD(@"timeStart_Announcement") integerValue] != 0) {
            self.timeStart_Inspection = ValueFUD(@"timeStart_Announcement");
        }
    }
    return self;
}

@end
