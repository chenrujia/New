//
//  BXTRepairInfo.h
//  BXT
//
//  Created by Jason on 15/9/6.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXTRepairInfo;
@interface BXTData : NSObject

@property (nonatomic, copy  ) NSString      *page;

@property (nonatomic, assign) NSInteger     number;

@property (nonatomic, assign) NSInteger     pages;

@property (nonatomic, copy  ) NSString      *returncode;

@property (nonatomic, strong) NSArray<BXTRepairInfo *> *data;

@property (nonatomic, assign) NSInteger     total_number;

@end

@interface BXTRepairInfo : NSObject

@property (nonatomic, copy  ) NSString  *integral_grab;

@property (nonatomic, copy  ) NSString  *receive_time;

@property (nonatomic, copy  ) NSString  *fault_confirm;

@property (nonatomic, copy  ) NSString  *repairID;

@property (nonatomic, copy  ) NSString  *integral;

@property (nonatomic, copy  ) NSString  *is_receive;

@property (nonatomic, copy  ) NSString  *stores_name;

@property (nonatomic, copy  ) NSString  *urgent;

@property (nonatomic, copy  ) NSString  *contact_name;

@property (nonatomic, copy  ) NSString  *fault;

@property (nonatomic, copy  ) NSString  *repair_time;

@property (nonatomic, copy  ) NSString  *state;

@property (nonatomic, copy  ) NSString  *evaluation_notes;

@property (nonatomic, copy  ) NSString  *repair_user_name;

@property (nonatomic, copy  ) NSString  *orderid;

@property (nonatomic, copy  ) NSString  *repairstate;

@property (nonatomic, copy  ) NSString  *is_repairing;

@property (nonatomic, copy  ) NSString  *workprocess;

@property (nonatomic, copy  ) NSString  *is_read;

@property (nonatomic, copy  ) NSString  *inspection_end_time;

@property (nonatomic, strong) NSArray<NSString  *> *repair_user;

@property (nonatomic, copy  ) NSString  *area;

@property (nonatomic, copy  ) NSString  *is_gadget;

@property (nonatomic, copy  ) NSString  *subgroup;

@property (nonatomic, copy  ) NSString  *ads_txt;

@property (nonatomic, copy  ) NSString  *subgroup_name;

@property (nonatomic, assign) NSInteger stores_id;

@property (nonatomic, copy  ) NSString  *place;

@property (nonatomic, copy  ) NSString  *is_dispatch;

@property (nonatomic, copy  ) NSString  *man_hours;

@property (nonatomic, copy  ) NSString  *order_type;

@property (nonatomic, copy  ) NSString  *collection;

@property (nonatomic, copy  ) NSString  *fixed_pic;

@property (nonatomic, copy  ) NSString  *start_time;

@property (nonatomic, copy  ) NSString  *fault_confirm_notes;

@property (nonatomic, copy  ) NSString  *fault_id;

@property (nonatomic, copy  ) NSString  *receive_state;

@property (nonatomic, copy  ) NSString  *faulttype;

@property (nonatomic, copy  ) NSString  *faulttype_name;

@property (nonatomic, copy  ) NSString  *faulttype_type;

@property (nonatomic, copy  ) NSString  *task_type;

@property (nonatomic, assign) NSInteger long_time;

@property (nonatomic, copy  ) NSString  *contact_tel;

@property (nonatomic, copy  ) NSString  *department;

@property (nonatomic, copy  ) NSString  *cause;

@end

