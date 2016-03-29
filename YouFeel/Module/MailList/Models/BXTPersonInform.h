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

@property (nonatomic, strong) BXTPersonChecks *storesChecks;
@property (nonatomic, copy) NSString *stores;
@property (nonatomic, copy) NSString *clientid;
@property (nonatomic, copy) NSString *stores_id;
@property (nonatomic, copy) NSString *sex_name;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *out_userid;
@property (nonatomic, copy) NSString *department_id;
@property (nonatomic, copy) NSString *StrID;
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *verify_state;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *subgroup_name;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *subgroup;
@property (nonatomic, copy) NSString *is_verify;
@property (nonatomic, copy) NSString *role_id;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
