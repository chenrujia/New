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
- (instancetype)initWithFrame:(CGRect)frame deviceID:(NSString *)device_id orderID:(NSString *)orderID
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.deviceID = device_id;
        self.orderID = orderID;
        [self initial];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
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

@end
