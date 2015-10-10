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

@property (nonatomic ,assign) NSInteger maxPics;

+ (BXTGlobal *)shareGlobal;

/**
 *  设置与获取 用户属性
 */
+ (void)setUserProperty:(id)value withKey:(NSString *)key;
+ (id)getUserProperty:(NSString *)key;

/**
 *  正则验证手机号
 */
+ (BOOL)validateMobile:(NSString *)mobile;

/**
 *  转换十六进制颜色
 */
UIColor* colorWithHexString(NSString *stringToConvert);



@end
