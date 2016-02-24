//
//  BXTStatisticsMianView.h
//  YouFeel
//
//  Created by 满孝意 on 16/2/22.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "BXTHeaderFile.h"
#import "CYLTabBarController.h"
#import "AppDelegate.h"
#import "BXTStatisticsCell.h"

@interface BXTStatisticsMianView : UIView <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *detailArray;
@property (nonatomic, strong) NSMutableArray *imageArray1;
@property (nonatomic, strong) NSMutableArray *imageArray2;

/** ---- 初始化 ---- */
- (void)initial;

/** ---- 显示 ---- */
- (void)showLoadingMBP:(NSString *)text;

/** ---- 隐藏 ---- */
- (void)hideMBP;

/** ---- 获取UINavigationController ---- */
- (UINavigationController *)getNavigation;

@end
