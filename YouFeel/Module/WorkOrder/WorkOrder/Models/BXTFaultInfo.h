//
//  BXTFaultInfo.h
//  BXT
//
//  Created by Jason on 15/9/6.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXTBaseClassifyInfo.h"

@interface BXTFaultInfo : BXTBaseClassifyInfo

@property (nonatomic, copy) NSString *faulttype;
@property (nonatomic, copy) NSString *del_state;
@property (nonatomic, copy) NSString *fault_id;
@property (nonatomic, copy) NSString *task_type;
@property (nonatomic, copy) NSString *subgroup_id;
@property (nonatomic, copy) NSString *faultintegral;
@property (nonatomic, copy) NSString *pid;

@end
