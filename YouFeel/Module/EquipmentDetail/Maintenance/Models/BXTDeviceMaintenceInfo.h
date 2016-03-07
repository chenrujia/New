//
//  BXTDeviceMaintenceInfo.h
//  YouFeel
//
//  Created by Jason on 16/3/7.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXTDeviceInspectionInfo,BXTDeviceCheckInfo,BXTDeviceConfigInfo;

@interface BXTDeviceMaintenceInfo : NSObject

@property (nonatomic, copy) NSString *maintenceID;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSNumber *is_update;
@property (nonatomic, copy) NSString *inspection_code;
@property (nonatomic, copy) NSString *inspection_item_name;
@property (nonatomic, copy) NSString *faulttype_name;
@property (nonatomic, copy) NSString *faulttype_type_name;
@property (nonatomic, strong) NSArray<BXTDeviceInspectionInfo *> *inspection_info;
@property (nonatomic, copy) NSString *inspection_item_id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSString *task_id;
@property (nonatomic, copy) NSString *repair_user;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *inspection_time;
@property (nonatomic, copy) NSString *workorder_id;
@property (nonatomic, copy) NSString *time_name;
@property (nonatomic, copy) NSString *inspection_title;

//+设备维护记录详情相关
@property (nonatomic, copy) NSArray  *pic;
@property (nonatomic, copy) NSString *inspection_state;

//+设备维护记录详情相关
@property (nonatomic, copy) NSArray  *repair_arr;
@property (nonatomic, strong) NSArray<BXTDeviceConfigInfo *> *device_con;
@property (nonatomic, copy) NSString *device_id;
@property (nonatomic, copy) NSString *device_state;
@property (nonatomic, copy) NSString *device_state_name;

@end
@interface BXTDeviceInspectionInfo : NSObject

@property (nonatomic, copy) NSString *check_item;
@property (nonatomic, strong) NSArray<BXTDeviceCheckInfo *> *check_arr;

@end

@interface BXTDeviceCheckInfo : NSObject

@property (nonatomic, copy) NSString *check_con;
@property (nonatomic, copy) NSString *default_description;
@property (nonatomic, copy) NSString *check_key;

@end

@interface BXTDeviceConfigInfo : NSObject

@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *code_number;
@property (nonatomic, copy) NSArray  *control_user_arr;
@property (nonatomic, copy) NSString *control_users;
@property (nonatomic, copy) NSString *deviceID;
@property (nonatomic, copy) NSString *install_time;
@property (nonatomic, copy) NSString *model_number;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSString *place_id;
@property (nonatomic, copy) NSString *server_area;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSArray  *pic;
@property (nonatomic, copy) NSString *stores_id;
@property (nonatomic, copy) NSString *take_over_time;
@property (nonatomic, copy) NSString *state_name;

@end

