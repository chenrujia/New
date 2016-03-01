//
//  BXTResignViewController.h
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

@interface BXTResignViewController : BXTBaseViewController

@property (nonatomic, assign) BOOL isLoginByWX;

- (void)isLoginByWeiXin:(BOOL)loginType;

@end
