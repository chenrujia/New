//
//  BXTEquipmentBaseView.m
//  YouFeel
//
//  Created by 满孝意 on 15/12/29.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTEquipmentBaseView.h"

@interface BXTEquipmentBaseView () <MBProgressHUDDelegate>

@end

@implementation BXTEquipmentBaseView

#pragma mark -
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame deviceID:(NSString *)device_id
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.deviceID = device_id;
        [self initial];
    }
    return self;
}

- (instancetype)init
{
    if (self == [super init])
    {
        [self initial];
    }
    return self;
}

- (void)initial
{
    
}

#pragma mark -
#pragma mark - 方法
- (void)showLoadingMBP:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.delegate = self;
    hud.removeFromSuperViewOnHide = YES;
}

- (void)hideMBP
{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

- (UINavigationController *)getNavigation
{
    id rootVC = [AppDelegate appdelegete].window.rootViewController;
    UINavigationController *nav = nil;
    if ([rootVC isKindOfClass:[CYLTabBarController class]])
    {
        CYLTabBarController *tempVC = rootVC;
        nav = [tempVC.viewControllers objectAtIndex:tempVC.selectedIndex];
    }
    else if ([rootVC isKindOfClass:[UINavigationController class]])
    {
        nav = rootVC;
    }
    
    return nav;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
