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
    BindingUser,
    GetVerificationCode,
    DepartmentType,
    ShopType,
    PositionType,
    ShopLists,
    BranchResign,
    BranchLogin,
    CommitShop,
    FaultType,
    OrderFaultType,
    AllFaultType,
    CreateMaintenanceOrder,
    CreateRepair,
    RepairList,
    SubgroupLists,
    PlaceLists,
    DeleteRepair,
    RepairDetail,
    DeviceList,
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
    Device_AvailableStatics,
    Device_AvailableType,
    InspectionPlanOverview,
    Statistics_MTPlanList,
    Statistics_EPList,
    Statistics_DeviceTypeList,
    Statistics_MTComplete,
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
 */
- (void)resignUser:(NSDictionary *)parameters;

/**
 *  绑定
 */
- (void)bindingUser:(NSDictionary *)parameters;

/**
 *  登录
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
 *  设备列表
 */
- (void)deviceListWithPlaceID:(NSString *)placeID;
- (void)devicesWithPlaceID:(NSString *)placeID;

/**
 *  店铺信息
 */
- (void)shopLists:(NSString *)departmentID;

/**
 *  分店注册
 */
- (void)branchResign:(NSInteger)is_repair
           andShopID:(NSString *)shopID;

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
- (void)faultTypeListWithRTaskType:(NSString *)taskType;

/**
 *  工单类型
 */
- (void)orderTypeList;

/**
 *  全部故障类型
 */
- (void)allFaultTypeListWith:(NSString *)taskType;

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
 *  获取工单列表 - 新
 */
- (void)listOfRepairOrderWithTaskType:(NSString *)task_type // 工单任务类型 1正常工单 2维保工单
                              FaultID:(NSString *)fault_id // 报修人的用户id
                          FaulttypeID:(NSString *)faulttype_id // 故障类型id
                                Order:(NSString *)order // 排序 1按排序顺序排序
                          DispatchUid:(NSString *)dispatch_uid // 维修员的用户id（维修员获取被指派的任务）
                            RepairUid:(NSString *)repair_uid // 维修员的用户id（维修员获取自己的工单列表）
                         DailyTimeout:(NSString *)daily_timeout // 正常工单筛选是否超时 1超时 2正常
                    InspectionTimeout:(NSString *)inspection_timeout // 维保工单过期查询 1超时 2将要超时
                             TimeName:(NSString *)timename // 要排序的字段名称（此处填写 fault_time）
                             TmeStart:(NSString *)timestart // 时间戳的开始时间
                             TimeOver:(NSString *)timeover // 时间戳的结束时间
                           SubgroupID:(NSString *)subgroup_id // 获取专业分组的工单列表
                              PlaceID:(NSString *)place_id // 获取此位置下面的所有位置的工单
                          RepairState:(NSString *)repairstate // 工单状态
                                State:(NSString *)state // 维修状态 1已修好 2 未修好
                    FaultCarriedState:(NSString *)fault_carried_state // 报修者的列表进度状态
                   RepairCarriedState:(NSString *)repair_carried_state // 维修者的列表进度状态
                                 Page:(NSInteger)page;

/**
 *  获取故障类型列表 - 新
 */
- (void)listOFSubgroup;

/**
 *  获取位置数组 - 新
 *  isAllPlace - YES获取全部位置
 */
- (void)listOFPlaceIsAllPlace:(BOOL)isAllPlace;

/**
 *  设备添加报修
 */
- (void)createNewMaintenanceOrderWithDeviceID:(NSString *)deviceID
                                    faulttype:(NSString *)faulttype
                               faultType_type:(NSString *)faulttype_type
                                   faultCause:(NSString *)cause
                                   faultLevel:(NSString *)level
                                  depatmentID:(NSString *)depID
                                    equipment:(NSString *)eqID
                                   faultNotes:(NSString *)notes
                                   imageArray:(NSArray *)images
                              repairUserArray:(NSArray *)userArray;

/**
 *  新建工单
 */
- (void)createRepair:(NSString *)faultType
      faultType_type:(NSString *)faulttype_type
           deviceIDs:(NSString *)deviceID
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
- (void)newsListWithPage:(NSInteger)page
              noticeType:(NSString *)noticeType;

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
 *  意见反馈列表
 */
- (void)feedbackCommentList;

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
 *  统计-计划维保概览
 */
- (void)inspectionPlanOverview;

/**
 *  统计-设备完好率统计
 */
- (void)deviceAvailableStaticsWithDate:(NSString *)date;

/**
 *  统计-设备分类统计
 */
- (void)deviceTypeStaticsWithDate:(NSString *)date;

/**
 *  统计-维保任务列表
 */
- (void)statisticsMTPlanListWithTimeStart:(NSString *)startTime
                                  TimeEnd:(NSString *)endTime
                              SubgroupIDs:(NSString *)subgroupIDs
                         FaulttypeTypeIDs:(NSString *)faulttypeTypeIDs
                                    State:(NSString *)state
                                    Order:(NSString *)order
                                 Pagesize:(NSString *)pageSize
                                     Page:(NSString *)page;

/**
 *  统计-维保设备列表
 */
- (void)statisticsEPListWithTime:(NSString *)date
                           State:(NSString *)state
                           Order:(NSString *)order
                          TypeID:(NSString *)typeID
                          AreaID:(NSString *)areaID
                         PlaceID:(NSString *)placeID
                        StoresID:(NSString *)storesID
                        Pagesize:(NSString *)pageSize
                            Page:(NSString *)page;

/**
 *  获取设备分类（一级分类）
 */
- (void)deviceTypeList;

/**
 *  统计-维保完成率统计
 */
- (void)statisticsMTCompleteWithDate:(NSString *)date
                            Subgroup:(NSString *)subgroup
                       FaulttypeType:(NSString *)faulttypeType;

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
                                timeEnd:(NSString *)endTime
                                   Type:(NSString *)type;

/**
 *  统计-按分组好评
 */
- (void)statisticsPraiseWithTimeStart:(NSString *)startTime
                              timeEnd:(NSString *)endTime
                                 Type:(NSString *)type;

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
- (void)mailListOfOnePersonWithID:(NSString *)userID shopID:(NSString *)shopID;

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
                   andState:(NSString *)state
                  andImages:(NSArray *)images
               andLongitude:(CGFloat)longitude
                andLatitude:(CGFloat)latitude
                    andDesc:(NSString *)desc;

/**
 *  修改设备维护记录
 */
- (void)updateInspectionRecordID:(NSString *)recordID
                        deviceID:(NSString *)device_id
                 andInspectionID:(NSString *)inspectionID
               andInspectionData:(NSString *)inspectionData
                        andNotes:(NSString *)notes
                        andState:(NSString *)state
                       andImages:(NSArray *)images
                    andLongitude:(CGFloat)longitude
                     andLatitude:(CGFloat)latitude
                         andDesc:(NSString *)desc;

/**
 *  设备维护记录详情
 */
- (void)inspectionRecordInfo:(NSString *)deviceID
                   andWorkID:(NSString *)workID;

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
