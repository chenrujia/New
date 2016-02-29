//
//  BXTRepairDetailInfo.h
//  BXT
//
//  Created by Jason on 15/9/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTRepairDetailInfo : NSObject

@property (nonatomic ,assign) NSInteger    area;
@property (nonatomic ,strong) NSString     *area_name;
@property (nonatomic ,strong) NSString     *cause;
@property (nonatomic ,assign) NSInteger    collection;
@property (nonatomic ,strong) NSString     *collection_note;
@property (nonatomic ,strong) NSString     *repair_time;
@property (nonatomic ,assign) NSInteger    department;
@property (nonatomic ,strong) NSString     *department_name;
@property (nonatomic ,strong) NSString     *dispatching_time;
@property (nonatomic ,strong) NSString     *end_time;
@property (nonatomic ,strong) NSString     *equipmentnumber;
@property (nonatomic ,strong) NSString     *evaluation_name;
@property (nonatomic ,strong) NSString     *evaluation_notes;
@property (nonatomic ,strong) NSArray      *evaluation_pic;
@property (nonatomic ,strong) NSString     *evaluation_time;
@property (nonatomic ,strong) NSString     *fault;
@property (nonatomic ,strong) NSArray      *fault_pic;
@property (nonatomic ,assign) NSInteger    faulttype;
@property (nonatomic ,strong) NSString     *faulttype_name;
@property (nonatomic ,strong) NSArray      *fixed_pic;
@property (nonatomic ,assign) NSInteger    repairID;
@property (nonatomic ,assign) NSInteger    is_gadget;
@property (nonatomic ,strong) NSString     *mechanismid;
@property (nonatomic ,strong) NSString     *notes;
@property (nonatomic ,strong) NSString     *orderid;
@property (nonatomic ,assign) NSInteger    place;
@property (nonatomic ,strong) NSString     *place_name;
@property (nonatomic ,strong) NSString     *stores_name;
@property (nonatomic ,strong) NSString     *receive_time;
@property (nonatomic ,assign) NSInteger    repair_user;
@property (nonatomic ,strong) NSString     *repair_user_name;
@property (nonatomic ,assign) NSInteger    repairstate;
@property (nonatomic ,strong) NSString     *repairstate_name;
@property (nonatomic ,strong) NSString     *state;
@property (nonatomic ,assign) NSInteger    subgroup;
@property (nonatomic ,strong) NSString     *subgroup_name;
@property (nonatomic ,assign) NSInteger    urgent;
@property (nonatomic ,assign) NSInteger    isRepairing;
@property (nonatomic ,strong) NSString     *urgent_state;
@property (nonatomic ,strong) NSString     *visit;
@property (nonatomic ,strong) NSString     *visitmobile;
@property (nonatomic ,strong) NSString     *workprocess;
@property (nonatomic ,strong) NSArray      *repair_fault_arr;
@property (nonatomic ,strong) NSArray      *repair_user_arr;
@property (nonatomic ,strong) NSString     *man_hours;
@property (nonatomic ,strong) NSString     *long_time;
@property (nonatomic ,strong) NSString     *start_time;
@property (nonatomic ,assign) NSInteger    order_type;
@property (nonatomic, assign) NSInteger    task_type;
@property (nonatomic, strong) NSArray      *progress;

//维保相关
@property (nonatomic, strong) NSArray      *device_list;
@property (nonatomic, strong) NSNumber     *all_inspection_state;

@end
