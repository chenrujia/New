//
//  BXTRepairDetailViewController.h
//  BXT
//
//  Created by Jason on 15/9/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import "BXTRepairInfo.h"
#import <RongIMKit/RongIMKit.h>

//商铺版工单详情
@interface BXTRepairDetailViewController : BXTBaseViewController

- (instancetype)initWithRepair:(BXTRepairInfo *)repair;

@end
