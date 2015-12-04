//
//  BXTNewOrderViewController.h
//  YouFeel
//
//  Created by Jason on 15/11/12.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface BXTNewOrderViewController : BXTBaseViewController

- (instancetype)initWithIsAssign:(BOOL)assign
                  andWithOrderID:(NSString *)orderID;

@end
