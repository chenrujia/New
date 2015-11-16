//
//  BXTMaintenanceProcessViewController.h
//  BXT
//
//  Created by Jason on 15/9/21.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import "BXTRepairDetailInfo.h"
@import AssetsLibrary;
@import AVFoundation;
@import MobileCoreServices;

@interface BXTMaintenanceProcessViewController : BXTBaseViewController

typedef void(^blockT)(void);
@property (nonatomic, copy) blockT BlockRefresh;

- (instancetype)initWithCause:(NSString *)cause andCurrentFaultID:(NSInteger)faultID andRepairID:(NSInteger)repairID andReaciveTime:(NSString *)time;

@end
