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
#import "CrashManager.h"
#import "MobClick.h"
#import "BXTLoginViewController.h"
#import "BXTHeadquartersViewController.h"
#import "UINavigationController+YRBackGesture.h"

NSString* const NotificationCategoryIdent  = @"ACTIONABLE";
NSString* const NotificationActionOneIdent = @"ACTION_ONE";
NSString* const NotificationActionTwoIdent = @"ACTION_TWO";

#define RONGCLOUD_IM_APPKEY @"ik1qhw091jstp"

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
    
    
    // token验证失败 - 退出登录
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"VERIFY_TOKEN_FAIL" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self loadingLoginVC];
    }];
    
    
    BOOL isLoaded = [[NSUserDefaults standardUserDefaults] boolForKey:@"LoadedGuideView"];
    if (isLoaded)
    {
        //默认自动登录
        if ([BXTGlobal getUserProperty:U_USERNAME] && [BXTGlobal getUserProperty:U_PASSWORD] && [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"])
        {
            NSDictionary *userInfoDic = @{@"username":[BXTGlobal getUserProperty:U_USERNAME],@"password":[BXTGlobal getUserProperty:U_PASSWORD],@"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"]};
            
            BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
            [dataRequest loginUser:userInfoDic];
        }
        else
        {
            [self loadingLoginVC];
        }
    }
    else
    {
        [self loadingGuideView];
    }
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    
    // [2]:注册APNS
    [self registerRemoteNotification];
    
    // [3]:友盟配置
    [MobClick startWithAppkey:@"566e7c1867e58e7160002af5" reportPolicy:BATCH channelId:nil];
    
    
    //统一导航条样式
    UIFont *font = [UIFont systemFontOfSize:19.f];
    NSDictionary *textAttributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:RCKitDispatchMessageNotification object:nil] subscribeNext:^(id x) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    }];
    
    
    //设置会话列表头像和会话界面头像
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    
    
    //注册消息处理函数的处理方法,处理崩溃信息,写入本地
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    
    CrashManager *crashManager = [CrashManager defaultManager];
    //Crash日志
    if ([crashManager isCrashLog])
    {
        NSString *crashString = [crashManager crashLogContent];//Crash日志内容
        LogRed(@"crashString = %@",crashString);//
    }
    [crashManager clearCrashLog];//清除Crash日志
    
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

- (void)loadingGuideView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.window.bounds];;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 5, SCREEN_HEIGHT);
    [self.window.rootViewController.view addSubview:scrollView];
    
    NSString *tempValue = @"iphone4";
    if (IS_IPHONE6P)
    {
        tempValue = @"plus";
    }
    else if (IS_IPHONE6)
    {
        tempValue = @"iphone6";
    }
    else if (IS_IPHONE5)
    {
        tempValue = @"iphone5";
    }
    
    for (NSInteger i = 1; i < 6; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i - 1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_%ld_%@",(long)i,tempValue]];
        [scrollView addSubview:imageView];
        
        if (i == 5)
        {
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap)];
            [imageView addGestureRecognizer:tapGesture];
        }
    }
}

- (void)imageViewTap
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoadedGuideView"];
    [self loadingLoginVC];
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
- (void)startSdkWith:(NSString *)appID
              appKey:(NSString*)appKey
           appSecret:(NSString *)appSecret
{
    //[1-1]:通过 AppId、appKey 、appSecret 启动SDK
    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:self];
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
    [[NSUserDefaults standardUserDefaults] setObject:clientId forKey:@"clientId"];
    if (_deviceToken)
    {
        [GeTuiSdk registerDeviceToken:_deviceToken];
    }
}

/**
 *  SDK收到透传消息回调
 */
- (void)GeTuiSdkDidReceivePayload:(NSString*)payloadId
                        andTaskId:(NSString*)taskId
                     andMessageId:(NSString *)aMsgId
                  fromApplication:(NSString *)appId
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
    LogRed(@"通知:%@",taskInfo);
    NSString *shop_id = [taskInfo objectForKey:@"shop_id"];
    [BXTGlobal shareGlobal].newsShopID = shop_id;
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    //如果该条消息不是该项目的
    if (![shop_id isEqualToString:companyInfo.company_id])
    {
        NSArray *my_shops = [BXTGlobal getUserProperty:U_MYSHOP];
        NSString *shop_name;
        BOOL isHave = NO;
        for (NSDictionary *dic in my_shops)
        {
            if ([[dic objectForKey:@"id"] isEqualToString:shop_id])
            {
                isHave = YES;
                shop_name = [dic objectForKey:@"shop_name"];
                break;
            }
        }
        if (!isHave) return;
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要取消此工单?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
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
                [[BXTGlobal shareGlobal].newsOrderIDs addObject:[taskInfo objectForKey:@"about_id"]];
                if ([self.window.rootViewController isKindOfClass:[UINavigationController class]])
                {
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GrabOrder" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GrabOrder" object:@""];
                }
            }
            else if ([[taskInfo objectForKey:@"event_type"] integerValue] == 2)//收到派工或者维修邀请
            {
                [[BXTGlobal shareGlobal].assignOrderIDs addObject:[taskInfo objectForKey:@"about_id"]];
                if ([self.window.rootViewController isKindOfClass:[UINavigationController class]])
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AssignOrderComing" object:nil];
                }
            }
            else
            {
                [self showAlertView:[taskInfo objectForKey:@"notice_title"]];
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

- (void)showAlertView:(NSString *)title
{
    if (IS_IOS_8)
    {
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertCtr addAction:doneAction];
        [self.window.rootViewController presentViewController:alertCtr animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

/**
 *  SDK收到sendMessage消息回调   发送上行消息结果反馈
 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId
                        result:(int)result
{
    //    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    //    NSLog(@"record  %@",record);
}

/**
 *  SDK遇到错误回调
 *  个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
 */
- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    LogRed(@"error%@",[error localizedDescription]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    // 处理APNs代码，通过userInfo可以取到推送的信息（包括内容，角标，自定义参数等）。如果需要弹窗等其他操作，则需要自行编码。
    //NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
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
- (void)requestResponseData:(id)response
                requeseType:(RequestType)type
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
        [BXTGlobal setUserProperty:[userInfoDic objectForKey:@"token"] withKey:U_TOKEN];
        
        NSArray *shopids = [userInfoDic objectForKey:@"shop_ids"];
        [BXTGlobal setUserProperty:shopids withKey:U_SHOPIDS];
        
        NSString *userID = [NSString stringWithFormat:@"%@",[userInfoDic objectForKey:@"id"]];
        [BXTGlobal setUserProperty:userID withKey:U_USERID];
        
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
            NSString *url = [NSString stringWithFormat:@"http://api.hellouf.com/?c=Port&m=actionGet_iPhone_v2_Port&shop_id=%@&token=%@", shopID, [BXTGlobal getUserProperty:U_TOKEN]];
            [BXTGlobal shareGlobal].baseURL = url;
            
            BXTDataRequest *pic_request = [[BXTDataRequest alloc] initWithDelegate:self];
            [pic_request updateHeadPic:[userInfoDic objectForKey:@"pic"]];
            
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
            [[BXTGlobal shareGlobal] reLoginWithDic:userInfo];
        }
    }
    else if (type == UpdateHeadPic)
    {
        NSLog(@"Update success");
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
    [GeTuiSdk runBackgroundEnable:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
