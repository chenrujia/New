//
//  BXTRepairDetailViewController.h
//  BXT
//
//  Created by Jason on 15/9/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTDetailBaseViewController.h"
#import "BXTRepairInfo.h"
#import <RongIMKit/RongIMKit.h>

//商铺版工单详情
@interface BXTRepairDetailViewController : BXTDetailBaseViewController

@property (weak, nonatomic) IBOutlet UIView             *contentView;
@property (weak, nonatomic) IBOutlet UILabel            *repairID;
@property (weak, nonatomic) IBOutlet UILabel            *time;
@property (weak, nonatomic) IBOutlet UILabel            *place;
@property (weak, nonatomic) IBOutlet UILabel            *name;
@property (weak, nonatomic) IBOutlet UILabel            *mobile;
@property (weak, nonatomic) IBOutlet UILabel            *faultType;
@property (weak, nonatomic) IBOutlet UILabel            *cause;
@property (weak, nonatomic) IBOutlet UILabel            *level;
@property (weak, nonatomic) IBOutlet UILabel            *notes;
@property (weak, nonatomic) IBOutlet UIView             *lineOne;
@property (weak, nonatomic) IBOutlet UIView             *lineTwo;
@property (weak, nonatomic) IBOutlet UILabel            *arrangeTime;
@property (weak, nonatomic) IBOutlet UILabel            *mmProcess;
@property (weak, nonatomic) IBOutlet UILabel            *workTime;
@property (weak, nonatomic) IBOutlet UILabel            *completeTime;
@property (weak, nonatomic) IBOutlet UILabel            *maintenanceMan;
@property (weak, nonatomic) IBOutlet UIButton           *cancelRepair;
@property (weak, nonatomic) IBOutlet UIScrollView       *images_scrollview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line_one_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line_two_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sco_content_height;

- (void)dataWithRepair:(BXTRepairInfo *)repair;

@end
