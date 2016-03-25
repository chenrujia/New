//
//  BXTHomeViewController.h
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "BXTRemindNum.h"

typedef NS_ENUM(NSInteger, HiddenType) {
    HiddenType_SpecialOrders = 1,
    HiddenType_BusinessStatistics,
    HiddenType_Both
};

@interface BXTHomeViewController : BXTBaseViewController <UITableViewDataSource,UITableViewDelegate,RCIMUserInfoDataSource>
{
    UILabel          *shop_label;
    UIButton         *logo_Btn;
    UILabel          *title_label;
    UIImageView      *logoImgView;
}

@property (nonatomic, strong) NSMutableArray *imgNameArray;
@property (nonatomic, strong) NSMutableArray *titleNameArray;
@property (nonatomic, strong) UITableView    *currentTableView;

- (void)createLogoView;
- (void)repairClick;

/**
 *  我的维修工单
 */
- (void)pushMyOrdersIsRepair:(BOOL)isRepair;
- (void)pushEvaluationList;
- (void)pushSpecialOrders;
- (void)pushStatistics;
- (void)pushExamination;
- (void)pushNormalOrders;
- (void)pushMaintenceOrders;
- (void)pushAchievements;
- (void)projectPhone;

@end
