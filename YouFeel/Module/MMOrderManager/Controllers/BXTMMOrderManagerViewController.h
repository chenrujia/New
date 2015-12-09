//
//  BXTMMOrderManagerViewController.h
//  BXT
//
//  Created by Jason on 15/10/8.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

typedef NS_ENUM(NSInteger, BXTRefreshType) {
    RefreshDown,
    RefreshUp
};

@interface BXTMMOrderManagerViewController : BXTBaseViewController
{
    BXTRefreshType      refreshType;
}
@end
