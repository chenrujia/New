//
//  UIView+Nav.m
//  BXT
//
//  Created by Jason on 15/9/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "UIView+Nav.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "CYLTabBarController.h"

@implementation UIView (Nav)

- (UINavigationController *)navigation
{
    CYLTabBarController *tabBar = (CYLTabBarController *)[AppDelegate appdelegete].window.rootViewController;
    UINavigationController *nav = [tabBar.viewControllers objectAtIndex:tabBar.selectedIndex];
    return nav;
}

- (void)showLoadingMBP:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
}

- (void)hideMBP
{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

@end
