//
//  BXTRepairDetailViewController.h
//  BXT
//
//  Created by Jason on 15/9/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTPhotoBaseViewController.h"
#import "BXTRepairInfo.h"
#import <RongIMKit/RongIMKit.h>

//商铺版工单详情
@interface BXTRepairDetailViewController : BXTPhotoBaseViewController

- (instancetype)initWithRepair:(BXTRepairInfo *)repair;

@end
