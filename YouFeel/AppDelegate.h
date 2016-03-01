//
//  AppDelegate.h
//  YouFeel
//
//  Created by Jason on 15/10/10.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTDataRequest.h"
#import "GeTuiSdk.h"
#import "WXApi.h"
#import <RongIMLib/RongIMLib.h>
#import <RongIMKit/RongIMKit.h>

#define APP_ID           @"wx5c34402c24a80d9d"
#define APP_SECRET       @"2113239052ce9a78d75d20e90efa937e"
#define kAppId           @"Et6F23PyhQ8gisEobno7u2"
#define kAppKey          @"wSY82iAJR77E8eTlTGxWx1"
#define kAppSecret       @"XfCZ5grnZmAN0jOd9rBWM2"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GeTuiSdkDelegate,BXTDataResponseDelegate,UIAlertViewDelegate,RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate,WXApiDelegate>
{
    NSString *device_token;
    BOOL     isLoginByWX;
}
@property (strong, nonatomic) UIWindow  *window;
@property (strong, nonatomic) NSString  *payloadId;
@property (assign, nonatomic) NSInteger lastPayloadIndex;
@property (assign, nonatomic) SdkStatus sdkStatus;
@property (strong, nonatomic) NSString  *access_token;
@property (strong, nonatomic) NSString  *openid;
@property (strong, nonatomic) NSString  *nickname;// 用户昵称
@property (strong, nonatomic) NSString  *headimgurl;// 用户头像地址

+ (AppDelegate *)appdelegete;
+ (BOOL)setTags:(NSArray *)tags;

- (void)bindAlias:(NSString *)aAlias;
- (void)unbindAlias:(NSString *)aAlias;

@end

