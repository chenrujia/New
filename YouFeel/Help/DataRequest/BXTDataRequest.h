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
    LocationShop,
    UpdateTime,
    UserInfoForChatList,
    FindPassword,
    ChangePassWord,
    UpdateHeadPic,
    UpdateShopAddress,
    ConfigInfo,
    StartRepair,
    Statistics_Complete,
    Statistics_Subgroup,
    Statistics_Faulttype,
    Statistics_Workload_day,
    Statistics_Workload_year,
    Statistics_Workload,
    Statistics_Praise,
    SpecialOrderTypes,
    Exit_Login,
    Device_Con,
    Device_Repair_List,
    Inspection_Record_List,
    Mail_Get_All,
    Mail_User_list,
    MaintenanceEquipmentList,
    Add_Inspection,
    Update_Inspection,
    Ads_Pics,
    Remind_Number
};

@protocol BXTDataResponseDelegate <NSObject>

- (void)requestResponseData:(id)response
                requeseType:(RequestType)type;
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
 *  工单列表 第一个是报修者身份，第二个是维修者身份，第三个是管理者
 */
- (void)repairsList:(NSString *)state
            andPage:(NSInteger)page
andIsMaintenanceMan:(BOOL)isMaintenanceMan
andRepairerIsReacive:(NSString *)reacive;

- (void)repairerList:(NSString *)state
             andPage:(NSInteger)page
            andPlace:(NSString *)place
       andDepartment:(NSString *)department
        andBeginTime:(NSString *)beginTime
          andEndTime:(NSString *)endTime
        andFaultType:(NSString *)faultType
         andTaskType:(NSString *)taskType;

- (void)repairsList:(NSString *)longTime
         andDisUser:(NSString *)disUser
       andCloseUser:(NSString *)closeUser
       andOrderType:(NSString *)orderType
      andSubgroupID:(NSString *)groupID
            andPage:(NSInteger)page
        close_state:(NSString *)close_state;

- (void)allRepairs:(NSString *)collection
       andTimeName:(NSString *)timeName
      andStartTime:(NSString *)startTime
        andEndTime:(NSString *)endTime
      andOrderType:(NSString *)orderType
        andGroupID:(NSString *)groupID
      andSubgroups:(NSArray *)groups
          andState:(NSString *)state
           andPage:(NSInteger)page;

/**
 *  新建工单
 */
- (void)createRepair:(NSString *)faultType
      faultType_type:(NSString *)faulttype_type
          faultCause:(NSString *)cause
          faultLevel:(NSString *)level
         depatmentID:(NSString *)depID
         floorInfoID:(NSString *)floorID
          areaInfoId:(NSString *)areaID
          shopInfoID:(NSString *)shopID
           equipment:(NSString *)eqID
          faultNotes:(NSString *)notes
          imageArray:(NSArray *)images
     repairUserArray:(NSArray *)userArray;

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
- (void)evaluateRepair:(NSArray *)rateArray
       evaluationNotes:(NSString *)notes
              repairID:(NSString *)reID
            imageArray:(NSArray *)images;

/**
 *  接单
 */
- (void)reaciveOrderID:(NSString *)repairID
           arrivalTime:(NSString *)time
             andUserID:(NSString *)userID
              andUsers:(NSArray *)users
             andIsGrad:(BOOL)isGrab;

/**
 *  指派后的接单
 */
- (void)reaciveOrderForAssign:(NSString *)repairID
                  arrivalTime:(NSString *)time
                    andUserID:(NSString *)userID;

/**
 *  派工or增员
 */
- (void)dispatchingMan:(NSString *)repairID
               andMans:(NSArray *)mans;

/**
 *  维修者分组
 */
- (void)propertyGrouping;

/**
 *  维修状态
 */
- (void)maintenanceState:(NSString *)repairID
          andReaciveTime:(NSString *)reaciveTime
           andFinishTime:(NSString *)finishTime
     andMaintenanceState:(NSString *)state
            andFaultType:(NSString *)faultType
             andManHours:(NSString *)hours
       andSpecialOrderID:(NSString *)specialOID
               andImages:(NSArray *)images
                andNotes:(NSString *)notes
                andMMLog:(NSString *)mmLog
      andCollectionGroup:(NSString *)group;

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
- (void)shopWithLatitude:(NSString *)latitude
        andWithLongitude:(NSString *)longitude;

/**
 *  消息列表
 */
- (void)newsListWithPage:(NSInteger)page;

/**
 *  消息分类列表
 */
- (void)messageList;

/**
 *  更新到达现场时间
 */
- (void)updateTime:(NSString *)time
       andRepairID:(NSString *)repairID;

/**
 *  意见反馈
 */
- (void)feedback:(NSString *)notes;

/**
 *  关于我们
 */
- (void)aboutUs;

/**
 *  会话列表用户信息
 */
- (void)userInfoForChatListWithID:(NSString *)userID;

/**
 *  找回密码
 */
- (void)findPassWordWithMobile:(NSString *)moblie
                   andWithCode:(NSString *)code;

/**
 *  重置密码
 */
- (void)changePassWord:(NSString *)password
             andWithID:(NSString *)pw_ID
            andWithKey:(NSString *)key;

/**
 *  更新头像
 */
- (void)updateHeadPic:(NSString *)pic;

/**
 *  更新店铺地址
 */
- (void)updateShopAddress:(NSString *)storeID;

/**
 *  获取配置参数
 */
- (void)configInfo;

/**
 *  开始维修
 */
- (void)startRepair:(NSString *)repairID;

/**
 *  统计-完成率统计
 */
- (void)statisticsCompleteWithTimeStart:(NSString *)startTime
                                timeEnd:(NSString *)endTime;

/**
 *  统计-分组统计
 */
- (void)statisticsSubgroupWithTimeStart:(NSString *)startTime
                                timeEnd:(NSString *)endTime;

/**
 *  统计-故障类型统计
 */
- (void)statisticsFaulttypeWithTimeStart:(NSString *)startTime
                                 timeEnd:(NSString *)endTime;

/**
 *  统计-按月获取每日详情
 */
- (void)statisticsWorkloadDayWithYear:(NSString *)year
                                month:(NSString *)month;

/**
 *  统计-按年获取每月详情
 */
- (void)statisticsWorkloadYearWithYear:(NSString *)year;

/**
 *  统计-按分组统计维修量
 */
- (void)statisticsWorkloadWithTimeStart:(NSString *)startTime
                                timeEnd:(NSString *)endTime;

/**
 *  统计-按分组好评
 */
- (void)statisticsPraiseWithTimeStart:(NSString *)startTime
                              timeEnd:(NSString *)endTime;

/**
 *  特殊工单类型
 */
- (void)specialOrderTypes;

/**
 *  驳回工单
 */
- (void)rejectOrder:(NSString *)orderID
          withNotes:(NSString *)notes;

/**
 *  关闭工单
 */
- (void)closeOrder:(NSString *)orderID
         withNotes:(NSString *)notes;

/**
 *  退出登录
 */
- (void)exitLoginWithClientID:(NSString *)clientid;

/**
 *  设备详情
 */
- (void)equipmentInformation:(NSString *)deviceID;

/**
 *  当前工单
 */
- (void)deviceRepairListWithOrder:(NSString *)order
                         deviceID:(NSString *)device_id
                        timestart:(NSString *)startTime
                         timeover:(NSString *)endTime
                         pagesize:(NSString *)pagesize
                             page:(NSString *)page;

/**
 *  维保档案
 */
- (void)inspectionRecordListWithPagesize:(NSString *)pagesize
                                    page:(NSString *)page
                                deviceID:(NSString *)device_id
                               timestart:(NSString *)startTime
                                timeover:(NSString *)endTime;

/**
 *  通讯录列表
 */
- (void)mailListOfAllPerson;

/**
 *  通讯录搜索列表
 */
- (void)mailListOfUserList;

/**
 *  个人信息
 */
- (void)mailListOfOnePersonWithID:(NSString *)userID;

/**
 *  解析二维码内容
 */
- (void)scanResultWithContent:(NSString *)content;

/**
 *  维保设备列表
 */
- (void)maintenanceEquipmentList:(NSString *)deviceID;

/**
 *  添加设备维护记录
 */
- (void)addInspectionRecord:(NSString *)workorderID
                   deviceID:(NSString *)device_id
            andInspectionID:(NSString *)inspectionID
          andInspectionData:(NSString *)inspectionData
                   andNotes:(NSString *)notes
                  andImages:(NSArray *)images;

/**
 *  修改设备维护记录
 */
- (void)updateInspectionRecordID:(NSString *)recordID
                        deviceID:(NSString *)device_id
                  andWorkorderID:(NSString *)workorderID
                 andInspectionID:(NSString *)inspectionID
               andInspectionData:(NSString *)inspectionData
                        andNotes:(NSString *)notes
                       andImages:(NSArray *)images;

/**
 *  设备维护记录详情
 */
- (void)inspectionRecordInfo:(NSString *)deviceID;

/**
 *  首页广告页
 */
- (void)advertisementPages;

/**
 *  广告位图片展示
 */
- (void)appVCAdvertisement;

/**
 *  公告列表
 */
- (void)announcementListWithReadState:(NSString *)readState
                        pagesize:(NSString *)pagesize
                            page:(NSString *)page;

/**
 *  提醒数字接口
 */
- (void)remindNumberWithDailyTimeStart:(NSString *)dailyStart
                    InspectioTimeStart:(NSString *)inspectioStart;

@end
