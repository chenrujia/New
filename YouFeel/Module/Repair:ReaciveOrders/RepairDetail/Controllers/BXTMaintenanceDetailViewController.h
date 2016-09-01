//
//  BXTMaintenanceDetailViewController.h
//  YouFeel
//
//  Created by Jason on 16/1/7.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTDetailBaseViewController.h"

typedef NS_ENUM (NSInteger, SceneType)
{
    MyRepairType = 1,//我的报修工单
    MyMaintenanceType = 2,//我的维修工单
    DailyType = 3,//日常工单接单池
    MaintainType = 4,//维保工单接单池
    MessageType = 5,//从消息列表进入
    AllOrderType = 6,//全部工单
    OtherAffairType = 7,//其他事物
};

@interface BXTMaintenanceDetailViewController : BXTDetailBaseViewController
{
    BOOL isFirst;//判断是不是第一次进入viewDidAppear
}
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

@property (nonatomic, assign) SceneType sceneType;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView       *contentView;
@property (weak, nonatomic) IBOutlet UIImageView  *headImgView;
@property (weak, nonatomic) IBOutlet UILabel      *repairerName;
@property (weak, nonatomic) IBOutlet UILabel      *departmentName;
@property (weak, nonatomic) IBOutlet UILabel      *positionName;
@property (weak, nonatomic) IBOutlet UIButton     *connectTa;
@property (weak, nonatomic) IBOutlet UILabel      *orderType;
@property (weak, nonatomic) IBOutlet UILabel      *orderState;
@property (weak, nonatomic) IBOutlet UILabel      *repairPerson;
@property (weak, nonatomic) IBOutlet UILabel      *repairUsers;
@property (weak, nonatomic) IBOutlet UILabel      *maintenceRecord;
@property (weak, nonatomic) IBOutlet UILabel      *repairID;
@property (weak, nonatomic) IBOutlet UILabel      *repairTime;
@property (weak, nonatomic) IBOutlet UILabel      *place;
@property (weak, nonatomic) IBOutlet UILabel      *faultType;
@property (weak, nonatomic) IBOutlet UILabel      *cause;
@property (weak, nonatomic) IBOutlet UIView       *firstBV;
@property (weak, nonatomic) IBOutlet UIView       *secondBV;
@property (weak, nonatomic) IBOutlet UIView       *thirdBV;
@property (weak, nonatomic) IBOutlet UIView       *fouthBV;
@property (weak, nonatomic) IBOutlet UIView       *fifthBV;
@property (weak, nonatomic) IBOutlet UIView       *sixthBV;
@property (weak, nonatomic) IBOutlet UIView       *seventhBV;
@property (weak, nonatomic) IBOutlet UIView       *eighthBV;
@property (weak, nonatomic) IBOutlet UIView       *ninthBV;
@property (weak, nonatomic) IBOutlet UIView       *tenthBV;
@property (weak, nonatomic) IBOutlet UIView       *buttonBV;
@property (weak, nonatomic) IBOutlet UILabel      *reaciveOrderTime;
@property (weak, nonatomic) IBOutlet UILabel      *comeTime;
@property (weak, nonatomic) IBOutlet UILabel      *consumeTime;
@property (weak, nonatomic) IBOutlet UILabel      *endTime;
@property (weak, nonatomic) IBOutlet UILabel      *doneState;
@property (weak, nonatomic) IBOutlet UILabel      *doneNotes;
@property (weak, nonatomic) IBOutlet UILabel      *commentContent;
@property (weak, nonatomic) IBOutlet UILabel      *confirmationPerson;
@property (weak, nonatomic) IBOutlet UILabel      *criticPerson;

@property (weak, nonatomic) IBOutlet UILabel      *evaluateNotes;
@property (weak, nonatomic) IBOutlet UILabel      *orderStyle;
@property (weak, nonatomic) IBOutlet UIImageView  *alarm;
@property (weak, nonatomic) IBOutlet UIImageView  *faultPicOne;
@property (weak, nonatomic) IBOutlet UIImageView  *faultPicTwo;
@property (weak, nonatomic) IBOutlet UIImageView  *faultPicThree;
@property (weak, nonatomic) IBOutlet UIImageView  *fixPicOne;
@property (weak, nonatomic) IBOutlet UIImageView  *fixPicTwo;
@property (weak, nonatomic) IBOutlet UIImageView  *fixPicThree;
@property (weak, nonatomic) IBOutlet UIImageView  *evaluatePicOne;
@property (weak, nonatomic) IBOutlet UIImageView  *evaluatePicTwo;
@property (weak, nonatomic) IBOutlet UIImageView  *evaluatePicThree;
@property (weak, nonatomic) IBOutlet UIScrollView *mmScroller;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scroller_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *time_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *first_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fifth_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sixth_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ninth_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *first_bv_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fifth_bv_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seventh_bv_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ninth_bv_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *end_time_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *done_state_top;

- (void)dataWithRepairID:(NSString *)repairID sceneType:(SceneType)type;

/**
 *  其他事物 -- affairID
 */
@property (copy, nonatomic) NSString *affairID;

@property (strong, nonatomic) RACSubject *delegateSignal;

@end
