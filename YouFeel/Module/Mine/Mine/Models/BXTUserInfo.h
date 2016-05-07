//
//  BXTUserInfo.h
//  BXT
//
//  Created by Jason on 15/8/21.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXTHeadquartersInfo.h"

#define U_USERNAME     @"userName"
#define U_PASSWORD     @"passWord"
#define U_NAME         @"name"
#define U_SEX          @"sex"
#define U_COMPANY      @"company"
#define U_SHOP         @"shopInfo"
#define U_USERID       @"userID"
#define U_BRANCHUSERID @"branchUserID"
#define U_SHOPIDS      @"shopIdsArray"
#define U_MOBILE       @"mobileNumber"
#define U_HEADERIMAGE  @"headerImage"
#define U_MYSHOP       @"my_shop"
#define U_IMTOKEN      @"im_token"
#define U_USERSARRAY   @"usersArray"
#define U_TOKEN        @"token"
#define U_OPENID       @"openID"
#define USEREMAIL      @"email"
#define BINDINGWEIXIN     @"binding_weixin"
#define PERMISSIONKEYS @"permission_keys"

//存储用的Model
@class BXTResignedShopInfo;
@interface BXTUserInfo : NSObject

@property (nonatomic ,strong) BXTHeadquartersInfo *company;
@property (nonatomic ,strong) id <NSCopying>      shopInfo;
@property (nonatomic ,copy  ) NSString            *userName;
@property (nonatomic ,copy  ) NSString            *passWord;
@property (nonatomic ,copy  ) NSString            *name;
@property (nonatomic ,copy  ) NSString            *sex;
@property (nonatomic ,copy  ) NSString            *userID;
@property (nonatomic ,copy  ) NSString            *branchUserID;
@property (nonatomic ,strong) NSArray             *shopIdsArray;
@property (nonatomic ,copy  ) NSString            *mobileNumber;
@property (nonatomic ,copy  ) NSString            *headerImage;
@property (nonatomic ,strong) NSArray             *my_shop;
@property (nonatomic ,copy  ) NSString            *im_token;
@property (nonatomic ,strong) NSMutableArray      *usersArray;
@property (nonatomic, copy  ) NSString            *token;
@property (nonatomic, copy  ) NSString            *openID;
@property (nonatomic, copy  ) NSString            *permission_keys;

@end

//外层登录Model
@interface BXTAbroadUserInfo : NSObject

@property (nonatomic, copy) NSString *personal_role;
@property (nonatomic, copy) NSString *lastLogin;
@property (nonatomic, copy) NSString *easemob_username;
@property (nonatomic, strong) NSArray<BXTResignedShopInfo *> *my_shop;
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
@property (nonatomic, strong) NSArray<NSString *> *shop_ids;
@property (nonatomic, copy) NSString *is_test;
@property (nonatomic, copy) NSString *username;

@end

//内层登录Model
@interface BXTBranchUserInfo : NSObject

@property (nonatomic, copy  ) NSString  *subgroup_name;
@property (nonatomic, copy  ) NSString  *userID;
@property (nonatomic, copy  ) NSString  *stores_id;
@property (nonatomic, copy  ) NSString  *duty_id;
@property (nonatomic, copy  ) NSString  *department_id;
@property (nonatomic, copy  ) NSString  *stores_name;
@property (nonatomic, assign) NSInteger is_repair;
@property (nonatomic, copy  ) NSString  *subgroup_id;
@property (nonatomic, copy  ) NSString  *department_name;
@property (nonatomic, copy  ) NSString  *duty_name;
@property (nonatomic, copy  ) NSString  *permission_keys;

@end

@interface BXTResignedShopInfo : NSObject

@property (nonatomic, copy) NSString *shopID;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *shop_pic;
@property (nonatomic, copy) NSString *shop_logo;
@property (nonatomic, copy) NSString *shop_address;

@end

