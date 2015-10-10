//
//  UIView+Nav.m
//  BXT
//
//  Created by Jason on 15/9/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "UIView+Nav.h"
#import "AppDelegate.h"

@implementation UIView (Nav)

- (UINavigationController *)navigation
{
    UINavigationController *nav = (UINavigationController *)[AppDelegate appdelegete].window.rootViewController;
    return nav;
}

@end
