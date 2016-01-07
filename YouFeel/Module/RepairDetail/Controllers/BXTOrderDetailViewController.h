//
//  BXTOrderDetailViewController.h
//  BXT
//
//  Created by Jason on 15/9/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTDetailBaseViewController.h"
#import "BXTRepairInfo.h"
#import <RongIMKit/RongIMKit.h>

//维修员版工单详情
@interface BXTOrderDetailViewController : BXTDetailBaseViewController

/**
 *  是否有关闭工单按钮
 */
@property (nonatomic, assign) BOOL isRejectVC;
/**
 *  从全部工单过来的只有查看的权利
 */
@property (nonatomic, assign) BOOL isAllOrderType;
@property (weak, nonatomic) IBOutlet UIView       *contentView;
@property (weak, nonatomic) IBOutlet UIImageView  *headImgView;
@property (weak, nonatomic) IBOutlet UILabel      *repairerName;
@property (weak, nonatomic) IBOutlet UILabel      *repairerDetail;
@property (weak, nonatomic) IBOutlet UILabel      *mobile;
@property (weak, nonatomic) IBOutlet UIButton     *connectTa;
@property (weak, nonatomic) IBOutlet UILabel      *repairID;
@property (weak, nonatomic) IBOutlet UILabel      *groupName;
@property (weak, nonatomic) IBOutlet UILabel      *time;
@property (weak, nonatomic) IBOutlet UILabel      *orderType;
@property (weak, nonatomic) IBOutlet UILabel      *place;
@property (weak, nonatomic) IBOutlet UILabel      *faultType;
@property (weak, nonatomic) IBOutlet UILabel      *cause;
@property (weak, nonatomic) IBOutlet UILabel      *level;
@property (weak, nonatomic) IBOutlet UILabel      *notes;
@property (weak, nonatomic) IBOutlet UIScrollView *images_scrollview;
@property (weak, nonatomic) IBOutlet UIView       *lineOne;
@property (weak, nonatomic) IBOutlet UILabel      *arrangeTime;
@property (weak, nonatomic) IBOutlet UILabel      *mmProcess;
@property (weak, nonatomic) IBOutlet UILabel      *workTime;
@property (weak, nonatomic) IBOutlet UILabel      *completeTime;
@property (weak, nonatomic) IBOutlet UIView       *lineTwo;
@property (weak, nonatomic) IBOutlet UILabel      *maintenanceMan;
@property (weak, nonatomic) IBOutlet UIButton     *reaciveOrder;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sco_content_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *group_name_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line_one_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line_two_top;

- (IBAction)reaciveBtn:(id)sender;
- (void)dataWithRepairID:(NSString *)repair_ID;

@end
