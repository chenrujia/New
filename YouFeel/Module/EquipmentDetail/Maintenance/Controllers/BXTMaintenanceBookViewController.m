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
#import "BXTDeviceMaintenceInfo.h"
#import "UIImageView+WebCache.h"

@interface BXTMaintenanceBookViewController ()<BXTDataResponseDelegate>
{
    BOOL isFirst;
}

@property (nonatomic, strong) BXTDeviceMaintenceInfo *maintenceInfo;
@property (nonatomic, copy) NSString *safetyGuidelines;

@end

@implementation BXTMaintenanceBookViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                       deviceID:(NSString *)devID
                       recordID:(NSString *)recordID
               safetyGuidelines:(NSString *)safety
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        isFirst = YES;
        self.deviceID = devID;
        self.recordID = recordID;
        self.safetyGuidelines = safety;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"维保作业书" andRightTitle:nil andRightImage:nil];
    [self.currentTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (isFirst)
    {
        [self requestDate];
        isFirst = NO;
    }
    [self.view layoutSubviews];
}

- (void)requestDate
{
    [BXTGlobal showLoadingMBP:@"加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request inspectionRecordInfo:self.recordID];
}

#pragma mark -
#pragma mark 事件处理
- (void)navigationRightButton
{
    BXTMaintenanceViewController *mainVC = [[BXTMaintenanceViewController alloc] initWithNibName:@"BXTMaintenanceViewController" bundle:nil maintence:self.maintenceInfo deviceID:self.deviceID deviceStateList:self.deviceStates safetyGuidelines:self.safetyGuidelines];
    mainVC.isUpdate = YES;
    [self.navigationController pushViewController:mainVC animated:YES];
}

- (void)connactBtnClick:(UIButton *)btn
{
    BXTControlUserInfo *userInfo = _maintenceInfo.repair_arr[0];
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
    titleLabel.font = [UIFont systemFontOfSize:16.f];
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
        titleLabel.text = @"设备状态";
        return view;
    }
    else if (section == 3)
    {
        titleLabel.text = @"完成时间";
        return view;
    }
    else if (section == 4)
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
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return self.maintenceInfo.inspection_info.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 190.f;
    }
    else if (indexPath.section == 1)
    {
        BXTDeviceInspectionInfo *inspectionInfo = self.maintenceInfo.inspection_info[indexPath.row];
        NSString *content = [NSString stringWithFormat:@"作业内容：  %@",inspectionInfo.check_item];
        CGSize size = MB_MULTILINE_TEXTSIZE(content, [UIFont systemFontOfSize:17], CGSizeMake(SCREEN_WIDTH - 20, 300), NSLineBreakByWordWrapping);
        CGFloat height = 8.f + size.height + 10.f + inspectionInfo.check_arr.count * (8 + 20) + 10.f;
        return height;
    }
    else if (indexPath.section == 2 || indexPath.section == 3)
    {
        return 50.f;
    }
    else if (indexPath.section == 4)
    {
        UIFont *font = [UIFont systemFontOfSize:17.f];
        CGSize size = MB_MULTILINE_TEXTSIZE(self.maintenceInfo.notes, font, CGSizeMake(SCREEN_WIDTH - 30.f, 1000), NSLineBreakByWordWrapping);
        if (self.maintenceInfo.pic.count > 0)
        {
            return 12.f + size.height + 12.f + 73.f + 26.f;
        }
        return 12.f + size.height + 8.f;
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
        
        if (self.maintenceInfo)
        {
            BXTDeviceConfigInfo *deviceInfo = self.maintenceInfo.device_con[0];
            cell.deviceName.text = [NSString stringWithFormat:@"设备名称：%@",deviceInfo.name];
            cell.deviceNumber.text = [NSString stringWithFormat:@"设备编号：%@",deviceInfo.code_number];
            cell.deviceSystem.text = [NSString stringWithFormat:@"系统：%@",self.maintenceInfo.faulttype_type_name];
            cell.maintenanceProject.text = [NSString stringWithFormat:@"维保项目：%@",self.maintenceInfo.inspection_item_name];
            cell.maintenancePlane.text = [NSString stringWithFormat:@"维保计划：%@",self.maintenceInfo.inspection_time];
            NSString *str = [NSString stringWithFormat:@"设备当前状态：%@",self.maintenceInfo.device_state_name];
            NSRange range = [str rangeOfString:self.maintenceInfo.device_state_name];
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"2FAEFF") range:range];
            cell.deviceState.attributedText = attributeStr;
            if ([self.maintenceInfo.state integerValue] == 1)
            {
                cell.orderState.text = @"维修中";
            }
            else
            {
                cell.orderState.text = @"已完成";
            }
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
        
        for (UIView *subView in cell.contentView.subviews)
        {
            if (subView.tag >= 600)
            {
                [subView removeFromSuperview];
            }
        }
        
        BXTDeviceInspectionInfo *inspectionInfo = self.maintenceInfo.inspection_info[indexPath.row];
        NSString *content = [NSString stringWithFormat:@"作业内容：  %@",inspectionInfo.check_item];
        CGSize size = MB_MULTILINE_TEXTSIZE(content, [UIFont systemFontOfSize:17], CGSizeMake(SCREEN_WIDTH - 20, 300), NSLineBreakByWordWrapping);
        cell.maintenceProject.text = content;
        
        for (NSInteger i = 0; i < inspectionInfo.check_arr.count; i++)
        {
            BXTDeviceCheckInfo *checkPro = inspectionInfo.check_arr[i];
            UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 8.f + size.height + 10.f + i * (8 + 20), SCREEN_WIDTH - 20, 20)];
            infoLabel.font = [UIFont systemFontOfSize:17.f];
            infoLabel.text = [NSString stringWithFormat:@"%@：%@",checkPro.check_con,checkPro.default_description];
            infoLabel.tag = 600 + indexPath.row;
            [cell.contentView addSubview:infoLabel];
        }
        
        return cell;
    }
    else if (indexPath.section == 2 || indexPath.section == 3)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimeCell"];
        }
        if (indexPath.section == 2)
        {
            cell.textLabel.text = self.maintenceInfo.device_state_name;
        }
        else
        {
            cell.textLabel.text = self.maintenceInfo.create_time;
        }
        
        return cell;
    }
    else if (indexPath.section == 4)
    {
        BXTMaintenceNotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MaintenceNotesCell"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"BXTMaintenceNotesTableViewCell" bundle:nil] forCellReuseIdentifier:@"MaintenceNotesCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"MaintenceNotesCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.notes.text = self.maintenceInfo.notes;
        [cell handleImages:self.maintenceInfo];
        @weakify(self);
        UITapGestureRecognizer *tapGROne = [[UITapGestureRecognizer alloc] init];
        [[tapGROne rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            self.mwPhotosArray = [self containAllPhotos:self.maintenceInfo.pic];
            [self loadMWPhotoBrowser:cell.imageOne.tag];
        }];
        [cell.imageOne addGestureRecognizer:tapGROne];
        UITapGestureRecognizer *tapGRTwo = [[UITapGestureRecognizer alloc] init];
        [[tapGRTwo rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            self.mwPhotosArray = [self containAllPhotos:self.maintenceInfo.pic];
            [self loadMWPhotoBrowser:cell.imageTwo.tag];
        }];
        [cell.imageTwo addGestureRecognizer:tapGRTwo];
        UITapGestureRecognizer *tapGRThree = [[UITapGestureRecognizer alloc] init];
        [[tapGRThree rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            self.mwPhotosArray = [self containAllPhotos:self.maintenceInfo.pic];
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
        if (self.maintenceInfo.repair_arr.count > 0)
        {
            BXTControlUserInfo *userInfo = self.maintenceInfo.repair_arr[0];
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:userInfo.head_pic] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            cell.userName.text = userInfo.name;
            cell.userJob.text = userInfo.role;
            if (userInfo.mobile.length == 0)
            {
                cell.userMoblie.text = @"暂无";
            }
            else if (userInfo.mobile.length == 11)
            {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:userInfo.mobile];
                [attributedString addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"3cafff") range:NSMakeRange(0, 11)];
                [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 11)];
                cell.userMoblie.attributedText = attributedString;
            }
            if ([userInfo.out_userid isEqualToString:[BXTGlobal getUserProperty:U_USERID]])
            {
                cell.connactTa.hidden = YES;
            }
            else
            {
                [cell.connactTa addTarget:self action:@selector(connactBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    if (data.count == 0)
    {
        return;
    }
    NSArray *states = [dic objectForKey:@"device_state_list"];
    self.deviceStates = states;
    NSDictionary *dictionary = data[0];
    [BXTDeviceMaintenceInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"maintenceID":@"id"};
    }];
    BXTDeviceMaintenceInfo *maintence = [BXTDeviceMaintenceInfo mj_objectWithKeyValues:dictionary];
    self.maintenceInfo = maintence;
    if ([maintence.is_update integerValue] == 2)
    {
        UIView *navView = [self.view viewWithTag:KNavViewTag];
        [navView removeFromSuperview];
        [self navigationSetting:@"维保作业书" andRightTitle:@"修改" andRightImage:nil];
    }
    [self.currentTable reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
