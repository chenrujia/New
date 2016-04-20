//
//  BXTRepairDetailInfo.m
//  BXT
//
//  Created by Jason on 15/9/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTRepairDetailInfo.h"

@implementation BXTRepairDetailInfo

+ (NSDictionary *)objectClassInArray
{
    return @{@"repair_user_arr":[BXTMaintenanceManInfo class],
             @"dispatch_user_arr":[BXTMaintenanceManInfo class],
             @"fault_pic":[BXTFaultPicInfo class],
             @"fixed_pic":[BXTFaultPicInfo class],
             @"evaluation_pic":[BXTFaultPicInfo class],
             @"device_lists":[BXTDeviceMMListInfo class],
             @"fault_user_arr":[BXTRepairPersonInfo class],
             @"progress":[BXTProgressInfo class],
             @"report":[BXTReportInfo class],
             @"praise":[BXTPraiseInfo class]};
}

@end

@implementation BXTReportInfo

@end

@implementation BXTMaintenanceManInfo

@end

@implementation BXTPraiseInfo

@end

@implementation BXTRepairPersonInfo

@end

@implementation BXTDeviceMMListInfo

+ (NSDictionary *)objectClassInArray
{
    return @{@"ads_name" : [BXTAdsNameInfo class]};
}

@end

@implementation BXTAdsNameInfo

@end

@implementation BXTProgressInfo

@end

@implementation BXTFaultPicInfo

@end