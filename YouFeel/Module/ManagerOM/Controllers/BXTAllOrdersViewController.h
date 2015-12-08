//
//  BXTAllOrdersViewController.h
//  YouFeel
//
//  Created by Jason on 15/11/30.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

@interface BXTAllOrdersViewController : BXTBaseViewController

@property (nonatomic, assign) BOOL isSpecialPush;
@property (nonatomic, copy) NSString *transStartTime;
@property (nonatomic, copy) NSString *transEndTime;
@property (nonatomic, copy) NSString *transType;

@end
