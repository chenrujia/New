//
//  BXTRepairViewController.h
//  BXT
//
//  Created by Jason on 15/8/31.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

typedef NS_ENUM(NSInteger, BXTRefreshType) {
    RefreshDown,
    RefreshUp
};

typedef NS_ENUM(NSInteger, RepairVCType) {
    ShopsVCType,
    MMVCType
};

@interface BXTRepairViewController : BXTBaseViewController
{
    BXTRefreshType      refreshType;
}

- (instancetype)initWithVCType:(RepairVCType)vcType;

@end
