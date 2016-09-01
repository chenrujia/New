//
//  BXTPersonInform.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/12.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXTPersonChecks.h"

@interface BXTPersonInform : NSObject

@property (nonatomic, assign) NSInteger binding_weixin;
@property (nonatomic, copy) NSString *gender_name;
@property (nonatomic, copy) NSString *hide_mobile;
@property (nonatomic, copy) NSString *bind_place_ids;
@property (nonatomic, copy) NSString *stores_id;
@property (nonatomic, copy) NSString *subgroup_id;
@property (nonatomic, copy) NSString *stores_name;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *out_userid;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *department_id;
@property (nonatomic, copy) NSString *personID;
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *have_subgroup_name;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *department_name;
@property (nonatomic, copy) NSString *have_subgroup_ids;
@property (nonatomic, copy) NSString *subgroup_name;
@property (nonatomic, copy) NSString *power;
@property (nonatomic, assign) NSInteger is_repair;
@property (nonatomic, copy) NSString *role_id;
@property (nonatomic, copy) NSString *duty_name;
@property (nonatomic, assign) NSInteger binding_shop;

@end
