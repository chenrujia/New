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
    RepairType,
    AssignType
};

typedef void (^ChooseMans)(NSMutableArray *mans);

@interface BXTAddOtherManViewController : BXTBaseViewController

/**
 *  派单页面跳转
 */
@property (nonatomic, assign) BOOL isAssignVCPushed;
@property (nonatomic, strong) NSMutableArray *manIDArray;

- (instancetype)initWithRepairID:(NSInteger)repair_id
                   andWithVCType:(ControllerType)vc_type;

- (void)didChoosedMans:(ChooseMans)mans;

@end
