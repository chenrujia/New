//
//  BXTMaintenanceProcessViewController.h
//  BXT
//
//  Created by Jason on 15/9/21.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import "BXTRepairInfo.h"
@import AssetsLibrary;
@import AVFoundation;
@import MobileCoreServices;

@interface BXTMaintenanceProcessViewController : BXTBaseViewController

- (instancetype)initWithCause:(BXTRepairInfo *)repairInfo;

@end
