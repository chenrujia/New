//
//  BXTMaintenanceBookViewController.m
//  YouFeel
//
//  Created by Jason on 16/1/12.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMaintenanceBookViewController.h"
#import "BXTDeviceInfoTableViewCell.h"
#import "BXTHeaderForVC.h"
#import "BXTMaintenceInfo.h"
#import "BXTInspectionInfo.h"
#import "BXTCheckProjectInfo.h"
#import "BXTDeviceConfigInfo.h"
#import "BXTControlUserInfo.h"

@interface BXTMaintenanceBookViewController ()<BXTDataResponseDelegate>

@end

@implementation BXTMaintenanceBookViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil deviceID:(NSString *)devID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.deviceID = devID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"维保作业书" andRightTitle:@"修改" andRightImage:nil];
    [_currentTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    //请求详情
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request inspectionRecordInfo:_deviceID];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 30.f;
    }
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30.f)];
        view.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15., 0, 100.f, 30)];
        titleLabel.textColor = colorWithHexString(@"888c8f");
        titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        titleLabel.text = @"设备信息";
        [view addSubview:titleLabel];
        
        return view;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == _maintenceInfo.inspection_info.count + 1)
//    {
//        return 170;
//    }
    return 158.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTDeviceInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceInfoCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"BXTDeviceInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"DeviceInfoCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.deviceName.text = @"1";
    cell.deviceNumber.text = @"2";
    cell.deviceSystem.text = @"3";
    cell.maintenanceProject.text = @"4";
    cell.maintenancePlane.text = @"5";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    LogRed(@"dic...%@",dic);
    NSDictionary *dictionary = data[0];
    
    DCObjectMapping *maintenceID = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"maintenceID" onClass:[BXTMaintenceInfo class]];
    DCParserConfiguration *maintenceConfig = [DCParserConfiguration configuration];
    [maintenceConfig addObjectMapping:maintenceID];
    DCKeyValueObjectMapping *maintenceParser = [DCKeyValueObjectMapping mapperForClass:[BXTMaintenceInfo class]  andConfiguration:maintenceConfig];
    BXTMaintenceInfo *maintence = [maintenceParser parseDictionary:dictionary];
    
    //维保项目
    NSMutableArray *inspectionArray = [NSMutableArray array];
    NSArray *inspections = [dictionary objectForKey:@"inspection_info"];
    for (NSDictionary *placeDic in inspections)
    {
        DCArrayMapping *inspectionMapper = [DCArrayMapping mapperForClassElements:[BXTCheckProjectInfo class] forAttribute:@"check_arr" onClass:[BXTInspectionInfo class]];
        DCParserConfiguration *inspectionConfig = [DCParserConfiguration configuration];
        [inspectionConfig addArrayMapper:inspectionMapper];
        DCKeyValueObjectMapping *inspectionParser = [DCKeyValueObjectMapping mapperForClass:[BXTInspectionInfo class]  andConfiguration:inspectionConfig];
        BXTInspectionInfo *inspection = [inspectionParser parseDictionary:placeDic];
        [inspectionArray addObject:inspection];
    }
    maintence.inspection_info = inspectionArray;
    
    //管理员和维修员
    NSMutableArray *devicesArray = [NSMutableArray array];
    NSArray *device_con_array = [dictionary objectForKey:@"device_con"];
    for (NSDictionary *deviceDic in device_con_array)
    {
        DCArrayMapping *deviceMapper = [DCArrayMapping mapperForClassElements:[BXTControlUserInfo class] forAttribute:@"control_user_arr" onClass:[BXTDeviceConfigInfo class]];
        DCParserConfiguration *deviceConfig = [DCParserConfiguration configuration];
        [deviceConfig addArrayMapper:deviceMapper];
        DCKeyValueObjectMapping *deviceParser = [DCKeyValueObjectMapping mapperForClass:[BXTDeviceConfigInfo class]  andConfiguration:deviceConfig];
        BXTInspectionInfo *device = [deviceParser parseDictionary:deviceDic];
        [devicesArray addObject:device];
    }
    maintence.device_con = devicesArray;
    
    NSLog(@".....");
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
