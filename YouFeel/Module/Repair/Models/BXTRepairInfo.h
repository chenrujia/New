//
//  BXTRepairInfo.h
//  BXT
//
//  Created by Jason on 15/9/6.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTRepairInfo : NSObject

@property (nonatomic ,strong) NSString  *area;
@property (nonatomic ,strong) NSString  *faulttype_name;
@property (nonatomic ,assign) NSInteger collection;
@property (nonatomic ,strong) NSString  *repair_time;
@property (nonatomic ,assign) NSInteger department;
@property (nonatomic ,strong) NSString  *fault;
@property (nonatomic ,assign) NSInteger fault_id;
@property (nonatomic ,assign) NSInteger faulttype;
@property (nonatomic ,assign) NSInteger repairID;
@property (nonatomic ,assign) NSInteger integral;
@property (nonatomic ,assign) BOOL      is_gadget;
@property (nonatomic ,assign) BOOL      is_read;
@property (nonatomic ,strong) NSString  *orderid;
@property (nonatomic ,strong) NSString  *place;
@property (nonatomic ,strong) NSArray   *repair_user;
@property (nonatomic ,assign) NSInteger repairstate;
@property (nonatomic ,strong) NSString  *state;
@property (nonatomic ,assign) NSInteger urgent;
@property (nonatomic ,strong) NSString  *receive_time;
@property (nonatomic ,strong) NSString  *workprocess;
@property (nonatomic ,strong) NSString  *receive_state;
@property (nonatomic ,strong) NSString  *visitmobile;

@end
