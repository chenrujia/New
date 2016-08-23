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
#import "CYLTabBarControllerConfig.h"
#import <CommonCrypto/CommonDigest.h>
#import "BXTSubgroupInfo.h"
#import "sys/utsname.h"

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
        bxtGlobal.energyColors = @[@"f45b5b", @"1683e2", @"f5c809", @"f1983e"];
        bxtGlobal.energyType = 1;
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

- (void)branchLoginWithDic:(NSDictionary *)dic isPushToRootVC:(BOOL)isPushToRootVC
{
    [BXTBranchUserInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"userID":@"id"};
    }];
    BXTBranchUserInfo *branchUser = [BXTBranchUserInfo mj_objectWithKeyValues:dic];
    [BXTGlobal setUserProperty:branchUser.userID withKey:U_BRANCHUSERID];
    [BXTGlobal setUserProperty:branchUser.permission_keys withKey:PERMISSIONKEYS];
    
    // Yes是维修员，No是报修者
    [BXTGlobal shareGlobal].isRepair = branchUser.is_repair == 2;
    // 显示抄表权限
    [BXTGlobal shareGlobal].isEnergy = branchUser.is_energy == 1;
    // 处于登录状态
    [BXTGlobal shareGlobal].isLogin = YES;
    
    // 专业分组
    [BXTSubgroupInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"subgroupID":@"id"};
    }];
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    [dataSource addObjectsFromArray:[BXTSubgroupInfo mj_objectArrayWithKeyValuesArray:branchUser.my_subgroup]];
    [[ANKeyValueTable userDefaultTable] setValue:dataSource withKey:MYSUBGROUPSAVE];
    [[ANKeyValueTable userDefaultTable] synchronize:YES];
    
    BXTPostionInfo *roleInfo = [[BXTPostionInfo alloc] init];
    roleInfo.role_id = branchUser.duty_id;
    roleInfo.duty_name = branchUser.duty_name;
    
    if (isPushToRootVC)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHYSAVEDSHOPID" object:nil];
        
        CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
        [[AppDelegate appdelegete].window setRootViewController:tabBarControllerConfig.tabBarController];
    }
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

+ (NSString *)transTimeStampWithTime:(NSString *)time withType:(NSString *)timeType
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:timeType];
    NSDate *date = [formatter dateFromString:time];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
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

// 获取开始时间与结束时间 时间戳
+ (NSArray *)transTimeToWhatWeNeed:(NSArray *)timeArray
{
    NSString *begainTime = [NSString stringWithFormat:@"%@ 00:00:00", timeArray[0]];
    NSString *endTime = [NSString stringWithFormat:@"%@ 23:59:59", timeArray[1]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *begainDate = [dateFormatter dateFromString:begainTime];
    NSString *filterOfTimeBegain = [NSString stringWithFormat:@"%ld", (long)[begainDate timeIntervalSince1970]];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    NSString *filterOfTimeEnd = [NSString stringWithFormat:@"%ld", (long)[endDate timeIntervalSince1970]];
    
    return [NSArray arrayWithObjects:filterOfTimeBegain, filterOfTimeEnd, nil];
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
    
    NSString *startTime = [NSString stringWithFormat:@"%ld-%2.ld-01", (long)year, (long)month];
    NSString *endTime = [NSString stringWithFormat:@"%ld-%2.ld-%2.ld",(long)year, (long)month, (unsigned long)numberOfDaysInMonth];
    
    return [NSArray arrayWithObjects:startTime, endTime, nil];
}

// 获取当年第一天最后一天的数组
+ (NSArray *)yearStartAndEnd
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger year = [components year];
    
    NSString *startTime = [NSString stringWithFormat:@"%ld-01-01", (long)year];
    NSString *endTime = [NSString stringWithFormat:@"%ld-12-31",(long)year];
    
    return [NSArray arrayWithObjects:startTime, endTime, nil];
}

// 获取当日第一天最后一天的数组
+ (NSArray *)dayStartAndEnd
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    return [NSArray arrayWithObjects:dateStr, dateStr, nil];
}

// 获取几天前及今天的数组
+ (NSArray *)dayOfCountStartAndEnd:(NSInteger)count
{
    NSInteger timeInterval = (count - 1) * 24 * 60 * 60;
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSInteger newTime = now - timeInterval;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:newTime];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *beforeDateStr = [formatter stringFromDate:newDate];
    
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    return [NSArray arrayWithObjects:beforeDateStr, dateStr, nil];
}

// 获取周一到今天的数组
+ (NSArray *)weekdayStartAndEnd
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:[NSDate date]];
    NSLog(@"%ld", (long)theComponents.weekday-1);
    
    return [self dayOfCountStartAndEnd:theComponents.weekday-1];
}

// 获取年月日数组
+ (NSArray *)yearAndmonthAndDay
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSString *yearStr = [NSString stringWithFormat:@"%ld", (long)[components year]];
    NSString *monthStr = [NSString stringWithFormat:@"%ld", (long)[components month]];
    NSString *dayStr = [NSString stringWithFormat:@"%ld", (long)[components day]];
    return [NSArray arrayWithObjects:yearStr, monthStr, dayStr, nil];
}

+ (void)showLoadingMBP:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)hideMBP
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

+ (void)showText:(NSString *)text view:(UIView *)view completionBlock:(void (^)())completion
{
    [MBProgressHUD hideHUDForView:view animated:YES];
    MBProgressHUD *showHud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:showHud];
    showHud.label.text = text;
    showHud.mode = MBProgressHUDModeText;
    [showHud showAnimated:YES];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [showHud removeFromSuperview];
        if (completion) {
            completion();
        }
    });
}

+ (NSString *)md5:(NSString *)inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

#pragma mark -
#pragma mark - 富文本转化
+ (NSMutableAttributedString *)transToRichLabelOfIndex:(NSInteger)index String:(NSString *)originStr
{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:originStr];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:colorWithHexString(CellContentColorStr)
                          range:NSMakeRange(index, originStr.length - index)];
    return AttributedStr;
}

- (NSString*)deviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])
    {
        return @"iPhone 1G";
    }
    else if ([deviceString isEqualToString:@"iPhone1,2"])
    {
        return @"iPhone 3G";
    }
    else if ([deviceString isEqualToString:@"iPhone2,1"])
    {
        return @"iPhone 3GS";
    }
    else if ([deviceString isEqualToString:@"iPhone3,1"])
    {
        return @"iPhone 4";
    }
    else if ([deviceString isEqualToString:@"iPhone3,2"])
    {
        return @"Verizon iPhone 4";
    }
    else if ([deviceString isEqualToString:@"iPhone4,1"])
    {
        return @"iPhone 4S";
    }
    else if ([deviceString isEqualToString:@"iPhone5,1"])
    {
        return @"iPhone 5";
    }
    else if ([deviceString isEqualToString:@"iPhone5,2"])
    {
        return @"iPhone 5";
    }
    else if ([deviceString isEqualToString:@"iPhone5,3"])
    {
        return @"iPhone 5C";
    }
    else if ([deviceString isEqualToString:@"iPhone5,4"])
    {
        return @"iPhone 5C";
    }
    else if ([deviceString isEqualToString:@"iPhone6,1"])
    {
        return @"iPhone 5S";
    }
    else if ([deviceString isEqualToString:@"iPhone6,2"])
    {
        return @"iPhone 5S";
    }
    else if ([deviceString isEqualToString:@"iPhone7,1"])
    {
        return @"iPhone 6 Plus";
    }
    else if ([deviceString isEqualToString:@"iPhone7,2"])
    {
        return @"iPhone 6";
    }
    else if ([deviceString isEqualToString:@"iPhone8,1"])
    {
        return @"iPhone 6s";
    }
    else if ([deviceString isEqualToString:@"iPhone8,2"])
    {
        return @"iPhone 6s Plus";
    }
    else if ([deviceString isEqualToString:@"iPod1,1"])
    {
        return @"iPod Touch 1G";
    }
    else if ([deviceString isEqualToString:@"iPod2,1"])
    {
        return @"iPod Touch 2G";
    }
    else if ([deviceString isEqualToString:@"iPod3,1"])
    {
        return @"iPod Touch 3G";
    }
    else if ([deviceString isEqualToString:@"iPod4,1"])
    {
        return @"iPod Touch 4G";
    }
    else if ([deviceString isEqualToString:@"iPod5,1"])
    {
        return @"iPod Touch 5G";
    }
    else if ([deviceString isEqualToString:@"iPad1,1"])
    {
        return @"iPad";
    }
    else if ([deviceString isEqualToString:@"iPad2,1"])
    {
        return @"iPad 2 (WiFi)";
    }
    else if ([deviceString isEqualToString:@"iPad2,2"])
    {
        return @"iPad 2 (GSM)";
    }
    else if ([deviceString isEqualToString:@"iPad2,3"])
    {
        return @"iPad 2 (CDMA)";
    }
    else if ([deviceString isEqualToString:@"iPad2,4"])
    {
        return @"iPad 2 (32nm)";
    }
    else if ([deviceString isEqualToString:@"iPad2,5"])
    {
        return @"iPad mini (WiFi)";
    }
    else if ([deviceString isEqualToString:@"iPad2,6"])
    {
        return @"iPad mini (GSM)";
    }
    else if ([deviceString isEqualToString:@"iPad2,7"])
    {
        return @"iPad mini (CDMA)";
    }
    else if ([deviceString isEqualToString:@"iPad3,1"])
    {
        return @"iPad 3(WiFi)";
    }
    else if ([deviceString isEqualToString:@"iPad3,2"])
    {
        return @"iPad 3(CDMA)";
    }
    else if ([deviceString isEqualToString:@"iPad3,3"])
    {
        return @"iPad 3(4G)";
    }
    else if ([deviceString isEqualToString:@"iPad3,4"])
    {
        return @"iPad 4 (WiFi)";
    }
    else if ([deviceString isEqualToString:@"iPad3,5"])
    {
        return @"iPad 4 (4G)";
    }
    else if ([deviceString isEqualToString:@"iPad3,6"])
    {
        return @"iPad 4 (CDMA)";
    }
    else if ([deviceString isEqualToString:@"iPad4,1"])
    {
        return @"iPad Air";
    }
    else if ([deviceString isEqualToString:@"iPad4,2"])
    {
        return @"iPad Air";
    }
    else if ([deviceString isEqualToString:@"iPad4,3"])
    {
        return @"iPad Air";
    }
    else if ([deviceString isEqualToString:@"iPad5,3"])
    {
        return @"iPad Air 2";
    }
    else if ([deviceString isEqualToString:@"iPad5,4"])
    {
        return @"iPad Air 2";
    }
    else if ([deviceString isEqualToString:@"i386"])
    {
        return @"Simulator";
    }
    else if ([deviceString isEqualToString:@"x86_64"])
    {
        return @"Simulator";
    }
    else if ([deviceString isEqualToString:@"iPad4,4"] || [deviceString isEqualToString:@"iPad4,5"] || [deviceString isEqualToString:@"iPad4,6"])
    {
        return @"iPad mini 2";
    }
    else if ([deviceString isEqualToString:@"iPad4,7"]||[deviceString isEqualToString:@"iPad4,8"]||[deviceString isEqualToString:@"iPad4,9"])  return @"iPad mini 3";
    {
        return deviceString;
    }
    return @"";
}

@end
