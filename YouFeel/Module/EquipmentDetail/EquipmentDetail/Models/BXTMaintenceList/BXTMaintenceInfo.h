//
//  BXTMaintenceInfo.h
//  YouFeel
//
//  Created by Jason on 16/1/8.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTMaintenceInfo : NSObject

@property (nonatomic, strong) NSString *maintenceID;
@property (nonatomic, strong) NSArray  *inspection_info;
@property (nonatomic, strong) NSString *inspection_item_id;
@property (nonatomic, strong) NSString *inspection_title;
@property (nonatomic, strong) NSString *operating_condition_content;
@property (nonatomic, strong) NSString *operating_condition_title;
@property (nonatomic, strong) NSNumber *task_id;
@property (nonatomic, strong) NSString *time_name;
//+设备维保列表相关
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *faulttype_name;
@property (nonatomic, strong) NSString *faulttype_type_name;
@property (nonatomic, strong) NSString *inspection_code;
@property (nonatomic, strong) NSString *inspection_item_name;
@property (nonatomic, strong) NSString *inspection_time;
@property (nonatomic, strong) NSString *repair_user;
@property (nonatomic, strong) NSNumber *state;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *workorder_id;
//+设备维护记录详情相关
@property (nonatomic, strong) NSArray  *device_con;
@property (nonatomic, strong) NSString *device_id;

@end
