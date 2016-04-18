//
//  BXTRepairDetailInfo.h
//  BXT
//
//  Created by Jason on 15/9/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXTReportInfo,BXTPraiseInfo,BXTRepairPersonInfo,BXTProgressInfo,BXTFaultPicInfo,BXTDeviceMMListInfo,BXTAdsNameInfo,BXTMaintenanceManInfo;
@interface BXTRepairDetailInfo : NSObject

@property (nonatomic, copy  ) NSString                         *fault_id;
@property (nonatomic, strong) NSArray<BXTFaultPicInfo *>       *evaluation_pic;
@property (nonatomic, strong) NSArray<BXTRepairPersonInfo *>   *fault_user_arr;
@property (nonatomic, strong) BXTReportInfo                    *report;
@property (nonatomic, copy  ) NSString                         *repairstate;
@property (nonatomic, copy  ) NSString                         *device_ids;
@property (nonatomic, copy  ) NSString                         *place_name;
@property (nonatomic, strong) NSArray<BXTFaultPicInfo *>       *fixed_pic;
@property (nonatomic, copy  ) NSString                         *repair_user;
@property (nonatomic, strong) NSArray<BXTFaultPicInfo *>       *fault_pic;
@property (nonatomic, copy  ) NSString                         *dispatch_users;
@property (nonatomic, strong) NSArray<BXTDeviceMMListInfo *>   *device_lists;
@property (nonatomic, copy  ) NSString                         *cause;
@property (nonatomic, copy  ) NSString                         *workprocess;
@property (nonatomic, strong) NSArray<BXTMaintenanceManInfo *> *repair_user_arr;
@property (nonatomic, copy  ) NSString                         *orderid;
@property (nonatomic, copy  ) NSString                         *is_appointment;
@property (nonatomic, copy  ) NSString                         *faulttype_name;
@property (nonatomic, copy  ) NSString                         *department_id;
@property (nonatomic, copy  ) NSString                         *orderID;
@property (nonatomic, copy  ) NSString                         *close_state;
@property (nonatomic, strong) NSArray<BXTProgressInfo *>       *progress;
@property (nonatomic, copy  ) NSString                         *ads_txt;
@property (nonatomic, copy  ) NSString                         *fault_time_name;
@property (nonatomic, copy  ) NSString                         *subgroup_name;
@property (nonatomic, copy  ) NSString                         *task_type;
@property (nonatomic, copy  ) NSString                         *evaluation_notes;
@property (nonatomic, copy  ) NSString                         *evaluation_time_name;
@property (nonatomic, strong) NSArray<BXTMaintenanceManInfo *> *dispatch_user_arr;
@property (nonatomic, copy  ) NSString                         *repairstate_name;
@property (nonatomic, strong) BXTPraiseInfo                    *praise;

@end

@interface BXTReportInfo : NSObject

@property (nonatomic, copy) NSString *real_repairstate_name;
@property (nonatomic, copy) NSString *real_faulttype_name;
@property (nonatomic, copy) NSString *end_time_name;
@property (nonatomic, copy) NSString *real_place_name;
@property (nonatomic, copy) NSString *workprocess;

@end

@interface BXTMaintenanceManInfo : NSObject

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *mmID;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *log_content;
@property (nonatomic, copy) NSString *out_userid;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *name;

@end

@interface BXTPraiseInfo : NSObject

@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, assign) NSInteger serve;
@property (nonatomic, assign) NSInteger professional;

@end

@interface BXTRepairPersonInfo : NSObject

@property (nonatomic, copy) NSString *rpID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *duty_id;
@property (nonatomic, copy) NSString *subgroup_name;
@property (nonatomic, copy) NSString *out_userid;
@property (nonatomic, copy) NSString *department_id;
@property (nonatomic, copy) NSString *duty_name;
@property (nonatomic, copy) NSString *subgroup_id;
@property (nonatomic, copy) NSString *department_name;
@property (nonatomic, copy) NSString *shop_id;

@end

@interface BXTDeviceMMListInfo : NSObject

@property (nonatomic, copy  ) NSString       *deviceMMID;
@property (nonatomic, copy  ) NSString       *state;
@property (nonatomic, copy  ) NSString       *take_over_time;
@property (nonatomic, copy  ) NSString       *qrcode;
@property (nonatomic, copy  ) NSString       *model_number;
@property (nonatomic, copy  ) NSString       *brand;
@property (nonatomic, copy  ) NSString       *factory_id;
@property (nonatomic, copy  ) NSString       *area_id;
@property (nonatomic, copy  ) NSString       *stores_id;
@property (nonatomic, copy  ) NSString       *code_number;
@property (nonatomic, copy  ) NSString       *type_id;
@property (nonatomic, copy  ) NSString       *place_id;
@property (nonatomic, copy  ) NSString       *server_area;
@property (nonatomic, copy  ) NSString       *inspection_state;
@property (nonatomic, copy  ) NSString       *name;
@property (nonatomic, strong) NSArray<BXTAdsNameInfo *> *ads_name;

@end

@interface BXTAdsNameInfo : NSObject

@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *adsNameID;
@property (nonatomic, copy) NSString *stores_id;
@property (nonatomic, copy) NSString *stores_name;
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, copy) NSString *place_name;
@property (nonatomic, copy) NSString *place_id;

@end

@interface BXTProgressInfo : NSObject

@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *word;

@end

@interface BXTFaultPicInfo : NSObject

@property (nonatomic, copy) NSString *photo_file;
@property (nonatomic, copy) NSString *photo_thumb_file;

@end

