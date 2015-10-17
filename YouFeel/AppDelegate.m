//
//  AppDelegate.m
//  YouFeel
//
//  Created by Jason on 15/10/10.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "AppDelegate.h"
#import "BXTHeaderFile.h"
#import "BXTLoginViewController.h"
#import "UINavigationController+YRBackGesture.h"
#import "IQKeyboardManager.h"
#import "BXTShopsHomeViewController.h"
#import "BXTRepairHomeViewController.h"

NSString* const NotificationCategoryIdent  = @"ACTIONABLE";
NSString* const NotificationActionOneIdent = @"ACTION_ONE";
NSString* const NotificationActionTwoIdent = @"ACTION_TWO";

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)appdelegete
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //自动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    //默认自动登录
    if ([BXTGlobal getUserProperty:U_USERNAME] && [BXTGlobal getUserProperty:U_PASSWORD] && [BXTGlobal getUserProperty:U_CLIENTID])
    {
        NSDictionary *userInfoDic = @{@"username":[BXTGlobal getUserProperty:U_USERNAME],@"password":[BXTGlobal getUserProperty:U_PASSWORD],@"cid":[BXTGlobal getUserProperty:U_CLIENTID]};
        
        BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
        [dataRequest loginUser:userInfoDic];
    }
    else
    {
        BXTLoginViewController *loginVC = [[BXTLoginViewController alloc] init];
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:loginVC];
        navigation.navigationBar.hidden = YES;
        navigation.enableBackGesture = YES;
        self.window.rootViewController = navigation;
    }

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    
    // [2]:注册APNS
    [self registerRemoteNotification];
    
    // [2-EXT]: 获取启动时收到的APN数据
    NSDictionary *message=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSString *payloadMsg = [message objectForKey:@"payload"];
    LogRed(@"payloadMsg:%@",payloadMsg);
//    if (payloadMsg)
//    {
//        #warning 记得改。。。
//        [[BXTGlobal shareGlobal].orderIDs addObject:payloadMsg];
//    }
    
    return YES;
}

/**
 *  注册通知
 */
- (void)registerRemoteNotification
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        //IOS8 新的通知机制category注册
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"取消"];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:@"回复"];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:NotificationCategoryIdent];
        [actionCategory setActions:@[action1, action2]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                        UIUserNotificationTypeSound|
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                       UIRemoteNotificationTypeSound|
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                   UIRemoteNotificationTypeSound|
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
    
}

/**
 *  启动SDK ，并设置后台开关和电子围栏开关
 */
- (void)startSdkWith:(NSString *)appID appKey:(NSString*)appKey appSecret:(NSString *)appSecret
{
    NSError *err =nil;
    //[1-1]:通过 AppId、appKey 、appSecret 启动SDK
    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:self error:&err];
    //[1-2]:设置是否后台运行开关
    [GeTuiSdk runBackgroundEnable:YES];
    //[1-3]:设置地理围栏功能，开启LBS定位服务和是否允许SDK 弹出用户定位请求，请求NSLocationAlwaysUsageDescription权限,如果UserVerify设置为NO，需第三方负责提示用户定位授权。
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
}

/**
 *  向服务器注册DeviceToken
 */
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken:%@",_deviceToken);

    [GeTuiSdk registerDeviceToken:_deviceToken];
}

/**
 *  个推SDK支持用户设置标签，标示一组标签用户，可以针对标签用户进行推送。
 */
+ (BOOL)setTags:(NSArray *)tags
{
    return [GeTuiSdk setTags:tags];
}

/**
 *  个推SDK支持绑定别名功能
 */
- (void)bindAlias:(NSString *)aAlias
{
    [GeTuiSdk bindAlias:aAlias];
}

- (void)unbindAlias:(NSString *)aAlias
{
    [GeTuiSdk unbindAlias:aAlias];
}

#pragma mark -
#pragma 个推代理
/**
 *  SDK启动成功返回CID
 */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId  // SDK 返回clientid
{
    LogRed(@"clientId:%@",clientId);
    [BXTGlobal setUserProperty:clientId withKey:U_CLIENTID];
    if (_deviceToken)
    {
        [GeTuiSdk registerDeviceToken:_deviceToken];
    }
}

/**
 *  SDK收到透传消息回调
 */
- (void)GeTuiSdkDidReceivePayload:(NSString*)payloadId andTaskId:(NSString*)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId
{
    _payloadId = payloadId;
    
    NSData *payload = [GeTuiSdk retrivePayloadById:payloadId]; //根据payloadId取回Payload
    NSString *payloadMsg = nil;
    
    if (payload)
    {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
    }
    
    NSString *record = [NSString stringWithFormat:@"%ld, %@, %@",(long)++_lastPayloadIndex, [self formateTime:[NSDate date]], payloadMsg];
#warning 记得改。。。
    [[BXTGlobal shareGlobal].orderIDs addObject:taskId];
    LogBlue(@"1count......%lu",(unsigned long)[BXTGlobal shareGlobal].orderIDs.count);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewRepairComing" object:nil];
    LogRed(@"record  %@, task id : %@, messageId:%@",record, taskId, aMsgId);
}

/**
 *  SDK收到sendMessage消息回调   发送上行消息结果反馈
 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result
{
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    NSLog(@"record  %@",record);
}

/**
 *  SDK遇到错误回调
 *  个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
 */
- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    LogRed(@"error%@",[error localizedDescription]);
}

/**
 *  SDK运行状态通知
 *
 *  SdkStatusStarting // 正在启动
 *  SdkStatusStarted // 启动
 *  SdkStatusStoped // 停止
 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus
{
    _sdkStatus = aStatus;
}

/**
 *  BXTDataResponseDelegate
 */
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSLog(@"%@", response);
    NSDictionary *dic = response;
    if (type == LoginType && [[dic objectForKey:@"returncode"] isEqualToString:@"0"])
    {
        NSArray *dataArray = [dic objectForKey:@"data"];
        NSDictionary *userInfoDic = [dataArray objectAtIndex:0];
        
        [BXTGlobal setUserProperty:[userInfoDic objectForKey:@"gender"] withKey:U_SEX];
        [BXTGlobal setUserProperty:[userInfoDic objectForKey:@"name"] withKey:U_NAME];
        [BXTGlobal setUserProperty:[userInfoDic objectForKey:@"pic"] withKey:U_HEADERIMAGE];
        
        NSArray *shopids = [userInfoDic objectForKey:@"shop_ids"];
        [BXTGlobal setUserProperty:shopids withKey:U_SHOPIDS];
        
        NSArray *my_shop = [userInfoDic objectForKey:@"my_shop"];
        [BXTGlobal setUserProperty:my_shop withKey:U_MYSHOP];
#warning 空的情况
        NSDictionary *shopsDic = my_shop[0];
        NSString *shopID = [shopsDic objectForKey:@"id"];
        NSString *shopName = [shopsDic objectForKey:@"shop_name"];
        BXTHeadquartersInfo *companyInfo = [[BXTHeadquartersInfo alloc] init];
        companyInfo.company_id = shopID;
        companyInfo.name = shopName;
        [BXTGlobal setUserProperty:companyInfo withKey:U_COMPANY];
        NSString *url = [NSString stringWithFormat:@"http://api.91eng.com/?c=Port&m=actionGet_Android_v2_Port&shop_id=%@",shopID];
        [BXTGlobal shareGlobal].baseURL = url;
        
        NSString *userID = [NSString stringWithFormat:@"%@",[userInfoDic objectForKey:@"id"]];
        [BXTGlobal setUserProperty:userID withKey:U_USERID];
        
        /**分店登录**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request branchLogin];
    }
    else if (type == BranchLogin && [[dic objectForKey:@"returncode"] isEqualToString:@"0"])
    {
        NSArray *data = [dic objectForKey:@"data"];
        if (data.count > 0)
        {
            NSDictionary *userInfo = data[0];
            
            NSArray *bindingAds = [userInfo objectForKey:@"binding_ads"];
            [BXTGlobal setUserProperty:bindingAds withKey:U_BINDINGADS];
            
            BXTDepartmentInfo *departmentInfo = [[BXTDepartmentInfo alloc] init];
            departmentInfo.dep_id = [userInfo objectForKey:@"department"];
            departmentInfo.department = [userInfo objectForKey:@"department_name"];
            [BXTGlobal setUserProperty:departmentInfo withKey:U_DEPARTMENT];
            
            BXTGroupingInfo *groupInfo = [[BXTGroupingInfo alloc] init];
            groupInfo.group_id = [userInfo objectForKey:@"subgroup"];
            groupInfo.subgroup = [userInfo objectForKey:@"subgroup_name"];
            [BXTGlobal setUserProperty:groupInfo withKey:U_GROUPINGINFO];
            
            NSString *userID = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
            [BXTGlobal setUserProperty:userID withKey:U_BRANCHUSERID];
            
            BXTPostionInfo *roleInfo = [[BXTPostionInfo alloc] init];
            roleInfo.role_id = [userInfo objectForKey:@"role_id"];
            roleInfo.role = [userInfo objectForKey:@"role"];
            [BXTGlobal setUserProperty:roleInfo withKey:U_POSITION];
            
            BXTShopInfo *shopInfo = [[BXTShopInfo alloc] init];
            shopInfo.stores_id = [userInfo objectForKey:@"stores_id"];
            shopInfo.stores_name = [userInfo objectForKey:@"stores"];
            [BXTGlobal setUserProperty:shopInfo withKey:U_SHOP];
            
            [BXTGlobal setUserProperty:[userInfo objectForKey:@"username"] withKey:U_USERNAME];
            [BXTGlobal setUserProperty:[userInfo objectForKey:@"role_con"] withKey:U_ROLEARRAY];
            [BXTGlobal setUserProperty:[userInfo objectForKey:@"mobile"] withKey:U_MOBILE];
            
            UINavigationController *nav;
            if ([[userInfo objectForKey:@"is_repair"] integerValue] == 1)
            {
                BXTShopsHomeViewController *homeVC = [[BXTShopsHomeViewController alloc] initWithIsRepair:NO];
                nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
            }
            else if ([[userInfo objectForKey:@"is_repair"] integerValue] == 2)
            {
                BXTRepairHomeViewController *homeVC = [[BXTRepairHomeViewController alloc] initWithIsRepair:YES];
                nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
            }
            nav.navigationBar.hidden = YES;
            [AppDelegate appdelegete].window.rootViewController = nav;
        }
    }
}

- (void)requestError:(NSError *)error
{
    
}

- (NSString*)formateTime:(NSDate*)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString* dateTime = [formatter stringFromDate:date];
    return dateTime;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [GeTuiSdk resume];  // 恢复个推SDK运行
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    [GeTuiSdk registerDeviceToken:@""];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // [EXT] APP进入后台时，通知个推SDK进入后台
    [GeTuiSdk enterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
