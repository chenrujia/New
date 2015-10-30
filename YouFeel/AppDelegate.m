//
//  AppDelegate.m
//  YouFeel
//
//  Created by Jason on 15/10/10.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "AppDelegate.h"
#import "BXTHeaderFile.h"
#import "NSString+URL.h"
#import "BXTLoginViewController.h"
#import "UINavigationController+YRBackGesture.h"
#import "BXTShopsHomeViewController.h"
#import "BXTRepairHomeViewController.h"
#import "BXTGrabOrderViewController.h"
#import "BXTHeadquartersViewController.h"

NSString* const NotificationCategoryIdent  = @"ACTIONABLE";
NSString* const NotificationActionOneIdent = @"ACTION_ONE";
NSString* const NotificationActionTwoIdent = @"ACTION_TWO";

#define RONGCLOUD_IM_APPKEY @"3argexb6rvfoe"

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
    //新的SDK不允许在设置rootViewController之前做过于复杂的操作,So.....坑
    UIViewController* myvc = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = myvc;
    
    //初始化融云SDK
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
    //自动键盘
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:YES];
    //默认自动登录
    if ([BXTGlobal getUserProperty:U_USERNAME] && [BXTGlobal getUserProperty:U_PASSWORD] && [BXTGlobal getUserProperty:U_CLIENTID])
    {
        NSDictionary *userInfoDic = @{@"username":[BXTGlobal getUserProperty:U_USERNAME],@"password":[BXTGlobal getUserProperty:U_PASSWORD],@"cid":[BXTGlobal getUserProperty:U_CLIENTID]};
        
        BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
        [dataRequest loginUser:userInfoDic];
    }
    else
    {
        [self loadingLoginVC];
    }

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    
    // [2]:注册APNS
    [self registerRemoteNotification];
    
    // [2-EXT]: 获取启动时收到的APN数据
//    NSDictionary *message=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    NSString *payloadMsg = [message objectForKey:@"payload"];
//    LogRed(@"payloadMsg:%@",payloadMsg);
//    if (payloadMsg)
//    {
//        #warning 记得改。。。
//        [[BXTGlobal shareGlobal].orderIDs addObject:payloadMsg];
//    }
    
    //统一导航条样式
    UIFont *font = [UIFont systemFontOfSize:19.f];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName : font,
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]
     setBarTintColor:colorWithHexString(@"042a5f")];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessageNotification:) name:RCKitDispatchMessageNotification object:nil];
    //设置会话列表头像和会话界面头像
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    
    return YES;
}

- (void)loadingLoginVC
{
    BXTLoginViewController *loginVC = [[BXTLoginViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:loginVC];
    navigation.navigationBar.hidden = YES;
    navigation.enableBackGesture = YES;
    self.window.rootViewController = navigation;
}

/**
 *  注册通知
 */
- (void)registerRemoteNotification
{
    if (IS_IOS_8)
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
    LogRed(@"deviceToken:%@",_deviceToken);

    [GeTuiSdk registerDeviceToken:_deviceToken];
    [[RCIMClient sharedRCIMClient] setDeviceToken:_deviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    [GeTuiSdk registerDeviceToken:@""];
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
    NSRange startRange = [record rangeOfString:@"{"];
    NSRange endRange = [record rangeOfString:@"}"];
    
    NSString *dicStr = [record substringWithRange:NSMakeRange(startRange.location, endRange.location - startRange.location + 1)];
    NSDictionary *taskInfo = [dicStr JSONValue];
    
    NSString *shop_id = [taskInfo objectForKey:@"shop_id"];
    [BXTGlobal shareGlobal].newsShopID = shop_id;
    [[BXTGlobal shareGlobal].orderIDs addObject:[taskInfo objectForKey:@"about_id"]];
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    //如果该条消息不是该项目的
    if (![shop_id isEqualToString:companyInfo.company_id])
    {
        NSArray *my_shops = [BXTGlobal getUserProperty:U_MYSHOP];
        NSString *shop_name;
        for (NSDictionary *dic in my_shops)
        {
            if ([[dic objectForKey:@"id"] isEqualToString:shop_id])
            {
                shop_name = [dic objectForKey:@"shop_name"];
                break;
            }
        }
        if (IS_IOS_8)
        {
            UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您有来自%@的新消息，是否立即查看？",shop_name] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"稍后查看" style:UIAlertActionStyleCancel handler:nil];
            [alertCtr addAction:cancelAction];
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"立即查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                BXTHeadquartersViewController *headVC = [[BXTHeadquartersViewController alloc] initWithType:YES];
                UINavigationController *navigation = (UINavigationController *)self.window.rootViewController;
                [navigation pushViewController:headVC animated:YES];
            }];
            [alertCtr addAction:doneAction];
            [self.window.rootViewController presentViewController:alertCtr animated:YES completion:nil];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要取消此工单?"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
            [alert show];
        }
        return;
    }
    switch ([[taskInfo objectForKey:@"notice_type"] integerValue])
    {
        case 1://系统消息
            
            break;
        case 2://工单消息
            if ([[taskInfo objectForKey:@"event_type"] integerValue] == 1)//收到抢单信息
            {
                if ([self.window.rootViewController isKindOfClass:[UINavigationController class]])
                {
                    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
                    if ([nav.viewControllers.lastObject isKindOfClass:[BXTGrabOrderViewController class]])
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewRepairAgain" object:nil];
                    }
                    else
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewRepairComing" object:nil];
                    }
                }
            }
            else if ([[taskInfo objectForKey:@"event_type"] integerValue] == 2)//收到派工或者维修邀请
            {
                
            }
            else if ([[taskInfo objectForKey:@"event_type"] integerValue] == 3)//抢单后或者确认通知后回馈报修者到达时间
            {
                
            }
            else if ([[taskInfo objectForKey:@"event_type"] integerValue] == 4)//维修完成后通知后报修者
            {
                
            }
            else//维修者获取好评
            {
//                if (IS_IOS_8)
//                {
//                    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",[taskInfo objectForKey:@"title"]] message:nil preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//                    [alertCtr addAction:cancelAction];
//                    [self.window.rootViewController presentViewController:alertCtr animated:YES completion:nil];
//                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//                }
//                else
//                {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",[taskInfo objectForKey:@"title"]]
//                                                                    message:nil
//                                                                   delegate:self
//                                                          cancelButtonTitle:@"取消"
//                                                          otherButtonTitles:nil];
//                    [alert show];
//                }
            }
            break;
        case 3://通知
            
            break;
        case 4://预警
            
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsComing" object:@"1"];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    LogRed(@"task id : %@",taskId);
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        BXTHeadquartersViewController *headVC = [[BXTHeadquartersViewController alloc] initWithType:YES];
        UINavigationController *navigation = (UINavigationController *)self.window.rootViewController;
        [navigation pushViewController:headVC animated:YES];
    }
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
        [BXTGlobal setUserProperty:[userInfoDic objectForKey:@"im_token"] withKey:U_IMTOKEN];
        
        NSArray *shopids = [userInfoDic objectForKey:@"shop_ids"];
        [BXTGlobal setUserProperty:shopids withKey:U_SHOPIDS];
        
        NSArray *my_shop = [userInfoDic objectForKey:@"my_shop"];
        [BXTGlobal setUserProperty:my_shop withKey:U_MYSHOP];
        if (my_shop && my_shop.count > 0)
        {
            NSDictionary *shopsDic = my_shop[0];
            NSString *shopID = [shopsDic objectForKey:@"id"];
            NSString *shopName = [shopsDic objectForKey:@"shop_name"];
            BXTHeadquartersInfo *companyInfo = [[BXTHeadquartersInfo alloc] init];
            companyInfo.company_id = shopID;
            companyInfo.name = shopName;
            [BXTGlobal setUserProperty:companyInfo withKey:U_COMPANY];
            NSString *url = [NSString stringWithFormat:@"http://api.51bxt.com/?c=Port&m=actionGet_iPhone_v2_Port&shop_id=%@",shopID];
            [BXTGlobal shareGlobal].baseURL = url;
            
            NSString *userID = [NSString stringWithFormat:@"%@",[userInfoDic objectForKey:@"id"]];
            [BXTGlobal setUserProperty:userID withKey:U_USERID];
            
            /**分店登录**/
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request branchLogin];
        }
        else
        {
            [self loadingLoginVC];
        }
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
    else
    {
        [self loadingLoginVC];
    }
}

- (void)requestError:(NSError *)error
{
    [self loadingLoginVC];
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

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status
{
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的帐号在别的设备上登录，您被迫下线！" delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        BXTLoginViewController *loginVC = [[BXTLoginViewController alloc] init];
        UINavigationController *_navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = _navi;
    }
}

- (void)didReceiveMessageNotification:(NSNotification *)notification
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsComing" object:@"2"];
    });
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [GeTuiSdk resume];  // 恢复个推SDK运行
//    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // [EXT] APP进入后台时，通知个推SDK进入后台
    [GeTuiSdk enterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
