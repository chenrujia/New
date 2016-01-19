//
//  BXTMaintenanceBookViewController.m
//  YouFeel
//
//  Created by Jason on 16/1/12.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMaintenanceBookViewController.h"
#import "BXTDeviceInfoTableViewCell.h"
#import "BXTMaintenceProjectTableViewCell.h"
#import "BXTMaintenceNotesTableViewCell.h"
#import "BXTMaintenanceViewController.h"
#import "BXTControlUserTableViewCell.h"
#import "BXTHeaderForVC.h"
#import "BXTMaintenceInfo.h"
#import "BXTInspectionInfo.h"
#import "BXTCheckProjectInfo.h"
#import "BXTDeviceConfigInfo.h"
#import "UIImageView+WebCache.h"

@interface BXTMaintenanceBookViewController ()<BXTDataResponseDelegate>
{
    NSMutableArray *checkProjectArray;
    NSMutableArray *cpHeightArray;
}
@property (nonatomic, strong) BXTMaintenceInfo *maintenceInfo;

@end

@implementation BXTMaintenanceBookViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil deviceID:(NSString *)devID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.deviceID = devID;
        checkProjectArray = [NSMutableArray array];
        cpHeightArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"维保作业书" andRightTitle:nil andRightImage:nil];
    [_currentTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self showLoadingMBP:@"努力加载中..."];
    //请求详情
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request inspectionRecordInfo:_deviceID];
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RefreshTable" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request inspectionRecordInfo:self.deviceID];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -
#pragma mark 事件处理
- (void)navigationRightButton
{
    BXTMaintenanceViewController *mainVC = [[BXTMaintenanceViewController alloc] initWithNibName:@"BXTMaintenanceViewController" bundle:nil maintence:_maintenceInfo deviceID:self.deviceID];
    mainVC.isUpdate = YES;
    [self.navigationController pushViewController:mainVC animated:YES];
}

- (void)connactBtnClick:(UIButton *)btn
{
    BXTDeviceConfigInfo *deviceInfo = _maintenceInfo.device_con[0];
    BXTControlUserInfo *userInfo;
    if (btn.tag == 4)
    {
        userInfo = deviceInfo.control_user_arr[0];
    }
    else if (btn.tag == 5)
    {
        userInfo = deviceInfo.control_user_arr[1];
    }
    [self handleUserInfoWithUser:userInfo];
}

#pragma mark -
#pragma mark 代理
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30.f)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15., 0, 100.f, 30)];
    titleLabel.textColor = colorWithHexString(@"888c8f");
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [view addSubview:titleLabel];
    if (section == 0)
    {
        titleLabel.text = @"设备信息";
        return view;
    }
    else if (section == 1)
    {
        titleLabel.text = @"维保作业内容";
        return view;
    }
    else if (section == 2)
    {
        titleLabel.text = @"完成时间";
        return view;
    }
    else if (section == 3)
    {
        titleLabel.text = @"备注";
        return view;
    }
    else
    {
        titleLabel.text = @"维修人";
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return checkProjectArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 160.f;
    }
    else if (indexPath.section == 1)
    {
        if (cpHeightArray.count >= indexPath.row + 1)
        {
            return [[cpHeightArray objectAtIndex:indexPath.row] floatValue];
        }
        return 100.f;
    }
    else if (indexPath.section == 2)
    {
        return 50.f;
    }
    else if (indexPath.section == 3)
    {
        BXTDeviceConfigInfo *deviceInfo = _maintenceInfo.device_con[0];
        UIFont *font = [UIFont systemFontOfSize:17.f];
        CGSize size = MB_MULTILINE_TEXTSIZE(deviceInfo.notes, font, CGSizeMake(SCREEN_WIDTH - 30.f, 1000), NSLineBreakByWordWrapping);
        if (deviceInfo.pic.count > 0)
        {
            return 12.f + size.height + 12.f + 73.f + 20.f;
        }
        return 12.f + size.height + 12.f;
    }
    return 97.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        BXTDeviceInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceInfoCell"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"BXTDeviceInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"DeviceInfoCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceInfoCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        BXTDeviceConfigInfo *deviceInfo = _maintenceInfo.device_con[0];
        cell.deviceName.text = [NSString stringWithFormat:@"设备名称：%@",deviceInfo.name];
        cell.deviceNumber.text = [NSString stringWithFormat:@"设备编号：%@",deviceInfo.model_number];
        cell.deviceSystem.text = [NSString stringWithFormat:@"系统：%@",_maintenceInfo.faulttype_type_name];
        cell.maintenanceProject.text = [NSString stringWithFormat:@"维保项目：%@",_maintenceInfo.inspection_item_name];
        cell.maintenancePlane.text = [NSString stringWithFormat:@"维保计划：%@",_maintenceInfo.inspection_time];
        if ([_maintenceInfo.state integerValue] == 1)
        {
            cell.orderState.text = @"维修中";
        }
        else
        {
            cell.orderState.text = @"已完成";
        }
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        BXTMaintenceProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MaintenceProjectCell"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"BXTMaintenceProjectTableViewCell" bundle:nil] forCellReuseIdentifier:@"MaintenceProjectCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"MaintenceProjectCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        BXTCheckProjectInfo *checkInfo = checkProjectArray[indexPath.row];
        cell.maintenceProject.text = checkInfo.project_name;
        cell.projectName.text = checkInfo.check_con;
        cell.projectState.text = checkInfo.default_description;
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        CGFloat checkProjectRH = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
        if (indexPath.row + 1 <= cpHeightArray.count)
        {
            [cpHeightArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:checkProjectRH]];
        }
        else
        {
            [cpHeightArray addObject:[NSNumber numberWithFloat:checkProjectRH]];
        }
        
        return cell;
    }
    else if (indexPath.section == 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimeCell"];
        }
        cell.textLabel.text = _maintenceInfo.create_time;
        
        return cell;
    }
    else if (indexPath.section == 3)
    {
        BXTMaintenceNotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MaintenceNotesCell"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"BXTMaintenceNotesTableViewCell" bundle:nil] forCellReuseIdentifier:@"MaintenceNotesCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"MaintenceNotesCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.notes.text = _maintenceInfo.notes;
        [cell handleImages:_maintenceInfo];
        @weakify(self);
        UITapGestureRecognizer *tapGROne = [[UITapGestureRecognizer alloc] init];
        [[tapGROne rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            self.mwPhotosArray = [self containAllPhotos:_maintenceInfo.pic];
            [self loadMWPhotoBrowser:cell.imageOne.tag];
        }];
        [cell.imageOne addGestureRecognizer:tapGROne];
        UITapGestureRecognizer *tapGRTwo = [[UITapGestureRecognizer alloc] init];
        [[tapGRTwo rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            self.mwPhotosArray = [self containAllPhotos:_maintenceInfo.pic];
            [self loadMWPhotoBrowser:cell.imageTwo.tag];
        }];
        [cell.imageTwo addGestureRecognizer:tapGRTwo];
        UITapGestureRecognizer *tapGRThree = [[UITapGestureRecognizer alloc] init];
        [[tapGRThree rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            self.mwPhotosArray = [self containAllPhotos:_maintenceInfo.pic];
            [self loadMWPhotoBrowser:cell.imageThree.tag];
        }];
        [cell.imageThree addGestureRecognizer:tapGRThree];
        
        return cell;
    }
    else
    {
        BXTControlUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ManagerUserCell"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"BXTControlUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"ManagerUserCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"ManagerUserCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        BXTDeviceConfigInfo *deviceInfo = _maintenceInfo.device_con[0];
        BXTControlUserInfo *userInfo = deviceInfo.control_user_arr[1];
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:userInfo.head_pic] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        cell.userName.text = userInfo.name;
        cell.userJob.text = userInfo.role;
        if (userInfo.mobile.length == 0)
        {
            cell.userMoblie.text = @"暂无";
        }
        else
        {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:userInfo.mobile];
            [attributedString addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"3cafff") range:NSMakeRange(0, 11)];
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 11)];
            cell.userMoblie.attributedText = attributedString;
        }
        cell.connactTa.tag = indexPath.section;
        [cell.connactTa addTarget:self action:@selector(connactBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
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
    if ([maintence.is_update integerValue] == 2)
    {
        UIView *navView = [self.view viewWithTag:KNavViewTag];
        [navView removeFromSuperview];
        [self navigationSetting:@"维保作业书" andRightTitle:@"修改" andRightImage:nil];
    }
    //单独过滤出检查项目
    for (BXTInspectionInfo *inspection_info in maintence.inspection_info)
    {
        for (BXTCheckProjectInfo *check_info in inspection_info.check_arr)
        {
            check_info.project_name = inspection_info.check_item;
            [checkProjectArray addObject:check_info];
        }
    }
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
    self.maintenceInfo = maintence;
    [_currentTable reloadData];
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
