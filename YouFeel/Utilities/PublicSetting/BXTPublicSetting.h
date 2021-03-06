//
//  BXTPublicSetting.h
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#ifndef BXT_BXTPublicSetting_h
#define BXT_BXTPublicSetting_h

// AppStore下载地址
#define APPSTORE_APPADDRESS @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1093739474"

//  app 版本
#define IOSSHORTAPPVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define VERSIONNUM [IOSSHORTAPPVERSION stringByReplacingOccurrencesOfString:@"." withString:@""]

//  app build版本
#define IOSAPPVERSION   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//  app 名称
#define IOSAPPNAME      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

//  判断是否是IOS8
#define IS_IOS_9        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? YES : NO)

//  判断是否是IOS8
#define IS_IOS_8        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

//  判断是否是IOS7
#define IS_IOS_7        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)

//  判断是否是IPHONE4
#define IS_IPHONE4      ([UIScreen mainScreen].bounds.size.height == 480 ? YES : NO)

//  判断是否是IPHONE5
#define IS_IPHONE5      ([UIScreen mainScreen].bounds.size.height >= 568 ? YES : NO)

//  判断是否是IPHONE6
#define IS_IPHONE6      ([UIScreen mainScreen].bounds.size.height >= 667 ? YES : NO)

//  判断是否是IPHONE6P
#define IS_IPHONE6P     ([UIScreen mainScreen].bounds.size.height >= 736 ? YES : NO)

//  自适应宽度和高度
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.height-20)

//  release下不输出Log
#ifndef __OPTIMIZE__
#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#else
#define NSLog(...) {}
#endif

//  打印类名，行数
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

//  导航条高度
#define KNAVIVIEWHEIGHT         ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 64 : 44)

#define KTABBARHEIGHT           44.f

//  请求地址
#define KADMINBASEURL           [NSString stringWithFormat:@"%@/version/%@", @"http://admin.helloufu.com/?r=port/Get_iPhone_v2_Port", VERSIONNUM]
#define KAPIBASEURL             [NSString stringWithFormat:@"%@&version=%@", @"http://api.helloufu.com/?c=Port&m=actionGet_iPhone_v2_Port", VERSIONNUM]

#define YPLACESAVE            @"PlaceSave"
#define MYSUBGROUPSAVE        @"MySubgroupSave"
#define YMAILLISTSAVE         @"MailListSave"
#define YSAVEDSHOPID          @"SavedShopID"
#define YSAVEDTIME            @"SavedTime"

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

/** ---- 弱引用、强引用 ---- **/
#define LRWeakSelf(type)  __weak typeof(type) weak##type = type;
#define LRStrongSelf(type)  __strong typeof(type) type = weak##type;

//  动态计算高度
#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;

#endif
