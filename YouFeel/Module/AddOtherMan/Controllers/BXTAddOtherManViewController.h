//
//  BXTAddOtherManViewController.h
//  BXT
//
//  Created by Jason on 15/9/22.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

typedef NS_ENUM(NSInteger, ControllerType) {
    DetailType,
    RepairType
};

typedef void (^ChooseMans)(NSMutableArray *mans);

@interface BXTAddOtherManViewController : BXTBaseViewController

- (instancetype)initWithRepairID:(NSInteger)repair_id andWithVCType:(ControllerType)vc_type;

- (void)didChoosedMans:(ChooseMans)mans;

@end
