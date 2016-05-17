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
#import "MobClick.h"
#import "BXTPlaceInfo.h"
#import "BXTRemindNum.h"
#import "ANKeyValueTable.h"
#import "CYLTabBarController.h"
#import "BXTLoadingViewController.h"
#import "UINavigationController+YRBackGesture.h"
#import "BXTApplicationsViewController.h"
#import "BXTNoticeListViewController.h"
#import "BXTGrabOrderViewController.h"
#import "CYLTabBarControllerConfig.h"
#import "UIViewController+Swizzled.h"
#import "BXTProjectAddNewViewController.h"
#import "BXTNewOrderViewController.h"
#import "BXTNickNameViewController.h"

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
    SWIZZ_IT;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //新的SDK不允许在设置rootViewController之前做过于复杂的操作,So.....坑
    BXTLoadingViewController *myVC = [[BXTLoadingViewController alloc] init];
    self.window.rootViewController = myVC;
    
    //初始化融云SDK
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
    
    //自动键盘
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:YES];
    
    //注册APP_ID
    [WXApi registerApp:APP_ID];
    
    // token验证失败 - 退出登录
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"VERIFY_TOKEN_FAIL" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self loadingLoginVC];
    }];
    
    
    BOOL isLoaded = [[NSUserDefaults standardUserDefaults] boolForKey:@"LoadedGuideView"];
    if (isLoaded)
    {
        //默认自动登录（普通登录）
        if ([BXTGlobal getUserProperty:U_USERNAME] && [BXTGlobal getUserProperty:U_PASSWORD] && [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"])
        {
            NSDictionary *userInfoDic = @{@"username":[BXTGlobal getUserProperty:U_USERNAME],
                                          @"password":[BXTGlobal getUserProperty:U_PASSWORD],
                                          @"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"],
                                          @"type":@"1"};
            
            BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
            [dataRequest loginUser:userInfoDic];
        }
        //第三方登录
        else if ([BXTGlobal getUserProperty:U_OPENID] && [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"])
        {
            isLoginByWX = YES;
            NSDictionary *userInfoDic = @{@"username":@"",
                                          @"password":@"",
                                          @"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"],
                                          @"type":@"2",
                                          @"flat_id":@"1",
                                          @"only_code":[BXTGlobal getUserProperty:U_OPENID]};
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
    
    // 处理远程通知启动APP
    [self receiveNotificationByLaunchingOptions:launchOptions];
    
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
    
    return YES;
}

- (void)loadingLoginVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndResign" bundle:nil];
    UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"BXTLoginViewController"];
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
    [[NSUserDefaults standardUserDefaults] synchronize];
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

/** 自定义：APP被“推送”启动时处理推送消息处理（APP 未启动--》启动）*/
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions
{
    if (!launchOptions) return;
    /*
     通过“远程推送”启动APP
     UIApplicationLaunchOptionsRemoteNotificationKey 远程推送Key
     */
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo)
    {
        LogRed(@"\n>>>[Launching RemoteNotification]:%@",userInfo);
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
    device_token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    LogRed(@"deviceToken:%@",device_token);
    [GeTuiSdk registerDeviceToken:device_token];
    [[RCIMClient sharedRCIMClient] setDeviceToken:device_token];
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
    if (device_token)
    {
        [GeTuiSdk registerDeviceToken:device_token];
    }
}

/**
 *  SDK收到透传消息回调
 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData
                            andTaskId:(NSString *)taskId
                             andMsgId:(NSString *)msgId
                           andOffLine:(BOOL)offLine
                          fromGtAppId:(NSString *)appId
{
    NSString *payloadMsg = nil;
    if (payloadData)
    {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes
                                              length:payloadData.length
                                            encoding:NSUTF8StringEncoding];
    }
    
    NSString *record = [NSString stringWithFormat:@"%ld, %@, %@",(long)++_lastPayloadIndex, [self formateTime:[NSDate date]], payloadMsg];
    NSRange startRange = [record rangeOfString:@"{"];
    NSRange endRange = [record rangeOfString:@"}"];
    
    NSString *dicStr = [record substringWithRange:NSMakeRange(startRange.location, endRange.location - startRange.location + 1)];
    NSDictionary *taskInfo = [dicStr JSONValue];
    LogRed(@"通知消息:%@",taskInfo);
    //如果处于非登录状态，则不处理任何消息。
    if (![BXTGlobal shareGlobal].isLogin) return;
    
    NSString *shop_id = [NSString stringWithFormat:@"%@", [taskInfo objectForKey:@"shop_id"]];
    [BXTGlobal shareGlobal].newsShopID = shop_id;
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    
    //如果该条消息不是该项目的
    if (![shop_id isEqualToString:companyInfo.company_id])
    {
        NSArray *my_shops = [BXTGlobal getUserProperty:U_MYSHOP];
        NSString *shop_name;
        BOOL isHave = NO;
        for (BXTResignedShopInfo *shopInfo in my_shops)
        {
            if ([[NSString stringWithFormat:@"%@", shopInfo.shopID] isEqualToString:shop_id])
            {
                isHave = YES;
                shop_name = shopInfo.shop_name;
                break;
            }
        }
        if (!isHave) return;
        if (IS_IOS_8)
        {
            UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您有来自%@的新消息，是否立即查看？",shop_name] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"稍后查看" style:UIAlertActionStyleCancel handler:nil];
            [alertCtr addAction:cancelAction];
            @weakify(self);
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"立即查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self);
                BXTProjectAddNewViewController *headVC = [[BXTProjectAddNewViewController alloc] initWithType:YES];
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
                BXTGrabOrderViewController *grabOrderVC = [[BXTGrabOrderViewController alloc] init];
                grabOrderVC.hidesBottomBarWhenPushed = YES;
                
                // 工单数 > 实时抢单页面数 -> 跳转
                BXTHeadquartersInfo *company = [BXTGlobal getUserProperty:U_COMPANY];
                if ([company.company_id isEqualToString:[BXTGlobal shareGlobal].newsShopID] &&
                    [BXTGlobal shareGlobal].newsOrderIDs.count > [BXTGlobal shareGlobal].numOfPresented)
                {
                    if ([BXTGlobal shareGlobal].presentNav)
                    {
                        [[BXTGlobal shareGlobal].presentNav pushViewController:grabOrderVC animated:YES];
                    }
                    else if ([self.window.rootViewController isKindOfClass:[UINavigationController class]])
                    {
                        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
                        [nav pushViewController:grabOrderVC animated:YES];
                    }
                    else if ([self.window.rootViewController isKindOfClass:[CYLTabBarController class]])
                    {
                        CYLTabBarController *tabbarC = (CYLTabBarController *)self.window.rootViewController;
                        UINavigationController *nav = (UINavigationController *)[tabbarC.viewControllers objectAtIndex:[tabbarC selectedIndex]];
                        [nav pushViewController:grabOrderVC animated:YES];
                    }
                }
            }
            else if ([[taskInfo objectForKey:@"event_type"] integerValue] == 5)//收到派工或者维修邀请
            {
                [[BXTGlobal shareGlobal].assignOrderIDs addObject:[taskInfo objectForKey:@"about_id"]];
                BXTNewOrderViewController *newOrderVC = [[BXTNewOrderViewController alloc] initWithIsVoice:YES];
                newOrderVC.hidesBottomBarWhenPushed = YES;
                
                if ([BXTGlobal shareGlobal].assignOrderIDs.count > [BXTGlobal shareGlobal].assignNumber)
                {
                    if ([BXTGlobal shareGlobal].presentNav)
                    {
                        [[BXTGlobal shareGlobal].presentNav pushViewController:newOrderVC animated:YES];
                    }
                    else if ([self.window.rootViewController isKindOfClass:[UINavigationController class]])
                    {
                        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
                        [nav pushViewController:newOrderVC animated:YES];
                    }
                    else if ([self.window.rootViewController isKindOfClass:[CYLTabBarController class]])
                    {
                        CYLTabBarController *tabbarC = (CYLTabBarController *)self.window.rootViewController;
                        UINavigationController *nav = (UINavigationController *)[tabbarC.viewControllers objectAtIndex:[tabbarC selectedIndex]];
                        [nav pushViewController:newOrderVC animated:YES];
                    }
                }
            }
            else
            {
                [self showAlertView:[taskInfo objectForKey:@"notice_title"] message:[taskInfo objectForKey:@"notice_body"]];
            }
            break;
        case 3://通知
            
            break;
        case 4://预警
            
            break;
        case 6://广播
            if ([[taskInfo objectForKey:@"event_type"] integerValue] == 1)
            {
                // 应用提示
                CYLTabBarController *tabbarC = (CYLTabBarController *)self.window.rootViewController;
                UIViewController *appController = [tabbarC.viewControllers objectAtIndex:2];
                NSInteger appNumStr = [BXTRemindNum sharedManager].app_show + 1;
                appController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)appNumStr];
                [BXTRemindNum sharedManager].announcementNum = [NSString stringWithFormat:@"%ld", (long)appNumStr];
            }
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsComing" object:@"1"];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)showAlertView:(NSString *)title message:(NSString *)message
{
    if (IS_IOS_8)
    {
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertCtr addAction:doneAction];
        [self.window.rootViewController presentViewController:alertCtr animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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
        BXTProjectAddNewViewController *headVC = [[BXTProjectAddNewViewController alloc] initWithType:YES];
        UINavigationController *navigation = (UINavigationController *)self.window.rootViewController;
        [navigation pushViewController:headVC animated:YES];
    }
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response
                requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    if (type == LoginType && [[dic objectForKey:@"returncode"] isEqualToString:@"0"])
    {
        NSArray *dataArray = [dic objectForKey:@"data"];
        NSDictionary *userInfoDic = [dataArray objectAtIndex:0];
        [BXTAbroadUserInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"userID":@"id"};
        }];
        [BXTResignedShopInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"shopID":@"id"};
        }];
        BXTAbroadUserInfo *abUserInfo = [BXTAbroadUserInfo mj_objectWithKeyValues:userInfoDic];
        
        [BXTGlobal setUserProperty:abUserInfo.username withKey:U_USERNAME];
        [BXTGlobal setUserProperty:abUserInfo.gender withKey:U_SEX];
        [BXTGlobal setUserProperty:abUserInfo.name withKey:U_NAME];
        [BXTGlobal setUserProperty:abUserInfo.pic withKey:U_HEADERIMAGE];
        [BXTGlobal setUserProperty:abUserInfo.im_token withKey:U_IMTOKEN];
        [BXTGlobal setUserProperty:abUserInfo.token withKey:U_TOKEN];
        [BXTGlobal setUserProperty:abUserInfo.shop_ids withKey:U_SHOPIDS];
        [BXTGlobal setUserProperty:abUserInfo.userID withKey:U_USERID];
        [BXTGlobal setUserProperty:abUserInfo.my_shop withKey:U_MYSHOP];
        
        if (abUserInfo.my_shop && abUserInfo.my_shop.count > 0)
        {
            BXTResignedShopInfo *shopInfo = abUserInfo.my_shop[0];
            NSString *shopID = shopInfo.shopID;
            NSString *shopName = shopInfo.shop_name;
            BXTHeadquartersInfo *companyInfo = [[BXTHeadquartersInfo alloc] init];
            companyInfo.company_id = shopID;
            companyInfo.name = shopName;
            [BXTGlobal setUserProperty:companyInfo withKey:U_COMPANY];
            NSString *url = [NSString stringWithFormat:@"%@&shop_id=%@&token=%@",KAPIBASEURL, shopID, [BXTGlobal getUserProperty:U_TOKEN]];
            [BXTGlobal shareGlobal].baseURL = url;
            if (![[ANKeyValueTable userDefaultTable] valueWithKey:YSAVEDSHOPID] || ![[[ANKeyValueTable userDefaultTable] valueWithKey:YSAVEDSHOPID] isEqualToString:shopID])
            {
                /**位置列表**/
                BXTDataRequest *location_request = [[BXTDataRequest alloc] initWithDelegate:self];
                [location_request listOFPlaceIsAllPlace];
            }
            else
            {
                NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
                NSInteger now = nowTime;
                NSInteger ago = [[[ANKeyValueTable userDefaultTable] valueWithKey:YSAVEDTIME] integerValue];
                //超过7天
                if (now - ago > 604800)
                {
                    /**位置列表**/
                    BXTDataRequest *location_request = [[BXTDataRequest alloc] initWithDelegate:self];
                    [location_request listOFPlaceIsAllPlace];
                }
            }
            [[ANKeyValueTable userDefaultTable] setValue:shopID withKey:YSAVEDSHOPID];
            
            /**分店登录**/
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request branchLogin];
        }
        else
        {
            [self loadingLoginVC];
        }
    }
    else if (type == LoginType && [[dic objectForKey:@"returncode"] isEqualToString:@"044"])
    {
        [self loadingLoginVC];
    }
    else if (type == LoginType && [[dic objectForKey:@"returncode"] isEqualToString:@"002"] && isLoginByWX)
    {
        isLoginByWX = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GotoResignVC" object:nil];
    }
    else if (type == BranchLogin && [[dic objectForKey:@"returncode"] isEqualToString:@"0"])
    {
        NSArray *data = [dic objectForKey:@"data"];
        if (data.count > 0)
        {
            NSDictionary *userInfo = data[0];
            [[BXTGlobal shareGlobal] branchLoginWithDic:userInfo isPushToRootVC:YES];
        }
    }
    else if (type == PlaceLists && [[dic objectForKey:@"returncode"] isEqualToString:@"0"])
    {
        NSArray *data = [dic objectForKey:@"data"];
        [BXTPlaceInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"placeID":@"id"};
        }];
        NSMutableArray *dataSource = [[NSMutableArray alloc] init];
        [dataSource addObjectsFromArray:[BXTPlaceInfo mj_objectArrayWithKeyValuesArray:data]];
        [[ANKeyValueTable userDefaultTable] setValue:dataSource withKey:YPLACESAVE];
        [[ANKeyValueTable userDefaultTable] synchronize:YES];
        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
        NSInteger now = nowTime;
        [[ANKeyValueTable userDefaultTable] setValue:[NSNumber numberWithInteger:now] withKey:YSAVEDTIME];
    }
    else if (type == PlaceLists && ![[dic objectForKey:@"returncode"] isEqualToString:@"0"])
    {
        BXTDataRequest *location_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [location_request listOFPlaceIsAllPlace];
    }
    else if (type == BindingUser && [[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        [BXTGlobal showText:@"绑定微信号成功" view:self.window completionBlock:nil];
        SaveValueTUD(BINDINGWEIXIN, @"2");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BindingWeixinNotify" object:nil];
    }
    else if (type == BindingUser && [[dic objectForKey:@"returncode"] isEqualToString:@"004"])
    {
        [BXTGlobal showText:@"该手机已经绑定了其他微信号，请更换手机号" view:self.window completionBlock:nil];
    }
    else if (type == BindingUser && [[dic objectForKey:@"returncode"] isEqualToString:@"014"])
    {
        [BXTGlobal showText:@"该手机号已绑定其他微信账户" view:self.window completionBlock:nil];
    }
    else
    {
        [self loadingLoginVC];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    if (type == LoginType)
    {
        [self loadingLoginVC];
    }
    else if (type == PlaceLists)
    {
        BXTDataRequest *location_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [location_request listOFPlaceIsAllPlace];
    }
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
                                              otherButtonTitles:nil];
        [alert show];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndResign" bundle:nil];
        UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"BXTLoginViewController"];
        UINavigationController *_navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = _navi;
    }
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsComing" object:@"2"];
        
        // 通讯提示
        CYLTabBarController *tabbarC = (CYLTabBarController *)self.window.rootViewController;
        UIViewController *mailController = [tabbarC.viewControllers objectAtIndex:1];
        
        mailController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [[RCIMClient sharedRCIMClient] getTotalUnreadCount]];
        if ([[RCIMClient sharedRCIMClient] getTotalUnreadCount] == 0) {
            mailController.tabBarItem.badgeValue = nil;
        }
        
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
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // [EXT] APP进入后台时，通知个推SDK进入后台
    [GeTuiSdk runBackgroundEnable:YES];
}

#pragma mark -
#pragma mark 微信api相关
// openURL
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

// handleURL
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

/**
 * onReq微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用
 * sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
 */
- (void)onReq:(BaseReq *)req
{
    
}

/**
 *  如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，
 *  会切到微信终端程序界面。
 */
- (void)onResp:(BaseResp *)resp
{
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode == 0)
    { // 用户同意
        NSLog(@"errCode = %d", aresp.errCode);
        NSLog(@"code = %@", aresp.code);
        
        // 获取access_token
        //      格式：https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
        NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", APP_ID, APP_SECRET, aresp.code];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *zoneUrl = [NSURL URLWithString:url];
            NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
            NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    _openid = [dic objectForKey:@"openid"]; // 初始化
                    _access_token = [dic objectForKey:@"access_token"];
                    //                    NSLog(@"openid = %@", _openid);
                    //                    NSLog(@"access = %@", [dic objectForKey:@"access_token"]);
                    NSLog(@"dic = %@", dic);
                    [self getUserInfo]; // 获取用户信息
                }
            });
        });
    }
    else if (aresp.errCode == -2)
    {
        NSLog(@"用户取消登录");
    }
    else if (aresp.errCode == -4)
    {
        NSLog(@"用户拒绝登录");
    }
    else
    {
        NSLog(@"errCode = %d", aresp.errCode);
        NSLog(@"code = %@", aresp.code);
    }
}

// 获取用户信息
- (void)getUserInfo
{
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", self.access_token, self.openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *openID = [dic objectForKey:@"openid"];
                [BXTGlobal setUserProperty:openID withKey:U_OPENID];
                [BXTGlobal shareGlobal].openID = openID;
                NSLog(@"openid = %@", openID);
                NSLog(@"nickname = %@", [dic objectForKey:@"nickname"]);
                NSLog(@"sex = %@", [dic objectForKey:@"sex"]);
                NSLog(@"country = %@", [dic objectForKey:@"country"]);
                NSLog(@"province = %@", [dic objectForKey:@"province"]);
                NSLog(@"city = %@", [dic objectForKey:@"city"]);
                NSLog(@"headimgurl = %@", [dic objectForKey:@"headimgurl"]);
                [BXTGlobal shareGlobal].wxHeadImage = [dic objectForKey:@"headimgurl"];
                NSLog(@"unionid = %@", [dic objectForKey:@"unionid"]);
                NSLog(@"privilege = %@", [dic objectForKey:@"privilege"]);
                
                AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appdelegate.headimgurl = [dic objectForKey:@"headimgurl"]; // 传递头像地址
                appdelegate.nickname = [dic objectForKey:@"nickname"]; // 传递昵称
                
                
                if ([BXTGlobal shareGlobal].isBindingWeiXin)
                {
                    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                    NSDictionary *dic = @{@"only_code":[BXTGlobal shareGlobal].openID,
                                          @"mobile":[BXTGlobal getUserProperty:U_USERNAME],
                                          @"flat_id":@"1"};
                    [request bindingUser:dic];
                }
                else
                {
                    isLoginByWX = YES;
                    NSDictionary *userInfoDic = @{@"username":@"",
                                                  @"password":@"",
                                                  @"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"],
                                                  @"type":@"2",
                                                  @"flat_id":@"1",
                                                  @"only_code":openID};
                    BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
                    [dataRequest loginUser:userInfoDic];
                }
                
            }
        });
    });
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
