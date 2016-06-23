//
//  BXTNoticeInformViewController.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

typedef NS_ENUM(NSInteger, PushType) {
    PushType_OA = 1,
    PushType_Other,
};

@interface BXTNoticeInformViewController : UIViewController

@property (nonatomic, assign) NSInteger pushType;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *urlStr;

@property (nonatomic, strong) RACSubject *delegateSignal;

@end
