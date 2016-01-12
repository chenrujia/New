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
@property (nonatomic, strong) NSString *stores;
@property (nonatomic, strong) NSString *clientid;
@property (nonatomic, strong) NSString *stores_id;
@property (nonatomic, strong) NSString *sex_name;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *out_userid;
@property (nonatomic, strong) NSString *department_id;
@property (nonatomic, strong) NSString *StrID;
@property (nonatomic, strong) NSString *head_pic;
@property (nonatomic, strong) NSString *verify_state;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *head;
@property (nonatomic, strong) NSString *subgroup_name;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *subgroup;
@property (nonatomic, strong) NSString *is_verify;
@property (nonatomic, strong) NSString *role_id;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
