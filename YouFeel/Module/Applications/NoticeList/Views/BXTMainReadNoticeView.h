//
//  BXTMainReadNoticeView.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTHeaderFile.h"
#import "BXTReadNoticeCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "CYLTabBarController.h"
#import "AppDelegate.h"
#import "BXTReadNotice.h"
#import "BXTNoticeInformViewController.h"

typedef NS_ENUM(NSInteger, NoticeType) {
    NoticeType_UnRead = 1,
    NoticeType_Read = 2
};

@interface BXTMainReadNoticeView : UIView <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate, BXTDataResponseDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;

/** ---- 初始化 ---- */
- (void)initial;

/** ---- 请求数据 ---- */
- (void)requestNetResourceWithReadState:(NSInteger)readState;

- (UINavigationController *)getNavigation;

@end
