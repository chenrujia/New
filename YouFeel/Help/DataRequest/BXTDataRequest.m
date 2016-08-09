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

- (void)unbundlingUser:(NSDictionary *)parameters
{
    self.requestType = UnBundingUser;
    NSString *url = [NSString stringWithFormat:@"%@/module/Account/opt/remove_binding",KADMINBASEURL];
    [self postRequest:url withParameters:parameters];
}

- (void)loginUser:(NSDictionary *)parameters
{
    self.requestType = LoginType;
    NSString *url = [NSString stringWithFormat:@"%@/module/User/opt/login",KADMINBASEURL];
    [self postRequest:url withParameters:parameters];
}

- (void)shopLocation
{
    self.requestType = ShopType;
    NSString *url = [NSString stringWithFormat:@"%@&module=Portmeans&opt=get_map",[BXTGlobal shareGlobal].baseURL];
    [self getRequest:url];
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

- (void)branchResign
{
    self.requestType = BranchResign;
    NSDictionary *dic = @{@"out_userid":[BXTGlobal getUserProperty:U_USERID]};
    NSString *url = [NSString stringWithFormat:@"%@&shop_id=4&module=user&opt=add_user",KAPIBASEURL];
    // 不给baseURL赋值，注册后URL无前缀
    [BXTGlobal shareGlobal].baseURL = [NSString stringWithFormat:@"%@&shop_id=4", KAPIBASEURL];
    // 更新U_SHOPIDS
    [BXTGlobal setUserProperty:@[@"4"] withKey:U_SHOPIDS];
    [self postRequest:url withParameters:dic];
}

- (void)branchLogin
{
    self.requestType = BranchLogin;
    NSArray *array = [BXTGlobal getUserProperty:U_SHOPIDS];
    NSDictionary *dic = @{@"out_userid":[BXTGlobal getUserProperty:U_USERID]};;
    NSString *url = nil;
    if (array && array.count)
    {
        url = [NSString stringWithFormat:@"%@&module=user&opt=shop_login", [BXTGlobal shareGlobal].baseURL];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@&shop_id=%@&module=user&opt=shop_login", KAPIBASEURL, @"4"];
    }
    
    [self postRequest:url withParameters:dic];
}

- (void)faultTypeListWithRTaskType:(NSString *)taskType more:(NSString *)more
{
    self.requestType = FaultType;
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=faulttype_type_lists",[BXTGlobal shareGlobal].baseURL];
    NSDictionary *dic;
    if (more)
    {
        dic = @{@"task_type":taskType,
                @"more":more};
    }
    else
    {
        dic = @{@"task_type":taskType};
    }
    [self postRequest:url withParameters:dic];
}

- (void)urgentFaultType
{
    self.requestType = FaultType;
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=faulttype_lists",[BXTGlobal shareGlobal].baseURL];
    NSDictionary *dic = @{@"urgent_state": @"2"};
    [self postRequest:url withParameters:dic];
}

- (void)orderTypeList
{
    self.requestType = OrderFaultType;
    NSDictionary *dic = @{@"task_type": @"1"};
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=faulttype_type_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)listOfRepairOrderWithTaskType:(NSString *)task_type
                       repairListType:(RepairListType)listType
                          faulttypeID:(NSString *)faulttype_id
                                order:(NSString *)order
                          dispatchUid:(NSString *)dispatch_uid
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
                         collectionID:(NSString *)collection_id
                             deviceID:(NSString *)device_id
                                 page:(NSInteger)page
                           closeState:(NSString *)close_state
{
    self.requestType = RepairList;
    
    NSDictionary *dic = @{@"faulttype_id": faulttype_id,
                          @"task_type":task_type,
                          @"order": order,
                          @"dispatch_uid": dispatch_uid,
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
                          @"collection_id": collection_id,
                          @"device_id": device_id,
                          @"close_state": close_state,
                          @"page":[NSString stringWithFormat:@"%ld",(long)page],
                          @"pagesize":@"5"};
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    if (listType == MyMaintenanceList)
    {
        [mutableDic setObject:[BXTGlobal getUserProperty:U_BRANCHUSERID] forKey:@"repair_uid"];
    }
    else if (listType == MyRepairList)
    {
        [mutableDic setObject:[BXTGlobal getUserProperty:U_BRANCHUSERID] forKey:@"fault_id"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=repair_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:mutableDic];
}

- (void)listOFSubgroupShopID:(NSString *)shopID
{
    self.requestType = SubgroupLists;
    NSString *url = [NSString stringWithFormat:@"%@&shop_id=%@&token=%@&module=Hqdb&opt=subgroup_lists", KAPIBASEURL, shopID, [BXTGlobal getUserProperty:U_TOKEN]];
    [self postRequest:url withParameters:nil];
}

- (void)listOFStoresPlaceWithStoresID:(NSString *)storesID
{
    self.requestType = ListOFStoresPlace;
    
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    NSString *url = [NSString stringWithFormat:@"%@&shop_id=%@&token=%@&module=Mydb&opt=get_stores_place", KAPIBASEURL, companyInfo.company_id, [BXTGlobal getUserProperty:U_TOKEN]];
    NSDictionary *dic = @{@"stores_id": storesID};
    [self postRequest:url withParameters:dic];
}

- (void)listOFPlaceIsAllPlace
{
    self.requestType = PlaceLists;
    
    NSDictionary *dic = @{@"more": @"1"};
    NSString *url = [NSString stringWithFormat:@"%@&module=Mydb&opt=place_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)listOFDepartmentWithPid:(NSString *)pid
                         shopID:(NSString *)shopID
                   identityType:(NSString *)identity_type
{
    self.requestType = DepartmentLists;
    
    NSDictionary *dic = @{@"pid": pid,
                          @"identity_type": identity_type};
    NSString *url = [NSString stringWithFormat:@"%@&shop_id=%@&token=%@&module=Hqdb&opt=department_lists", KAPIBASEURL, shopID, [BXTGlobal getUserProperty:U_TOKEN]];
    [self postRequest:url withParameters:dic];
}

- (void)listOFDutyWithDutyType:(NSString *)duty_type
                        shopID:(NSString *)shopID
                  identityType:(NSString *)identity_type
{
    self.requestType = DutyLists;
    
    NSDictionary *dic = @{@"duty_type": duty_type,
                          @"identity_type": identity_type};
    NSString *url = [NSString stringWithFormat:@"%@&shop_id=%@&token=%@&module=Hqdb&opt=duty_lists", KAPIBASEURL, shopID, [BXTGlobal getUserProperty:U_TOKEN]];
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

- (void)projectAuthenticationDetailWithApplicantID:(NSString *)applicantID
                                            shopID:(NSString *)shopID
                                         outUserID:(NSString *)outUserID
{
    self.requestType = AuthenticationDetail;
    
    // 认证审批 -- 默认项目详情
    if ([BXTGlobal isBlankString:shopID])
    {
        BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
        shopID = companyInfo.company_id;
    }
    if ([BXTGlobal isBlankString:outUserID]) {
        outUserID = [BXTGlobal getUserProperty:U_USERID];
    }
    
    NSDictionary *dic = @{@"id": applicantID,
                          @"shop_id": shopID,
                          @"out_userid": outUserID};
    NSString *urlLast = [NSString stringWithFormat:@"%@&shop_id=%@&token=%@",KAPIBASEURL, shopID, [BXTGlobal getUserProperty:U_TOKEN]];
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=authentication_detail",urlLast];
    [self postRequest:url withParameters:dic];
}

- (void)projectAuthenticationVerifyWithApplicantID:(NSString *)applicantID
                                         affairsID:(NSString *)affairs_id
                                          isVerify:(NSString *)is_verify
{
    self.requestType = AuthenticationVerify;
    
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    NSDictionary *dic = @{@"out_userid": applicantID,
                          @"shop_id": companyInfo.company_id,
                          @"is_verify": is_verify,
                          @"affairs_id":affairs_id,
                          @"verify_user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID]};
    
    NSString *urlLast = [NSString stringWithFormat:@"%@&shop_id=%@&token=%@",KAPIBASEURL, companyInfo.company_id, [BXTGlobal getUserProperty:U_TOKEN]];
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=authentication_verify",urlLast];
    
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
                         bindPlaceIDs:(NSString *)bind_place_ids
{
    self.requestType = AuthenticationApply;
    
    NSDictionary *dic = @{@"shop_id": shop_id,
                          @"out_userid": [BXTGlobal getUserProperty:U_USERID],
                          @"type": type,
                          @"department_id": department_id,
                          @"duty_id": duty_id,
                          @"subgroup_id": subgroup_id,
                          @"have_subgroup_ids": have_subgroup_ids,
                          @"stores_id": stores_id,
                          @"bind_place_ids": bind_place_ids };
    
    NSString *urlLast = [NSString stringWithFormat:@"%@&shop_id=%@&token=%@",KAPIBASEURL, shop_id, [BXTGlobal getUserProperty:U_TOKEN]];
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=authentication_apply",urlLast];
    
    [self postRequest:url withParameters:dic];
}

- (void)authenticationModifyWithShopID:(NSString *)shop_id
                                  type:(NSString *)type
                          departmentID:(NSString *)department_id
                                dutyID:(NSString *)duty_id
                            subgroupID:(NSString *)subgroup_id
                       haveSubgroupIDs:(NSString *)have_subgroup_ids
                              storesID:(NSString *)stores_id
{
    self.requestType = AuthenticationModify;
    
    NSDictionary *dic = @{@"shop_id": shop_id,
                          @"out_userid": [BXTGlobal getUserProperty:U_USERID],
                          @"type": type,
                          @"department_id": department_id,
                          @"duty_id": duty_id,
                          @"subgroup_id": subgroup_id,
                          @"have_subgroup_ids": have_subgroup_ids,
                          @"stores_id": stores_id };
    
    NSString *urlLast = [NSString stringWithFormat:@"%@&shop_id=%@&token=%@",KAPIBASEURL, shop_id, [BXTGlobal getUserProperty:U_TOKEN]];
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=authentication_modify",urlLast];
    
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

- (void)createRepair:(NSString *)reserveTime
         faultTypeID:(NSString *)faultTypeID
          faultCause:(NSString *)cause
             placeID:(NSString *)placeID
             adsText:(NSString *)adsText
           deviceIDs:(NSString *)deviceID
          imageArray:(NSArray *)images
     repairUserArray:(NSArray *)userArray
            isMySelf:(NSString *)isMySelf
{
    self.requestType = CreateRepair;
    NSString *faultID = [BXTGlobal getUserProperty:U_BRANCHUSERID];
    NSDictionary *dic;
    if (adsText)
    {
        dic = @{@"fault_id":faultID,
                @"fault_appointment_time":reserveTime,
                @"faulttype_id":faultTypeID,
                @"cause":cause,
                @"ads_txt":adsText,
                @"device_ids":deviceID,
                @"is_myself":isMySelf};
    }
    else
    {
        dic = @{@"fault_id":faultID,
                @"fault_appointment_time":reserveTime,
                @"faulttype_id":faultTypeID,
                @"cause":cause,
                @"place_id":placeID,
                @"device_ids":deviceID,
                @"is_myself":isMySelf};
    }
    
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
                          @"workorder_id":repairID};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=close_workorder",[BXTGlobal shareGlobal].baseURL];
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
             affairsID:(NSString *)affairs_id
{
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"workorder_id":reID,
                          @"serve_result":rateArray[2],
                          @"speed_result":rateArray[0],
                          @"professional_result":rateArray[1],
                          @"praise_notes":notes,
                          @"affairs_id":affairs_id};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=add_praise",[BXTGlobal shareGlobal].baseURL];
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

- (void)reaciveDispatchedOrderID:(NSString *)repairID
{
    self.requestType = ReaciveOrder;
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"workorder_id":repairID};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=accept_dispatch_workorder",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)dispatchingMan:(NSString *)repairID
               andMans:(NSString *)mans
{
    self.requestType = DispatchOrAdd;
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"dispatch_ids":mans,
                          @"workorder_id":repairID};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=dispatch_workorder",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)maintenanceState:(NSString *)repairID
                 placeID:(NSString *)placeID
             deviceState:(NSString *)deviceState
              orderState:(NSString *)state
               faultType:(NSString *)faultType
                reasonID:(NSString *)reasonID
                   mmLog:(NSString *)mmLog
                  images:(NSArray *)images

{
    self.requestType = MaintenanceProcess;
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"workorder_id":repairID,
                          @"state":state,
                          @"faulttype_id":faultType,
                          @"place_id":placeID,
                          @"workprocess":mmLog};
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (reasonID)
    {
        [mutableDic setObject:reasonID forKey:@"collection_id"];
    }
    if (deviceState)
    {
        [mutableDic setObject:deviceState forKey:@"device_state"];
    }
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=add_processed",[BXTGlobal shareGlobal].baseURL];
    [self uploadImageRequest:url withParameters:mutableDic withImages:images];
}

- (void)maintenanceManList
{
    self.requestType = ManList;
    NSString *url = [NSString stringWithFormat:@"%@&module=User&opt=subgroup_user",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:nil];
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
    NSString *url = [NSString stringWithFormat:@"%@&module=user&opt=user_info",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)listOFAllShops
{
    self.requestType = ListOFAllShops;
    
    NSDictionary *dic = @{@"all_sub": @"1"};
    NSString *url = [NSString stringWithFormat:@"%@/module/Shops/opt/get_shops",KADMINBASEURL];
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
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"page":[NSString stringWithFormat:@"%ld",(long)page],
                          @"pagesize":@"10"};
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Notice&opt=notice_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)deleteNewsWithIDs:(NSString *)deleteIDs
{
    self.requestType = DeleteNews;
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"del_ids":deleteIDs};
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Notice&opt=del_notice",[BXTGlobal shareGlobal].baseURL];
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
             andWithID:(NSString *)pwID
            andWithKey:(NSString *)key
{
    self.requestType = ChangePassWord;
    NSDictionary *dic = @{@"key":key,
                          @"id":pwID,
                          @"password":password};
    NSString *url = [NSString stringWithFormat:@"%@/opt/reset_pass/module/Account",KADMINBASEURL];
    [self postRequest:url withParameters:dic];
}

- (void)startRepair:(NSString *)repairID
{
    self.requestType = StartRepair;
    NSDictionary *dic = @{@"workorder_id":repairID,
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

- (void)statisticsInspectionTaskListWithStartTime:(NSString *)start_time
                                          endTime:(NSString *)end_time
                                      subgroupIDs:(NSString *)subgroup_ids
                                 faulttypeTypeIDs:(NSString *)faulttype_type_ids
                                            state:(NSString *)state
                                            order:(NSString *)order
                                         pagesize:(NSString *)pagesize
                                             page:(NSString *)page
{
    self.requestType = InspectionTaskList;
    
    NSDictionary *dic = @{@"start_time":start_time,
                          @"end_time":end_time,
                          @"subgroup_ids":subgroup_ids,
                          @"faulttype_type_ids":faulttype_type_ids,
                          @"state":state,
                          @"order":order,
                          @"pagesize":pagesize,
                          @"page":page};
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
                          @"type_ids": typeID,
                          @"area_id": areaID,
                          @"many_place_id": placeID,
                          @"stores_id": storesID,
                          @"pagesize": pageSize,
                          @"page": page};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=device_list",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)deviceTypeList
{
    self.requestType = Statistics_DeviceTypeList;
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=device_type_one_lists&attribute=0",[BXTGlobal shareGlobal].baseURL];
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
    NSDictionary *dic = @{@"timestart":startTime,
                          @"timeover":endTime,
                          @"task_type":@"1"};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=statistics_complete",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)statisticsSubgroupWithTimeStart:(NSString *)startTime
                                timeEnd:(NSString *)endTime
{
    self.requestType = Statistics_Subgroup;
    NSDictionary *dic = @{@"task_type":@"1",
                          @"timestart":startTime,
                          @"timeover":endTime};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=statistics_subgroup",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)statisticsFaulttypeWithTimeStart:(NSString *)startTime
                                 timeEnd:(NSString *)endTime
{
    self.requestType = Statistics_Faulttype;
    NSDictionary *dic = @{@"timestart":startTime,
                          @"timeover":endTime};
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
    NSDictionary *dic = @{@"timestart":startTime,
                          @"timeover":endTime,
                          @"task_type":type};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=statistics_subgroup_user",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)statisticsPraiseWithTimeStart:(NSString *)startTime
                              timeEnd:(NSString *)endTime
                                 Type:(NSString *)type
{
    self.requestType = Statistics_Praise;
    NSDictionary *dic = @{@"timestart":startTime,
                          @"timeover":endTime,
                          @"task_type":type};
    NSString *url = [NSString stringWithFormat:@"%@&module=Statistics&opt=statistics_praise",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)rejectOrder:(NSString *)orderID
          withNotes:(NSString *)notes
{
    NSDictionary *dic = @{@"workorder_id":orderID,
                          @"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"reject_note":notes};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=reject_dispatch_workorder",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)closeOrder:(NSString *)orderID
         withNotes:(NSString *)notes
{
    NSDictionary *dic = @{@"workorder_id":orderID,
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
    NSString *url = [NSString stringWithFormat:@"%@&module=Inspection&opt=inspection_record_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)mailListOfAllPerson
{
    self.requestType = Mail_Get_All;
    NSString *url = [NSString stringWithFormat:@"%@&module=Contacts&opt=contacts_lists",[BXTGlobal shareGlobal].baseURL];
    NSDictionary *dic = @{@"out_userid": [BXTGlobal getUserProperty:U_USERID]};
    [self postRequest:url withParameters:dic];
}

- (void)mailListOfUserListWithShopIDs:(NSString *)shopIDs
{
    self.requestType = Mail_User_list;
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Contacts&opt=user_lists",[BXTGlobal shareGlobal].baseURL];
    NSDictionary *dic = @{@"shop_ids": shopIDs};
    
    [self postRequest:url withParameters:dic];
}

- (void)mailListOfOnePersonWithID:(NSString *)userID
{
    self.requestType = UserInfo;
    
    NSDictionary *dic = @{@"id": userID};
    NSString *url = [NSString stringWithFormat:@"%@&module=user&opt=user_info",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)scanResultWithContent:(NSString *)content
{
    NSDictionary *dic = @{@"content": content,
                          @"scann_type": @"1"};
    NSString *url = [NSString stringWithFormat:@"%@&module=Qrcode&opt=resolu_qr",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)maintenanceEquipmentList:(NSString *)deviceID
                         orderID:(NSString *)orderID
{
    self.requestType = MaintenanceEquipmentList;
    NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:[BXTGlobal getUserProperty:U_BRANCHUSERID] forKey:@"user_id"];
    [mudic setObject:deviceID forKey:@"device_id"];
    if (orderID)
    {
        [mudic setObject:orderID forKey:@"workorder_id"];
    }
    NSString *url = [NSString stringWithFormat:@"%@&module=Inspection&opt=structure_inspection",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:mudic];
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
                          @"inspection_item_id":inspectionID,
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
                        deviceID:(NSString *)deviceID
             andInspectionItemID:(NSString *)inspectionItemID
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
                          @"device_id":deviceID,
                          @"inspection_item_id":inspectionItemID,
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

- (void)endMaintenceOrder:(NSString *)workOrderID
{
    self.requestType = EndMaintenceOrder;
    NSDictionary *dic = @{@"workorder_id":workOrderID,
                          @"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID]};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=add_processed_inspection",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)inspectionRecordInfo:(NSString *)recordID
{
    NSDictionary *dic = @{@"id":recordID,
                          @"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID]};
    NSString *url = [NSString stringWithFormat:@"%@&module=Inspection&opt=inspection_record_con",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)informOFOA
{
    self.requestType = InformOFOA;
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Apps&opt=get_oa_info&out_userid=%@",[BXTGlobal shareGlobal].baseURL, [BXTGlobal getUserProperty:U_USERID]];
    [self postRequest:url withParameters:nil];
}

- (void)appVCAdvertisement
{
    self.requestType = AppVCAdvertisement;
    
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

- (void)shopConfig
{
    self.requestType = ShopConfig;
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Mydb&opt=shop_config",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:nil];
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
    NSString *url = [NSString stringWithFormat:@"%@&module=Announcement&opt=announcement_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)remindNumberWithDailyTimestart:(NSString *)daily_timestart
                   inspectionTimestart:(NSString *)inspection_timestart
                       repairTimestart:(NSString *)repair_timestart
                       reportTimestart:(NSString *)report_timestart
                       objectTimestart:(NSString *)object_timestart
                 announcementTimestart:(NSString *)announcement_timestart
                       noticeTimestart:(NSString *)notice_timestart
{
    self.requestType = Remind_Number;
    
    NSDictionary *dic = @{@"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"daily_timestart": daily_timestart,
                          @"inspection_timestart": inspection_timestart,
                          @"repair_timestart": repair_timestart,
                          @"report_timestart": report_timestart,
                          @"object_timestart": object_timestart,
                          @"announcement_timestart": announcement_timestart,
                          @"notice_timestart": notice_timestart,
                          @"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"] };
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Mydb&opt=remind_number",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)isFixed:(NSString *)repairID
   confirmState:(NSString *)confirmState
   confirmNotes:(NSString *)notes
      affairsID:(NSString *)affairs_id
{
    self.requestType = IsSure;
    NSDictionary *dic = @{@"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"workorder_id": repairID,
                          @"confirm_state": confirmState,
                          @"fault_confirm_notes": notes,
                          @"affairs_id": affairs_id};
    
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=fault_confirm",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)specialWorkOrder
{
    self.requestType = SpecialOrder;
    NSDictionary *dic = @{@"type": @"collection"};
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=param_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)deviceStates
{
    self.requestType = DeviceState;
    NSDictionary *dic = @{@"type": @"device_state"};
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=param_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)repairStates
{
    self.requestType = RepairState;
    NSDictionary *dic = @{@"type": @"repairstate_name"};
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdb&opt=param_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)energyMeterListsWithType:(NSString *)type
                       checkType:(NSString *)check_type
                       priceType:(NSString *)price_type
                         placeID:(NSString *)place_id
                 measurementPath:(NSString *)measurement_path
                      searchName:(NSString *)search_name
                            page:(NSInteger)page
{
    self.requestType = EnergyMeterLists;
    // type = (1,2,3,4)就是电，水，燃气，热能
    NSDictionary *dic = @{@"type": type,
                          @"check_type": check_type,
                          @"price_type": price_type,
                          @"place_id": place_id,
                          @"measurement_path": measurement_path,
                          @"search_name": search_name,
                          @"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"page":[NSString stringWithFormat:@"%ld",(long)page],
                          @"pagesize":@"10"};
    NSString *url = [NSString stringWithFormat:@"%@&module=Energy&opt=meter_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)energyMeasuremenLevelListsWithType:(NSString *)type
{
    self.requestType = EnergyMeasuremenLevelLists;
    
    NSDictionary *dic = @{@"type": type};
    NSString *url = [NSString stringWithFormat:@"%@&module=energy&opt=measurement_level_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)energyMeterFavoriteAddWithAboutID:(NSString *)aboutID
                                   delIDs:(NSString *)del_ids
{
    self.requestType = MeterFavoriteAdd;
    if ([BXTGlobal isBlankString:aboutID])
    {
        self.requestType = MeterFavoriteDel;
    }
    
    NSDictionary *dic = @{@"about_id": aboutID,
                          @"del_ids": del_ids,
                          @"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID]};
    NSString *url = [NSString stringWithFormat:@"%@&module=energy&opt=meter_favorite_add",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)energyMeterFavoriteListsWithType:(NSString *)type
                               checkType:(NSString *)check_type
                                    page:(NSInteger)page
                              searchName:(NSString *)search_name
{
    self.requestType = MeterFavoriteLists;
    NSDictionary *dic = @{@"type": type,
                          @"check_type": check_type,
                          @"search_name": search_name,
                          @"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"page":[NSString stringWithFormat:@"%ld",(long)page],
                          @"pagesize":@"10"};
    NSString *url = [NSString stringWithFormat:@"%@&module=energy&opt=meter_favorite_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)energyMeterRecordMonthListsWithAboutID:(NSString *)aboutID
                                          year:(NSString *)year
{
    self.requestType = EnergyMeterRecordMonthLists;
    NSDictionary *dic = @{@"id": aboutID,
                          @"year": year,
                          @"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID]};
    NSString *url = [NSString stringWithFormat:@"%@&module=energy&opt=meter_record_month_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)energyMeterRecordDayListsWithAboutID:(NSString *)aboutID
                                        date:(NSString *)date
{
    self.requestType = EnergyMeterRecordDayLists;
    NSDictionary *dic = @{@"id": aboutID,
                          @"date": date,
                          @"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID]};
    NSString *url = [NSString stringWithFormat:@"%@&module=energy&opt=meter_record_day_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)energyMeterRecordListsWithAboutID:(NSString *)aboutID
                                     date:(NSString *)date
{
    self.requestType = EnergyMeterRecordLists;
    NSDictionary *dic = @{@"id": aboutID,
                          @"date": date,
                          @"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID]};
    NSString *url = [NSString stringWithFormat:@"%@&module=energy&opt=meter_record_lists",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)energyMeterDetailWithID:(NSString *)meterDetailID
{
    self.requestType = EnergyMeterDetail;
    NSDictionary *dic = @{@"id": meterDetailID,
                          @"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID]};
    NSString *url = [NSString stringWithFormat:@"%@&module=energy&opt=meter_detail",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)energyMeterRecordFileWithImage:(UIImage *)image
{
    self.requestType = EnergyMeterRecordFile;
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID]};
    NSString *url = [NSString stringWithFormat:@"%@&module=energy&opt=meter_record_file",[BXTGlobal shareGlobal].baseURL];
    [self uploadImageRequest:url withParameters:dic withImages:@[image]];
}

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
{
    self.requestType = EnergyMeterRecordAdd;
    NSDictionary *dic = @{@"id": aboutID,
                          @"total_num": total_num,
                          @"peak_period_num": peak_period_num,
                          @"flat_section_num": flat_section_num,
                          @"valley_section_num": valley_section_num,
                          @"peak_segment_num": peak_segment_num,
                          @"total_pic": total_pic,
                          @"peak_period_pic": peak_period_pic,
                          @"flat_section_pic": flat_section_pic,
                          @"valley_section_pic": valley_section_pic,
                          @"peak_segment_pic": peak_segment_pic,
                          @"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID]};
    NSString *url = [NSString stringWithFormat:@"%@&module=energy&opt=meter_record_add",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)energyMeterRecordCalculateWithAboutID:(NSString *)aboutID
                                    startTime:(NSString *)start_time
                                      endTime:(NSString *)end_time
{
    self.requestType = EnergyMeterRecordCalculate;
    
    if ([start_time isEqualToString:@"起始日期"]) {
        start_time = @"";
    }
    if ([end_time isEqualToString:@"结束日期"]) {
        end_time = @"";
    }
    NSDictionary *dic = @{@"id": aboutID,
                          @"start_time": start_time,
                          @"end_time": end_time,
                          @"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID]};
    NSString *url = [NSString stringWithFormat:@"%@&module=energy&opt=meter_record_calc",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)efficiencySurveyMonthWithDate:(NSString *)date
{
    self.requestType = EfficiencySurveyMonth;
    NSDictionary *dic = @{@"date": date};
    NSString *url = [NSString stringWithFormat:@"%@&module=energy&opt=efficiency_survey_month",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)efficiencySurveyYearWithDate:(NSString *)date
{
    self.requestType = EfficiencySurveyYear;
    NSDictionary *dic = @{@"date": date};
    NSString *url = [NSString stringWithFormat:@"%@&module=energy&opt=efficiency_survey_year",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)efficiencyDistributionMonthWithDate:(NSString *)date
                                      ppath:(NSString *)ppath
{
    self.requestType = EfficiencyDistributionMonth;
    NSDictionary *dic = @{@"date": date,
                          @"ppath": ppath};
    NSString *url = [NSString stringWithFormat:@"%@&module=energy&opt=efficiency_distribution_month",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)efficiencyDistributionYearWithDate:(NSString *)date
                                     ppath:(NSString *)ppath
{
    self.requestType = EfficiencyDistributionYear;
    NSDictionary *dic = @{@"date": date,
                          @"ppath": ppath};
    NSString *url = [NSString stringWithFormat:@"%@&module=energy&opt=efficiency_distribution_year",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)efficiencyTrendMonthWithDate:(NSString *)date
                               ppath:(NSString *)ppath
{
    self.requestType = EfficiencyTrendMonth;
    NSDictionary *dic = @{@"date": date,
                          @"ppath": ppath};
    NSString *url = [NSString stringWithFormat:@"%@&module=energy&opt=efficiency_trend_month",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)efficiencyTrendYearWithDate:(NSString *)date
                              ppath:(NSString *)ppath
{
    self.requestType = EfficiencyTrendYear;
    NSDictionary *dic = @{@"date": date,
                          @"ppath": ppath};
    NSString *url = [NSString stringWithFormat:@"%@&module=energy&opt=efficiency_trend_year",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)postRequest:(NSString *)url
     withParameters:(NSDictionary *)parameters
{
    if ([url hasPrefix:@"http://api"])
    {
        url = [self encryptTheURL:url dict:parameters];
    }
    LogRed(@"url......%ld\n%@",(long)self.requestType, url);
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
        [self.delegate requestResponseData:dictionary requeseType:self.requestType];
        // token验证失败
        if ([[NSString stringWithFormat:@"%@", dictionary[@"returncode"]] isEqualToString:@"037"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VERIFY_TOKEN_FAIL" object:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.delegate requestError:error requeseType:_requestType];
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
        LogBlue(@"\n\n---------------------response---------------------> of type:%ld    \n\n%@\n\n<---------------------response---------------------\n\n",(long)self.requestType,dictionary);
        [self.delegate requestResponseData:dictionary requeseType:self.requestType];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.delegate requestError:error requeseType:self.requestType];
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
    if (dic)
    {
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
