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
#import "UINavigationController+YRBackGesture.h"
#import "BXTProjectManageViewController.h"
#import "CYLTabBarController.h"
#import "BXTNewWorkOrderViewController.h"

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
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
        BXTNewWorkOrderViewController *newVC = (BXTNewWorkOrderViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTNewWorkOrderViewController"];
        newVC.isNewWorkOrder = YES;
        nav = [[UINavigationController alloc] initWithRootViewController:newVC];
        
        [BXTGlobal shareGlobal].presentNav = nav;
        [nav setEnableBackGesture:YES];
        nav.navigationBarHidden = YES;
        [[AppDelegate appdelegete].window.rootViewController presentViewController:nav animated:YES completion:nil];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"BXTRepairButton" object:nil] subscribeNext:^(id x) {
        [button setImage:[UIImage imageNamed:@"Tab_Repair"] forState:UIControlStateNormal];
        button.center = CGPointMake(SCREEN_WIDTH/2, 15);
        LogRed(@"center:%@",NSStringFromCGPoint(button.center));
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"BXTRepairButtonOther" object:nil] subscribeNext:^(id x) {
        [button setImage:[UIImage imageNamed:@"Tab_Bar"] forState:UIControlStateNormal];
        button.center = CGPointMake(SCREEN_WIDTH/2, 25);
        LogBlue(@"center:%@",NSStringFromCGPoint(button.center));
    }];
    
    return button;
}

+ (CGFloat)multiplerInCenterY
{
    return 0.3;
}

@end
