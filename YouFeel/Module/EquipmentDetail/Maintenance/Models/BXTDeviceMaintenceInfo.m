//
//  BXTDeviceMaintenceInfo.m
//  YouFeel
//
//  Created by Jason on 16/3/7.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTDeviceMaintenceInfo.h"

@implementation BXTDeviceMaintenceInfo

+ (NSDictionary *)objectClassInArray
{
    return @{@"inspection_info":[BXTDeviceInspectionInfo class],
             @"repair_arr":[BXTControlUserInfo class],
             @"device_con":[BXTDeviceConfigInfo class]};
}

@end

@implementation BXTDeviceInspectionInfo

+ (NSDictionary *)objectClassInArray
{
    return @{@"check_arr" : [BXTDeviceCheckInfo class]};
}

@end

@implementation BXTDeviceCheckInfo

@end

@implementation BXTDeviceConfigInfo

@end

@implementation BXTControlUserInfo

@end


