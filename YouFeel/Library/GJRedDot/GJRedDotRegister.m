//
//  GJRedDotRegister.m
//  GJRedDotDemo
//
//  Created by wangyutao on 16/5/23.
//  Copyright © 2016年 wangyutao. All rights reserved.
//

#import "GJRedDotRegister.h"

NSString *const GJHomeTabBarItem        = @"HomeTabBarItem";
NSString *const GJApplicationTabBarItem = @"ApplicationTabBarItem";
NSString *const GJDailyOrders           = @"DailyOrders";
NSString *const GJMaintenceOrders       = @"MaintenceOrders";
NSString *const GJMyMaintainOrders      = @"MyMaintainOrders";
NSString *const GJMyRepairOrders        = @"MyRepairOrders";
NSString *const GJOtherThing            = @"OtherThing";
NSString *const GJAnnouncement          = @"Announcement";

@implementation GJRedDotRegister

+ (NSArray *)registProfiles
{
    return @[@{GJHomeTabBarItem:@[GJDailyOrders,
                                  GJMaintenceOrders,
                                  GJMyMaintainOrders,
                                  GJMyRepairOrders,
                                  GJOtherThing
                                  ]},
             @{GJApplicationTabBarItem:@[GJAnnouncement]}];
}

@end
