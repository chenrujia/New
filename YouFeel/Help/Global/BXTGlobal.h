//
//  BXTGlobal.h
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BXTUserInfo.h"
#import "BXTDepartmentInfo.h"
#import "BXTPostionInfo.h"
#import "BXTFloorInfo.h"
#import "BXTAreaInfo.h"
#import "BXTShopInfo.h"
#import "BXTHeadquartersInfo.h"

@interface BXTGlobal : NSObject

@property (nonatomic ,assign) NSInteger      maxPics;
@property (nonatomic ,strong) NSString       *baseURL;
@property (nonatomic ,strong) NSMutableArray *orderIDs;
@property (nonatomic ,strong) NSString       *newsShopID;
@property (nonatomic ,assign) BOOL           isRepair;

+ (BXTGlobal *)shareGlobal;

/**
 *  设置与获取 用户属性
 */
+ (void)setUserProperty:(id)value withKey:(NSString *)key;
+ (id)getUserProperty:(NSString *)key;
+ (void)setUserInfo:(BXTUserInfo *)userInfo;
+ (BXTUserInfo *)getUserInfo;
- (void)reLoginWithDic:(NSDictionary *)dic;

/**
 *  正则验证手机号
 */
+ (BOOL)validateMobile:(NSString *)mobile;

/**
 *  正则验证4位验证码
 */
+ (BOOL)validateCAPTCHA:(NSString *)captcha;

/**
 *  正则验证用户名（中英文）
 */
+ (BOOL)validateUserName:(NSString *)username;

/**
 *  正则验证6位及以上密码
 */
+ (BOOL)validatePassword:(NSString *)pw;

- (void)enableForIQKeyBoard:(BOOL)enable;

/**
 *  转换十六进制颜色
 */
UIColor* colorWithHexString(NSString *stringToConvert);

+ (NSString *)transformationTime:(NSString *)timeType withTime:(NSString *)time;

CGFloat valueForDevice(CGFloat v1,CGFloat v2,CGFloat v3,CGFloat v4);

/**
 *  存数组
 */
+ (void)writeFileWithfileName:(NSString *)filename Array:(NSMutableArray *)infom;
/**
 *  取数组
 */
+ (NSArray *)readFileWithfileName:(NSString *)filename;

@end
