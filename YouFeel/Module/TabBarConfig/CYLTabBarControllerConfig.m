//
//  CYLTabBarControllerConfig.m
//  CYLTabBarController
//
//  Created by 微博@iOS程序犭袁 (http://weibo.com/luohanchenyilong/) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//

#import "BXTGlobal.h"
#import "CYLTabBarControllerConfig.h"
#import "BXTRepairHomeViewController.h"
#import "BXTShopsHomeViewController.h"
#import "BXTMailListViewController.h"
#import "BXTApplicationsViewController.h"
#import "BXTSettingViewController.h"
#import "UINavigationController+YRBackGesture.h"

@interface CYLTabBarControllerConfig ()

@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;

@end

@implementation CYLTabBarControllerConfig

- (CYLTabBarController *)tabBarController
{
    if (_tabBarController == nil)
    {
        BXTHomeViewController *homeVC;
        if ([BXTGlobal shareGlobal].isRepair)
        {
            homeVC = [[BXTRepairHomeViewController alloc] init];
        }
        else
        {
            homeVC = [[BXTShopsHomeViewController alloc] init];
        }
        UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
        [homeNav setEnableBackGesture:YES];
        homeNav.navigationBarHidden = YES;
        
        BXTMailListViewController *mailListVC = [[BXTMailListViewController alloc] init];
        UINavigationController *mailListNav = [[UINavigationController alloc] initWithRootViewController:mailListVC];
        [mailListNav setEnableBackGesture:YES];
        mailListNav.navigationBarHidden = YES;
        
        BXTApplicationsViewController *applicationsVC = [[BXTApplicationsViewController alloc] init];
        UINavigationController *applicationsNav = [[UINavigationController alloc] initWithRootViewController:applicationsVC];
        [applicationsNav setEnableBackGesture:YES];
        applicationsNav.navigationBarHidden = YES;
        
        BXTSettingViewController *settingVC = [[BXTSettingViewController alloc] init];
        UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:settingVC];
        [settingNav setEnableBackGesture:YES];
        settingNav.navigationBarHidden = YES;
        
        CYLTabBarController *tabBarController = [[CYLTabBarController alloc] init];
        [self setUpTabBarItemsAttributesForController:tabBarController];
        [tabBarController setViewControllers:@[homeNav,mailListNav,applicationsNav,settingNav]];
        [[self class] customizeTabBarAppearance];
        
        _tabBarController = tabBarController;
    }
    return _tabBarController;
}

- (void)setUpTabBarItemsAttributesForController:(CYLTabBarController *)tabBarController
{
    NSDictionary *dict1 = @{CYLTabBarItemImage : @"Tab_Home",
                            CYLTabBarItemSelectedImage : @"Tab_Home_Select",
                            };
    NSDictionary *dict2 = @{CYLTabBarItemImage : @"Tab_Friends",
                            CYLTabBarItemSelectedImage : @"Tab_Friends_Select",
                            };
    NSDictionary *dict3 = @{CYLTabBarItemImage : @"Tab_Application",
                            CYLTabBarItemSelectedImage : @"Tab_Application_Select",
                            };
    NSDictionary *dict4 = @{CYLTabBarItemImage : @"Tab_My",
                            CYLTabBarItemSelectedImage : @"Tab_My_Select",
                            };
    NSArray *tabBarItemsAttributes = @[dict1,dict2,dict3,dict4];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
}

+ (void)customizeTabBarAppearance
{
    //去除 TabBar 自带的顶部阴影
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}

@end
