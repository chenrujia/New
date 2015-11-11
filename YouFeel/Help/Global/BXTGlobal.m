//
//  BXTGlobal.m
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTGlobal.h"
#import "ANKeyValueTable.h"
#import "IQKeyboardManager.h"
#import "BXTRepairHomeViewController.h"
#import "BXTShopsHomeViewController.h"
#import "AppDelegate.h"

#define USERKEY @"UserInfo"

@implementation BXTGlobal

+ (BXTGlobal *)shareGlobal
{
    static BXTGlobal *bxtGlobal = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bxtGlobal = [[BXTGlobal alloc] init];
        bxtGlobal.orderIDs = [NSMutableArray array];
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

- (void)reLoginWithDic:(NSDictionary *)dic
{
    NSArray *bindingAds = [dic objectForKey:@"binding_ads"];
    [BXTGlobal setUserProperty:bindingAds withKey:U_BINDINGADS];
    
    if (bindingAds.count)
    {
        NSDictionary *areaDic = bindingAds[0];
        BXTFloorInfo *floor = [[BXTFloorInfo alloc] init];
        floor.area_id = [areaDic objectForKey:@"area_id"];
        floor.area_name = [areaDic objectForKey:@"area_name"];
        [BXTGlobal setUserProperty:floor withKey:U_FLOOOR];
        
        BXTAreaInfo *area = [[BXTAreaInfo alloc] init];
        area.place_id = [areaDic objectForKey:@"place_id"];
        area.place_name = [areaDic objectForKey:@"place_name"];
        [BXTGlobal setUserProperty:area withKey:U_AREA];
        
        BXTShopInfo *shop = [[BXTShopInfo alloc] init];
        shop.stores_id = [areaDic objectForKey:@"stores_id"];
        shop.stores_name = [areaDic objectForKey:@"stores_name"];
        [BXTGlobal setUserProperty:shop withKey:U_SHOP];
    }
    
    BXTDepartmentInfo *departmentInfo = [[BXTDepartmentInfo alloc] init];
    departmentInfo.dep_id = [dic objectForKey:@"department"];
    departmentInfo.department = [dic objectForKey:@"department_name"];
    [BXTGlobal setUserProperty:departmentInfo withKey:U_DEPARTMENT];
    
    BXTGroupingInfo *groupInfo = [[BXTGroupingInfo alloc] init];
    groupInfo.group_id = [dic objectForKey:@"subgroup"];
    groupInfo.subgroup = [dic objectForKey:@"subgroup_name"];
    [BXTGlobal setUserProperty:groupInfo withKey:U_GROUPINGINFO];
    
    NSString *userID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [BXTGlobal setUserProperty:userID withKey:U_BRANCHUSERID];
    
    BXTPostionInfo *roleInfo = [[BXTPostionInfo alloc] init];
    roleInfo.role_id = [dic objectForKey:@"role_id"];
    roleInfo.role = [dic objectForKey:@"role"];
    [BXTGlobal setUserProperty:roleInfo withKey:U_POSITION];
    
    [BXTGlobal setUserProperty:[dic objectForKey:@"username"] withKey:U_USERNAME];
    [BXTGlobal setUserProperty:[dic objectForKey:@"role_con"] withKey:U_ROLEARRAY];
    [BXTGlobal setUserProperty:[dic objectForKey:@"mobile"] withKey:U_MOBILE];
    
    UINavigationController *nav;
    if ([[dic objectForKey:@"is_repair"] integerValue] == 1)
    {
        BXTShopsHomeViewController *homeVC = [[BXTShopsHomeViewController alloc] initWithIsRepair:NO];
        nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    }
    else if ([[dic objectForKey:@"is_repair"] integerValue] == 2)
    {
        BXTRepairHomeViewController *homeVC = [[BXTRepairHomeViewController alloc] initWithIsRepair:YES];
        nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    }
    nav.navigationBar.hidden = YES;
    [AppDelegate appdelegete].window.rootViewController = nav;
}

+ (BOOL)validateMobile:(NSString *)mobile
{
    NSString *mobileRegex = @"^(13[0-9]|14[0-9]|15[0-9]|17[0-9]|18[0-9])\\d{8}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [mobileTest evaluateWithObject:mobile];
}

- (void)enableForIQKeyBoard:(BOOL)enable
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = enable;
    manager.shouldResignOnTouchOutside = enable;
    manager.shouldToolbarUsesTextFieldTintColor = enable;
    manager.enableAutoToolbar = enable;
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

+ (NSString *)transformationTime:(NSString *)timeType withTime:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:timeType];
    NSString *str = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[time integerValue]]]];
    return str;
}

@end
