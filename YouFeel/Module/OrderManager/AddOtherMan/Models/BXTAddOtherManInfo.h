//
//  BXTAddOtherManInfo.h
//  BXT
//
//  Created by Jason on 15/9/23.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTAddOtherManInfo : NSObject

@property (nonatomic ,strong) NSString  *manID;
@property (nonatomic ,strong) NSString  *name;
@property (nonatomic ,strong) NSString  *sex_name;
@property (nonatomic ,strong) NSString  *department;
@property (nonatomic ,assign) NSInteger subgroup;
@property (nonatomic ,strong) NSString  *mobile;
@property (nonatomic ,assign) NSInteger clientid;
@property (nonatomic ,assign) NSInteger stores_id;
@property (nonatomic ,assign) NSInteger is_verify;
@property (nonatomic ,strong) NSString  *role;
@property (nonatomic ,assign) NSInteger department_id;
@property (nonatomic ,strong) NSString  *stores;
@property (nonatomic ,strong) NSString  *verify_state;
@property (nonatomic ,strong) NSString  *head_pic;
@property (nonatomic ,strong) NSString  *subgroup_name;

@end
