//
//  BXTResignBaseView.h
//  BXT
//
//  Created by Jason on 15/9/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTHeaderForVC.h"
#import "BXTSelectBoxView.h"
#import "AppDelegate.h"
#import "BXTSettingTableViewCell.h"
#import "BXTShopLocationViewController.h"
#import "BXTShopsHomeViewController.h"
#import "BXTRepairHomeViewController.h"
#import "UIView+Nav.h"
#import "BXTGroupingInfo.h"
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, ViewType) {
    RepairType,
    PropertyType
};

@interface BXTResignBaseView : UIView <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BXTDataResponseDelegate,BXTBoxSelectedTitleDelegate,MBProgressHUDDelegate>
{
    UITableView *currentTableView;
    NSInteger indexRow;
    NSInteger currentRow;
    BXTSelectBoxView *boxView;
    NSMutableArray *departmentArray;
    NSMutableArray *positionArray;
    NSMutableArray *groupArray;
}

@property (nonatomic ,assign) ViewType viewType;

- (instancetype)initWithFrame:(CGRect)frame andViewType:(ViewType)type;

- (void)createBoxView:(NSInteger)section;

@end
