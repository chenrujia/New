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

#define kAppId           @"Et6F23PyhQ8gisEobno7u2"
#define kAppKey          @"wSY82iAJR77E8eTlTGxWx1"
#define kAppSecret       @"XfCZ5grnZmAN0jOd9rBWM2"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GeTuiSdkDelegate,BXTDataResponseDelegate>
{
    NSString *_deviceToken;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *payloadId;
@property (assign, nonatomic) NSInteger lastPayloadIndex;
@property (assign, nonatomic) SdkStatus sdkStatus;

+ (AppDelegate *)appdelegete;

+ (BOOL)setTags:(NSArray *)tags;

- (void)bindAlias:(NSString *)aAlias;
- (void)unbindAlias:(NSString *)aAlias;

@end

