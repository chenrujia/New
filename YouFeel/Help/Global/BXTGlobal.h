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
#import "BXTPostionInfo.h"
#import "BXTHeadquartersInfo.h"

/** ---- 背景色 ---- */
#define NavColorStr @"#00B1FF"
/** ---- cell-title色值 ---- */
#define CellTitleColorStr @"#383838"
/** ---- cell-content色值 ---- */
#define CellContentColorStr @"#6D6E6F"
/** ---- 存值 ---- */
#define SaveValueTUD(key, value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]
/** ---- 取值 ---- */
#define ValueFUD(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
/** ---- 刷新列表 ---- */
#define REFRESHTABLEVIEWOFLIST  @"REFRESHTABLEVIEWOFLIST"

/**弱引用、强引用**/
#define LRWeakSelf(type)  __weak typeof(type) weak##type = type;
#define LRStrongSelf(type)  __strong typeof(type) type = weak##type;

@interface BXTGlobal : NSObject

@property (nonatomic ,assign) NSInteger              maxPics;
@property (nonatomic ,copy  ) NSString               *baseURL;
@property (nonatomic ,copy  ) NSString               *BranchURL;
@property (nonatomic ,strong) NSMutableArray         *newsOrderIDs;
@property (nonatomic ,strong) NSMutableArray         *assignOrderIDs;
@property (nonatomic ,copy  ) NSString               *newsShopID;
@property (nonatomic ,assign) BOOL                   isRepair;//Yes是维修员，No是报修者
@property (nonatomic, assign) BOOL                   isLogin;//判断是否已经处于登录状态，处理推送使用的。
@property (nonatomic, assign) BOOL                   isBindingWeiXin;// 绑定微信 or 登录
@property (nonatomic, copy  ) NSString               *openID;
@property (nonatomic, copy  ) NSString               *wxHeadImage;
@property (nonatomic, assign) NSInteger              numOfPresented;
@property (nonatomic, assign) NSInteger              assignNumber;
@property (nonatomic, strong) NSString               *userName;
@property (nonatomic, strong) NSArray                *energyColors;
@property (nonatomic, assign) NSInteger              energyType;
@property (nonatomic, strong) UINavigationController *presentNav;

+ (BXTGlobal *)shareGlobal;

/**
 *  设置与获取 用户属性
 */
+ (void)setUserProperty:(id)value withKey:(NSString *)key;
+ (id)getUserProperty:(NSString *)key;
+ (void)setUserInfo:(BXTUserInfo *)userInfo;
+ (BXTUserInfo *)getUserInfo;
/**
 *  登录
 *
 *  @param dic     数组
 *  @param isPTRVC 是否跳转到首页
 */
- (void)branchLoginWithDic:(NSDictionary *)dic isPushToRootVC:(BOOL)isPushToRootVC;

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
 *  时间转时间戳
 */
+ (NSString *)transTimeStampWithTime:(NSString *)time withType:(NSString *)timeType;

/**
 *  时间戳转时间
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
+ (UIColor *)randomColor;

/**
 *  获取开始时间与结束时间 时间戳
 */
+ (NSArray *)transTimeToWhatWeNeed:(NSArray *)timeArray;

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
 *  获取几天前及今天的数组
 */
+ (NSArray *)dayOfCountStartAndEnd:(NSInteger)count;

/**
 *  获取周一到今天的数组
 */
+ (NSArray *)weekdayStartAndEnd;

/**
 * 获取年月日数组
 */
+ (NSArray *)yearAndmonthAndDay;

/**
 *  数据加载中...
 */
+ (void)showLoadingMBP:(NSString *)text;
/**
 *  隐藏MBProgressHUD
 */
+ (void)hideMBP;

/**
 * ---- 显示提示信息后添加动作 ----
 */
+ (void)showText:(NSString *)text view:(UIView *)view completionBlock:(void (^)())completion;

/**
 *  MD5加密
 */
+ (NSString *)md5:(NSString *)inPutText;

/**
 *  富文本转化
 */
+ (NSMutableAttributedString *)transToRichLabelOfIndex:(NSInteger)index String:(NSString *)originStr;

@end
