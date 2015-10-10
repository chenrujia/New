//
//  BXTOrderManagerViewController.h
//  BXT
//
//  Created by Jason on 15/9/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

typedef NS_ENUM(NSInteger, ControllerType) {
    RepairType,
    MaintenanceManType
};

@interface BXTOrderManagerViewController : BXTBaseViewController

@property (nonatomic ,assign) ControllerType vcType;

- (instancetype)initWithControllerType:(ControllerType)type;

@end
