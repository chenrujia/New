//
//  BXTRepairDetailInfo.h
//  BXT
//
//  Created by Jason on 15/9/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXTPraiseInfo,BXTMaintenanceManInfo,BXTDeviceMMListInfo,BXTAdsNameInfo,BXTCloseInfo,BXTRepairPersonInfo,BXTProgressInfo,BXTFaultPicInfo;
@interface BXTRepairDetailInfo : NSObject

@property (nonatomic, copy  ) NSString              *orderID;
@property (nonatomic, copy  ) NSString              *cause;
@property (nonatomic, copy  ) NSString              *repair_user;
@property (nonatomic, copy  ) NSString              *fault_confirm;
@property (nonatomic, copy  ) NSString              *contact_tel;
@property (nonatomic, strong) NSArray<BXTFaultPicInfo       *> *fault_pic;
@property (nonatomic, copy  ) NSString              *state;
@property (nonatomic, copy  ) NSString              *evaluation_name;
@property (nonatomic, copy  ) NSString              *fault_id;
@property (nonatomic, copy  ) NSString              *receive_time;
@property (nonatomic, copy  ) NSString              *long_time;
@property (nonatomic, copy  ) NSString              *notes;
@property (nonatomic, copy  ) NSString              *faulttype_type_name;
@property (nonatomic, copy  ) NSString              *department_name;
@property (nonatomic, strong) NSArray<BXTFaultPicInfo       *> *fixed_pic;
@property (nonatomic, copy  ) NSString              *close_state;
@property (nonatomic, copy  ) NSString              *department;
@property (nonatomic, copy  ) NSString              *workprocess;
@property (nonatomic, copy  ) NSString              *orderid;
@property (nonatomic, assign) NSInteger             stores_id;
@property (nonatomic, copy  ) NSString              *device_ids;
@property (nonatomic, copy  ) NSString              *area;
@property (nonatomic, strong) NSArray<BXTFaultPicInfo       *> *evaluation_pic;
@property (nonatomic, copy  ) NSString              *place_name;
@property (nonatomic, strong) NSArray<BXTRepairPersonInfo   *> *fault_user_arr;
@property (nonatomic, copy  ) NSString              *receive_state;
@property (nonatomic, copy  ) NSString              *contact_name;
@property (nonatomic, copy  ) NSString              *subgroup_name;
@property (nonatomic, copy  ) NSString              *man_hours;
@property (nonatomic, copy  ) NSString              *visitmobile;
@property (nonatomic, copy  ) NSString              *evaluation_notes;
@property (nonatomic, copy  ) NSString              *start_time;
@property (nonatomic, strong) NSArray<BXTProgressInfo       *> *progress;
@property (nonatomic, copy  ) NSString              *collection;
@property (nonatomic, strong) BXTPraiseInfo         *Praise;
@property (nonatomic, copy  ) NSString              *visit;
@property (nonatomic, copy  ) NSString              *end_time;
@property (nonatomic, copy  ) NSString              *subgroup;
@property (nonatomic, copy  ) NSString              *faulttype;
@property (nonatomic, copy  ) NSString              *inspection_end_time;
@property (nonatomic, copy  ) NSString              *faulttype_name;
@property (nonatomic, strong) NSArray<BXTCloseInfo          *> *close_info;
@property (nonatomic, copy  ) NSString              *place;
@property (nonatomic, copy  ) NSString              *is_receive;
@property (nonatomic, copy  ) NSString              *faulttype_type;
@property (nonatomic, copy  ) NSString              *fault;
@property (nonatomic, copy  ) NSString              *urgent;
@property (nonatomic, copy  ) NSString              *evaluation_time;
@property (nonatomic, copy  ) NSString              *close_user;
@property (nonatomic, copy  ) NSString              *repairstate_name;
@property (nonatomic, strong) NSArray<BXTMaintenanceManInfo *> *repair_user_arr;
@property (nonatomic, copy  ) NSString              *close_cause;
@property (nonatomic, copy  ) NSString              *ads_txt;
@property (nonatomic, copy  ) NSString              *urgent_state;
@property (nonatomic, copy  ) NSString              *repair_user_name;
@property (nonatomic, assign) NSInteger             all_inspection_state;
@property (nonatomic, copy  ) NSString              *order_type;
@property (nonatomic, assign) NSInteger             fault_confirm_notes;
@property (nonatomic, copy  ) NSString              *is_repairing;
@property (nonatomic, copy  ) NSString              *fault_time_name;
@property (nonatomic, strong) NSArray<BXTDeviceMMListInfo   *> *device_list;
@property (nonatomic, copy  ) NSString              *dispatching_time;
@property (nonatomic, copy  ) NSString              *repairstate;
@property (nonatomic, copy  ) NSString              *is_gadget;
@property (nonatomic, copy  ) NSString              *is_dispatch;
@property (nonatomic, copy  ) NSString              *task_type;

@end

@interface BXTPraiseInfo : NSObject

@property (nonatomic, copy) NSString *speed;
@property (nonatomic, copy) NSString *serve;
@property (nonatomic, copy) NSString *professional;

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

@interface BXTCloseInfo : NSObject

@property (nonatomic, copy) NSString *close_name;
@property (nonatomic, copy) NSString *close_user;
@property (nonatomic, copy) NSString *close_cause;

@end

@interface BXTRepairPersonInfo : NSObject

@property (nonatomic, copy) NSString *department_id;
@property (nonatomic, copy) NSString *department_name;
@property (nonatomic, copy) NSString *duty_id;
@property (nonatomic, copy) NSString *duty_name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *rpID;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *out_userid;
@property (nonatomic, copy) NSString *subgroup_id;
@property (nonatomic, copy) NSString *subgroup_name;

@end

@interface BXTProgressInfo : NSObject

@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy  ) NSString  *word;

@end

@interface BXTFaultPicInfo : NSObject

@property (nonatomic, copy) NSString *photo_file;
@property (nonatomic, copy) NSString *photo_thumb_file;

@end

