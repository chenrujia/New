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
    NSString *url = [NSString stringWithFormat:@"%@/module/User/opt/reg_user",KURLREQUEST];
    [self postRequest:url withParameters:parameters];
}

- (void)bindingUser:(NSDictionary *)parameters
{
    self.requestType = BindingUser;
    NSString *url = [NSString stringWithFormat:@"%@/module/User/opt/third_bind_mobile",KURLREQUEST];
    [self postRequest:url withParameters:parameters];
}

- (void)loginUser:(NSDictionary *)parameters
{
    self.requestType = LoginType;
    NSString *url = [NSString stringWithFormat:@"%@/module/User/opt/login",KURLREQUEST];
    [self postRequest:url withParameters:parameters];
}

- (void)departmentsList:(NSString *)is_repair
{
    self.requestType = DepartmentType;
    NSString *url = [NSString stringWithFormat:@"%@&module=Hqdata&opt=get_hq_department",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:nil];
}

- (void)positionsList:(NSString *)departmentID
{
    self.requestType = PositionType;
    NSString *url = [NSString stringWithFormat:@"%@&module=User&opt=role_list&department=%@",[BXTGlobal shareGlobal].baseURL,departmentID];
    [self getRequest:url];
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

- (void)shopLists:(NSString *)departmentID
{
    self.requestType = ShopLists;
    NSString *url;
    if (departmentID)
    {
        url = [NSString stringWithFormat:@"%@/module/Shops/opt/get_shops&id=%@",KURLREQUEST,departmentID];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@/module/Shops/opt/get_shops/is_hot/1",KURLREQUEST];
    }
    [self getRequest:url];
}

- (void)branchResign:(NSInteger)is_repair
{
    self.requestType = BranchResign;
    
    BXTDepartmentInfo *departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
    BXTPostionInfo *postionInfo = [BXTGlobal getUserProperty:U_POSITION];
    BXTHeadquartersInfo *company = [BXTGlobal getUserProperty:U_COMPANY];
    
    NSString *subGroup = @"";
    BXTGroupingInfo *groupInfo = [BXTGlobal getUserProperty:U_GROUPINGINFO];
    if (groupInfo)
    {
        subGroup = groupInfo.group_id;
    }
    
    NSDictionary *dic = @{@"name":[BXTGlobal getUserProperty:U_NAME],
                          @"username":[BXTGlobal getUserProperty:U_USERNAME],
                          @"mobile":[BXTGlobal getUserProperty:U_USERNAME],
                          @"role_id":postionInfo.role_id,
                          @"department_id":departmentInfo.dep_id,
                          @"clientid":@"123",
                          @"gender":[BXTGlobal getUserProperty:U_SEX],
                          @"out_userid":[BXTGlobal getUserProperty:U_USERID],
                          @"stores_id": @"",
                          @"shops_id":company.company_id,
                          @"subgroup":subGroup};
    NSString *url = [NSString stringWithFormat:@"%@&module=user&opt=add_user",[BXTGlobal shareGlobal].baseURL];
    
    [self postRequest:url withParameters:dic];
}

- (void)branchLogin
{
    self.requestType = BranchLogin;
    NSDictionary *dic;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"])
    {
        dic = @{@"username":[BXTGlobal getUserProperty:U_USERNAME],@"clientid":[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"]};
    }
    else
    {
        dic = @{@"username":[BXTGlobal getUserProperty:U_USERNAME],@"clientid":@""};
    }
    NSString *url = [NSString stringWithFormat:@"%@&module=login&opt=login",[BXTGlobal shareGlobal].baseURL];
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
    if ([taskType isEqualToString:@"2"]) {
        url = [NSString stringWithFormat:@"%@&module=Hqdata&opt=get_hq_faulttype_type&task_type=%@",[BXTGlobal shareGlobal].baseURL, taskType];
    }
    [self postRequest:url withParameters:nil];
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
    LogBlue(@"dic --- %@", dic);
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
     repairUserArray:(NSArray *)userArray
{
    self.requestType = CreateRepair;
    
    if (!notes)
    {
        notes = @"";
    }
    
    NSString *fault = [BXTGlobal getUserProperty:U_NAME];
    NSString *faultID = [BXTGlobal getUserProperty:U_BRANCHUSERID];
    NSString *moblie = [BXTGlobal getUserProperty:U_MOBILE];
    NSDictionary *dic = @{@"type":@"add",
                          @"faulttype":faultType,
                          @"faulttype_type":faulttype_type,
                          @"device_ids": deviceID,
                          @"cause":cause,
                          @"urgent":level,
                          @"department":depID,
                          @"area":floorID,
                          @"place":areaID,
                          @"stores_id":shopID,
                          @"equipment":eqID,
                          @"fault":fault,
                          @"fault_id":faultID,
                          @"visitmobile":moblie,
                          @"notes":notes,
                          @"collection":@"",
                          @"collection_note":@"",
                          @"repair_user_arr":userArray};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=add_fault",[BXTGlobal shareGlobal].baseURL];
    [self uploadImageRequest:url withParameters:dic withImages:images];
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
           arrivalTime:(NSString *)time
             andUserID:(NSString *)userID
              andUsers:(NSArray *)users
             andIsGrad:(BOOL)isGrab
{
    self.requestType = ReaciveOrder;
    NSDictionary *dic = @{@"is_grab":[NSString stringWithFormat:@"%d",isGrab],
                          @"user_id":userID,
                          @"user":users,
                          @"id":repairID,
                          @"arrival_time":time};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=dispatching",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)reaciveOrderForAssign:(NSString *)repairID
                  arrivalTime:(NSString *)time
                    andUserID:(NSString *)userID
{
    self.requestType = ReaciveOrder;
    NSDictionary *dic = @{@"user_id":userID,
                          @"id":repairID,
                          @"receive_time":time};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=update_receive_time",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:dic];
}

- (void)dispatchingMan:(NSString *)repairID
               andMans:(NSArray *)mans
{
    self.requestType = ReaciveOrder;
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"user":mans,
                          @"id":repairID};
    NSString *url = [NSString stringWithFormat:@"%@&module=Repair&opt=dispatching",[BXTGlobal shareGlobal].baseURL];
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
    NSString *url = [NSString stringWithFormat:@"%@/module/User/opt/perfect_user",KURLREQUEST];
    [self uploadImageRequest:url withParameters:dic withImages:@[image]];
}

- (void)mobileVerCode:(NSString *)mobile
{
    self.requestType = GetVerificationCode;
    NSDictionary *dic = @{@"mobile":mobile};
    NSString *url = [NSString stringWithFormat:@"%@/opt/get_verification_code/module/Means",KURLREQUEST];
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
    NSString *url = [NSString stringWithFormat:@"%@/module/Shops/opt/get_shops",KURLREQUEST];
    [self postRequest:url withParameters:dic];
}

- (void)newsListWithPage:(NSInteger)page
              noticeType:(NSString *)noticeType
{
    // notice_type
    // 1.系统消息 2工单消息 3工作通知消息 4.预警消息 6 公告消息
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_USERID],
                          @"page":[NSString stringWithFormat:@"%ld",(long)page],
                          @"pagesize":@"10",
                          @"shop_id":companyInfo.company_id,
                          @"notice_type": noticeType};
    NSString *url = [NSString stringWithFormat:@"%@/module/Letter/opt/letter_list",KURLREQUEST];
    [self postRequest:url withParameters:dic];
}

- (void)messageList
{
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_USERID],
                          @"shop_id":companyInfo.company_id};
    NSString *url = [NSString stringWithFormat:@"%@/module/Letter/opt/letter_type",KURLREQUEST];
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
    NSString *url = [NSString stringWithFormat:@"%@/module/comment/opt/add_comment",KURLREQUEST];
    [self postRequest:url withParameters:dic];
}

- (void)feedbackCommentList
{
    NSDictionary *dic = @{@"send_user":[BXTGlobal getUserProperty:U_USERID]};
    NSString *url = [NSString stringWithFormat:@"%@/module/Comment/opt/comment_list",KURLREQUEST];
    [self postRequest:url withParameters:dic];
}

- (void)aboutUs
{
    NSDictionary *dic = @{@"news_id":@"1"};
    NSString *url = [NSString stringWithFormat:@"%@/opt/news_con/module/news",KURLREQUEST];
    [self postRequest:url withParameters:dic];
}

- (void)userInfoForChatListWithID:(NSString *)userID
{
    self.requestType = UserInfoForChatList;
    NSDictionary *dic = @{@"user_id":userID};
    NSString *url = [NSString stringWithFormat:@"%@/module/Account/opt/account_con",KURLREQUEST];
    [self postRequest:url withParameters:dic];
}

- (void)findPassWordWithMobile:(NSString *)moblie
                   andWithCode:(NSString *)code
{
    self.requestType = FindPassword;
    NSDictionary *dic = @{@"type":@"3",
                          @"username":moblie,
                          @"mailmatch":code};
    NSString *url = [NSString stringWithFormat:@"%@/opt/find_pass/module/Account",KURLREQUEST];
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
    NSString *url = [NSString stringWithFormat:@"%@/opt/reset_pass/module/Account",KURLREQUEST];
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

- (void)configInfo
{
    self.requestType = ConfigInfo;
    NSString *url = [NSString stringWithFormat:@"%@&module=Config&opt=Config_info",[BXTGlobal shareGlobal].baseURL];
    [self postRequest:url withParameters:nil];
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
                          @"time_end":endTime};
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

- (void)exitLoginWithClientID:(NSString *)clientid
{
    self.requestType = Exit_Login;
    NSDictionary *dic = @{@"clientid": clientid};
    NSString *url = [NSString stringWithFormat:@"%@&module=Login&opt=exit_login",[BXTGlobal shareGlobal].baseURL];
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
    NSString *baseURL = [NSString stringWithFormat:@"http://api.51bxt.com/?c=Port&m=actionGet_iPhone_v2_Port&shop_id=%@&token=%@", shopID, [BXTGlobal getUserProperty:U_TOKEN]];
    NSString *url = [NSString stringWithFormat:@"%@&module=User&opt=user_con", baseURL];
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
    NSString *url = [NSString stringWithFormat:@"http://admin.51bxt.com/?r=port/Get_Android_v2_Port/module/shops/opt/shop_info&id=%@", shopID];
    [self getRequest:url];
}

- (void)advertisementPages
{
    self.requestType = Ads_Pics;
    
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    NSString *shopID = companyInfo.company_id;
    NSString *url = [NSString stringWithFormat:@"http://admin.51bxt.com/?r=port/Get_Android_v2_Port/opt/ads_pic/module/ads/ads_id/1/shop_id/%@", shopID];
    [self getRequest:url];
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

- (void)remindNumberWithDailyTimeStart:(NSString *)dailyStart
                    InspectioTimeStart:(NSString *)inspectioStart
{
    self.requestType = Remind_Number;
    NSDictionary *dic = @{@"user_id": [BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"daily_timestart": dailyStart,
                          @"inspectio_timestart": inspectioStart};
    NSString *url = [NSString stringWithFormat:@"%@&module=Remind&opt=remind_number",[BXTGlobal shareGlobal].baseURL];
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
    LogRed(@"dic......\n%@", [self dictionaryToJson:parameters]);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [response JSONValue];
        LogBlue(@"\n\n---------------------response--------------------->\n\n%@\n\n<---------------------response---------------------\n\n", response);
        [_delegate requestResponseData:dictionary requeseType:_requestType];
        // token验证失败
        if ([[NSString stringWithFormat:@"%@", dictionary[@"returncode"]] isEqualToString:@"037"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VERIFY_TOKEN_FAIL" object:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_delegate requestError:error];
        LogBlue(@"error:%@",error);
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
        [_delegate requestError:error];
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
        NSLog(@"\n\n---------------------response--------------------->\n\n%@\n\n<---------------------response---------------------\n\n", response);
        NSDictionary *dictionary = [response JSONValue];
        [_delegate requestResponseData:dictionary requeseType:_requestType];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_delegate requestError:error];
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
        NSString *randomKey = keyArray[random];
        id randomValue = parameters[randomKey];
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
    NSString *md5Str = [BXTGlobal md5:str1];
    
    NSString *str2 = [NSString stringWithFormat:@"shop_id$%@#%@", randomKey, md5Str];
    finalStr = [DES3Util encrypt:str2];
    
    NSString *finalURL = [finalStr stringByReplacingOccurrencesOfString:@"+" withString:@"_"];
    finalURL = [finalURL stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    
    url = [NSString stringWithFormat:@"%@&encrypt_content=%@", url, finalURL];
    
    return url;
}

@end
