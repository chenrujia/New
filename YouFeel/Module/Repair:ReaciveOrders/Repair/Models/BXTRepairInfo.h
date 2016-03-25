//
//  BXTRepairInfo.h
//  BXT
//
//  Created by Jason on 15/9/6.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTRepairInfo : NSObject


@property (nonatomic, copy) NSString *subgroup_name;

@property (nonatomic, copy) NSString *faulttype_name;

@property (nonatomic, copy) NSString *repairID;

@property (nonatomic, copy) NSString *repairstate;

@property (nonatomic, copy) NSString *fault_time_name;

@property (nonatomic, copy) NSString *orderid;

@property (nonatomic, copy) NSString *repairstate_name;

@property (nonatomic, copy) NSString *place_name;

@property (nonatomic, copy) NSString *task_type;

@property (nonatomic, copy) NSString *cause;

@property (nonatomic, copy) NSString *is_appointment;

@property (nonatomic, copy) NSString *timeout_state;

@end

