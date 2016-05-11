//
//  RemindNum.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/15.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTRemindNum.h"
#import "BXTHeaderForVC.h"

#define ISFIRSTTIME @"isFirstTime"

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
        if (!ValueFUD(ISFIRSTTIME)) {
            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
            NSString *timeStr = [NSString stringWithFormat:@"%.0f", interval];
            self.timeStart_Daily = timeStr;
            self.timeStart_Inspection = timeStr;
            self.timeStart_Repair = timeStr;
            self.timeStart_Report = timeStr;
            self.timeStart_Object = timeStr;
            self.timeStart_Announcement = timeStr;
            self.timeStart_Notice = timeStr;
            
            SaveValueTUD(@"timeStart_Daily", timeStr);
            SaveValueTUD(@"timeStart_Inspectio", timeStr);
            SaveValueTUD(@"timeStart_Repair", timeStr);
            SaveValueTUD(@"timeStart_Report", timeStr);
            SaveValueTUD(@"timeStart_Object", timeStr);
            SaveValueTUD(@"timeStart_Announcement", timeStr);
            SaveValueTUD(@"timeStart_Notice", timeStr);
            
            SaveValueTUD(ISFIRSTTIME, @"right");
        }
        else {
            self.timeStart_Daily = ValueFUD(@"timeStart_Daily");
            self.timeStart_Inspection = ValueFUD(@"timeStart_Inspectio");
            self.timeStart_Repair = ValueFUD(@"timeStart_Repair");
            self.timeStart_Report = ValueFUD(@"timeStart_Report");
            self.timeStart_Object = ValueFUD(@"timeStart_Object");
            self.timeStart_Announcement = ValueFUD(@"timeStart_Announcement");
            self.timeStart_Notice = ValueFUD(@"timeStart_Notice");
        }
    }
    return self;
}

@end
