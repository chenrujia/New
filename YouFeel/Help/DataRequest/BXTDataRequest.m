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
#import "AFHTTPRequestOperationManager.h"

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
    NSString *url = [NSString stringWithFormat:@"%@?r=port/Get_iPhone_v2_Port/module/User/opt/reg_user",KURLREQUEST];
    [self postRequest:url withParameters:parameters];
}

- (void)loginUser:(NSDictionary *)parameters
{
    self.requestType = LoginType;
    NSString *url = [NSString stringWithFormat:@"%@?r=port/Get_iPhone_v2_Port/module/User/opt/login",KURLREQUEST];
    [self postRequest:url withParameters:parameters];
}

- (void)departmentsList:(NSString *)is_repair
{
    self.requestType = DepartmentType;
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=Hqdata&opt=get_hq_department",KLASTURL];
    [self postRequest:url withParameters:@{@"is_repair":is_repair}];
}

- (void)positionsList:(NSString *)departmentID
{
    self.requestType = PositionType;
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=User&opt=role_list&department=%@",KLASTURL,departmentID];
    [self getRequest:url];
}

- (void)shopLocation
{
    self.requestType = ShopType;
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=Portmeans&opt=get_map",KLASTURL];
    [self getRequest:url];
}

- (void)shopLists:(NSString *)departmentID
{
    self.requestType = ShopLists;
    NSString *url;
    if (departmentID)
    {
        url = [NSString stringWithFormat:@"%@?r=port/Get_Android_v2_Port/module/Shops/opt/get_shops&id=%@",KURLREQUEST,departmentID];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@?r=port/Get_Android_v2_Port/module/Shops/opt/get_shops",KURLREQUEST];
    }
    [self getRequest:url];
}

- (void)branchResign:(NSInteger)is_repair
{
    self.requestType = BranchResign;
    NSString *store_id = @"";
    NSString *area_id = @"";
    BXTDepartmentInfo *departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
    BXTPostionInfo *postionInfo = [BXTGlobal getUserProperty:U_POSITION];
    BXTHeadquartersInfo *company = [BXTGlobal getUserProperty:U_COMPANY];
    /**只有作为店铺的时候才需要传这两个参数**/
    if ([departmentInfo.dep_id integerValue] == 2)
    {
        BXTAreaInfo *areaInfo = [BXTGlobal getUserProperty:U_AREA];
        area_id = areaInfo.place_id;
        id shopInfo = [BXTGlobal getUserProperty:U_SHOP];
        if ([shopInfo isKindOfClass:[NSString class]])
        {
            store_id = shopInfo;
        }
        else
        {
            BXTShopInfo *tempShop = (BXTShopInfo *)shopInfo;
            store_id = tempShop.stores_id;
        }
    }
    
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
                          @"stores_id":store_id,
                          @"clientid":@"123",
                          @"is_repair":[NSString stringWithFormat:@"%ld",(long)is_repair],
                          @"place_id":area_id,
                          @"gender":[BXTGlobal getUserProperty:U_SEX],
                          @"out_userid":[BXTGlobal getUserProperty:U_USERID],
                          @"shops_id":company.company_id,
                          @"subgroup":subGroup};
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=user&opt=add_user",KLASTURL];
    [self postRequest:url withParameters:dic];
}

- (void)branchLogin
{
    self.requestType = BranchLogin;
    NSDictionary *dic = @{@"username":[BXTGlobal getUserProperty:U_USERNAME]};

    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=login&opt=login",KLASTURL];
    [self postRequest:url withParameters:dic];
}

- (void)commitNewShop:(NSString *)shop
{
    self.requestType = CommitShop;
    BXTFloorInfo *floorInfo = [BXTGlobal getUserProperty:U_FLOOOR];
    BXTAreaInfo *areaInfo = [BXTGlobal getUserProperty:U_AREA];
    
    NSDictionary *dic = @{@"stores_name":shop,
                          @"quyu_id":floorInfo.area_id,
                          @"didian_id":areaInfo.place_id,
                          @"info":@"123",
                          @"stores_pic":@""};
    
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=user&opt=add_stores",KLASTURL];
    [self postRequest:url withParameters:dic];
}

- (void)faultTypeList
{
    self.requestType = FaultType;
    
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=Hqdata&opt=get_hq_faulttype_type",KLASTURL];
    [self postRequest:url withParameters:nil];
}

- (void)repairList:(NSString *)state andPage:(NSInteger)page andIsMaintenanceMan:(BOOL)isMaintenanceMan
{
    self.requestType = RepairList;
    BOOL isComplete;
    if ([state isEqualToString:@""])
    {
        isComplete = YES;
    }
    NSString *identity = @"faultid";
    if (isMaintenanceMan)
    {
        identity = @"repairer";
    }
    NSDictionary *dic;
    if (isComplete)
    {
        dic = @{identity:[BXTGlobal getUserProperty:U_BRANCHUSERID],
                @"state":@"2",
                @"pagesize":@"5",
                @"page":[NSString stringWithFormat:@"%ld",(long)page]};
    }
    else
    {
        dic = @{identity:[BXTGlobal getUserProperty:U_BRANCHUSERID],
                @"repairstate":state,
                @"pagesize":@"5",
                @"page":[NSString stringWithFormat:@"%ld",(long)page]};
    }
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=Repair&opt=repair_list",KLASTURL];
    [self postRequest:url withParameters:dic];
}

- (void)repairerList:(NSString *)state andPage:(NSInteger)page andPlace:(NSString *)place andDepartment:(NSString *)department andBeginTime:(NSString *)beginTime andEndTime:(NSString *)endTime andFaultType:(NSString *)faultType
{
    self.requestType = RepairList;
    BOOL isComplete;
    if ([state isEqualToString:@""])
    {
        isComplete = YES;
    }
    NSDictionary *dic;
    if (isComplete)
    {
        dic = @{@"state":@"2",
                @"pagesize":@"5",
                @"page":[NSString stringWithFormat:@"%ld",(long)page],
                @"place":place,
                @"department":department,
                @"timestart":beginTime,
                @"timeover":endTime,
                @"faulttype":faultType};
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
                @"faulttype":faultType};
    }
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=Repair&opt=repair_list",KLASTURL];
    [self postRequest:url withParameters:dic];
}

- (void)createRepair:(NSString *)faultType faultCause:(NSString *)cause faultLevel:(NSString *)level depatmentID:(NSString *)depID floorInfoID:(NSString *)floorID
          areaInfoId:(NSString *)areaID shopInfoID:(NSString *)shopID equipment:(NSString *)eqID faultNotes:(NSString *)notes imageArray:(NSArray *)images repairUserArray:(NSArray *)userArray
{
    self.requestType = CreateRepair;
    
    BXTGroupInfo *groupInfo = [BXTGlobal getUserProperty:U_GROUPINGINFO];
    NSString *fault = [BXTGlobal getUserProperty:U_USERNAME];
    NSString *faultID = [BXTGlobal getUserProperty:U_BRANCHUSERID];
    NSString *moblie = [BXTGlobal getUserProperty:U_MOBILE];
    NSDictionary *dic = @{@"type":@"add",
                          @"subgroup":groupInfo.group_id,
                          @"faulttype":faultType,
                          @"cause":cause,
                          @"urgent":level,
                          @"part":depID,
                          @"area":floorID,
                          @"posit":areaID,
                          @"stores_id":shopID,
                          @"equipment":eqID,
                          @"fault":fault,
                          @"fault_id":faultID,
                          @"visitmobile":moblie,
                          @"notes":notes,
                          @"collection":@"",
                          @"collection_note":@"",
                          @"repair_user_arr":userArray};
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=Repair&opt=add_fault",KLASTURL];
    [self uploadImageRequest:url withParameters:dic withImages:images];
}

- (void)deleteRepair:(NSString *)repairID
{
    self.requestType = DeleteRepair;
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_USERID],
                          @"id":repairID};
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=Repair&opt=del_fault",KLASTURL];
    [self postRequest:url withParameters:dic];
}

- (void)repairDetail:(NSString *)repairID
{
    self.requestType = RepairDetail;
    NSDictionary *dic = @{@"id":repairID};
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=Repair&opt=repair_con",KLASTURL];
    [self postRequest:url withParameters:dic];
}

- (void)evaluateRepair:(NSArray *)rateArray evaluationNotes:(NSString *)notes repairID:(NSString *)reID imageArray:(NSArray *)images
{
    NSDictionary *rateDic = @{@"speed":rateArray[0],@"professional":rateArray[1],@"serve":rateArray[2]};
    NSDictionary *dic = @{@"send_id":[BXTGlobal getUserProperty:U_USERID],@"id":reID,@"praise":rateDic,@"evaluation_notes":notes,@"evaluation_name":[BXTGlobal getUserProperty:U_NAME]};
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=Repair&opt=praise",KLASTURL];
    [self uploadImageRequest:url withParameters:dic withImages:images];
}

- (void)reaciveOrderID:(NSString *)repairID arrivalTime:(NSString *)time
{
    self.requestType = ReaciveOrder;
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"user":@[[BXTGlobal getUserProperty:U_BRANCHUSERID]],
                          @"id":repairID,
                          @"arrival_time":time};
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=Repair&opt=dispatching",KLASTURL];
    [self postRequest:url withParameters:dic];
}

- (void)dispatchingMan:(NSString *)repairID andMans:(NSArray *)mans
{
    self.requestType = ReaciveOrder;
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"user":mans,
                          @"id":repairID};
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=Repair&opt=dispatching",KLASTURL];
    [self postRequest:url withParameters:dic];
}

- (void)propertyGrouping
{
    self.requestType = PropertyGrouping;
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=Hqdata&opt=get_hq_subgroup",KLASTURL];
    [self getRequest:url];
}

- (void)maintenanceState:(NSString *)repairID andReaciveTime:(NSString *)reaciveTime andFinishTime:(NSString *)finishTime andMaintenanceState:(NSString *)state andFaultType:(NSString *)faultType
{
    self.requestType = MaintenanceProcess;
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_BRANCHUSERID],
                          @"receive_time":reaciveTime,
                          @"end_time":finishTime,
                          @"state":state,
                          @"faulttype":faultType,
                          @"id":repairID};
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=Repair&opt=add_processed",KLASTURL];
    [self postRequest:url withParameters:dic];
}

- (void)maintenanceManList:(NSString *)groupID
{
    self.requestType = ManList;
    NSDictionary *dic = @{@"role":@"2",
                          @"subgroup":groupID};
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=User&opt=user_list",KLASTURL];
    [self postRequest:url withParameters:dic];
}

- (void)uploadHeaderImage:(UIImage *)image
{
    self.requestType = UploadHeadImage;
    NSDictionary *dic = @{@"id":[BXTGlobal getUserProperty:U_USERID],
                          @"name":[BXTGlobal getUserProperty:U_NAME],
                          @"gender":[BXTGlobal getUserProperty:U_SEX]};
    NSString *url = [NSString stringWithFormat:@"%@?r=port/Get_Android_v2_Port/module/User/opt/perfect_user",KURLREQUEST];
    [self uploadImageRequest:url withParameters:dic withImages:@[image]];
}

- (void)mobileVerCode:(NSString *)mobile
{
    NSDictionary *dic = @{@"mobile":mobile};
    NSString *url = [NSString stringWithFormat:@"%@?r=port/Get_Android_v2_Port/opt/get_verification_code/module/Means",KURLREQUEST];
    [self postRequest:url withParameters:dic];
}

- (void)userInfo
{
    self.requestType = UserInfo;
    NSDictionary *dic = @{@"id":[BXTGlobal getUserProperty:U_BRANCHUSERID]};
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=User&opt=user_con",KLASTURL];
    [self postRequest:url withParameters:dic];
}

- (void)achievementsList:(NSInteger)months
{
    NSDictionary *dic = @{@"user_id":[BXTGlobal getUserProperty:U_USERID],
                          @"months_num":[NSString stringWithFormat:@"%ld",(long)months]};
    NSString *url = [NSString stringWithFormat:@"%@?c=Port&m=actionGet_Android_v2_Port&module=Statistics&opt=get_achievements",KLASTURL];
    [self postRequest:url withParameters:dic];
}

- (void)postRequest:(NSString *)url withParameters:(NSDictionary *)parameters
{
    LogRed(@"url......%@",url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [response JSONValue];
        [_delegate requestResponseData:dictionary requeseType:_requestType];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate requestError:error];
    }];
}

- (void)uploadImageRequest:(NSString *)url withParameters:(NSDictionary *)parameters withImages:(NSArray *)images
{
    LogRed(@"url......%@",url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 显示进度
    AFHTTPRequestOperation *operation = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传 多张图片
        for(NSInteger i = 0; i < images.count; i++)
        {
            UIImage *image = [images objectAtIndex:i];
            NSData  *imageData = UIImageJPEGRepresentation(image, 1.f);
            // 上传的参数名
            NSString * Name = [NSString stringWithFormat:@"image%ld", (long)i];
            // 上传filename
            NSString * fileName = [NSString stringWithFormat:@"%@.jpg", Name];
            [formData appendPartWithFileData:imageData name:Name fileName:fileName mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [result JSONValue];
        [_delegate requestResponseData:dictionary requeseType:_requestType];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [_delegate requestError:error];
    }];
    
    [self showHUD];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        CGFloat progress = totalBytesWritten/totalBytesExpectedToWrite;
        [self setProgress:progress];
        NSLog(@"bytesWritten=%lu, totalBytesWritten=%lld, totalBytesExpectedToWrite=%lld", (unsigned long)bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }];
}

- (void)getRequest:(NSString *)url
{
    LogRed(@"%@",url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [response JSONValue];
        [_delegate requestResponseData:dictionary requeseType:_requestType];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate requestError:error];
    }];
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
        progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
        progressHUD.mode = MBProgressHUDModeCustomView;
        progressHUD.detailsLabelText = @"上传成功";
        [progressHUD hide:YES afterDelay:2];
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [progressHUD removeFromSuperview];
    progressHUD = nil;
}

@end
