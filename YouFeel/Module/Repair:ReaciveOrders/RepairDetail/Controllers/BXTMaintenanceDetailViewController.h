//
//  BXTMaintenanceDetailViewController.h
//  YouFeel
//
//  Created by Jason on 16/1/7.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTDetailBaseViewController.h"

@interface BXTMaintenanceDetailViewController : BXTDetailBaseViewController

/**
 *  是否有关闭工单按钮
 */
@property (nonatomic, assign) BOOL isRejectVC;
/**
 *  从全部工单过来的只有查看的权利
 */
@property (nonatomic, assign) BOOL isAllOrderType;
/**
 *  是否是从设备详情过来的
 */
@property (nonatomic, assign) BOOL isComingFromDeviceInfo;

@property (weak, nonatomic) IBOutlet UIView       *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *images_scrollview;
@property (weak, nonatomic) IBOutlet UIImageView  *headImgView;
@property (weak, nonatomic) IBOutlet UILabel      *repairerName;
@property (weak, nonatomic) IBOutlet UILabel      *repairerDetail;
@property (weak, nonatomic) IBOutlet UILabel      *mobile;
@property (weak, nonatomic) IBOutlet UIButton     *connectTa;
@property (weak, nonatomic) IBOutlet UIView       *lineView;
@property (weak, nonatomic) IBOutlet UILabel      *repairID;
@property (weak, nonatomic) IBOutlet UILabel      *maintenance;
@property (weak, nonatomic) IBOutlet UILabel      *groupName;
@property (weak, nonatomic) IBOutlet UILabel      *repairTime;
@property (weak, nonatomic) IBOutlet UILabel      *endTime;
@property (weak, nonatomic) IBOutlet UILabel      *place;
@property (weak, nonatomic) IBOutlet UILabel      *faultType;
@property (weak, nonatomic) IBOutlet UILabel      *cause;
@property (weak, nonatomic) IBOutlet UILabel      *level;
@property (weak, nonatomic) IBOutlet UIView       *firstBV;
@property (weak, nonatomic) IBOutlet UIView       *secondBV;
@property (weak, nonatomic) IBOutlet UIView       *thirdBV;
@property (weak, nonatomic) IBOutlet UIView       *fouthBV;
@property (weak, nonatomic) IBOutlet UILabel      *arrangeTime;
@property (weak, nonatomic) IBOutlet UILabel      *mmProcess;
@property (weak, nonatomic) IBOutlet UILabel      *workTime;
@property (weak, nonatomic) IBOutlet UILabel      *completeTime;
@property (weak, nonatomic) IBOutlet UILabel      *maintenanceMan;
@property (weak, nonatomic) IBOutlet UIButton     *reaciveOrder;
@property (weak, nonatomic) IBOutlet UITabBar     *bottomTabBar;
@property (weak, nonatomic) IBOutlet UIButton     *cancelRepair;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sco_content_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sco_content_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *first_bv_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repair_id_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *second_bv_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *third_bv_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fouth_bv_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *group_name_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *third_bv_top;

- (IBAction)cancelTheRepair:(id)sender;
- (IBAction)reaciveAction:(id)sender;
- (void)dataWithRepairID:(NSString *)repair_ID;

@end
