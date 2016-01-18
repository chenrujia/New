//
//  BXTNoticeInformViewController.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

typedef NS_ENUM(NSInteger, PushType) {
    PushType_NoticeInform = 1,
    PushType_Project
};

@interface BXTNoticeInformViewController : BXTBaseViewController

@property (nonatomic, copy) NSString *urlStr;

@end
