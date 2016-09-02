//
//  BXTOrderDetailViewModel.h
//  YouFeel
//
//  Created by Jason on 16/9/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXTRepairDetailInfo.h"
@import AVFoundation.AVAudioPlayer;

@interface BXTOrderDetailViewModel : NSObject

//刷新UI
@property (nonatomic, strong) RACSubject          *refreshSubject;
//退出VC
@property (nonatomic, strong) RACSubject          *backSubject;

@property (nonatomic, strong) BXTRepairDetailInfo *orderDetail;

@property (nonatomic, strong) AVAudioPlayer       *player;
@property (nonatomic, strong) NSString            *orderID;


//r_p_(repair_person)报修人的缩写
@property (nonatomic, strong) NSString            *r_p_headURL;
@property (nonatomic, strong) NSString            *r_p_name;
@property (nonatomic, strong) NSString            *r_p_departmantName;
@property (nonatomic, strong) NSString            *r_p_jobName;
@property (nonatomic, assign) CGFloat             r_p_job_width;
@property (nonatomic, strong) NSAttributedString  *r_p_time;
@property (nonatomic, assign) BOOL                appointmentHidden;

// 接单
- (void)acceptOrder;

@end
