//
//  BXTReaciveOrdersViewController.m
//  BXT
//
//  Created by Jason on 15/9/16.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTReaciveOrdersViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTRepairInfo.h"
#import "DOPDropDownMenu.h"
#import "BXTFaultInfo.h"
#import "BXTFaultTypeInfo.h"
#import "BXTSelectBoxView.h"
#import "BXTReaciveOrderTableViewCell.h"
#import "BXTOrderDetailViewController.h"

@interface BXTReaciveOrdersViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,BXTBoxSelectedTitleDelegate,UITableViewDelegate,UITableViewDataSource,BXTDataResponseDelegate>
{
    NSMutableArray    *ordersArray;
    NSMutableArray    *areasArray;
    NSMutableArray    *departmentsArray;
    NSMutableArray    *timesArray;
    NSMutableArray    *repairTypesArray;
    UITableView       *currentTableView;
    BXTSelectBoxView  *boxView;
    NSArray           *comeTimeArray;
    NSString          *orderID;
    NSInteger         selectTag;
    BXTAreaInfo       *selectArea;
    BXTFaultTypeInfo  *selectFaultType;
    BXTDepartmentInfo *selectDepartment;
    NSString          *repairBeginTime;
    NSString          *repairEndTime;
    
    UIView *bgView;
    UIDatePicker *datePicker;
    NSDate *originDate;
    NSTimeInterval timeInterval;
}
@end

@implementation BXTReaciveOrdersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    repairBeginTime = @"";
    repairEndTime = @"";
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    for (NSString *timeStr in [BXTGlobal readFileWithfileName:@"arriveArray"]) {
        [timeArray addObject:[NSString stringWithFormat:@"%@分钟内", timeStr]];
    }
    [timeArray addObject:@"自定义"];
    comeTimeArray = timeArray;
    [self resignNotifacation];
    [self navigationSetting:@"我要接单" andRightTitle:nil andRightImage:nil];
    [self createDOP];
    [self createTableView];
    [self requestData];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createDOP
{
    areasArray = [NSMutableArray arrayWithObjects:@"地区", nil];
    departmentsArray = [NSMutableArray arrayWithObjects:@"部门", nil];
    timesArray = [NSMutableArray arrayWithObjects:@"时间",@"1天",@"2天",@"3天",@"1周",@"1个月",@"3个月", nil];
    repairTypesArray = [NSMutableArray arrayWithObjects:@"故障", nil];
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
}

- (void)createTableView
{
    ordersArray = [[NSMutableArray alloc] init];
    
    currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:UITableViewStyleGrouped];
    [currentTableView registerClass:[BXTReaciveOrderTableViewCell class] forCellReuseIdentifier:@"ReaciveOrderCell"];
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    [self.view addSubview:currentTableView];
}

#pragma mark -
#pragma mark 事件处理
- (void)resignNotifacation
{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReaciveOrderSuccess" object:nil] subscribeNext:^(id x) {
        [self reloadTable];
    }];
}

- (void)requestData
{
    [self showLoadingMBP:@"努力加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**获取报修列表**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request repairerList:@"1"
                      andPage:1
                     andPlace:@"0"
                andDepartment:@"0"
                 andBeginTime:@"0"
                   andEndTime:@"0"
                 andFaultType:@"0"];
    });
    dispatch_async(concurrentQueue, ^{
        /**请求位置**/
        BXTDataRequest *location_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [location_request shopLocation];
    });
    dispatch_async(concurrentQueue, ^{
        /**请求部门列表**/
        BXTDataRequest *dep_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [dep_request departmentsList:@"1"];
    });
    dispatch_async(concurrentQueue, ^{
        /**请求故障类型列表**/
        BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [fau_request faultTypeList];
    });
}

- (void)reloadTable
{
    [ordersArray removeObjectAtIndex:selectTag];
    [currentTableView reloadData];
}

- (void)reaciveOrder:(UIButton *)btn
{
    selectTag = btn.tag;
    BXTRepairInfo *repairInfo = [ordersArray objectAtIndex:btn.tag];
    orderID = [NSString stringWithFormat:@"%ld",(long)repairInfo.repairID];
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6f;
    backView.tag = 101;
    [self.view addSubview:backView];
    
    if (boxView)
    {
        [boxView boxTitle:@"请选择到达时间" boxSelectedViewType:Other listDataSource:comeTimeArray];
        [self.view bringSubviewToFront:boxView];
    }
    else
    {
        boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:@"请选择到达时间" boxSelectedViewType:Other listDataSource:comeTimeArray markID:nil actionDelegate:self];
        [self.view addSubview:boxView];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH, 180.f)];
    }];
}

- (NSString *)transTimeStampToTime:(NSString *)timeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *dateTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]]];
    return dateTime;
}

#pragma mark -
#pragma mark 代理
/**
 *  UITableViewDelegate & UITableViewDatasource
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 16.f;//section头部高度
    }
    return 10.f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (section == 0)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16.f)];
    }
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 265.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [ordersArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTReaciveOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReaciveOrderCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BXTRepairInfo *repairInfo = [ordersArray objectAtIndex:indexPath.section];
    cell.repairID.text = [NSString stringWithFormat:@"工单号:%@",repairInfo.orderid];
    //自适应分组名
    CGSize group_size = MB_MULTILINE_TEXTSIZE(repairInfo.subgroup_name, [UIFont systemFontOfSize:16.f], CGSizeMake(SCREEN_WIDTH, 40.f), NSLineBreakByWordWrapping);
    group_size.width += 10.f;
    group_size.height = CGRectGetHeight(cell.groupName.frame);
    cell.groupName.frame = CGRectMake(SCREEN_WIDTH - group_size.width - 15.f, CGRectGetMinY(cell.groupName.frame), group_size.width, group_size.height);
    cell.groupName.text = repairInfo.subgroup_name;
    
    cell.place.text = [NSString stringWithFormat:@"位置:%@",repairInfo.area];
    cell.faultType.text = [NSString stringWithFormat:@"故障类型:%@",repairInfo.faulttype_name];
    cell.cause.text = [NSString stringWithFormat:@"故障描述:%@",repairInfo.cause];
    cell.repairTime.text = [NSString stringWithFormat:@"报修时间:%@",repairInfo.repair_time];
    NSString *time = [self transTimeStampToTime:repairInfo.long_time];
    cell.longTime.text = [NSString stringWithFormat:@"截止时间:%@",time];
    
    NSString *str;
    NSRange range;
    if (repairInfo.urgent == 2)
    {
        str = @"等级:一般";
        range = [str rangeOfString:@"一般"];
    }
    else
    {
        str = @"等级:紧急";
        range = [str rangeOfString:@"紧急"];
    }
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
    cell.level.attributedText = attributeStr;
    cell.reaciveBtn.tag = indexPath.section;
    [cell.reaciveBtn addTarget:self action:@selector(reaciveOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTRepairInfo *repairInfo = [ordersArray objectAtIndex:indexPath.section];
    BXTOrderDetailViewController *repairDetailVC = [[BXTOrderDetailViewController alloc] initWithRepairID:[NSString stringWithFormat:@"%ld",(long)repairInfo.repairID]];
    [self.navigationController pushViewController:repairDetailVC animated:YES];
}

/**
 *  DOPDropDownMenuDataSource & DOPDropDownMenuDelegate
 */
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 4;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0)
    {
        return areasArray.count;
    }
    else if (column == 1)
    {
        return departmentsArray.count;
    }
    else if (column == 2)
    {
        return timesArray.count;
    }
    else
    {
        return repairTypesArray.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0)
    {
        if (indexPath.row == 0) return areasArray[0];
        BXTFloorInfo *floor = areasArray[indexPath.row];
        return floor.area_name;
    }
    else if (indexPath.column == 1)
    {
        if (indexPath.row == 0) return departmentsArray[0];
        BXTDepartmentInfo *department = departmentsArray[indexPath.row];
        return department.department;
    }
    else if (indexPath.column == 2)
    {
        return timesArray[indexPath.row];
    }
    else
    {
        if (indexPath.row == 0) return repairTypesArray[0];
        BXTFaultInfo *fault = repairTypesArray[indexPath.row];
        return fault.faulttype_type;
    }
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    if (column == 0)
    {
        if (row == 0  || row > areasArray.count - 1) return 0;
        BXTFloorInfo *floor = areasArray[row];
        return floor.place.count;
    }
    else if (column == 3)
    {
        if (row == 0 || row > repairTypesArray.count - 1) return 0;
        BXTFaultInfo *fault = repairTypesArray[row];
        return fault.sub_data.count;
    }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0)
    {
        if (indexPath.row == 0 || indexPath.row > areasArray.count - 1) return nil;
        BXTFloorInfo *floor = areasArray[indexPath.row];
        BXTAreaInfo *area = floor.place[indexPath.item];
        return area.place_name;
    }
    else if (indexPath.column == 3)
    {
        if (indexPath.row == 0 || indexPath.row > areasArray.count - 1) return nil;
        BXTFaultInfo *fault = repairTypesArray[indexPath.row];
        BXTFaultTypeInfo *faultType = fault.sub_data[indexPath.item];
        return faultType.faulttype;
    }
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0)
    {
        if (indexPath.column == 0)
        {
            BXTFloorInfo *floor = areasArray[indexPath.row];
            BXTAreaInfo *area = floor.place[indexPath.item];
            selectArea = area;
        }
        else if (indexPath.column == 3)
        {
            BXTFaultInfo *fault = repairTypesArray[indexPath.row];
            BXTFaultTypeInfo *faultType = fault.sub_data[indexPath.item];
            selectFaultType = faultType;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            return;
        }
        else if (indexPath.row == 1)
        {
            [self showLoadingMBP:@"努力加载中..."];
            /**获取报修列表**/
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request repairerList:@"1"
                          andPage:1
                         andPlace:@"0"
                    andDepartment:@"0"
                     andBeginTime:@"0"
                       andEndTime:@"0"
                     andFaultType:@"0"];
            return;
        }
        else if (indexPath.column == 1)
        {
            BXTDepartmentInfo *department = departmentsArray[indexPath.row];
            selectDepartment = department;
        }
        else if (indexPath.column == 2)
        {
            NSString *time = timesArray[indexPath.row];
            NSTimeInterval endTime = [NSDate date].timeIntervalSince1970;
            NSTimeInterval beginTime;
            if ([time isEqualToString:@"1天"])
            {
                beginTime = endTime - 86400;
            }
            else if ([time isEqualToString:@"2天"])
            {
                beginTime = endTime - 172800;
            }
            else if ([time isEqualToString:@"3天"])
            {
                beginTime = endTime - 259200;
            }
            else if ([time isEqualToString:@"1周"])
            {
                beginTime = endTime - 604800;
            }
            else if ([time isEqualToString:@"1个月"])
            {
                beginTime = endTime - 2592000;
            }
            else if ([time isEqualToString:@"3个月"])
            {
                beginTime = endTime - 7776000;
            }
            
            repairBeginTime = [NSString stringWithFormat:@"%f",beginTime];
            repairEndTime = [NSString stringWithFormat:@"%f",endTime];
        }
    }
    
    NSString *place_id = selectArea ? selectArea.place_id : @"";
    NSString *department_id = selectDepartment ? selectDepartment.dep_id : @"";
    NSString *fault_type_id = selectFaultType ? [NSString stringWithFormat:@"%ld",(long)selectFaultType.fau_id] : @"";
    
    [self showLoadingMBP:@"努力加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairerList:@"1"
                  andPage:1
                 andPlace:place_id
            andDepartment:department_id
             andBeginTime:repairBeginTime
               andEndTime:repairEndTime
             andFaultType:fault_type_id];
}

/**
 *  请求返回代理
 */
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == RepairList)
    {
        [ordersArray removeAllObjects];
        if (data.count)
        {
            for (NSDictionary *dictionary in data)
            {
                DCParserConfiguration *config = [DCParserConfiguration configuration];
                DCObjectMapping *map = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"repairID" onClass:[BXTRepairInfo class]];
                [config addObjectMapping:map];
                
                DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTRepairInfo class] andConfiguration:config];
                BXTRepairInfo *repairInfo = [parser parseDictionary:dictionary];
                
                [ordersArray addObject:repairInfo];
            }
        }
        [currentTableView reloadData];
        [self hideMBP];
    }
    else if (type == ShopType)
    {
        for (NSDictionary *dictionary in data)
        {
            DCArrayMapping *floorMapper = [DCArrayMapping mapperForClassElements:[BXTAreaInfo class] forAttribute:@"place" onClass:[BXTFloorInfo class]];
            DCParserConfiguration *floorConfig = [DCParserConfiguration configuration];
            [floorConfig addArrayMapper:floorMapper];
            DCKeyValueObjectMapping *floorParser = [DCKeyValueObjectMapping mapperForClass:[BXTFloorInfo class]  andConfiguration:floorConfig];
            BXTFloorInfo *floor = [floorParser parseDictionary:dictionary];
            
            [areasArray addObject:floor];
        }
    }
    else if (type == DepartmentType)
    {
        if (data.count)
        {
            for (NSDictionary *dictionary in data)
            {
                DCParserConfiguration *config = [DCParserConfiguration configuration];
                DCObjectMapping *text = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"dep_id" onClass:[BXTDepartmentInfo class]];
                [config addObjectMapping:text];
                DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTDepartmentInfo class] andConfiguration:config];
                BXTDepartmentInfo *departmentInfo = [parser parseDictionary:dictionary];
                
                [departmentsArray addObject:departmentInfo];
            }
        }
    }
    else if (type == FaultType)
    {
        for (NSDictionary *dictionary in data)
        {
            DCParserConfiguration *config = [DCParserConfiguration configuration];
            DCObjectMapping *text = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"fault_id" onClass:[BXTFaultInfo class]];
            [config addObjectMapping:text];
            DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTFaultInfo class] andConfiguration:config];
            BXTFaultInfo *faultObj = [parser parseDictionary:dictionary];
            
            NSMutableArray *fault_subs = [NSMutableArray array];
            NSArray *places = [dictionary objectForKey:@"sub_data"];
            
            for (NSDictionary *placeDic in places)
            {
                DCParserConfiguration *fault_type_config = [DCParserConfiguration configuration];
                DCObjectMapping *fault_type_map = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"fau_id" onClass:[BXTFaultTypeInfo class]];
                [fault_type_config addObjectMapping:fault_type_map];
                DCKeyValueObjectMapping *fault_type_parser = [DCKeyValueObjectMapping mapperForClass:[BXTFaultTypeInfo class] andConfiguration:fault_type_config];
                BXTFaultInfo *faultTypeObj = [fault_type_parser parseDictionary:placeDic];
                [fault_subs addObject:faultTypeObj];
            }
            
            faultObj.sub_data = fault_subs;
            [repairTypesArray addObject:faultObj];
        }
    }
    else if (type == ReaciveOrder)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [self showMBP:@"接单成功！" withBlock:nil];
            [self reloadTable];
        }
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        if (datePicker)
        {
            [datePicker removeFromSuperview];
            datePicker = nil;
            [currentTableView reloadData];
        } else {
            [UIView animateWithDuration:0.3f animations:^{
                [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
            }];
        }
        
        [view removeFromSuperview];
    }
}

- (void)boxSelectedObj:(id)obj selectedType:(BoxSelectedType)type
{
    UIView *view = [self.view viewWithTag:101];
    [view removeFromSuperview];
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
    }];
    
    if ([obj isKindOfClass:[NSString class]])
    {
        NSString *tempStr = (NSString *)obj;
        if ([tempStr isEqualToString:@"自定义"]) {
            [self createDatePicker];
            return;
        }
        NSString *timeStr = [tempStr stringByReplacingOccurrencesOfString:@"分钟内" withString:@""];
        NSTimeInterval timer = [[NSDate date] timeIntervalSince1970] + [timeStr intValue]*50;
        timeStr = [NSString stringWithFormat:@"%.0f", timer];
        
        [self showLoadingMBP:@"请稍候..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        NSString *userID = [BXTGlobal getUserProperty:U_BRANCHUSERID];
        NSArray *users = @[userID];
        [request reaciveOrderID:orderID
                    arrivalTime:timeStr
                      andUserID:userID
                       andUsers:users
                      andIsGrad:NO];
    }
}

#pragma mark -
#pragma mark - UIDatePicker
- (void)createDatePicker
{
    bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    bgView.tag = 101;
    [self.view addSubview:bgView];
    
    originDate = [NSDate date];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-50-40, SCREEN_WIDTH, 40)];
    titleLabel.backgroundColor = colorWithHexString(@"ffffff");
    titleLabel.text = @"请选择到达时间";
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame)-1, SCREEN_WIDTH-30, 1)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [bgView addSubview:line];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216-50, SCREEN_WIDTH, 216)];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    datePicker.backgroundColor = colorWithHexString(@"ffffff");
    datePicker.minimumDate = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
    [bgView addSubview:datePicker];
    
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    toolView.backgroundColor = colorWithHexString(@"ffffff");
    [bgView addSubview:toolView];
    // sure
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 50)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(datePickerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.tag = 10001;
    sureBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    sureBtn.layer.borderWidth = 0.5;
    [toolView addSubview:sureBtn];
    // cancel
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 50)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(datePickerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    cancelBtn.layer.borderWidth = 0.5;
    cancelBtn.tag = 10002;
    [toolView addSubview:cancelBtn];
}

- (void)dateChange:(UIDatePicker *)picker
{
    // 获取分钟数
    timeInterval = [picker.date timeIntervalSince1970];
}

- (void)datePickerBtnClick:(UIButton *)button
{
    if (button.tag == 10001)
    {
        [self showLoadingMBP:@"请稍候..."];
        NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)timeInterval];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        NSString *userID = [BXTGlobal getUserProperty:U_BRANCHUSERID];
        NSArray *users = @[userID];
        [request reaciveOrderID:orderID
                    arrivalTime:timeStr
                      andUserID:userID
                       andUsers:users
                      andIsGrad:NO];
    }
    datePicker = nil;
    [bgView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
