//
//  BXTAssignOrderViewModel.h
//  YouFeel
//
//  Created by Jason on 16/9/12.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXTRepairDetailInfo.h"
#import <AVFoundation/AVFoundation.h>

@interface BXTAssignOrderViewModel : NSObject

@property (nonatomic, strong) RACCommand          *detailRequestCommand;
@property (nonatomic, strong) RACCommand          *acceptOrderCommand;
@property (nonatomic, strong) RACCommand          *rejectOrderCommand;
@property (nonatomic, strong) BXTRepairDetailInfo *orderDetail;
@property (nonatomic, strong) NSString            *orderID;
@property (nonatomic, strong) AVAudioPlayer       *player;

//r_p_(repair_person)报修人的缩写
@property (nonatomic, strong) NSString            *r_p_headURL;
@property (nonatomic, strong) NSString            *r_p_name;
@property (nonatomic, strong) NSString            *r_p_departmantName;
@property (nonatomic, strong) NSString            *r_p_jobName;
@property (nonatomic, assign) CGFloat             r_p_job_width;
@property (nonatomic, strong) NSAttributedString  *r_p_time;
@property (nonatomic, assign) BOOL                appointmentHidden;

@end
