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
#import "BXTPublicSetting.h"
#import "CommonCrypto/CommonDigest.h"

#define USERKEY @"UserInfo"

@implementation BXTGlobal

+ (BXTGlobal *)shareGlobal
{
    static BXTGlobal *bxtGlobal = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bxtGlobal = [[BXTGlobal alloc] init];
        bxtGlobal.newsOrderIDs = [NSMutableArray array];
        bxtGlobal.assignOrderIDs = [NSMutableArray array];
        bxtGlobal.numOfPresented = 0;
        bxtGlobal.assignNumber = 0;
        bxtGlobal.longTime = @"";
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
        area.stores = @[shop];
    }
    
    BXTDepartmentInfo *departmentInfo = [[BXTDepartmentInfo alloc] init];
    departmentInfo.dep_id = [dic objectForKey:@"department"];
    departmentInfo.department = [dic objectForKey:@"department_name"];
    [BXTGlobal setUserProperty:departmentInfo withKey:U_DEPARTMENT];
    
    BXTGroupingInfo *groupInfo = [[BXTGroupingInfo alloc] init];
    groupInfo.group_id = [dic objectForKey:@"subgroup"];
    groupInfo.subgroup = [dic objectForKey:@"subgroup_name"];
    [BXTGlobal setUserProperty:groupInfo withKey:U_GROUPINGINFO];
    
    [BXTGlobal shareGlobal].longTime = [dic objectForKey:@"long_time"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"long_time"] forKey:@"LongTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *userID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [BXTGlobal setUserProperty:userID withKey:U_BRANCHUSERID];
    
    BXTPostionInfo *roleInfo = [[BXTPostionInfo alloc] init];
    roleInfo.role_id = [dic objectForKey:@"role_id"];
    roleInfo.role = [dic objectForKey:@"role"];
    [BXTGlobal setUserProperty:roleInfo withKey:U_POSITION];
    
    [BXTGlobal setUserProperty:[dic objectForKey:@"username"] withKey:U_USERNAME];
    [BXTGlobal setUserProperty:[dic objectForKey:@"role_con"] withKey:U_ROLEARRAY];
    [BXTGlobal setUserProperty:[dic objectForKey:@"mobile"] withKey:U_MOBILE];
    [BXTGlobal setUserProperty:[dic objectForKey:@"is_verify"] withKey:U_IS_VERIFY];
    
    UINavigationController *nav;
    if ([[dic objectForKey:@"is_repair"] integerValue] == 1)
    {
        [BXTGlobal shareGlobal].isRepair = NO;
        BXTShopsHomeViewController *homeVC = [[BXTShopsHomeViewController alloc] init];
        nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    }
    else if ([[dic objectForKey:@"is_repair"] integerValue] == 2)
    {
        [BXTGlobal shareGlobal].isRepair = YES;
        BXTRepairHomeViewController *homeVC = [[BXTRepairHomeViewController alloc] init];
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

+ (BOOL)validateCAPTCHA:(NSString *)captcha
{
    NSString *captchaRegex = @"^\\d{4}$";
    NSPredicate *captchaTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", captchaRegex];
    return [captchaTest evaluateWithObject:captcha];
}

+ (BOOL)validateUserName:(NSString *)username
{
    NSString *usernameRegex = @"^([\u4e00-\u9fa5]+|([a-zA-Z]+\\s?)+)$";
    NSPredicate *usernamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",usernameRegex];
    return [usernamePredicate evaluateWithObject:username];
}

+ (BOOL)validatePassword:(NSString *)pw
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:pw];
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

+ (NSString *)transTimeWithDate:(NSDate *)date withType:(NSString *)timeType
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:timeType];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

CGFloat valueForDevice(CGFloat v1,CGFloat v2,CGFloat v3,CGFloat v4)
{
    CGFloat value;
    if (IS_IPHONE6P)
    {
        value = v1;
    }
    else if (IS_IPHONE6)
    {
        value = v2;
    }
    else if (IS_IPHONE5)
    {
        value = v3;
    }
    else
    {
        value = v4;
    }
    return value;
}

// 存数组方法
+ (void)writeFileWithfileName:(NSString *)filename Array:(NSMutableArray *)infom
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", filename]];
    [infom writeToFile:filePath atomically:YES];
}
// 取数组方法
+ (NSArray *)readFileWithfileName:(NSString *)filename
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", filename]];
    return [NSArray arrayWithContentsOfFile:filePath];
}

// 判断字符处是否为空
+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL)
    {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    
    if ([string isEqualToString:@"(null)"])
    {
        return YES;
    }
    
    return NO;
}

+ (UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

// 获取当月第一天最后一天的数组
+ (NSArray *)monthStartAndEnd
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger year = [components year];
    NSInteger month = [components month];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = range.length;
    
    NSString *startTime = [NSString stringWithFormat:@"%ld-%ld-1", (long)year, (long)month];
    NSString *endTime = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year, (long)month, (unsigned long)numberOfDaysInMonth];
    
    return [NSArray arrayWithObjects:startTime, endTime, nil];
}

// 获取当年第一天最后一天的数组
+ (NSArray *)yearStartAndEnd
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger year = [components year];
    
    NSString *startTime = [NSString stringWithFormat:@"%ld-1-1", (long)year];
    NSString *endTime = [NSString stringWithFormat:@"%ld-12-31",(long)year];
    
    return [NSArray arrayWithObjects:startTime, endTime, nil];
}

// 获取当日第一天最后一天的数组
+ (NSArray *)dayStartAndEnd
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    return [NSArray arrayWithObjects:dateStr, dateStr, nil];
}

+ (NSArray *)yearAndmonthAndDay
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSString *yearStr = [NSString stringWithFormat:@"%ld", (long)[components year]];
    NSString *monthStr = [NSString stringWithFormat:@"%ld", (long)[components month]];
    NSString *dayStr = [NSString stringWithFormat:@"%ld", (long)[components day]];
    return [NSArray arrayWithObjects:yearStr, monthStr, dayStr, nil];
}

+ (void)showText:(NSString *)text view:(UIView *)view completionBlock:(void (^)())completion {
    [MBProgressHUD hideHUDForView:view animated:YES];
    MBProgressHUD *showHud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:showHud];
    showHud.labelText = text;
    showHud.mode = MBProgressHUDModeText;
    [showHud showAnimated:YES whileExecutingBlock:^{
        sleep(1.5);
    } completionBlock:^{
        [showHud removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

+ (NSString *)md5:(NSString *)inPutText {
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
          
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

@end
