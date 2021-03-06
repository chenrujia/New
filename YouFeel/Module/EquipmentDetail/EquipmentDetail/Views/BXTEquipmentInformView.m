//
//  EquipmentInformView.m
//  YouFeel
//
//  Created by 满孝意 on 15/12/29.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTEquipmentInformView.h"
#import "BXTHeaderForVC.h"
#import "DataModels.h"
#import "UIView+Nav.h"
#import "BXTEquipmentInformCell.h"
#import "BXTEquipmentInform_PersonCell.h"
#import "BXTEPStateCell.h"
#import "BXTNewWorkOrderViewController.h"

@interface BXTEquipmentInformView () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>
{
    UIImageView *arrow;
}

@property (nonatomic, strong) BXTEquipmentData *equipmentModel;
@property (nonatomic, strong) UITableView      *tableView;
@property (nonatomic, strong) NSArray          *dataArray;
@property (nonatomic, strong) NSArray          *headerTitleArray;
@property (nonatomic, strong) NSMutableArray   *titleArray;
@property (nonatomic, strong) NSMutableArray   *detailArray;
@property (nonatomic, strong) NSMutableArray   *isShowArray;
@property (nonatomic, copy  ) NSString         *stateName;
@property (nonatomic, copy  ) NSString         *stateID;
@property (nonatomic, assign) CGFloat          cellHeight;

@end

@implementation BXTEquipmentInformView
#pragma mark -
#pragma mark - 初始化
- (void)initial
{
    self.dataArray = [[NSArray alloc] init];
    self.headerTitleArray = @[@"", @"基本信息", @"厂家信息", @"设备参数", @"设备负责人", @"设备状态记录"];
    self.detailArray = [[NSMutableArray alloc] init];
    self.isShowArray = [[NSMutableArray alloc] init];
    for (int i=0; i<=self.headerTitleArray.count-1; i++)
    {
        [self.isShowArray addObject:@"0"];
    }
    [self.isShowArray replaceObjectAtIndex:1 withObject:@"1"];
    //侦听，跳转到新建报修
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"PresentCreateNewOrder" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
        BXTNewWorkOrderViewController *newVC = (BXTNewWorkOrderViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTNewWorkOrderViewController"];
        newVC.isNewWorkOrder = YES;
        NSDictionary *dic = @{@"deviceName":self.equipmentModel.name,
                              @"deviceID":self.deviceID,
                              @"placeName":self.equipmentModel.server_area,
                              @"placeID":self.equipmentModel.place_id};
        [newVC deviceInfoWithDictionary:dic];
        [[self navigation] pushViewController:newVC animated:YES];
    }];
    
    [BXTGlobal showLoadingMBP:@"加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request equipmentInformation:self.deviceID];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.headerTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    if ([self.isShowArray[section] isEqualToString:@"1"])
    {
        NSArray *numArray = self.titleArray[section];
        return numArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5)
    {
        BXTEPStateCell *cell = [BXTEPStateCell cellWithTableView:tableView];
        
        cell.stateList = self.detailArray[indexPath.section][indexPath.row];
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        self.cellHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
        
        return cell;
    }
    
    if (indexPath.section == 4)
    {
        BXTEquipmentInform_PersonCell *cell = [BXTEquipmentInform_PersonCell cellWithTableView:tableView];
        
        cell.userList = self.detailArray[indexPath.section][indexPath.row];
        @weakify(self);
        [[cell.connectView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self connectTaWithOutID:cell.userList];
        }];
        
        return cell;
    }
    
    BXTEquipmentInformCell *cell = [BXTEquipmentInformCell cellWithTableView:tableView];
    NSString *title = [NSString stringWithFormat:@"%@：", self.titleArray[indexPath.section][indexPath.row]];
    CGSize title_size = MB_MULTILINE_TEXTSIZE(title, [UIFont boldSystemFontOfSize:15.f], CGSizeMake(1000.f, 100.f), NSLineBreakByWordWrapping);
    cell.title_width.constant = title_size.width;
    [cell.contentView layoutIfNeeded];
    cell.titleView.text = title;
    if (self.detailArray.count != 0)
    {
        cell.detailView.text = self.detailArray[indexPath.section][indexPath.row];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        cell.statusView.hidden = NO;
        cell.statusView.text = self.stateName;
        cell.statusView.textColor = colorWithHexString([self adjustStateColor:self.stateID]);
    }
    
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH-90, 10, 75, 30);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@"操作规范" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.borderColor = [[UIColor blackColor] CGColor];
        button.layer.borderWidth = 0.5;
        button.layer.cornerRadius = 5;
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [MYAlertAction showAlertWithTitle:nil msg:ValueFUD(@"OPERATINGDESC")  chooseBlock:^(NSInteger buttonIdx) {
                
            } buttonsStatement:@"确定", nil];
        }];
        
        [cell.contentView addSubview:button];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5)
    {
        return self.cellHeight;
    }
    if (indexPath.section == 4)
    {
        return 90;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"headerTitle";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [UIView new];
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = section;
    btn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    btn.layer.borderWidth = 0.5;
    @weakify(self);
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        // 改变组的显示状态
        if ([self.isShowArray[btn.tag] isEqualToString:@"1"])
        {
            [self.isShowArray replaceObjectAtIndex:btn.tag withObject:@"0"];
        }
        else
        {
            [self.isShowArray replaceObjectAtIndex:btn.tag withObject:@"1"];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 14.5, 100, 21)];
    title.text = self.headerTitleArray[section];
    title.textColor = colorWithHexString(@"#666666");
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:15];
    [btn addSubview:title];
    
    arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 21, 15, 8)];
    arrow.image = [UIImage imageNamed:@"down_arrow_gray"];
    if ([self.isShowArray[section] isEqualToString:@"1"])
    {
        arrow.image = [UIImage imageNamed:@"up_arrow_gray"];
    }
    [btn addSubview:arrow];
    
    return btn;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == Device_Con && data.count > 0 && [dic[@"returncode"] integerValue] == 0)
    {
        NSDictionary *dataDict = data[0];
        self.titleArray = [[NSMutableArray alloc] initWithArray:@[@[@"设备名称", @"设备编号"],  @[@"设备型号", @"设备分类", @"设备品牌", @"安装位置", @"服务区域", @"接管日期", @"启用日期"], @[@"品牌", @"厂家", @"地址", @"联系人  ", @"联系电话"], @[@"设备参数"], @[@"负责人"], @[@"状态记录"]]];
        self.equipmentModel = [BXTEquipmentData modelObjectWithDictionary:dataDict];
        
        // section == 0
        NSMutableArray *equipArray = [[NSMutableArray alloc] initWithObjects:self.equipmentModel.name, self.equipmentModel.code_number, nil];
        self.stateName = self.equipmentModel.state_name;
        self.stateID = self.equipmentModel.state;
        
        // section == 1
        NSMutableArray *baseArray = [[NSMutableArray alloc] initWithObjects:self.equipmentModel.model_number, self.equipmentModel.type_name, self.equipmentModel.brand, self.equipmentModel.place_name, self.equipmentModel.server_area, self.equipmentModel.take_over_data, self.equipmentModel.start_data, nil];
        
        // section == 2
        NSDictionary *factoryDict = dataDict[@"factory_info"];
        NSMutableArray *companyArray = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", nil];
        BXTEquipmentFactoryInfo *factoryInfoModel = [BXTEquipmentFactoryInfo modelObjectWithDictionary:factoryDict];
        companyArray = (NSMutableArray *)@[factoryInfoModel.bread, factoryInfoModel.factory_name, factoryInfoModel.address, factoryInfoModel.linkman, factoryInfoModel.mobile];
        
        // section == 3
        NSArray *paramsArray0 = dataDict[@"params_info"];
        NSMutableArray *paramsArray = [[NSMutableArray alloc] init];
        NSMutableArray *paramsTitleArray = [[NSMutableArray alloc] init];
        for (NSDictionary *paramsDict in paramsArray0)
        {
            BXTEquipmentParams *paramsModel = [BXTEquipmentParams modelObjectWithDictionary:paramsDict];
            [paramsTitleArray addObject:paramsModel.param_key];
            [paramsArray addObject:paramsModel.param_value];
        }
        
        // section == 4
        NSArray *authorArray0 = dataDict[@"control_users_info"];
        NSMutableArray *authorArray = [[NSMutableArray alloc] init];
        NSMutableArray *authorTitleArray = [[NSMutableArray alloc] init];
        for (NSDictionary *authorDict in authorArray0)
        {
            BXTEquipmentControlUserArr *controlUserModel = [BXTEquipmentControlUserArr modelObjectWithDictionary:authorDict];
            [authorTitleArray addObject:@"负责人"];
            [authorArray addObject:controlUserModel];
        }
        
        // section == 5
        NSArray *stateArray0 = dataDict[@"state_record_list"];
        NSMutableArray *stateArray = [[NSMutableArray alloc] init];
        NSMutableArray *stateTitleArray = [[NSMutableArray alloc] init];
        for (NSDictionary *stateDict in stateArray0)
        {
            BXTEquipmentState *stateRecordModel = [BXTEquipmentState modelObjectWithDictionary:stateDict];
            [stateTitleArray addObject:@"状态记录"];
            [stateArray addObject:stateRecordModel];
        }
        
        // 存储 设备操作规范
        SaveValueTUD(@"OPERATINGDESC", dataDict[@"operating_desc"]);
        
        // 更新数组
        [self.titleArray replaceObjectAtIndex:3 withObject:paramsTitleArray];
        [self.titleArray replaceObjectAtIndex:4 withObject:authorTitleArray];
        [self.titleArray replaceObjectAtIndex:5 withObject:stateTitleArray];
        [self.detailArray addObjectsFromArray:@[equipArray, baseArray, companyArray, paramsArray, authorArray, stateArray]];
        
        [self.tableView reloadData];
    }
    else if ([dic[@"returncode"] integerValue] == 002)
    {
        [MYAlertAction showAlertWithTitle:@"暂无此设备" msg:nil chooseBlock:^(NSInteger buttonIdx) {
            [[self navigation] popViewControllerAnimated:YES];
        } buttonsStatement:@"退出", nil];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

#pragma mark -
#pragma mark - connectTa
- (void)connectTaWithOutID:(BXTEquipmentControlUserArr *)model
{
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = model.out_userid;
    
    NSString *my_userID = [BXTGlobal getUserProperty:U_USERID];
    if ([userInfo.userId isEqualToString:my_userID])
    {
        [BXTGlobal showText:@"温馨提示：不可与自己对话" completionBlock:nil];
        return ;
    }
    userInfo.name = model.name;
    userInfo.portraitUri = model.headMedium;
    
    NSMutableArray *usersArray = [BXTGlobal getUserProperty:U_USERSARRAY];
    if (usersArray)
    {
        NSArray *arrResult = [usersArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.userId = %@",userInfo.userId]];
        if (arrResult.count)
        {
            RCUserInfo *temp_userInfo = arrResult[0];
            NSInteger index = [usersArray indexOfObject:temp_userInfo];
            [usersArray replaceObjectAtIndex:index withObject:temp_userInfo];
        }
        else
        {
            [usersArray addObject:userInfo];
        }
    }
    else
    {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:userInfo];
        [BXTGlobal setUserProperty:array withKey:U_USERSARRAY];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HaveConnact" object:nil];
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:NO];
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = userInfo.userId;
    conversationVC.title = userInfo.name;
    [[self navigation] pushViewController:conversationVC animated:YES];
}

- (NSString *)adjustStateColor:(NSString *)state
{
    NSString *colorStr;
    switch ([state integerValue]) {
        case 1: colorStr = @"#34B47E"; break;
        case 2: colorStr = @"#EA3622"; break;
        case 3: colorStr = @"#D6AD5B"; break;
        case 4: colorStr = @"#989C9F"; break;
        default: break;
    }
    
    return colorStr;
}

@end
