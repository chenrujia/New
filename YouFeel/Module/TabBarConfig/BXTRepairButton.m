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
        [nav setEnableBackGesture:YES];
        nav.navigationBarHidden = YES;
        [[AppDelegate appdelegete].window.rootViewController presentViewController:nav animated:YES completion:nil];
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
