//
//  AppDelegate.h
//  YouFeel
//
//  Created by Jason on 15/10/10.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTDataRequest.h"
#import "WXApi.h"
#import <RongIMLib/RongIMLib.h>
#import <RongIMKit/RongIMKit.h>

#define APP_ID           @"wx45e56bc2563438f5"
#define APP_SECRET       @"5c89faa2d7ed1a1767cb86c267aeb61e"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BXTDataResponseDelegate,UIAlertViewDelegate,RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate,WXApiDelegate>
{
    BOOL     isLoginByWX;
}
@property (strong, nonatomic) UIWindow  *window;
@property (nonatomic, strong) NSString  *device_token;
@property (assign, nonatomic) NSInteger lastPayloadIndex;
@property (strong, nonatomic) NSString  *access_token;
@property (strong, nonatomic) NSString  *openid;
@property (strong, nonatomic) NSString  *nickname;// 用户昵称
@property (strong, nonatomic) NSString  *headimgurl;// 用户头像地址

+ (AppDelegate *)appdelegete;

@end

