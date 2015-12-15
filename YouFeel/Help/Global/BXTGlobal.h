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

/** ---- 存值 ---- */
#define SaveValueTUD(key, value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]
/** ---- 取值 ---- */
#define ValueFUD(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

@interface BXTGlobal : NSObject

@property (nonatomic ,assign) NSInteger      maxPics;
@property (nonatomic ,strong) NSString       *baseURL;
@property (nonatomic ,strong) NSString       *BranchURL;
@property (nonatomic ,strong) NSMutableArray *newsOrderIDs;
@property (nonatomic ,strong) NSMutableArray *assignOrderIDs;
@property (nonatomic ,strong) NSString       *newsShopID;
@property (nonatomic ,assign) BOOL           isRepair;
@property (nonatomic ,assign) NSString       *longTime;

@property (nonatomic, assign) NSInteger numOfPresented;
@property (nonatomic, assign) NSInteger assignNumber;

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

/**
 *  时间戳转时间
 */
+ (NSString *)transformationTime:(NSString *)timeType withTime:(NSString *)time;

/**
 *  NSDate转NSString
 */
+ (NSString *)transTimeWithDate:(NSDate *)date withType:(NSString *)timeType;

CGFloat valueForDevice(CGFloat v1,CGFloat v2,CGFloat v3,CGFloat v4);

/**
 *  存数组
 */
+ (void)writeFileWithfileName:(NSString *)filename Array:(NSMutableArray *)infom;
/**
 *  取数组
 */
+ (NSArray *)readFileWithfileName:(NSString *)filename;

/**
 *  判断字符处是否为空
 */
+ (BOOL)isBlankString:(NSString *)string;

/**
 *  随机颜色
 */
+ (UIColor *) randomColor;

/**
 *  获取当月第一天最后一天的数组
 */
+ (NSArray *)monthStartAndEnd;

/**
 *  获取当年第一天最后一天的数组
 */
+ (NSArray *)yearStartAndEnd;

/**
 *  获取当日2次的数组
 */
+ (NSArray *)dayStartAndEnd;

/**
 * 获取年月日数组
 */
+ (NSArray *)yearAndmonthAndDay;

/**
 * ---- 显示提示信息后添加动作 ---- 
 */
+ (void)showText:(NSString *)text view:(UIView *)view completionBlock:(void (^)())completion;

/**
 *  MD5加密
 */
+ (NSString *)md5:(NSString *)inPutText;

@end
