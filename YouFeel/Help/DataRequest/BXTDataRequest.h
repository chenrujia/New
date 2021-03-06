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
    ShopType = 3,
    ShopLists = 4,
    BranchResign = 5,
    BranchLogin = 6,
    FaultType = 7,
    OrderFaultType = 8,
    CreateRepair = 9,
    RepairList = 10,
    SubgroupLists = 11,
    PlaceLists = 12,
    OtherAffairLists = 13,
    MyIntegral = 14,
    IntegarlRanking = 15,
    ModifyUserInform = 16,
    MessageList = 17,
    DeleteRepair = 18,
    RepairDetail = 19,
    DeviceList = 20,
    ReaciveOrder = 21,
    MaintenanceProcess = 22,
    ManList = 23,
    UploadHeadImage = 24,
    UserInfo = 25,
    LocationShop = 26,
    UserInfoForChatList = 27,
    FindPassword = 28,
    ChangePassWord = 29,
    StartRepair = 30,
    Device_AvailableStatics = 31,
    Device_AvailableType = 32,
    InspectionPlanOverview = 33,
    Statistics_EPList = 34,
    Statistics_DeviceTypeList = 35,
    Statistics_MTComplete = 36,
    Statistics_Complete = 37,
    Statistics_Subgroup = 38,
    Statistics_Faulttype = 39,
    Statistics_Workload_day = 40,
    Statistics_Workload_year = 41,
    Statistics_Workload = 42,
    Statistics_Praise = 43,
    Exit_Login = 44,
    Device_Con = 45,
    Device_Repair_List = 46,
    Inspection_Record_List = 47,
    Mail_Get_All = 48,
    Mail_User_list = 49,
    MaintenanceEquipmentList = 50,
    Add_Inspection = 51,
    Update_Inspection = 52,
    Ads_Pics = 53,
    Remind_Number = 54,
    UserShopLists = 55,
    HandlePermission = 57,
    DepartmentLists = 58,
    DutyLists = 59,
    StoresList = 60,
    AuthenticationApply = 61,
    ModifyBindPlace = 62,
    SpecialOrder = 63,
    DeviceState = 64,
    AuthenticationVerify = 65,
    DispatchOrAdd = 66,
    AuthenticationModify = 67,
    RepairState = 68,
    InspectionTaskList = 69,
    IsSure = 70,
    ShopConfig = 71,
    UnBundingUser = 72,
    EndMaintenceOrder = 73,
    ListOFAllShops = 74,
    ListOFStoresPlace = 75,
    DeleteNews = 76,
    InformOFOA = 77,
    AppVCAdvertisement = 78,
    EnergyMeterLists = 79,
    EnergyMeterDetail = 80,
    EnergyMeasuremenLevelLists = 81,
    MeterFavoriteAdd = 82,
    MeterFavoriteDel = 83,
    MeterFavoriteLists = 84,
    EnergyMeterRecordFile = 85,
    EnergyMeterRecordAdd = 86,
    EnergyMeterRecordCalculate = 87,
    EnergyMeterRecordMonthLists = 88,
    EnergyMeterRecordDayLists = 89,
    EnergyMeterRecordLists = 90,
    EfficiencySurveyMonth = 91,
    EfficiencySurveyYear = 92,
    EfficiencyDistributionMonth = 93,
    EfficiencyDistributionYear = 94,
    EfficiencyTrendMonth = 95,
    EfficiencyTrendYear = 96,
    AboutUs = 97,
    ServiceAgreement = 98,
};

typedef NS_ENUM(NSInteger, RepairListType)
{
    MyMaintenanceList,//我的维修工单
    MyRepairList,//我的报修工单
    OtherList//日常工单或维保工单
};

typedef void(^DataRequestSuccess)(RequestType type,id response);
typedef void(^DataRequestFail)(RequestType type,NSError *error);

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

@property (nonatomic ,assign) RequestType             requestType;
@property (nonatomic, copy  ) DataRequestSuccess      successBlock;
@property (nonatomic, copy  ) DataRequestFail         failBlock;
@property (nonatomic ,weak  ) id <BXTDataResponseDelegate> delegate;

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
 *  解绑
 */
- (void)unbundlingUser:(NSDictionary *)parameters;

/**
 *  登录
 */
- (void)loginUser:(NSDictionary *)parameters;

/**
 *  分店位置
 */
- (void)shopLocation;

/**
 *  设备列表
 */
- (void)devicesWithPlaceID:(NSString *)placeID;

/**
 *  店铺信息
 */
- (void)shopLists:(NSString *)departmentID;

/**
 *  分店注册
 */
- (void)branchResign;

/**
 *  分店登录
 */
- (void)branchLogin;

/**
 *  故障类型
 */
- (void)faultTypeListWithRTaskType:(NSString *)taskType more:(NSString *)more;

/**
 *  紧急类型
 */
- (void)urgentFaultType;

/**
 *  工单类型
 */
- (void)orderTypeList;

/**
 *  获取工单列表
 */
- (void)listOfRepairOrderWithTaskType:(NSString *)task_type // 工单任务类型 1正常工单 2维保工单
                       repairListType:(RepairListType)listType//Yes维修工单 No报修工单
                          faulttypeID:(NSString *)faulttype_id // 故障类型id
                                order:(NSString *)order // 排序 1按排序顺序排序
                          dispatchUid:(NSString *)dispatch_uid // 维修员的用户id（维修员获取被指派的任务）
                         dailyTimeout:(NSString *)daily_timeout // 正常工单筛选是否超时 1超时 2正常
                    inspectionTimeout:(NSString *)inspection_timeout // 维保工单过期查询 1超时 2将要超时
                             timeName:(NSString *)timename // 要排序的字段名称（此处填写 fault_time）
                             tmeStart:(NSString *)timestart // 时间戳的开始时间
                             timeOver:(NSString *)timeover // 时间戳的结束时间
                           subgroupID:(NSString *)subgroup_id // 获取专业分组的工单列表
                          subgroupIDs:(NSString *)subgroup_ids // 获取专业分组的工单列表
                              placeID:(NSString *)place_id // 获取此位置下面的所有位置的工单
                          repairState:(NSString *)repairstate // 工单状态
                                state:(NSString *)state // 维修状态 1已修好 2 未修好
                    faultCarriedState:(NSString *)fault_carried_state // 报修者的列表进度状态
                   repairCarriedState:(NSString *)repair_carried_state // 维修者的列表进度状态
                         collectionID:(NSString *)collection_id
                             deviceID:(NSString *)device_id
                                 page:(NSInteger)page
                           closeState:(NSString *)close_state;  //默认传1， 特殊情况传0

/**
 *  获取专业分组列表
 */
- (void)listOFSubgroupShopID:(NSString *)shopID;

/**
 *  获取商铺位置列表
 */
- (void)listOFStoresPlaceWithStoresID:(NSString *)storesID;

/**
 *  获取位置数组
 *  isAllPlace - YES获取全部位置
 */
- (void)listOFPlaceIsAllPlace;

/**
 *  获取部门列表
 *  pid - 获取该id下部门树形数据，默认为0则为获取所有部门列表
 */
- (void)listOFDepartmentWithPid:(NSString *)pid
                         shopID:(NSString *)shopID
                   identityType:(NSString *)identity_type;

/**
 *  获取职位列表
 *  pid - 1报修 2维修，默认：全部
 */
- (void)listOFDutyWithDutyType:(NSString *)duty_type
                        shopID:(NSString *)shopID
                  identityType:(NSString *)identity_type;

/**
 *  获取商铺列表
 *  stores_name - 商铺名：模糊搜索
 */
- (void)listOFStoresWithStoresName:(NSString *)stores_name;

/**
 *  获取待处理事件列表
 */
- (void)listOFOtherAffairWithHandleState:(NSString *)handle_state
                                    page:(NSInteger)page;

/**
 *  获取我的积分
 */
- (void)listOFMyIntegralWithDate:(NSString *)date;

/**
 *  积分排名列表
 */
- (void)listOFIntegralRankingWithDate:(NSString *)date;

/**
 *  修改用户资料
 */
- (void)modifyUserInformWithName:(NSString *)name
                          gender:(NSString *)gender
                          mobile:(NSString *)mobile;

/**
 *  我的项目列表
 */
- (void)listOFUserShopLists;

/**
 *  项目认证审核
 *  is_verify - 认证审核：1通过 0不通过
 */
- (void)projectAuthenticationVerifyWithApplicantID:(NSString *)applicantID
                                         affairsID:(NSString *)affairs_id
                                          isVerify:(NSString *)is_verify;

/**
 *  分店添加用户
 */
- (void)projectAddUserWithShopID:(NSString *)shopID;

/**
 *  项目认证申请
 */
- (void)authenticationApplyWithShopID:(NSString *)shop_id
                                 type:(NSString *)type
                         departmentID:(NSString *)department_id
                             dutyName:(NSString *)duty_name
                           subgroupID:(NSString *)subgroup_id
                      haveSubgroupIDs:(NSString *)have_subgroup_ids
                             storesID:(NSString *)stores_id
                         bindPlaceIDs:(NSString *)bind_place_ids;

/**
 *  项目认证修改
 */
- (void)authenticationModifyWithShopID:(NSString *)shop_id
                                  type:(NSString *)type
                          departmentID:(NSString *)department_id
                                dutyID:(NSString *)duty_id
                            subgroupID:(NSString *)subgroup_id
                       haveSubgroupIDs:(NSString *)have_subgroup_ids
                              storesID:(NSString *)stores_id;

/**
 *  修改用户常用位置
 */
- (void)modifyBindPlaceWithShopID:(NSString *)shop_id
                          placeID:(NSString *)place_id;

/**
 *  新建工单
 */
- (void)createRepair:(NSString *)reserveTime
         faultTypeID:(NSString *)faultTypeID
          faultCause:(NSString *)cause
             placeID:(NSString *)placeID
             adsText:(NSString *)adsText
           deviceIDs:(NSString *)deviceID
          imageArray:(NSArray *)images
     repairUserArray:(NSArray *)userArray
            isMySelf:(NSString *)isMySelf;

/**
 *  删除工单
 */
- (void)deleteRepair:(NSString *)repairID;

/**
 *  工单详情
 */
- (void)repairDetail:(NSString *)repairID;
- (void)repairDetail:(NSString *)repairID success:(DataRequestSuccess)successBlock fail:(DataRequestFail)failBlock;

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
            imageArray:(NSArray *)images
             affairsID:(NSString *)affairs_id;

/**
 *  接单
 */
- (void)reaciveOrderID:(NSString *)repairID;
- (void)reaciveOrderID:(NSString *)repairID success:(DataRequestSuccess)successBlock fail:(DataRequestFail)failBlock;

/**
 *  接指派过来的工单
 */
- (void)reaciveDispatchedOrderID:(NSString *)repairID;
- (void)reaciveDispatchedOrderID:(NSString *)repairID success:(DataRequestSuccess)successBlock fail:(DataRequestFail)failBlock;

/**
 *  派工or增员
 */
- (void)dispatchingMan:(NSString *)repairID
               andMans:(NSString *)mans;

/**
 *  维修过程
 */
- (void)maintenanceState:(NSString *)repairID
                 placeID:(NSString *)placeID
             deviceState:(NSString *)deviceState
              orderState:(NSString *)state
               faultType:(NSString *)faultType
                reasonID:(NSString *)reasonID
                   mmLog:(NSString *)mmLog
                  images:(NSArray *)images;

/**
 *  维修员列表
 */
- (void)maintenanceManList;

/**
 *  上传头像
 */
- (void)uploadHeaderImage:(UIImage *)image;

/**
 *  获取验证码
 *  1. 注册用户  2. 找回密码  3. 修改密码
 */
- (void)mobileVerCode:(NSString *)mobile
                 type:(NSString *)type;

/**
 *  用户详情
 */
- (void)userInfo;

/**
 *  所有商店
 */
- (void)listOFAllShops;

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
 *  删除消息
 */
- (void)deleteNewsWithIDs:(NSString *)deleteIDs;

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
 *  服务协议
 */
- (void)serviceAgreement;

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
             andWithID:(NSString *)pwID
            andWithKey:(NSString *)key;

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
- (void)statisticsInspectionTaskListWithStartTime:(NSString *)start_time
                                          endTime:(NSString *)end_time
                                      subgroupIDs:(NSString *)subgroup_ids
                                 faulttypeTypeIDs:(NSString *)faulttype_type_ids
                                            state:(NSString *)state
                                            order:(NSString *)order
                                         pagesize:(NSString *)pagesize
                                             page:(NSString *)page;

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
                      SearchName:(NSString *)search_name
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
 *  分店ids，其中0表示总店，如：0,11,4
 */
- (void)mailListOfUserListWithShopIDs:(NSString *)shopIDs;

/**
 *  个人信息 - 只有项目管理进入的详情用out_userid 其他userID
 */
- (void)mailListOfOnePersonWithID:(NSString *)userID
                        outUserID:(NSString *)out_userid
                           shopID:(NSString *)shop_id;

/**
 *  解析二维码内容
 */
- (void)scanResultWithContent:(NSString *)content;

/**
 *  维保设备列表
 */
- (void)maintenanceEquipmentList:(NSString *)deviceID
                         orderID:(NSString *)orderID;

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
                        deviceID:(NSString *)deviceID
             andInspectionItemID:(NSString *)inspectionItemID
               andInspectionData:(NSString *)inspectionData
                        andNotes:(NSString *)notes
                        andState:(NSString *)state
                       andImages:(NSArray *)images
                    andLongitude:(CGFloat)longitude
                     andLatitude:(CGFloat)latitude
                         andDesc:(NSString *)desc;

/**
 *  结束维保工单
 */
- (void)endMaintenceOrder:(NSString *)workOrderID;

/**
 *  设备维护记录详情
 */
- (void)inspectionRecordInfo:(NSString *)recordID;

/**
 *  首页广告页
 */
- (void)advertisementPages;

/**
 *  分店获取设置信息
 */
- (void)shopConfig;

/**
 *  OA系统
 */
- (void)informOFOA;

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
 *
 *  @param daily_timestart        日常工单起始时间
 *  @param inspection_timestart   维保工单起始时间
 *  @param repair_timestart       我的维修工单起始时间
 *  @param report_timestart       我的报修工单起始时间
 *  @param object_timestart       其他事务起始时间
 *  @param announcement_timestart 公告起始时间
 */
- (void)remindNumberWithDailyTimestart:(NSString *)daily_timestart
                   inspectionTimestart:(NSString *)inspection_timestart
                       repairTimestart:(NSString *)repair_timestart
                       reportTimestart:(NSString *)report_timestart
                       objectTimestart:(NSString *)object_timestart
                 announcementTimestart:(NSString *)announcement_timestart
                       noticeTimestart:(NSString *)notice_timestart;

/**
 *  报修者确认是否修好
 */
- (void)isFixed:(NSString *)repairID
   confirmState:(NSString *)confirmState
   confirmNotes:(NSString *)notes
      affairsID:(NSString *)affairs_id;

/**
 *  特殊工单 & 设备状态 & 维修状态
 */
- (void)specialWorkOrder;
- (void)deviceStates;
- (void)repairStates;

/**
 *  计量表列表
 */
- (void)energyMeterListsWithType:(NSString *)type
                       checkType:(NSString *)check_type
                       priceType:(NSString *)price_type
                         placeID:(NSString *)place_id
                 measurementPath:(NSString *)measurement_path
                      searchName:(NSString *)search_name
                            page:(NSInteger)page;

/**
 *  计量层级树形列表
 */
- (void)energyMeasuremenLevelListsWithType:(NSString *)type;

/**
 *  计量表收藏 - 添加/取消
 */
- (void)energyMeterFavoriteAddWithAboutID:(NSString *)aboutID
                                   delIDs:(NSString *)del_ids;

/**
 *  计量表 - 收藏列表
 */
- (void)energyMeterFavoriteListsWithType:(NSString *)type
                               checkType:(NSString *)check_type
                                    page:(NSInteger)page
                              searchName:(NSString *)search_name;

/**
 *  计量表 - 抄表记录，月
 */
- (void)energyMeterRecordMonthListsWithAboutID:(NSString *)aboutID
                                          year:(NSString *)year;

/**
 *  计量表 - 抄表记录，日
 */
- (void)energyMeterRecordDayListsWithAboutID:(NSString *)aboutID
                                        date:(NSString *)date;

/**
 *  计量表 - 抄表记录，列表
 */
- (void)energyMeterRecordListsWithAboutID:(NSString *)aboutID
                                     date:(NSString *)date
                                     page:(NSInteger)page;

/**
 *  计量表详情
 */
- (void)energyMeterDetailWithID:(NSString *)meterDetailID;

/**
 *  计量表抄表 - 上传图片
 */
- (void)energyMeterRecordFileWithImage:(UIImage *)image;

/**
 *  计量表 - 抄表
 */
- (void)energyMeterRecordAddWithAboutID:(NSString *)aboutID
                               totalNum:(NSString *)total_num
                          peakPeriodNum:(NSString *)peak_period_num
                         flatSectionNum:(NSString *)flat_section_num
                       valleySectionNum:(NSString *)valley_section_num
                         peakSegmentNum:(NSString *)peak_segment_num
                               totalPic:(NSString *)total_pic
                          peakPeriodPic:(NSString *)peak_period_pic
                         flatSectionPic:(NSString *)flat_section_pic
                       valleySectionPic:(NSString *)valley_section_pic
                         peakSegmentPic:(NSString *)peak_segment_pic
                        remainingEnergy:(NSString *)remaining_energy
                         remainingMoney:(NSString *)remaining_money;

/**
 *  计量表 - 能耗计算
 */
- (void)energyMeterRecordCalculateWithAboutID:(NSString *)aboutID
                                    startTime:(NSString *)start_time
                                      endTime:(NSString *)end_time;

/**
 *  建筑能效概况 - 月统计
 */
- (void)efficiencySurveyMonthWithDate:(NSString *)date;

/**
 *  建筑能效概况 - 年统计
 */
- (void)efficiencySurveyYearWithDate:(NSString *)date;

/**
 *  建筑能效分布 - 月统计
 */
- (void)efficiencyDistributionMonthWithDate:(NSString *)date
                                      ppath:(NSString *)ppath;

/**
 *  建筑能效分布 - 年统计
 */
- (void)efficiencyDistributionYearWithDate:(NSString *)date
                                     ppath:(NSString *)ppath;

/**
 *  建筑能效趋势 - 月统计
 */
- (void)efficiencyTrendMonthWithDate:(NSString *)date
                               ppath:(NSString *)ppath;

/**
 *  建筑能效趋势 - 年统计
 */
- (void)efficiencyTrendYearWithDate:(NSString *)date
                              ppath:(NSString *)ppath;

@end
