//
//  BXTOrderDetailViewController.h
//  BXT
//
//  Created by Jason on 15/9/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import "BXTRepairInfo.h"
#import <RongIMKit/RongIMKit.h>

@interface BXTOrderDetailViewController : BXTBaseViewController

/**
 *  是否有关闭工单按钮
 */
@property (nonatomic, assign) BOOL isRejectVC;

- (instancetype)initWithRepairID:(NSString *)reID;

@end
