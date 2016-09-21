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
#import "UMessage.h"
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
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

NSString* const NotificationCategoryIdent  = @"ACTIONABLE";
NSString* const NotificationActionOneIdent = @"ACTION_ONE";
NSString* const NotificationActionTwoIdent = @"ACTION_TWO";

#define RONGCLOUD_IM_APPKEY @"ik1qhw091jstp"
#define UMENGKEY            @"566e7c1867e58e7160002af5"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    SWIZZ_IT;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.device_token = @"hellouf";
    self.infoArray = [NSMutableArray array];
    //新的SDK不允许在设置rootViewController之前做过于复杂的操作,So.....坑
    BXTLoadingViewController *myVC = [[BXTLoadingViewController alloc] init];
    self.window.rootViewController = myVC;
    
    //初始化融云SDK
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
    
    //自动键盘
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:YES];
    
    //注册APP_ID
    [WXApi registerApp:APP_ID];
    
    BOOL isLoaded = [[NSUserDefaults standardUserDefaults] boolForKey:@"LoadedGuideView"];
    if (isLoaded)
    {
        //默认自动登录（普通登录）
        if ([BXTGlobal getUserProperty:U_USERNAME] && [BXTGlobal getUserProperty:U_PASSWORD])
        {
            NSDictionary *userInfoDic = @{@"username":[BXTGlobal getUserProperty:U_USERNAME],
                                          @"password":[BXTGlobal getUserProperty:U_PASSWORD],
                                          @"type":@"1"};
            
            BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
            [dataRequest loginUser:userInfoDic];
        }
        //第三方登录
        else if ([BXTGlobal getUserProperty:U_OPENID])
        {
            isLoginByWX = YES;
            NSDictionary *userInfoDic = @{@"username":@"",
                                          @"password":@"",
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
    
    // 友盟配置
    [UMAnalyticsConfig sharedInstance].appKey = UMENGKEY;
    [UMAnalyticsConfig sharedInstance].ePolicy = BATCH;
    [MobClick startWithConfigure:[UMAnalyticsConfig sharedInstance]];
    
    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:UMENGKEY launchOptions:launchOptions];
    
    //1.3.0版本开始简化初始化过程。如不需要交互式的通知，下面用下面一句话注册通知即可。
    [UMessage registerForRemoteNotifications];
    
    //统一导航条样式
    UIFont *font = [UIFont systemFontOfSize:19.f];
    NSDictionary *textAttributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //设置会话列表头像和会话界面头像
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    
    //配置Fabric
    [Fabric with:@[CrashlyticsKit]];
    [self logFabricUser];
    
    [self addNotification];
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    self.device_token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken:%@",_device_token);
    [[RCIMClient sharedRCIMClient] setDeviceToken:_device_token];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"通知消息1:%@",userInfo);
    /**
     UIApplicationStateActive,活动在前台
     UIApplicationStateInactive,从后台跳入前台（仅仅是代表点击消息进入，而不是点击icon进入）
     UIApplicationStateBackground运行在后台
     **/
    if (self.isGetIn)
    {
        if(application.applicationState != UIApplicationStateInactive)
        {
            [self handleNotification:userInfo];
        }
    }
    else
    {
        if(application.applicationState == UIApplicationStateInactive)
        {
            [self.infoArray addObject:userInfo];
        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

+ (AppDelegate *)appdelegete
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)addNotification
{
    // token验证失败 - 退出登录
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"VERIFY_TOKEN_FAIL" object:nil] subscribeNext:^(id x) {
        [self loadingLoginVC];
    }];
    
    // 处理远程通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HandleRemoteNotification" object:nil] subscribeNext:^(id x) {
        if (self.infoArray.count)
        {
            for (NSDictionary *infoDic in self.infoArray)
            {
                [self handleNotification:infoDic];
            }
            [self.infoArray removeAllObjects];
        }
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:RCKitDispatchMessageNotification object:nil] subscribeNext:^(id x) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"REFRESHYSAVEDSHOPID" object:nil] subscribeNext:^(id x) {
        /**位置列表**/
        BXTDataRequest *location_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [location_request listOFPlaceIsAllPlace];
    }];
}

- (void)logFabricUser
{
    [CrashlyticsKit setUserIdentifier:@"3c933117c36927bea8ff4f1ab41c48630db1a41f"];
    [CrashlyticsKit setUserEmail:@"hellouf@163.com"];
    [CrashlyticsKit setUserName:@"Jason"];
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
    scrollView.bounces = NO;
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

- (void)handleNotification:(NSDictionary *)userInfo
{
    NSString *taskStr = [userInfo objectForKey:@"notify"];
    NSDictionary *taskInfo = [taskStr JSONValue];
    NSString *shop_id = [NSString stringWithFormat:@"%@", [taskInfo objectForKey:@"shop_id"]];
    [BXTGlobal shareGlobal].newsShopID = shop_id;
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    
    //如果该条消息不是该项目的
    if (![shop_id isEqualToString:companyInfo.company_id])
    {
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
                
                // 超过10分钟， 不跳转
                NSInteger timeSp = [[NSDate date] timeIntervalSince1970];
                NSInteger getTimeSp = [[NSString stringWithFormat:@"%@", taskInfo[@"send_time"]] integerValue];
                if (timeSp - getTimeSp > 600)
                {
                    [self showAlertView:@"温馨提示" message:@"您有错过的工单，请前去消息列表查看！"];
                    return;
                }
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
                BXTGrabOrderViewController *grabOrderVC = (BXTGrabOrderViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTGrabOrderViewController"];
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
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
                BXTNewOrderViewController *newOrderVC = (BXTNewOrderViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTNewOrderViewController"];
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
        
        if (abUserInfo.shop_ids && abUserInfo.shop_ids.count > 0)
        {
            NSString *shopID = abUserInfo.shop_ids[0];
            NSString *shopName = [abUserInfo.my_shop_arr objectForKey:shopID];
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
    else if (type == PlaceLists)
    {
        if ([[dic objectForKey:@"returncode"] isEqualToString:@"0"]) {
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
    }
    else if (type == BindingUser && [[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        [BXTGlobal showText:@"绑定微信号成功" completionBlock:nil];
        SaveValueTUD(U_BINDINGWEIXIN, @"2");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BindingWeixinNotify" object:nil];
    }
    else if (type == BindingUser && [[dic objectForKey:@"returncode"] isEqualToString:@"004"])
    {
        [BXTGlobal showText:@"该手机已经绑定了其他微信号，请更换手机号" completionBlock:nil];
    }
    else if (type == BindingUser && [[dic objectForKey:@"returncode"] isEqualToString:@"014"])
    {
        [BXTGlobal showText:@"该手机号已绑定其他微信账户" completionBlock:nil];
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
        if ([[RCIMClient sharedRCIMClient] getTotalUnreadCount] <= 0)
        {
            mailController.tabBarItem.badgeValue = nil;
        }
        else
        {
            mailController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [[RCIMClient sharedRCIMClient] getTotalUnreadCount]];
        }
    });
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
