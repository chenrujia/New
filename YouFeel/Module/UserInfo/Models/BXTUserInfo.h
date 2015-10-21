//
//  BXTUserInfo.h
//  BXT
//
//  Created by Jason on 15/8/21.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXTShopInfo.h"
#import "BXTAreaInfo.h"
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
#define U_CLIENTID     @"clientID"
#define U_USERID       @"userID"
#define U_BRANCHUSERID @"branchUserID"
#define U_ROLEARRAY    @"roleArray"
#define U_SHOPIDS      @"shopIdsArray"
#define U_MOBILE       @"mobileNumber"
#define U_GROUPINGINFO @"groupingInfo"
#define U_HEADERIMAGE  @"headerImage"
#define U_MYSHOP       @"my_shop"

@interface BXTUserInfo : NSObject

@property (nonatomic ,strong) NSString            *userName;
@property (nonatomic ,strong) NSString            *passWord;
@property (nonatomic ,strong) NSString            *name;
@property (nonatomic ,strong) NSString            *sex;
@property (nonatomic ,strong) BXTHeadquartersInfo *company;
@property (nonatomic ,strong) BXTDepartmentInfo   *department;
@property (nonatomic ,strong) BXTPostionInfo      *position;
@property (nonatomic ,strong) BXTFloorInfo        *floorInfo;
@property (nonatomic ,strong) BXTAreaInfo         *areaInfo;
@property (nonatomic ,strong) NSString            *clientID;
@property (nonatomic ,strong) BXTGroupingInfo     *groupingInfo;
@property (nonatomic ,strong) id <NSCopying>      shopInfo;
@property (nonatomic ,strong) NSArray             *binding_ads;
@property (nonatomic ,strong) NSString            *userID;
@property (nonatomic ,strong) NSString            *branchUserID;
@property (nonatomic ,strong) NSArray             *roleArray;
@property (nonatomic ,strong) NSArray             *shopIdsArray;
@property (nonatomic ,strong) NSString            *mobileNumber;
@property (nonatomic ,strong) NSString            *headerImage;
@property (nonatomic ,strong) NSArray             *my_shop;

@end
