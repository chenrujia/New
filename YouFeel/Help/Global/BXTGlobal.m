//
//  BXTGlobal.m
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTGlobal.h"
#import "ANKeyValueTable.h"

#define USERKEY @"UserInfo"

@implementation BXTGlobal

+ (BXTGlobal *)shareGlobal
{
    static BXTGlobal *bxtGlobal = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bxtGlobal = [[BXTGlobal alloc] init];
    });
    return bxtGlobal;
}

+ (void)setUserProperty:(id)value withKey:(NSString *)key
{
    BXTUserInfo *userInfo = [BXTGlobal getUserInfo];
    [userInfo setValue:value forKey:key];
    [BXTGlobal setUserInfo:userInfo];
}

+ (id)getUserProperty:(NSString *)key
{
    BXTUserInfo *userInfo = [BXTGlobal getUserInfo];
    id obj = [userInfo valueForKey:key];
    return obj;
}

+ (void)setUserInfo:(BXTUserInfo *)userInfo
{
    [[ANKeyValueTable userDefaultTable] setValue:userInfo withKey:USERKEY];
}

+ (BXTUserInfo *)getUserInfo
{
    BXTUserInfo *userInfo = [[ANKeyValueTable userDefaultTable] valueWithKey:USERKEY];
    if (userInfo)
    {
        return userInfo;
    }
    else
    {
        return [[BXTUserInfo alloc] init];
    }
}

+ (BOOL)validateMobile:(NSString *)mobile
{
    NSString *mobileRegex = @"^(13[0-9]|14[0-9]|15[0-9]|18[0-9])\\d{8}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [mobileTest evaluateWithObject:mobile];
}

UIColor* colorWithHexString(NSString *stringToConvert)
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return [UIColor whiteColor];//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [UIColor whiteColor];
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.f];
}

@end
