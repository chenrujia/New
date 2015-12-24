//
//  BXTHomeViewController.h
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface BXTHomeViewController : BXTBaseViewController <UITableViewDataSource,UITableViewDelegate,RCIMUserInfoDataSource>
{
    UILabel          *shop_label;
    UIButton         *logo_Btn;
    UILabel          *title_label;
    NSMutableArray   *datasource;
    UIImageView      *logoImgView;
}

@property (nonatomic, strong) NSMutableArray *imgNameArray;
@property (nonatomic, strong) NSMutableArray *titleNameArray;
@property (nonatomic, strong) UITableView    *currentTableView;

- (void)createLogoView;
- (void)repairClick;
/**
 *  是否已验证
 */
- (BOOL)is_verify;

@end
