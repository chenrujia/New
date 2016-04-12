//
//  BXTRejectOrderViewController.h
//  YouFeel
//
//  Created by Jason on 15/12/3.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ViewControllType)
{
    ExamineVCType,//审批说明
    AssignVCType,//拒接指派
    RejectType//驳回维修结果
};

@interface BXTRejectOrderViewController : BXTBaseViewController
@property (nonatomic, assign) ViewControllType vcType;

- (instancetype)initWithOrderID:(NSString *)orderID viewControllerType:(ViewControllType)type;

@end
