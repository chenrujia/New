//
//  BXTCurrentOrderData.h
//
//  Created by 孝意 满 on 15/12/31
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTCurrentOrderData : NSObject

@property (nonatomic, copy) NSString *dataIdentifier;
@property (nonatomic, copy) NSString *inspection_end_time;
@property (nonatomic, copy) NSString *is_appointment;
@property (nonatomic, assign) NSInteger timeout_state;
@property (nonatomic, copy) NSString *faulttype_name;
@property (nonatomic, copy) NSString *repairstate;
@property (nonatomic, copy) NSString *fault_time_name;
@property (nonatomic, copy) NSString *repairstate_name;
@property (nonatomic, copy) NSString *device_ids;
@property (nonatomic, copy) NSString *subgroup_name;
@property (nonatomic, copy) NSString *orderid;
@property (nonatomic, copy) NSString *fault_id;
@property (nonatomic, copy) NSString *repair_user;
@property (nonatomic, copy) NSString *dispatch_users;
@property (nonatomic, copy) NSString *inspection_end_time_name;
@property (nonatomic, copy) NSString *department_id;
@property (nonatomic, copy) NSString *cause;
@property (nonatomic, copy) NSString *task_type;
@property (nonatomic, copy) NSString *place_name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
