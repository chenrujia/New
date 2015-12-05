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

@property (nonatomic, copy) NSString *pushType;
- (instancetype)initWithRepairID:(NSString *)reID;

@end
