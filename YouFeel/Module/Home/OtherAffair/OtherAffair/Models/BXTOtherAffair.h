//
//  BXTOtherAffair.h
//  YouFeel
//
//  Created by 满孝意 on 16/3/30.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTOtherAffair : NSObject

/** ---- 待处理事件ID ---- */
@property (nonatomic, copy) NSString *messageID;
@property (nonatomic, copy) NSString *affairs_desc;
@property (nonatomic, copy) NSString *affairs_title;
@property (nonatomic, copy) NSString *affairs_time_name;
/** ---- 事件类别 1.认证审批 11.维修确认 12待评价工单 ---- */
@property (nonatomic, copy) NSString *affairs_type;
/** ---- 相关id ---- */
@property (nonatomic, copy) NSString *about_id;

@end
