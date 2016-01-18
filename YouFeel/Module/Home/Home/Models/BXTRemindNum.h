//
//  RemindNum.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/15.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTRemindNum : NSObject

+ (BXTRemindNum *)sharedManager;

/** ---- 日常工单 ---- */
@property (nonatomic, copy) NSString *dailyNum;
/** ---- 维保工单 ---- */
@property (nonatomic, copy) NSString *inspectioNum;
/** ---- 应用 ---- */
@property (nonatomic, copy) NSString *appNum;
/** ---- 项目通告 ---- */
@property (nonatomic, copy) NSString *announcementNum;

/** ---- 点击阅读时间 ---- */
@property (nonatomic, copy) NSString *timeStart;

@end
