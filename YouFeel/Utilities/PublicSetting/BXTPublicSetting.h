//
//  BXTPublicSetting.h
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#ifndef BXT_BXTPublicSetting_h
#define BXT_BXTPublicSetting_h

//  app 版本
#define IOSSHORTAPPVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//  app build版本
#define IOSAPPVERSION      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//  app 名称
#define IOSAPPNAME         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

//  判断是否是IOS8
#define IS_IOS_8        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

//  判断是否是IOS7
#define IS_IOS_7        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)

//  判断是否是IPHONE4
#define IS_IPHONE4 ([UIScreen mainScreen].bounds.size.height == 480 ? YES : NO)

//  判断是否是IPHONE5
#define IS_IPHONE5 ([UIScreen mainScreen].bounds.size.height >= 568 ? YES : NO)

//  判断是否是IPHONE6
#define IS_IPHONE6 ([UIScreen mainScreen].bounds.size.height >= 667 ? YES : NO)

//  判断是否是IPHONE6P
#define IS_IPHONE6P ([UIScreen mainScreen].bounds.size.height >= 736 ? YES : NO)

//  自适应宽度和高度
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.height-20)

//  release下不输出Log
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

//  XcodeColor
#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#define LogBlue(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,0,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogRed(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg255,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)

//  导航条高度
#define KNAVIVIEWHEIGHT         ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 64 : 44)

//  请求地址
#define KURLREQUEST             @"http://admin.51bxt.com/?r=port/Get_iPhone_v2_Port"

#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;

#endif
