//
//  BXTAddOtherManInfo.h
//  BXT
//
//  Created by Jason on 15/9/23.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTAddOtherManInfo : NSObject

@property (nonatomic ,copy  ) NSString  *manID;
@property (nonatomic ,copy  ) NSString  *name;
@property (nonatomic ,copy  ) NSString  *sex_name;
@property (nonatomic ,copy  ) NSString  *department;
@property (nonatomic ,assign) NSInteger subgroup;
@property (nonatomic ,copy  ) NSString  *mobile;
@property (nonatomic ,assign) NSInteger clientid;
@property (nonatomic ,assign) NSInteger stores_id;
@property (nonatomic ,assign) NSInteger is_verify;
@property (nonatomic ,copy  ) NSString  *role;
@property (nonatomic ,assign) NSInteger department_id;
@property (nonatomic ,copy  ) NSString  *stores;
@property (nonatomic ,copy  ) NSString  *verify_state;
@property (nonatomic ,copy  ) NSString  *head_pic;
@property (nonatomic ,copy  ) NSString  *subgroup_name;

@end
