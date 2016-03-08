//
//  BXTUserInfo.h
//  BXT
//
//  Created by Jason on 15/8/21.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXTFloorInfo.h"
#import "BXTGroupInfo.h"
#import "BXTPostionInfo.h"
#import "BXTGroupingInfo.h"
#import "BXTDepartmentInfo.h"
#import "BXTHeadquartersInfo.h"

#define U_USERNAME     @"userName"
#define U_PASSWORD     @"passWord"
#define U_NAME         @"name"
#define U_SEX          @"sex"
#define U_COMPANY      @"company"
#define U_DEPARTMENT   @"department"
#define U_POSITION     @"position"
#define U_FLOOOR       @"floorInfo"
#define U_AREA         @"areaInfo"
#define U_SHOP         @"shopInfo"
#define U_BINDINGADS   @"binding_ads"
#define U_USERID       @"userID"
#define U_BRANCHUSERID @"branchUserID"
#define U_ROLEARRAY    @"roleArray"
#define U_SHOPIDS      @"shopIdsArray"
#define U_MOBILE       @"mobileNumber"
#define U_GROUPINGINFO @"groupingInfo"
#define U_HEADERIMAGE  @"headerImage"
#define U_MYSHOP       @"my_shop"
#define U_IMTOKEN      @"im_token"
#define U_USERSARRAY   @"usersArray"
#define U_TOKEN        @"token"
#define U_IS_VERIFY    @"is_verify"
#define U_OPENID       @"openID"

//存储用的Model
@interface BXTUserInfo : NSObject

@property (nonatomic ,strong) BXTHeadquartersInfo *company;
@property (nonatomic ,strong) BXTDepartmentInfo   *department;
@property (nonatomic ,strong) BXTPostionInfo      *position;
@property (nonatomic ,strong) BXTFloorInfo        *floorInfo;
@property (nonatomic ,strong) BXTAreaInfo         *areaInfo;
@property (nonatomic ,strong) BXTGroupingInfo     *groupingInfo;
@property (nonatomic ,strong) id <NSCopying>      shopInfo;
@property (nonatomic ,strong) NSString            *userName;
@property (nonatomic ,strong) NSString            *passWord;
@property (nonatomic ,strong) NSString            *name;
@property (nonatomic ,strong) NSString            *sex;
@property (nonatomic ,strong) NSArray             *binding_ads;
@property (nonatomic ,strong) NSString            *userID;
@property (nonatomic ,strong) NSString            *branchUserID;
@property (nonatomic ,strong) NSArray             *roleArray;
@property (nonatomic ,strong) NSArray             *shopIdsArray;
@property (nonatomic ,strong) NSString            *mobileNumber;
@property (nonatomic ,strong) NSString            *headerImage;
@property (nonatomic ,strong) NSArray             *my_shop;
@property (nonatomic ,strong) NSString            *im_token;
@property (nonatomic ,strong) NSMutableArray      *usersArray;
@property (nonatomic, strong) NSString            *token;
@property (nonatomic, strong) NSString            *is_verify;
@property (nonatomic, strong) NSString            *openID;

@end

//外层登录Model
@interface BXTAbroadUserInfo : NSObject

@property (nonatomic, copy) NSString *personal_role;
@property (nonatomic, copy) NSString *lastLogin;
@property (nonatomic, copy) NSString *easemob_username;
@property (nonatomic, strong) NSArray *my_shop;
@property (nonatomic, strong) NSDictionary *my_shop_arr;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *im_token;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *matchs;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *publisher_role;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *is_admin;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, strong) NSArray *shop_ids;
@property (nonatomic, copy) NSString *is_test;
@property (nonatomic, copy) NSString *username;

@end

//内层登录Model
@interface BXTBranchUserInfo : NSObject

@property (nonatomic, copy) NSString *stores;
@property (nonatomic, strong) NSArray *binding_ads;
@property (nonatomic, copy) NSString *long_time;
@property (nonatomic, copy) NSString *stores_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *out_userid;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *is_repair;
@property (nonatomic, copy) NSString *is_admin;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *is_leader;
@property (nonatomic, copy) NSString *binding_stores;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *subgroup_name;
@property (nonatomic, copy) NSString *subgroup;
@property (nonatomic, copy) NSString *is_verify;
@property (nonatomic, copy) NSString *department_name;
@property (nonatomic, copy) NSString *role_id;
@property (nonatomic, strong) NSArray *role_con;
@property (nonatomic, copy) NSString *username;

@end


