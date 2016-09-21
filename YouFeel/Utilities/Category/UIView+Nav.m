//
//  UIView+Nav.m
//  BXT
//
//  Created by Jason on 15/9/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "UIView+Nav.h"
#import "AppDelegate.h"
#import "BXTGlobal.h"
#import "CYLTabBarController.h"

@implementation UIView (Nav)

- (UINavigationController *)navigation
{
    id rootVC = [AppDelegate appdelegete].window.rootViewController;
    UINavigationController *nav = nil;
    if ([BXTGlobal shareGlobal].presentNav)
    {
        nav = [BXTGlobal shareGlobal].presentNav;
    }
    else if ([rootVC isKindOfClass:[UINavigationController class]])
    {
        nav = rootVC;
    }
    else if ([rootVC isKindOfClass:[CYLTabBarController class]])
    {
        CYLTabBarController *tempVC = (CYLTabBarController *)rootVC;
        nav = (UINavigationController *)[tempVC.viewControllers objectAtIndex:tempVC.selectedIndex];
    }
    
    return nav;
}

@end
