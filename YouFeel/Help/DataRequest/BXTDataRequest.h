//
//  BXTDataRequest.h
//  BXT
//
//  Created by Jason on 15/8/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, RequestType) {
    LoginType,
    DepartmentType,
    ShopType,
    PositionType,
    ShopLists,
    BranchResign,
    BranchLogin,
    CommitShop,
    FaultType,
    CreateRepair,
    RepairList,
    DeleteRepair,
    RepairDetail,
    ReaciveOrder,
    PropertyGrouping,
    MaintenanceProcess,
    ManList,
    UploadHeadImage,
    UserInfo,
    LocationShop
};

@protocol BXTDataResponseDelegate <NSObject>

- (void)requestResponseData:(id)response requeseType:(RequestType)type;
- (void)requestError:(NSError *)error;

@end

@interface BXTDataRequest : NSObject<MBProgressHUDDelegate>
{
    MBProgressHUD *progressHUD;
}
@property (nonatomic ,assign) RequestType requestType;
@property (nonatomic ,weak) id <BXTDataResponseDelegate> delegate;

- (instancetype)initWithDelegate:(id <BXTDataResponseDelegate>)delegate;

/**
 *  注册
 *
 *  @param parameters 注册时需要传的参数
 */
- (void)resignUser:(NSDictionary *)parameters;

/**
 *  登录
 *
 *  @param parameters 登录时需要传的参数
 */
- (void)loginUser:(NSDictionary *)parameters;

/**
 *  部门列表
 */
- (void)departmentsList:(NSString *)is_repair;

/**
 *  职位列表
 */
- (void)positionsList:(NSString *)departmentID;

/**
 *  分店位置
 */
- (void)shopLocation;

/**
 *  店铺信息
 */
- (void)shopLists:(NSString *)departmentID;

/**
 *  分店注册
 */
- (void)branchResign:(NSInteger)is_repair;

/**
 *  分店登录
 */
- (void)branchLogin;

/**
 *  添加商铺
 */
- (void)commitNewShop:(NSString *)shop;

/**
 *  故障类型
 */
- (void)faultTypeList;

/**
 *  报修列表 第一个是报修者身份，第一个是维修者身份
 */
- (void)repairList:(NSString *)state andPage:(NSInteger)page andIsMaintenanceMan:(BOOL)isMaintenanceMan;
- (void)repairerList:(NSString *)state andPage:(NSInteger)page andPlace:(NSString *)place andDepartment:(NSString *)department andBeginTime:(NSString *)beginTime andEndTime:(NSString *)endTime andFaultType:(NSString *)faultType;

/**
 *  新建工单
 */
- (void)createRepair:(NSString *)faultType faultCause:(NSString *)cause faultLevel:(NSString *)level depatmentID:(NSString *)depID floorInfoID:(NSString *)floorID
          areaInfoId:(NSString *)areaID shopInfoID:(NSString *)shopID equipment:(NSString *)eqID faultNotes:(NSString *)notes imageArray:(NSArray *)images repairUserArray:(NSArray *)userArray;

/**
 *  删除工单
 */
- (void)deleteRepair:(NSString *)repairID;

/**
 *  工单详情
 */
- (void)repairDetail:(NSString *)repairID;

/**
 *  评价
 */
- (void)evaluateRepair:(NSArray *)rateArray evaluationNotes:(NSString *)notes repairID:(NSString *)reID imageArray:(NSArray *)images;

/**
 *  接单
 */
- (void)reaciveOrderID:(NSString *)repairID arrivalTime:(NSString *)time andIsGrad:(BOOL)isGrab;

/**
 *  派工or增员
 */
- (void)dispatchingMan:(NSString *)repairID andMans:(NSArray *)mans;

/**
 *  维修者分组
 */
- (void)propertyGrouping;

/**
 *  维修状态
 */
- (void)maintenanceState:(NSString *)repairID andReaciveTime:(NSString *)reaciveTime andFinishTime:(NSString *)finishTime andMaintenanceState:(NSString *)state andFaultType:(NSString *)faultType andManHours:(NSString *)hours;

/**
 *  维修员列表
 */
- (void)maintenanceManList:(NSString *)groupID;

/**
 *  上传头像
 */
- (void)uploadHeaderImage:(UIImage *)image;

/**
 *  获取验证码
 */
- (void)mobileVerCode:(NSString *)mobile;

/**
 *  用户详情
 */
- (void)userInfo;

/**
 *  绩效列表
 */
- (void)achievementsList:(NSInteger)months;

/**
 *  评价列表
 */
- (void)evaluationListWithType:(NSInteger)evaType;

/**
 *  获取附近商店
 */
- (void)shopWithLatitude:(NSString *)latitude andWithLongitude:(NSString *)longitude;

/**
 *  消息列表
 */
- (void)newsList;

/**
 *  消息分类列表
 */
- (void)messageList;

@end
