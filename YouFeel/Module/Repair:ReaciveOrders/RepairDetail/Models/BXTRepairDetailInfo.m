//
//  BXTRepairDetailInfo.m
//  BXT
//
//  Created by Jason on 15/9/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTRepairDetailInfo.h"

@implementation BXTRepairDetailInfo


+ (NSDictionary *)objectClassInArray{
    return @{@"repair_user_arr":[BXTMaintenanceManInfo class],
             @"fault_pic":[BXTFaultPicInfo class],
             @"fixed_pic":[BXTFaultPicInfo class],
             @"evaluation_pic":[BXTFaultPicInfo class],
             @"device_list":[BXTDeviceMMListInfo class],
             @"close_info":[BXTCloseInfo class],
             @"repair_fault_arr":[BXTRepairPersonInfo class],
             @"progress":[BXTProgressInfo class]};
}
@end
@implementation BXTPraiseInfo

@end


@implementation BXTMaintenanceManInfo

@end


@implementation BXTDeviceMMListInfo

+ (NSDictionary *)objectClassInArray{
    return @{@"ads_name" : [BXTAdsNameInfo class]};
}

@end


@implementation BXTAdsNameInfo

@end


@implementation BXTCloseInfo

@end


@implementation BXTRepairPersonInfo

@end


@implementation BXTProgressInfo

@end

@implementation BXTFaultPicInfo

@end


