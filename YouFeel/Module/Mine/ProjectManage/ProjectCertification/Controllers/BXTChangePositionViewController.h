//
//  BXTChangePositionViewController.h
//  YouFeel
//
//  Created by 满孝意 on 16/8/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

@interface BXTChangePositionViewController : BXTBaseViewController

typedef void (^blockTPosition)(NSString *position);
@property(nonatomic, copy) blockTPosition transPosition;

@end
