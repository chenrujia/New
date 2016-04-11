//
//  BXTDataRequest.m
//  BXT
//
//  Created by Jason on 15/8/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTDataRequest.h"
#import "NSString+URL.h"
#import "BXTHeaderFile.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "DES3Util.h"

@implementation BXTDataRequest

- (instancetype)initWithDelegate:(id <BXTDataResponseDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
    }
    return self;
}

- (void)resignUser:(NSDictionary *)parameters
{
    NSString *url = [NSString stringWithFormat:@"%@/module/User/opt/reg_user",KADMINBASEURL];
    [self postRequest:url withParameters:parameters];
}

- (void)bindingUser:(NSDictionary *)parameters
{
    self.requestType = BindingUser;
    NSString *url = [NSString stringWithFormat:@"%@/module/User/opt/third_bind_mobile",KADMINBASEURL];
    [self postRequest:url withParameters:parameters];
}

- (void)loginUser:(NSDictionary *)parameters
{
    self.requestType = LoginType;
    NSString *url = [NSString stringWithFormat:@"%@/module/User/opt/login",KADMINBASEURL];
    [self postRequest:url withParameters:parameters];
}

- (void)departmentsList:(NSString *)pid
{
    self.requestType = DepartmentType;
    NSDictionary *dic = nil;
    if (pid)
    {
        dic = @{@"pid": pid};
    }
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=department_one_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)positionsList:(NSString *)dutyType
{
    self.requestType = PositionType;
    NSDictionary *dic = nil;
    if (dutyType)
    {
        dic = @{@"duty_type": dutyType};
    }
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=duty_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)shopLocation
{
    self.requestType = ShopType;
    NSString *url = [NSString stringWithFormat:@"%@&module=Portmeans&opt=get_map",[BXTGlobal shareGlobal].baseURL];
    [self getRequest:url];
}

- (void)deviceListWithPlaceID:(NSString *)placeID
{
    self.requestType = DeviceList;
    NSDictionary *dic = @{@"page": @"0",
                          @"pagesize": @"0",
                          @"place_id": placeID};
    NSString *url = [NSString stringWithFormat:@"%@&module=Device&opt=device_list",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)devicesWithPlaceID:(NSString *)placeID
{
    self.requestType = DeviceList;
    NSDictionary *dic = @{@"place_id": placeID};
    NSString *url = [NSString stringWithFormat:@"%@&module=Device&opt=device_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)shopLists:(NSString *)departmentID
{
    self.requestType = ShopLists;
    NSString *url;
    if (departmentID)
    {
        url = [NSString stringWithFormat:@"%@/module/Shops/opt/get_shops&id=%@",KADMINBASEURL,departmentID];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@/module/Shops/opt/get_shops/is_hot/1",KADMINBASEURL];
    }
    [self getRequest:url];
}

- (void)branchResign:(NSInteger)is_repair
           andShopID:(NSString *)shopID
      andBindPlaceID:(NSString *)placeID
      andSubgroupIDS:(NSString *)subIDS

{
    self.requestType = BranchResign;
    
    BXTDepartmentInfo *departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
    BXTPostionInfo *postionInfo = [BXTGlobal getUserProperty:U_POSITION];
    
    NSString *subGroup = @"";
    BXTGroupingInfo *groupInfo = [BXTGlobal getUserProperty:U_GROUPINGINFO];
    if (groupInfo)
    {
        subGroup = groupInfo.group_id;
    }
    
    NSDictionary *dic = @{@"out_userid":[BXTGlobal getUserProperty:U_USERID],
                          @"duty_id":postionInfo.role_id,
                          @"department_id":departmentInfo.dep_id,
                          @"subgroup_id":groupInfo.group_id,
                          @"have_subgroup_ids":subIDS,
                          @"stores_id": shopID,
                          @"bind_place_ids":placeID};
    
    SaveValueTUD(@"BranchResign_shopID", shopID);
    
    NSString *urlLast = [NSString stringWithFormat:@"%@&shop_id=%@&token=%@",KAPIBASEURL, shopID, [BXTGlobal getUserProperty:U_TOKEN]];
    NSString *url = [NSString stringWithFormat:@"%@&module=user&opt=add_user",urlLast];
    
    [self postRequest:url withParameters:dic];
}

- (void)branchResign
{
    self.requestType = BranchResign;
    NSDictionary *dic = @{@"out_userid":[BXTGlobal getUserProperty:U_USERID]};
    //TODO:shop_id=11这是测试值
    NSString *url = [NSString stringWithFormat:@"%@&shop_id=11&module=user&opt=add_user",KAPIBASEURL];
    [self postRequest:url withParameters:dic];
}

- (void)branchLogin
{
    self.requestType = BranchLogin;
    
    NSArray *array = [BXTGlobal getUserProperty:U_SHOPIDS];
    NSString *shopID = nil;
    NSString *shortURL = nil;
    if (array && array.count)
    {
        shopID = [NSString stringWithFormat:@"%@", array[0]];
        shortURL = [BXTGlobal shareGlobal].baseURL;
    }
    else
    {
        //TODO: 11是临时值
        shopID = @"11";
        shortURL = KAPIBASEURL;
    }
    NSDictionary *dic = @{@"out_userid":[BXTGlobal getUserProperty:U_USERID]};
    NSString *url = [NSString stringWithFormat:@"%@&shop_id=%@&module=user&opt=shop_login",shortURL,shopID];
    [self postRequest:url withParameters:dic];
}

- (void)commitNewShop:(NSString *)shop
{
    self.requestType = CommitShop;
    BXTFloorInfo *floorInfo = [BXTGlobal getUserProperty:U_FLOOOR];
    BXTAreaInfo *areaInfo = [BXTGlobal getUserProperty:U_AREA];
    
    NSDictionary *dic = @{@"stores_name":shop,
                          @"area_id":floorInfo.area_id,
                          @"place_id":areaInfo.place_id,
                          @"info":@"123",
                          @"stores_pic":@""};
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Stores&opt=add_stores",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)faultTypeListWithRTaskType:(NSString *)taskType
{
    self.requestType = FaultType;
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdata&opt=get_hq_faulttype_type",[BXTGlobal shareGlobal].baseURL];
    if ([taskType isEqualToString:@"2"])
    {
        url = [NSString stringWithFormat:@"%@&module=Hqdata&opt=get_hq_faulttype_type&task_type=%@",[BXTGlobal shareGlobal].baseURL, taskType];
    }
    [self postRequest:url withParameters:nil];
}

- (void)orderTypeList
{
    self.requestType = OrderFaultType;
    NSDictionary *dic = @{@"task_type": @"1"};
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=faulttype_type_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)allFaultTypeListWith:(NSString *)taskType
{
    self.requestType = AllFaultType;
    NSDictionary *dic = @{@"task_type": taskType};
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdata&opt=get_hq_all_faulttype",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)repairsList:(NSString *)state
            andPage:(NSInteger)page
andIsMaintenanceMan:(BOOL)isMaintenanceMan
andRepairerIsReacive:(NSString *)reacive
{
    self.requestType = RepairList;
    BOOL stateIsComplete = NO;
    if ([state isEqualToString:@""])
    {
        stateIsComplete = YES;
    }
    NSString *identity = @"faultid";
    if (isMaintenanceMan)
    {
        identity = @"repairer";
    }
    if ([reacive isEqualToString:@"1"]) {
        state = @"";
    }
    if ([reacive isEqualToString:@"2"]) {
        state = @"2";
    }
    
    NSDictionary *dic;
    if (stateIsComplete)
    {
        dic = @{identity:[BXTGlobal getUserProperty:U_BRANCHUSERID],
                @"state":@"2",
                @"pagesize":@"5",
                @"page":[NSString stringWithFormat:@"%ld",(long)page],
                @"is_repairing":reacive};
    }
    else
    {
        dic = @{identity:[BXTGlobal getUserProperty:U_BRANCHUSERID],
                @"repairstate":state,
                @"pagesize":@"5",
                @"page":[NSString stringWithFormat:@"%ld",(long)page],
                @"is_repairing":reacive};
    }
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=repair_list",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)repairerList:(NSString *)state
             andPage:(NSInteger)page
            andPlace:(NSString *)place
       andDepartment:(NSString *)department
        andBeginTime:(NSString *)beginTime
          andEndTime:(NSString *)endTime
        andFaultType:(NSString *)faultType
         andTaskType:(NSString *)taskType
{
    self.requestType = RepairList;
    BOOL stateIsComplete = NO;
    if ([state isEqualToString:@""])
    {
        stateIsComplete = YES;
    }
    NSDictionary *dic;
    NSString *timeName = @"";
    if (beginTime.length > 0)
    {
        timeName = @"repair_time";
    }
    if (stateIsComplete)
    {
        dic = @{@"state":@"2",
                @"pagesize":@"5",
                @"page":[NSString stringWithFormat:@"%ld",(long)page],
                @"place":place,
                @"department":department,
                @"timestart":beginTime,
                @"timeover":endTime,
                @"timename":timeName,
                @"faulttype":faultType,
                @"task_type":taskType};
    }
    else
    {
        dic = @{@"repairstate":state,
                @"pagesize":@"5",
                @"page":[NSString stringWithFormat:@"%ld",(long)page],
                @"place":place,
                @"department":department,
                @"timestart":beginTime,
                @"timeover":endTime,
                @"timename":timeName,
                @"faulttype":faultType,
                @"task_type":taskType};
    }
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=repair_list",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)repairsList:(NSString *)longTime
         andDisUser:(NSString *)disUser
       andCloseUser:(NSString *)closeUser
       andOrderType:(NSString *)orderType
      andSubgroupID:(NSString *)groupID
            andPage:(NSInteger)page
        close_state:(NSString *)close_state
{
    NSString *closeState = @"";
    if (closeUser.length > 0)
    {
        closeState = @"2";
    }
    NSDictionary *dic;
    //不区分类型
    if (close_state.length > 0)
    {
        dic = @{@"long_time":longTime,
                @"dispatching_user":disUser,
                @"close_state":closeState,
                @"close_user":closeUser,
                @"order":orderType,
                @"page":[NSString stringWithFormat:@"%ld",(long)page],
                @"order_subgroup":groupID,
                @"pagesize":@"5",
                @"close_state":close_state};
    }
    else
    {
        dic = @{@"long_time":longTime,
                @"dispatching_user":disUser,
                @"close_state":closeState,
                @"close_user":closeUser,
                @"order":orderType,
                @"page":[NSString stringWithFormat:@"%ld",(long)page],
                @"pagesize":@"5",
                @"order_subgroup":groupID};
    }
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=repair_list",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)allRepairs:(NSString *)collection
       andTimeName:(NSString *)timeName
      andStartTime:(NSString *)startTime
        andEndTime:(NSString *)endTime
      andOrderType:(NSString *)orderType
        andGroupID:(NSString *)groupID
      andSubgroups:(NSArray *)groups
          andState:(NSString *)state
           andPage:(NSInteger)page
{
    NSDictionary *dic = @{@"collection":collection,
                          @"timename":timeName,
                          @"timestart":startTime,
                          @"timeover":endTime,
                          @"order":orderType,
                          @"order_subgroup":groupID,
                          @"check_subgroup":groups,
                          @"state":state,
                          @"page":[NSString stringWithFormat:@"%ld",(long)page],
                          @"pagesize":@"5",
                          @"close_state":@"all",
                          @"task_type":@"1"};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=repair_list",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)listOfRepairOrderWithTaskType:(NSString *)task_type
                              faultID:(NSString *)fault_id
                          faulttypeID:(NSString *)faulttype_id
                                order:(NSString *)order
                          dispatchUid:(NSString *)dispatch_uid
                            repairUid:(NSString *)repair_uid
                         dailyTimeout:(NSString *)daily_timeout
                    inspectionTimeout:(NSString *)inspection_timeout
                             timeName:(NSString *)timename
                             tmeStart:(NSString *)timestart
                             timeOver:(NSString *)timeover
                           subgroupID:(NSString *)subgroup_id
                              placeID:(NSString *)place_id
                          repairState:(NSString *)repairstate
                                state:(NSString *)state
                    faultCarriedState:(NSString *)fault_carried_state
                   repairCarriedState:(NSString *)repair_carried_state
                                 page:(NSInteger)page
{
    self.requestType = RepairList;
    NSDictionary *dic = @{@"task_type": task_type,
                          @"fault_id": fault_id,
                          @"faulttype_id": faulttype_id,
                          @"order": order,
                          @"dispatch_uid": dispatch_uid,
                          @"repair_uid": repair_uid,
                          @"daily_timeout": daily_timeout,
                          @"inspection_timeout": inspection_timeout,
                          @"timename": timename,
                          @"timestart": timestart,
                          @"timeover": timeover,
                          @"subgroup_id": subgroup_id,
                          @"place_id": place_id,
                          @"repairstate": repairstate,
                          @"state": state,
                          @"fault_carried_state": fault_carried_state,
                          @"repair_carried_state": repair_carried_state,
                          @"page":[NSString stringWithFormat:@"%ld",(long)page],
                          @"pagesize":@"5"};
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=repair_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)listOFSubgroup
{
    self.requestType = SubgroupLists;
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=subgroup_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:nil];
}

- (void)listOFPlaceIsAllPlace:(BOOL)isAllPlace
{
    self.requestType = PlaceLists;
    NSString *isMore = @"";
    if (isAllPlace)
    {
        isMore = @"1";
    }
    NSDictionary *dic = @{@"more": isMore};
    NSString *url = [NSString stringWithFormat:@"%@&module=Mydb&opt=place_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)listOFDepartmentWithPid:(NSString *)pid
{
    self.requestType = DepartmentLists;
    
    NSDictionary *dic = @{@"pid": pid};
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=department_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)listOFDutyWithDutyType:(NSString *)duty_type
{
    self.requestType = DutyLists;
    
    NSDictionary *dic = @{@"duty_type": duty_type};
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=duty_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)listOFStoresWithStoresName:(NSString *)stores_name
{
    self.requestType = StoresList;
    
    NSDictionary *dic = @{@"stores_name": stores_name};
    NSString *url = [NSString stringWithFormat:@"%@&module=Mydb&opt=stores_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)listOFOtherAffairWithHandleState:(NSString *)handle_state
                                    page:(NSInteger)page
{
    self.requestType = OtherAffairLists;
    
    NSDictionary *dic = @{@"handle_state": handle_state,
                          @"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"page": [NSString stringWithFormat:@"%ld",(long)page],
                          @"pagesize": @"5"};
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Affairs&opt=affairs_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)listOFMyIntegralWithDate:(NSString *)date
{
    self.requestType = MyIntegral;
    
    NSDictionary *dic = @{@"date": date,
                          @"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID]};
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=my_integral",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)listOFIntegralRankingWithDate:(NSString *)date
{
    self.requestType = IntegarlRanking;
    
    NSDictionary *dic = @{@"date": date,
                          @"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID]};
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=integral_ranking",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)modifyUserInformWithName:(NSString *)name
                          gender:(NSString *)gender
                          mobile:(NSString *)mobile
{
    self.requestType = ModifyUserInform;
    
    NSDictionary *dic = @{@"name": name,
                          @"gender": gender,
                          @"mobile": mobile,
                          @"id": [BXTGlobal getUserProperty:U_USERID]};
    
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    NSString *url = [NSString stringWithFormat:@"%@/module/User/opt/perfect_user/id/%@", KADMINBASEURL, companyInfo.company_id];
    
    [self postRequest:url withParameters:dic];
}

- (void)listOFUserShopLists
{
    self.requestType = UserShopLists;
    
    NSString *url = [NSString stringWithFormat:@"%@/module/Shops/opt/user_shop_lists&user_id=%@", KADMINBASEURL, [BXTGlobal getUserProperty:U_USERID]];
    [self postRequest:url withParameters:nil];
}

- (void)projectAuthenticationDetailWithShopID:(NSString *)shopID
{
    self.requestType = AuthenticationDetail;
    
    NSDictionary *dic = @{@"shop_id": shopID,
                          @"out_userid": [BXTGlobal getUserProperty:U_USERID]};
    
    NSString *urlLast = [NSString stringWithFormat:@"%@&shop_id=%@&token=%@",KAPIBASEURL, shopID, [BXTGlobal getUserProperty:U_TOKEN]];
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=authentication_detail",urlLast];
    [self postRequest:url withParameters:dic];
}

- (void)projectAddUserWithShopID:(NSString *)shopID
{
    self.requestType = BranchResign;
    
    NSDictionary *dic = @{@"out_userid": [BXTGlobal getUserProperty:U_USERID]};
    
    NSString *urlLast = [NSString stringWithFormat:@"%@&shop_id=%@&token=%@",KAPIBASEURL, shopID, [BXTGlobal getUserProperty:U_TOKEN]];
    NSString *url = [NSString stringWithFormat:@"%@&module=user&opt=add_user",urlLast];
    
    [self postRequest:url withParameters:dic];
}

- (void)authenticationApplyWithShopID:(NSString *)shop_id
                                 type:(NSString *)type
                         departmentID:(NSString *)department_id
                               dutyID:(NSString *)duty_id
                           subgroupID:(NSString *)subgroup_id
                      haveSubgroupIDs:(NSString *)have_subgroup_ids
                             storesID:(NSString *)stores_id
{
    self.requestType = AuthenticationApply;
    
    NSDictionary *dic = @{@"shop_id": shop_id,
                          @"out_userid": [BXTGlobal getUserProperty:U_USERID],
                          @"type": type,
                          @"department_id": department_id,
                          @"duty_id": duty_id,
                          @"subgroup_id": subgroup_id,
                          @"have_subgroup_ids": have_subgroup_ids,
                          @"stores_id": stores_id };
    
    NSString *urlLast = [NSString stringWithFormat:@"%@&shop_id=%@&token=%@",KAPIBASEURL, shop_id, [BXTGlobal getUserProperty:U_TOKEN]];
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=authentication_apply",urlLast];
    
    [self postRequest:url withParameters:dic];
}

- (void)modifyBindPlaceWithShopID:(NSString *)shop_id
                          placeID:(NSString *)place_id
{
    self.requestType = ModifyBindPlace;
    
    NSDictionary *dic = @{@"shop_id": shop_id,
                          @"out_userid": [BXTGlobal getUserProperty:U_USERID],
                          @"place_id": place_id };
    
    NSString *url = [NSString stringWithFormat:@"%@&module=user&opt=bind_place_modify",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)createNewMaintenanceOrderWithDeviceID:(NSString *)deviceID
                                    faulttype:(NSString *)faulttype
                               faultType_type:(NSString *)faulttype_type
                                   faultCause:(NSString *)cause
                                   faultLevel:(NSString *)level
                                  depatmentID:(NSString *)depID
                                    equipment:(NSString *)eqID
                                   faultNotes:(NSString *)notes
                                   imageArray:(NSArray *)images
                              repairUserArray:(NSArray *)userArray
{
    self.requestType = CreateMaintenanceOrder;
    
    if (!notes)
    {
        notes = @"";
    }
    
    NSString *fault = [BXTGlobal getUserProperty:U_NAME];
    NSString *faultID = [BXTGlobal getUserProperty:U_BRANCHUSERID];
    NSString *moblie = [BXTGlobal getUserProperty:U_MOBILE];
    NSDictionary *dic = @{@"type":@"add",
                          @"device_ids": deviceID,
                          @"faulttype":faulttype,
                          @"faulttype_type":faulttype_type,
                          @"cause":cause,
                          @"urgent":level,
                          @"department":depID,
                          @"equipment":eqID,
                          @"fault":fault,
                          @"fault_id":faultID,
                          @"visitmobile":moblie,
                          @"notes":notes,
                          @"collection":@"",
                          @"collection_note":@"",
                          @"repair_user_arr":userArray};
    NSString *url = [NSString stringWithFormat:@"%@&module=Device_repair&opt=device_add_fault",[BXTGlobal shareGlobal].baseURL];
    [self uploadImageRequest:url withParameters:dic withImages:images];
}

- (void)createRepair:(NSString *)reserveTime
         faultTypeID:(NSString *)faultTypeID
          faultCause:(NSString *)cause
             placeID:(NSString *)placeID
           deviceIDs:(NSString *)deviceID
              adsTxt:(NSString *)adsTxt
          imageArray:(NSArray *)images
     repairUserArray:(NSArray *)userArray
{
    self.requestType = CreateRepair;
    NSString *faultID = [BXTGlobal getUserProperty:U_BRANCHUSERID];
    NSDictionary *dic = @{@"fault_id":faultID,
                          @"fault_appointment_time":reserveTime,
                          @"faulttype_id":faultTypeID,
                          @"cause":cause,
                          @"place_id":placeID,
                          @"device_ids":deviceID,
                          @"ads_txt":adsTxt};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=add_fault",[BXTGlobal shareGlobal].baseURL];
    if (images.count)
    {
        [self uploadImageRequest:url withParameters:dic withImages:images];
    }
    else
    {
        [self postRequest:url withParameters:dic];
    }
}

- (void)deleteRepair:(NSString *)repairID
{
    self.requestType = DeleteRepair;
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_USERID],
                          @"id":repairID};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=del_fault",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)repairDetail:(NSString *)repairID
{
    self.requestType = RepairDetail;
    NSDictionary *dic = @{@"id":repairID};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=repair_con",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)handlePermission:(NSString *)workorderID
                 sceneID:(NSString *)sceneID
{
    self.requestType = HandlePermission;
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"workorder_id":workorderID,
                          @"scene_id":sceneID};
    NSString *url = [NSString stringWithFormat:@"%@&module=Mydb&opt=handle_permission",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)evaluateRepair:(NSArray *)rateArray
       evaluationNotes:(NSString *)notes
              repairID:(NSString *)reID
            imageArray:(NSArray *)images
{
    NSDictionary *rateDic = @{@"speed":rateArray[0],@"professional":rateArray[1],@"serve":rateArray[2]};
    NSDictionary *dic = @{@"send_id":[BXTGlobal getUserProperty:U_USERID],@"id":reID,@"praise":rateDic,@"evaluation_notes":notes,@"evaluation_name":[BXTGlobal getUserProperty:U_NAME]};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=praise",[BXTGlobal shareGlobal].baseURL];
    [self uploadImageRequest:url withParameters:dic withImages:images];
}

- (void)reaciveOrderID:(NSString *)repairID
{
    self.requestType = ReaciveOrder;
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"workorder_id":repairID};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=accept_workorder",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)dispatchingMan:(NSString *)repairID
               andMans:(NSArray *)mans
{
    self.requestType = ReaciveOrder;
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"dispatch_ids":mans,
                          @"workorder_id":repairID};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=dispatch_workorder",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)propertyGrouping
{
    self.requestType = PropertyGrouping;
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdata&opt=get_hq_subgroup",[BXTGlobal shareGlobal].baseURL];
    [self getRequest:url];
}

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
      andCollectionGroup:(NSString *)group
{
    self.requestType = MaintenanceProcess;
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"receive_time":reaciveTime,
                          @"end_time":finishTime,
                          @"state":state,
                          @"faulttype":faultType,
                          @"id":repairID,
                          @"man_hours":hours,
                          @"collection":specialOID,
                          @"workprocess":notes,
                          @"log_content":mmLog,
                          @"cooperation_group":group};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=add_processed",[BXTGlobal shareGlobal].baseURL];
    [self uploadImageRequest:url withParameters:dic withImages:images];
}

- (void)maintenanceManList:(NSString *)groupID
{
    self.requestType = ManList;
    NSDictionary *dic = @{@"is_repair":@"2",
                          @"subgroup":groupID};
    NSString *url = [NSString stringWithFormat:@"%@&module=User&opt=user_list",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)uploadHeaderImage:(UIImage *)image
{
    self.requestType = UploadHeadImage;
    NSDictionary *dic = @{@"id":[BXTGlobal getUserProperty:U_USERID],
                          @"name":[BXTGlobal getUserProperty:U_NAME],
                          @"gender":[BXTGlobal getUserProperty:U_SEX]};
    NSString *url = [NSString stringWithFormat:@"%@/module/User/opt/perfect_user",KADMINBASEURL];
    [self uploadImageRequest:url withParameters:dic withImages:@[image]];
}

- (void)mobileVerCode:(NSString *)mobile
{
    self.requestType = GetVerificationCode;
    NSDictionary *dic = @{@"mobile":mobile};
    NSString *url = [NSString stringWithFormat:@"%@/opt/get_verification_code/module/Means",KADMINBASEURL];
    [self postRequest:url withParameters:dic];
}

- (void)userInfo
{
    self.requestType = UserInfo;
    NSDictionary *dic = @{@"id":[BXTGlobal getUserProperty:U_BRANCHUSERID]};
    NSString *url = [NSString stringWithFormat:@"%@&module=User&opt=user_con",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)achievementsList:(NSInteger)months
{
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"months_num":[NSString stringWithFormat:@"%ld",(long)months]};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=get_achievements",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)evaluationListWithType:(NSInteger)evaType
{
    NSDictionary *dic = @{@"faultid":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"repairstate":[NSString stringWithFormat:@"%ld",(long)evaType]};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=evaluation_list",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)shopWithLatitude:(NSString *)latitude
        andWithLongitude:(NSString *)longitude
{
    self.requestType = LocationShop;
    NSDictionary *dic = @{@"latitude":latitude,
                          @"longitude":longitude};
    NSString *url = [NSString stringWithFormat:@"%@/module/Shops/opt/get_shops",KADMINBASEURL];
    [self postRequest:url withParameters:dic];
}

- (void)newsListWithPage:(NSInteger)page
{
    self.requestType = MessageList;
    //TODO: user_id记得改回来
    NSDictionary *dic = @{@"user_id":@"31",
                          @"page":[NSString stringWithFormat:@"%ld",(long)page],
                          @"pagesize":@"10"};
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Notice&opt=notice_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)messageList
{
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_USERID],
                          @"shop_id":companyInfo.company_id};
    NSString *url = [NSString stringWithFormat:@"%@/module/Letter/opt/letter_type",KADMINBASEURL];
    [self postRequest:url withParameters:dic];
}

- (void)updateTime:(NSString *)time
       andRepairID:(NSString *)repairID
{
    self.requestType = UpdateTime;
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"id":repairID,
                          @"receive_time":time};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=update_receive_time",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)feedback:(NSString *)notes
{
    NSDictionary *dic = @{@"send_user":[BXTGlobal getUserProperty:U_USERID],
                          @"type":@"1",
                          @"content":notes};
    NSString *url = [NSString stringWithFormat:@"%@/module/comment/opt/add_comment",KADMINBASEURL];
    [self postRequest:url withParameters:dic];
}

- (void)feedbackCommentList
{
    NSDictionary *dic = @{@"send_user":[BXTGlobal getUserProperty:U_USERID]};
    NSString *url = [NSString stringWithFormat:@"%@/module/Comment/opt/comment_list",KADMINBASEURL];
    [self postRequest:url withParameters:dic];
}

- (void)aboutUs
{
    NSDictionary *dic = @{@"news_id":@"1"};
    NSString *url = [NSString stringWithFormat:@"%@/opt/news_con/module/news",KADMINBASEURL];
    [self postRequest:url withParameters:dic];
}

- (void)userInfoForChatListWithID:(NSString *)userID
{
    self.requestType = UserInfoForChatList;
    NSDictionary *dic = @{@"user_id":userID};
    NSString *url = [NSString stringWithFormat:@"%@/module/Account/opt/account_con",KADMINBASEURL];
    [self postRequest:url withParameters:dic];
}

- (void)findPassWordWithMobile:(NSString *)moblie
                   andWithCode:(NSString *)code
{
    self.requestType = FindPassword;
    NSDictionary *dic = @{@"type":@"3",
                          @"username":moblie,
                          @"mailmatch":code};
    NSString *url = [NSString stringWithFormat:@"%@/opt/find_pass/module/Account",KADMINBASEURL];
    [self postRequest:url withParameters:dic];
}

- (void)changePassWord:(NSString *)password
             andWithID:(NSString *)pw_ID
            andWithKey:(NSString *)key
{
    self.requestType = ChangePassWord;
    NSDictionary *dic = @{@"key":key,
                          @"id":pw_ID,
                          @"password":password};
    NSString *url = [NSString stringWithFormat:@"%@/opt/reset_pass/module/Account",KADMINBASEURL];
    [self postRequest:url withParameters:dic];
}

- (void)updateHeadPic:(NSString *)pic
{
    self.requestType = UpdateHeadPic;
    NSDictionary *dic = @{@"url":pic,
                          @"id":[BXTGlobal getUserProperty:U_USERID]};
    NSString *url = [NSString stringWithFormat:@"%@&module=Login&opt=update_head",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)updateShopAddress:(NSString *)storeID
{
    self.requestType = UpdateShopAddress;
    NSDictionary *dic = @{@"stores_id": storeID,
                          @"id":[BXTGlobal getUserProperty:U_BRANCHUSERID]};
    NSString *url = [NSString stringWithFormat:@"%@&module=User&opt=update_user",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)startRepair:(NSString *)repairID
{
    self.requestType = StartRepair;
    NSDictionary *dic = @{@"id":repairID,
                          @"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID]};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=start_repair",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)inspectionPlanOverview
{
    self.requestType = InspectionPlanOverview;
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=inspection_plan_overview",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:nil];
}

- (void)deviceAvailableStaticsWithDate:(NSString *)date
{
    self.requestType = Device_AvailableStatics;
    NSDictionary *dic = @{@"date":date};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=device_state",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)deviceTypeStaticsWithDate:(NSString *)date
{
    self.requestType = Device_AvailableType;
    NSDictionary *dic = @{@"date":date};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=device_type",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)statisticsMTPlanListWithTimeStart:(NSString *)startTime
                                  TimeEnd:(NSString *)endTime
                              SubgroupIDs:(NSString *)subgroupIDs
                         FaulttypeTypeIDs:(NSString *)faulttypeTypeIDs
                                    State:(NSString *)state
                                    Order:(NSString *)order
                                 Pagesize:(NSString *)pageSize
                                     Page:(NSString *)page
{
    self.requestType = Statistics_MTPlanList;
    NSDictionary *dic = @{@"start_time": startTime,
                          @"end_time": endTime,
                          @"subgroup_ids": subgroupIDs,
                          @"faulttype_type_ids": faulttypeTypeIDs,
                          @"state": state,
                          @"order": order,
                          @"pagesize": pageSize,
                          @"page": page};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=inspection_task_list",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)statisticsEPListWithTime:(NSString *)date
                           State:(NSString *)state
                           Order:(NSString *)order
                          TypeID:(NSString *)typeID
                          AreaID:(NSString *)areaID
                         PlaceID:(NSString *)placeID
                        StoresID:(NSString *)storesID
                        Pagesize:(NSString *)pageSize
                            Page:(NSString *)page
{
    self.requestType = Statistics_EPList;
    NSDictionary *dic = @{@"date": date,
                          @"state": state,
                          @"order": order,
                          @"type_id": typeID,
                          @"area_id": areaID,
                          @"place_id": placeID,
                          @"stores_id": storesID,
                          @"pagesize": pageSize,
                          @"page": page};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=device_list",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)deviceTypeList
{
    self.requestType = Statistics_DeviceTypeList;
    NSString *url = [NSString stringWithFormat:@"%@&module=Device&opt=device_type_list&attribute=0",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:nil];
}

- (void)statisticsMTCompleteWithDate:(NSString *)date
                            Subgroup:(NSString *)subgroup
                       FaulttypeType:(NSString *)faulttypeType
{
    self.requestType = Statistics_MTComplete;
    NSDictionary *dic = @{@"date":date,
                          @"subgroup":subgroup,
                          @"faulttype_type":faulttypeType};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=inspection_plan",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)statisticsCompleteWithTimeStart:(NSString *)startTime
                                timeEnd:(NSString *)endTime
{
    self.requestType = Statistics_Complete;
    NSDictionary *dic = @{@"time_start":startTime,
                          @"time_end":endTime,
                          @"task_type":@"1"};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=statistics_complete",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)statisticsSubgroupWithTimeStart:(NSString *)startTime
                                timeEnd:(NSString *)endTime
{
    self.requestType = Statistics_Subgroup;
    NSDictionary *dic = @{@"time_start":startTime,
                          @"time_end":endTime};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=statistics_subgroup",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)statisticsFaulttypeWithTimeStart:(NSString *)startTime
                                 timeEnd:(NSString *)endTime
{
    self.requestType = Statistics_Faulttype;
    NSDictionary *dic = @{@"time_start":startTime,
                          @"time_end":endTime};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=statistics_faulttype",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)statisticsWorkloadDayWithYear:(NSString *)year
                                month:(NSString *)month
{
    self.requestType = Statistics_Workload_day;
    NSDictionary *dic = @{@"year":year,
                          @"month":month};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=statistics_workload_day",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)statisticsWorkloadYearWithYear:(NSString *)year
{
    self.requestType = Statistics_Workload_year;
    NSDictionary *dic = @{@"year":year};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=statistics_workload_year",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)statisticsWorkloadWithTimeStart:(NSString *)startTime
                                timeEnd:(NSString *)endTime
                                   Type:(NSString *)type
{
    self.requestType = Statistics_Workload;
    NSDictionary *dic = @{@"time_start":startTime,
                          @"time_end":endTime,
                          @"task_type":type};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=statistics_workload",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)statisticsPraiseWithTimeStart:(NSString *)startTime
                              timeEnd:(NSString *)endTime
                                 Type:(NSString *)type
{
    self.requestType = Statistics_Praise;
    NSDictionary *dic = @{@"time_start":startTime,
                          @"time_end":endTime,
                          @"task_type":type};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=statistics_praise",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)specialOrderTypes
{
    self.requestType = SpecialOrderTypes;
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdata&opt=get_hq_collection",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:nil];
}

- (void)rejectOrder:(NSString *)orderID
          withNotes:(NSString *)notes
{
    NSDictionary *dic = @{@"id":orderID,
                          @"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"reject_note":notes};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=reject_workorder",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)closeOrder:(NSString *)orderID
         withNotes:(NSString *)notes
{
    NSDictionary *dic = @{@"id":orderID,
                          @"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"close_cause":notes};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=close_workorder",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)exitLogin
{
    self.requestType = Exit_Login;
    NSDictionary *dic = @{@"out_userid": [BXTGlobal getUserProperty:U_USERID]};
    NSString *url = [NSString stringWithFormat:@"%@&module=user&opt=exit_login",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)equipmentInformation:(NSString *)deviceID
{
    self.requestType = Device_Con;
    NSDictionary *dic = @{@"id":deviceID};
    NSString *url = [NSString stringWithFormat:@"%@&module=Device&opt=device_con",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)deviceRepairListWithOrder:(NSString *)order
                         deviceID:(NSString *)device_id
                        timestart:(NSString *)startTime
                         timeover:(NSString *)endTime
                         pagesize:(NSString *)pagesize
                             page:(NSString *)page
{
    self.requestType = Device_Repair_List;
    NSString *timeName = @"";
    if (startTime.length > 0)
    {
        timeName = @"repair_time";
    }
    NSDictionary *dic = @{@"order": order,
                          @"timestart": startTime,
                          @"timeover": endTime,
                          @"timename":timeName,
                          @"pagesize": pagesize,
                          @"page": page,
                          @"device_id":device_id};
    NSString *url = [NSString stringWithFormat:@"%@&module=Device_repair&opt=device_repair_list",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)inspectionRecordListWithPagesize:(NSString *)pagesize
                                    page:(NSString *)page
                                deviceID:(NSString *)device_id
                               timestart:(NSString *)startTime
                                timeover:(NSString *)endTime
{
    self.requestType = Inspection_Record_List;
    NSString *timeName = @"";
    if (startTime.length > 0)
    {
        timeName = @"repair_time";
    }
    NSDictionary *dic = @{@"pagesize": pagesize,
                          @"page": page,
                          @"timestart": startTime,
                          @"timeover": endTime,
                          @"timename":timeName,
                          @"device_id":device_id};
    NSString *url = [NSString stringWithFormat:@"%@&module=Inspection&opt=inspection_record_list",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)mailListOfAllPerson
{
    self.requestType = Mail_Get_All;
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdirectory&opt=get_all",[BXTGlobal shareGlobal].baseURL];
    NSDictionary *dic = @{@"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID]};
    [self postRequest:url withParameters:dic];
}

- (void)mailListOfUserList
{
    self.requestType = Mail_User_list;
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdirectory&opt=user_list",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:nil];
}

- (void)mailListOfOnePersonWithID:(NSString *)userID shopID:(NSString *)shopID
{
    self.requestType = UserInfo;
    SaveValueTUD(@"shopID_Special", shopID);
    
    NSDictionary *dic = @{@"id": userID};
    NSString *baseURL = [NSString stringWithFormat:@"%@&shop_id=%@&token=%@",KAPIBASEURL, shopID, [BXTGlobal getUserProperty:U_TOKEN]];
    NSString *url = [NSString stringWithFormat:@"%@&module=user&opt=user_info", baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)scanResultWithContent:(NSString *)content
{
    NSDictionary *dic = @{@"content": content};
    NSString *url = [NSString stringWithFormat:@"%@&module=Qrcode&opt=resolu_qr",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)maintenanceEquipmentList:(NSString *)deviceID
{
    self.requestType = MaintenanceEquipmentList;
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"device_id":deviceID};
    NSString *url = [NSString stringWithFormat:@"%@&module=Inspection&opt=structure_inspection",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)addInspectionRecord:(NSString *)workorderID
                   deviceID:(NSString *)device_id
            andInspectionID:(NSString *)inspectionID
          andInspectionData:(NSString *)inspectionData
                   andNotes:(NSString *)notes
                   andState:(NSString *)state
                  andImages:(NSArray *)images
               andLongitude:(CGFloat)longitude
                andLatitude:(CGFloat)latitude
                    andDesc:(NSString *)desc
{
    self.requestType = Add_Inspection;
    NSDictionary *dic = @{@"workorder_id":workorderID,
                          @"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"device_id":device_id,
                          @"inspection_info":inspectionData,
                          @"device_state":state,
                          @"notes":notes,
                          @"desc":desc,
                          @"longitude":[NSString stringWithFormat:@"%f",longitude],
                          @"latitude":[NSString stringWithFormat:@"%f",latitude]};
    NSString *url = [NSString stringWithFormat:@"%@&module=Inspection&opt=add_inspection_record",[BXTGlobal shareGlobal].baseURL];
    if (images && images.count > 0)
    {
        [self uploadImageRequest:url withParameters:dic withImages:images];
    }
    else
    {
        [self postRequest:url withParameters:dic];
    }
}

- (void)updateInspectionRecordID:(NSString *)recordID
                        deviceID:(NSString *)device_id
                 andInspectionID:(NSString *)inspectionID
               andInspectionData:(NSString *)inspectionData
                        andNotes:(NSString *)notes
                        andState:(NSString *)state
                       andImages:(NSArray *)images
                    andLongitude:(CGFloat)longitude
                     andLatitude:(CGFloat)latitude
                         andDesc:(NSString *)desc
{
    self.requestType = Update_Inspection;
    NSDictionary *dic = @{@"id":recordID,
                          @"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"device_id":device_id,
                          @"inspection_info":inspectionData,
                          @"device_state":state,
                          @"notes":notes,
                          @"desc":desc,
                          @"longitude":[NSString stringWithFormat:@"%f",longitude],
                          @"latitude":[NSString stringWithFormat:@"%f",latitude]};
    NSString *url = [NSString stringWithFormat:@"%@&module=Inspection&opt=update_inspection_record",[BXTGlobal shareGlobal].baseURL];
    if (images && images.count > 0)
    {
        [self uploadImageRequest:url withParameters:dic withImages:images];
    }
    else
    {
        [self postRequest:url withParameters:dic];
    }
}

- (void)inspectionRecordInfo:(NSString *)deviceID
                   andWorkID:(NSString *)workID
{
    NSDictionary *dic;
    if (workID)
    {
        dic = @{@"device_id":deviceID,
                @"workorder_id":workID,
                @"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID]};
    }
    else
    {
        dic = @{@"id":deviceID,
                @"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID]};
    }
    NSString *url = [NSString stringWithFormat:@"%@&module=Inspection&opt=inspection_record_con",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)appVCAdvertisement
{
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    NSString *shopID = companyInfo.company_id;
    NSString *url = [NSString stringWithFormat:@"%@/module/shops/opt/shop_info&id=%@", KADMINBASEURL, shopID];
    [self getRequest:url];
}

- (void)advertisementPages
{
    self.requestType = Ads_Pics;
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    NSString *shopID = companyInfo.company_id;
    NSDictionary *dic = @{@"ads_id":@"1",
                          @"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID]};
    NSString *url = [NSString stringWithFormat:@"%@&module=Ads&opt=ads_pic&shop_id=%@", KAPIBASEURL, shopID];
    [self postRequest:url withParameters:dic];
}

- (void)announcementListWithReadState:(NSString *)readState
                             pagesize:(NSString *)pagesize
                                 page:(NSString *)page
{
    NSDictionary *dic = @{@"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"type": @"1",
                          @"read_state": readState,
                          @"pagesize": pagesize,
                          @"page": page};
    NSString *url = [NSString stringWithFormat:@"%@&module=Announcement&opt=announcement_list",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)remindNumberWithDailyTimestart:(NSString *)daily_timestart
                   inspectionTimestart:(NSString *)inspection_timestart
                       repairTimestart:(NSString *)repair_timestart
                       reportTimestart:(NSString *)report_timestart
                       objectTimestart:(NSString *)object_timestart
                 announcementTimestart:(NSString *)announcement_timestart
{
    self.requestType = Remind_Number;
    NSDictionary *dic = @{@"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"daily_timestart": daily_timestart,
                          @"inspection_timestart": inspection_timestart,
                          @"repair_timestart": repair_timestart,
                          @"report_timestart": report_timestart,
                          @"object_timestart": object_timestart,
                          @"announcement_timestart": announcement_timestart};
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Mydb&opt=remind_number",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)isFixed:(NSString *)repairID
   confirmState:(NSString *)confirmState
   confirmNotes:(NSString *)notes
{
    self.requestType = IsFixed;
    NSDictionary *dic = @{@"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"workorder_id": repairID,
                          @"confirm_state": confirmState,
                          @"fault_confirm_notes": notes};
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=fault_confirm",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)postRequest:(NSString *)url
     withParameters:(NSDictionary *)parameters
{
    if ([url hasPrefix:@"http://api"])
    {
        url = [self encryptTheURL:url dict:parameters];
    }
    LogRed(@"url......\n%@", url);
    LogRed(@"post参数值.....\n%@", [self dictionaryToJson:parameters]);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [response JSONValue];
        LogBlue(@"\n\n---------------------response---------------------> of type:%ld    \n\n%@\n\n<---------------------response---------------------\n\n",(long)self.requestType,response);
        [_delegate requestResponseData:dictionary requeseType:_requestType];
        // token验证失败
        if ([[NSString stringWithFormat:@"%@", dictionary[@"returncode"]] isEqualToString:@"037"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VERIFY_TOKEN_FAIL" object:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_delegate requestError:error requeseType:_requestType];
        LogBlue(@"type>>>>>:%ld    error:%@",(long)self.requestType,error);
    }];
}

- (void)uploadImageRequest:(NSString *)url
            withParameters:(NSDictionary *)parameters
                withImages:(NSArray *)images
{
    if ([url hasPrefix:@"http://api"])
    {
        url = [self encryptTheURL:url dict:parameters];
    }
    LogRed(@"url......%@",url);
    LogRed(@"post参数值.....\n%@", [self dictionaryToJson:parameters]);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 显示进度
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传 多张图片
        for(NSInteger i = 0; i < images.count; i++)
        {
            UIImage *image = [images objectAtIndex:i];
            NSData  *imageData = UIImageJPEGRepresentation(image, 0.3f);
            // 上传的参数名
            NSString * Name = [NSString stringWithFormat:@"image%ld", (long)i];
            // 上传filename
            NSString * fileName = [NSString stringWithFormat:@"%@.jpg", Name];
            [formData appendPartWithFileData:imageData name:Name fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [result JSONValue];
        [_delegate requestResponseData:dictionary requeseType:_requestType];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_delegate requestError:error requeseType:_requestType];
    }];
}

- (void)getRequest:(NSString *)url
{
    LogRed(@"%@",url);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        LogBlue(@"\n\n---------------------response--------------------->\n\n%@\n\n<---------------------response---------------------\n\n", response);
        NSDictionary *dictionary = [response JSONValue];
        [_delegate requestResponseData:dictionary requeseType:_requestType];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_delegate requestError:error requeseType:_requestType];
    }];
}

#pragma mark -
#pragma mark 字典转成JSon
- (NSString *)dictionaryToJson:(NSDictionary *)dic
{
    if (dic) {
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return @"";
}

- (void)showHUD
{
    AppDelegate *app = [AppDelegate appdelegete];
    progressHUD = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    progressHUD.delegate = self;
    progressHUD.detailsLabelText = @"正在上传,请稍后...";
    progressHUD.mode = MBProgressHUDModeDeterminate;
}

- (void)setProgress:(float)newProgress
{
    progressHUD.progress = newProgress;
    if (newProgress >= 1.0f)
    {
        [progressHUD hide:YES];
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [progressHUD removeFromSuperview];
    progressHUD = nil;
}

// 加密
- (NSString *)encryptTheURL:(NSString *)url dict:(NSDictionary *)parameters
{
    // value1(shop_id) + value2(key) + hell ouf.com  ------>  md5加密 <ONE>
    //  shop_id + $ + key + # + <ONE>  -----> DES3Util
    
    NSString *finalStr;
    NSString *randomKey = @"";
    id randomValue = @"";
    
    if (parameters)
    {
        // 获取key数组
        NSMutableArray *keyArray = [[NSMutableArray alloc] init];
        for (NSString *key in parameters)
        {
            [keyArray addObject:key];
        }
        // 随机取值
        int random = arc4random() % keyArray.count;
        randomKey = keyArray[random];
        randomValue = parameters[randomKey];
        // 只有字符串可以向下进行
        if (![randomValue isKindOfClass:[NSString class]])
        {
            randomKey = @"";
            randomValue = @"";
        }
    }
    
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    NSString *str1 = [NSString stringWithFormat:@"%@%@hello%@", companyInfo.company_id, randomValue, @"uf.com"];
    if (self.requestType == UserInfo)
    {
        str1 = [NSString stringWithFormat:@"%@%@hello%@", ValueFUD(@"shopID_Special"), randomValue, @"uf.com"];
    }
    if (self.requestType == BranchResign) {
        str1 = [NSString stringWithFormat:@"%@%@hello%@", ValueFUD(@"BranchResign_shopID"), randomValue, @"uf.com"];
    }
    NSString *md5Str = [BXTGlobal md5:str1];
    
    NSString *str2 = [NSString stringWithFormat:@"shop_id$%@#%@", randomKey, md5Str];
    finalStr = [DES3Util encrypt:str2];
    
    NSString *finalURL = [finalStr stringByReplacingOccurrencesOfString:@"+" withString:@"_"];
    finalURL = [finalURL stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    
    url = [NSString stringWithFormat:@"%@&encrypt_content=%@", url, finalURL];
    
    return url;
}

@end
