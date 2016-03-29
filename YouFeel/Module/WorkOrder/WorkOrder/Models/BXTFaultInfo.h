//
//  BXTFaultInfo.h
//  BXT
//
//  Created by Jason on 15/9/6.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXTFaultTypeInfo;

@interface BXTFaultInfo : NSObject

@property (nonatomic ,copy) NSString *fault_id;
@property (nonatomic ,copy) NSString *faulttype_type;
@property (nonatomic, strong) NSArray<BXTFaultTypeInfo *> *sub_data;

@end

@interface BXTFaultTypeInfo : NSObject

@property (nonatomic ,assign) NSInteger fau_id;
@property (nonatomic ,assign) NSInteger subgroup;
@property (nonatomic ,copy  ) NSString  *subgroup_name;
@property (nonatomic ,copy  ) NSString  *faulttype;
@property (nonatomic ,assign) NSInteger faulttype_type;
@property (nonatomic ,assign) NSInteger faultintegral;

@end
