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
    LoginType = 0,
    BindingUser = 1,
    GetVerificationCode = 2,
    DepartmentType = 3,
    ShopType = 4,
    PositionType = 5,
    ShopLists = 6,
    BranchResign = 7,
    BranchLogin = 8,
    CommitShop = 9,
    FaultType = 10,
    OrderFaultType = 11,
    AllFaultType = 12,
    CreateMaintenanceOrder = 13,
    CreateRepair = 14,
    RepairList = 15,
    SubgroupLists = 16,
    PlaceLists = 17,
    OtherAffairLists = 18,
    MyIntegral = 19,
    IntegarlRanking = 20,
    ModifyUserInform = 21,
    MessageList = 22,
    DeleteRepair = 23,
    RepairDetail = 24,
    DeviceList = 25,
    ReaciveOrder = 26,
    PropertyGrouping = 27,
    MaintenanceProcess = 28,
    ManList = 29,
    UploadHeadImage = 30,
    UserInfo = 31,
    LocationShop = 32,
    UpdateTime = 33,
    UserInfoForChatList = 34,
    FindPassword = 35,
    ChangePassWord = 36,
    UpdateHeadPic = 37,
    UpdateShopAddress = 38,
    StartRepair = 39,
    Device_AvailableStatics = 40,
    Device_AvailableType = 41,
    InspectionPlanOverview = 42,
    Statistics_MTPlanList = 43,
    Statistics_EPList = 44,
    Statistics_DeviceTypeList = 45,
    Statistics_MTComplete = 46,
    Statistics_Complete = 47,
    Statistics_Subgroup = 48,
    Statistics_Faulttype = 49,
    Statistics_Workload_day = 50,
    Statistics_Workload_year = 51,
    Statistics_Workload = 52,
    Statistics_Praise = 53,
    SpecialOrderTypes = 54,
    Exit_Login = 55,
    Device_Con = 56,
    Device_Repair_List = 57,
    Inspection_Record_List = 58,
    Mail_Get_All = 59,
    Mail_User_list = 60,
    MaintenanceEquipmentList = 61,
    Add_Inspection = 62,
    Update_Inspection = 63,
    Ads_Pics = 64,
    Remind_Number = 65,
    UserShopLists = 66,
    AuthenticationDetail = 67,
    HandlePermission = 68,
    DepartmentLists = 69,
    DutyLists = 70,
    StoresList = 71,
    AuthenticationApply = 72,
    IsFixed = 73,
};

@protocol BXTDataResponseDelegate <NSObject>

- (void)requestResponseData:(id)response
                requeseType:(RequestType)type;
- (void)requestError:(NSError *)error
         requeseType:(RequestType)type;

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
- (void)departmentsList:(NSString *)pid;

/**
 *  职位列表
 */
- (void)positionsList:(NSString *)dutyType;

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
           andShopID:(NSString *)shopID
      andBindPlaceID:(NSString *)placeID
      andSubgroupIDS:(NSString *)subIDS;
- (void)branchResign;

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
                              faultID:(NSString *)fault_id // 报修人的用户id
                          faulttypeID:(NSString *)faulttype_id // 故障类型id
                                order:(NSString *)order // 排序 1按排序顺序排序
                          dispatchUid:(NSString *)dispatch_uid // 维修员的用户id（维修员获取被指派的任务）
                            repairUid:(NSString *)repair_uid // 维修员的用户id（维修员获取自己的工单列表）
                         dailyTimeout:(NSString *)daily_timeout // 正常工单筛选是否超时 1超时 2正常
                    inspectionTimeout:(NSString *)inspection_timeout // 维保工单过期查询 1超时 2将要超时
                             timeName:(NSString *)timename // 要排序的字段名称（此处填写 fault_time）
                             tmeStart:(NSString *)timestart // 时间戳的开始时间
                             timeOver:(NSString *)timeover // 时间戳的结束时间
                           subgroupID:(NSString *)subgroup_id // 获取专业分组的工单列表
                              placeID:(NSString *)place_id // 获取此位置下面的所有位置的工单
                          repairState:(NSString *)repairstate // 工单状态
                                state:(NSString *)state // 维修状态 1已修好 2 未修好
                    faultCarriedState:(NSString *)fault_carried_state // 报修者的列表进度状态
                   repairCarriedState:(NSString *)repair_carried_state // 维修者的列表进度状态
                                 page:(NSInteger)page;

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
 *  获取部门列表 - 新
 *  pid - 获取该id下部门树形数据，默认为0则为获取所有部门列表
 */
- (void)listOFDepartmentWithPid:(NSString *)pid;

/**
 *  获取职位列表 - 新
 *  pid - 1报修 2维修，默认：全部
 */
- (void)listOFDutyWithDutyType:(NSString *)duty_type;

/**
 *  获取商铺列表 - 新
 *  stores_name - 商铺名：模糊搜索
 */
- (void)listOFStoresWithStoresName:(NSString *)stores_name;

/**
 *  获取待处理事件列表 - 新
 */
- (void)listOFOtherAffairWithHandleState:(NSString *)handle_state
                                    page:(NSInteger)page;

/**
 *  获取我的积分 - 新
 */
- (void)listOFMyIntegralWithDate:(NSString *)date;

/**
 *  积分排名列表 - 新
 */
- (void)listOFIntegralRankingWithDate:(NSString *)date;

/**
 *  修改用户资料 - 新
 */
- (void)modifyUserInformWithName:(NSString *)name
                          gender:(NSString *)gender
                          mobile:(NSString *)mobile;

/**
 *  我的项目列表 - 新
 */
- (void)listOFUserShopLists;

/**
 *  项目认证详情 - 新
 */
- (void)projectAuthenticationDetailWithShopID:(NSString *)shopID;

/**
 *  分店添加用户 - 新
 */
- (void)projectAddUserWithShopID:(NSString *)shopID;

/**
 *  项目认证申请 - 新
 */
- (void)authenticationApplyWithShopID:(NSString *)shop_id
                                 type:(NSString *)type
                         departmentID:(NSString *)department_id
                               dutyID:(NSString *)duty_id
                           subgroupID:(NSString *)subgroup_id
                      haveSubgroupIDs:(NSString *)have_subgroup_ids
                             storesID:(NSString *)stores_id;

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
- (void)createRepair:(NSString *)reserveTime
         faultTypeID:(NSString *)faultTypeID
          faultCause:(NSString *)cause
             placeID:(NSString *)placeID
           deviceIDs:(NSString *)deviceID
              adsTxt:(NSString *)adsTxt
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
 *  控制操作按钮显示
 */
- (void)handlePermission:(NSString *)workorderID
                 sceneID:(NSString *)sceneID;

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
- (void)reaciveOrderID:(NSString *)repairID;

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
- (void)exitLogin;

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
 *  提醒数字接口 - 新
 */
- (void)remindNumberWithDailyTimestart:(NSString *)daily_timestart
                   inspectionTimestart:(NSString *)inspection_timestart
                       repairTimestart:(NSString *)repair_timestart
                       reportTimestart:(NSString *)report_timestart
                       objectTimestart:(NSString *)object_timestart
                 announcementTimestart:(NSString *)announcement_timestart;

/**
 *  报修者确认是否修好
 */
- (void)isFixed:(NSString *)repairID
   confirmState:(NSString *)confirmState
   confirmNotes:(NSString *)notes;

@end
