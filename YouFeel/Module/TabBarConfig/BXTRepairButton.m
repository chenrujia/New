//
//  BXTRepairButton.m
//  CustomTabBar
//
//  Created by Jason on 15/12/24.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTRepairButton.h"
#import "BXTGlobal.h"
#import "AppDelegate.h"
#import "BXTMMOrderManagerViewController.h"
#import "BXTRepairViewController.h"
#import "UINavigationController+YRBackGesture.h"
#import "BXTProjectInfromViewController.h"
#import "CYLTabBarController.h"

@implementation BXTRepairButton

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+(void)load
{
    [super registerSubclass];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    
    return self;
}

#pragma mark -
#pragma mark CYLPlusButtonSubclassing
+ (instancetype)plusButton
{
    BXTRepairButton *button = [[BXTRepairButton alloc] init];
    [button setImage:[UIImage imageNamed:@"Tab_Repair"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"Tab_Repair_Select"] forState:UIControlStateHighlighted];
    [button sizeToFit];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSString *is_verify = [BXTGlobal getUserProperty:U_IS_VERIFY];
        if ([is_verify integerValue] != 1)
        {
            [BXTGlobal showText:@"您尚未验证，现在去验证" view:[AppDelegate appdelegete].window.rootViewController.view completionBlock:^{
                id rootVC = [AppDelegate appdelegete].window.rootViewController;
                CYLTabBarController *tempVC = (CYLTabBarController *)rootVC;
                UINavigationController *nav = [tempVC.viewControllers objectAtIndex:tempVC.selectedIndex];
                
                BXTProjectInfromViewController *pivc = [[BXTProjectInfromViewController alloc] init];
                pivc.hidesBottomBarWhenPushed = YES;
                
                [nav pushViewController:pivc animated:YES];
            }];
        }
        else
        {
            UINavigationController *nav;
            if ([BXTGlobal shareGlobal].isRepair)
            {
                BXTMMOrderManagerViewController *newOrderVC = [[BXTMMOrderManagerViewController alloc] init];
                newOrderVC.isRepairList = YES;
                nav = [[UINavigationController alloc] initWithRootViewController:newOrderVC];
            }
            else
            {
                BXTRepairViewController *repairVC = [[BXTRepairViewController alloc] initWithVCType:ShopsVCType];
                repairVC.isRepairList = YES;
                nav = [[UINavigationController alloc] initWithRootViewController:repairVC];
                
            }
            
            [BXTGlobal shareGlobal].presentNav = nav;
            [nav setEnableBackGesture:YES];
            nav.navigationBarHidden = YES;
            [[AppDelegate appdelegete].window.rootViewController presentViewController:nav animated:YES completion:nil];
        }
        
        
        
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"BXTRepairButton" object:nil] subscribeNext:^(id x) {
        [button setImage:[UIImage imageNamed:@"Tab_Repair"] forState:UIControlStateNormal];
        button.center = CGPointMake(SCREEN_WIDTH/2, 15);
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"BXTRepairButtonOther" object:nil] subscribeNext:^(id x) {
        [button setImage:[UIImage imageNamed:@"Tab_Bar"] forState:UIControlStateNormal];
        button.center = CGPointMake(SCREEN_WIDTH/2, 25);
    }];
    
    return button;
}

+ (CGFloat)multiplerInCenterY
{
    return 0.3;
}

@end
