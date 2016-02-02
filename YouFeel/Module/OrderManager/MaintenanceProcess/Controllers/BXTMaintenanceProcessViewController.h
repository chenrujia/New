//
//  BXTMaintenanceProcessViewController.h
//  BXT
//
//  Created by Jason on 15/9/21.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTPhotoBaseViewController.h"

typedef void(^blockT)(void);

@interface BXTMaintenanceProcessViewController : BXTPhotoBaseViewController

@property (nonatomic, copy) blockT BlockRefresh;

@property (nonatomic, strong) RACSubject *delegateSignal;

- (instancetype)initWithCause:(NSString *)cause
            andCurrentFaultID:(NSInteger)faultID
                  andRepairID:(NSInteger)repairID
               andReaciveTime:(NSString *)time;

@end
