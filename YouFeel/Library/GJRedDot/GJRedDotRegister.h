//
//  GJRedDotRegister.h
//  GJRedDotDemo
//
//  Created by wangyutao on 16/5/23.
//  Copyright © 2016年 wangyutao. All rights reserved.
//

#import <Foundation/Foundation.h>

//首页item
extern NSString *const GJHomeTabBarItem;
//应用item
extern NSString *const GJApplicationTabBarItem;
//日常工单
extern NSString *const GJDailyOrders;
//维保工单
extern NSString *const GJMaintenceOrders;
//我的维修工单
extern NSString *const GJMyMaintainOrders;
//我的报修工单
extern NSString *const GJMyRepairOrders;
//其他事物
extern NSString *const GJOtherThing;
//项目公告
extern NSString *const GJAnnouncement;

@interface GJRedDotRegister : NSObject

+ (NSArray *)registProfiles;

@end
