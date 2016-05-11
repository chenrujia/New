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

/** ---- 日常工单数 ---- */
@property (nonatomic, copy) NSString *dailyNum;
/** ---- 维保工单数 ---- */
@property (nonatomic, copy) NSString *inspectionNum;
/** ---- 我的维修工单数 ---- */
@property (nonatomic, copy) NSString *repairNum;
/** ---- 我的报修工单数 ---- */
@property (nonatomic, copy) NSString *reportNum;
/** ---- 其他事务数---- */
@property (nonatomic, copy) NSString *objectNum;
/** ---- 项目公告数 ---- */
@property (nonatomic, copy) NSString *announcementNum;

/** ---- “应用”是否显示气泡：1是 0否 ---- */
@property (assign, nonatomic) BOOL app_show;
/** ---- “首页”是否显示气泡：1是 0否 ---- */
@property (assign, nonatomic) BOOL index_show;
/** ---- “首页”是否显示消息气泡：1是 0否 ---- */
@property (assign, nonatomic) BOOL notice_show;


/** ---- 点击阅读时间-日常 ---- */
@property (nonatomic, copy) NSString *timeStart_Daily;
/** ---- 点击阅读时间-维保 ---- */
@property (nonatomic, copy) NSString *timeStart_Inspection;

/** ---- 点击阅读时间-我的维修工单 ---- */
@property (nonatomic, copy) NSString *timeStart_Repair;
/** ---- 点击阅读时间-我的报修工单 ---- */
@property (nonatomic, copy) NSString *timeStart_Report;
/** ---- 点击阅读时间-其他事务 ---- */
@property (nonatomic, copy) NSString *timeStart_Object;
/** ---- 点击阅读时间-公告 ---- */
@property (nonatomic, copy) NSString *timeStart_Announcement;

/** ---- 点击阅读时间-消息 ---- */
@property (nonatomic, copy) NSString *timeStart_Notice;

@end
