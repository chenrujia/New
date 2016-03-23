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
#import "UIScrollView+EmptyDataSet.h"
#import "BXTMaintenanceDetailViewController.h"
#import <MJRefresh.h>

#import "BXTMainTableViewCell.h"

@interface BXTReaciveOrdersViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource,BXTDataResponseDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
{
    NSMutableArray    *ordersArray;
    
    NSMutableArray    *groupArray;
    NSMutableArray    *stateArray;
    NSMutableArray    *areasArray;
    NSMutableArray    *timesArray;
    
    UITableView       *currentTableView;
    
    BXTAreaInfo       *selectArea;
    BXTFaultTypeInfo  *selectFaultType;
    NSInteger selectDepartment;
    NSString          *repairBeginTime;
    NSString          *repairEndTime;
}

@property (nonatomic, strong) NSString       *taskType;
@property (nonatomic, assign) NSInteger       currentPage;

@end

@implementation BXTReaciveOrdersViewController

- (instancetype)initWithTaskType:(NSInteger)task_type
{
    self = [super init];
    if (self)
    {
        self.taskType = [NSString stringWithFormat:@"%ld",(long)task_type];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    repairBeginTime = @"";
    repairEndTime = @"";
    
    [self resignNotifacation];
    
    if ([_taskType integerValue] == 1)
    {
        [self navigationSetting:@"日常工单" andRightTitle:nil andRightImage:nil];
    }
    else
    {
        [self navigationSetting:@"维保工单" andRightTitle:nil andRightImage:nil];
    }
    
    [self createDOP];
    [self createTableView];
    [self requestData];
    
}

- (void)getResource
{
    [self showLoadingMBP:@"努力加载中..."];
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairerList:@"1"
                  andPage:self.currentPage
                 andPlace:@"0"
            andDepartment:@"0"
             andBeginTime:@"0"
               andEndTime:@"0"
             andFaultType:@"0"
              andTaskType:self.taskType];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createDOP
{
    groupArray = [NSMutableArray arrayWithObjects:@"分组", nil];
    stateArray = [NSMutableArray arrayWithObjects:@"状态", @"正常工单", @"超时工单", nil];
    areasArray = [NSMutableArray arrayWithObjects:@"位置", nil];
    timesArray = [NSMutableArray arrayWithObjects:@"时间",@"1天",@"2天",@"3天",@"1周",@"1个月",@"3个月", nil];
    
    
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
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    currentTableView.emptyDataSetDelegate = self;
    currentTableView.emptyDataSetSource = self;
    [self.view addSubview:currentTableView];
}

#pragma mark -
#pragma mark 事件处理
- (void)resignNotifacation
{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReaciveOrderSuccess" object:nil] subscribeNext:^(id x) {
        [currentTableView reloadData];
    }];
}

- (void)requestData
{
    [self showLoadingMBP:@"努力加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**获取报修列表**/
//        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
//        [request ListOfRepairOrderWithTaskType:self.taskType
//                                       FaultID:@""
//                                      RepairID:@""
//                                          Page:1];
        
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request repairerList:@"1"
                      andPage:1
                     andPlace:@"0"
                andDepartment:@"0"
                 andBeginTime:@"0"
                   andEndTime:@"0"
                 andFaultType:@"0"
                  andTaskType:self.taskType];
    });
#pragma mark -
#pragma mark - cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
//    dispatch_async(concurrentQueue, ^{
//        /**请求位置**/
//        BXTDataRequest *location_request = [[BXTDataRequest alloc] initWithDelegate:self];
//        [location_request shopLocation];
//    });
//    dispatch_async(concurrentQueue, ^{
//        /**请求故障类型列表**/
//        BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
//        [fau_request faultTypeListWithRTaskType:@"all"];
//    });
    
    
    self.currentPage = 1;
    __block __typeof(self) weakSelf = self;
    currentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf getResource];
    }];
    currentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf getResource];
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
#pragma mark UITableViewDelegate & UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;//section头部高度
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.f;
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
    BXTMainTableViewCell *cell = [BXTMainTableViewCell cellWithTableView:tableView];
    
    BXTRepairInfo *repairInfo = [ordersArray objectAtIndex:indexPath.section];
    
    cell.orderNumView.text = [NSString stringWithFormat:@"编号:%@", repairInfo.orderid];
    cell.orderGroupView.text = [NSString stringWithFormat:@"%@  ", repairInfo.subgroup_name];
    cell.orderStateView.text = [NSString stringWithFormat:@"%@", repairInfo.repairstate_name];
    
    // 日常工单 - 时间、位置、内容
    if ([_taskType integerValue] == 1)
    {
        cell.orderTypeView.text = @"日常";
        cell.firstView.text = [NSString stringWithFormat:@"时间：%@", repairInfo.fault_time_name];
        cell.secondView.text = [NSString stringWithFormat:@"位置：%@", repairInfo.place_name];
        cell.thirdView.text = [NSString stringWithFormat:@"内容：%@", repairInfo.cause];
    }
    else // 维保工单 - 时间、项目、位置、内容
    {
        cell.orderTypeView.text = @"维保";
        cell.firstView.text = [NSString stringWithFormat:@"时间：%@", repairInfo.fault_time_name];
        cell.secondView.text = [NSString stringWithFormat:@"项目：%@", repairInfo.faulttype_name];
        cell.thirdView.text = [NSString stringWithFormat:@"位置：%@", repairInfo.place_name];
        cell.forthView.text = [NSString stringWithFormat:@"内容：%@", repairInfo.cause];
    }  
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BXTRepairInfo *repairInfo = [ordersArray objectAtIndex:indexPath.section];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
    BXTMaintenanceDetailViewController *repairDetailVC = (BXTMaintenanceDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTMaintenanceDetailViewController"];
    [repairDetailVC dataWithRepairID:repairInfo.repairID];
    [self.navigationController pushViewController:repairDetailVC animated:YES];
}

#pragma mark -
#pragma mark DZNEmptyDataSetDelegate & DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有符合条件的工单";
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor blackColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark -
#pragma mark DOPDropDownMenuDataSource & DOPDropDownMenuDelegate
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 4;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0)
    {
        return groupArray.count;
    }
    else if (column == 1)
    {
        return stateArray.count;
    }
    else if (column == 2)
    {
        return areasArray.count;
    }
    else
    {
        return timesArray.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0)
    {
        if (indexPath.row == 0) return groupArray[0];
        BXTFaultInfo *fault = groupArray[indexPath.row];
        return fault.faulttype_type;
    }
    else if (indexPath.column == 1)
    {
        return stateArray[indexPath.row];
    }
    else if (indexPath.column == 2)
    {
        if (indexPath.row == 0) return areasArray[0];
        BXTFloorInfo *floor = areasArray[indexPath.row];
        return floor.area_name;
    }
    else
    {
        return timesArray[indexPath.row];
    }
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    if (column == 2)
    {
        if (row == 0  || row > areasArray.count - 1) return 0;
        BXTFloorInfo *floor = areasArray[row];
        return floor.place.count;
    }
    
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 2)
    {
        if (indexPath.row == 0 || indexPath.row > areasArray.count - 1) return nil;
        BXTFloorInfo *floor = areasArray[indexPath.row];
        BXTAreaInfo *area = floor.place[indexPath.item];
        return area.place_name;
    }
    
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    //判断有无二级菜单
    if (indexPath.item >= 0)
    {
        //地区
        if (indexPath.column == 2)
        {
            BXTFloorInfo *floor = areasArray[indexPath.row];
            BXTAreaInfo *area = floor.place[indexPath.item];
            selectArea = area;
        }
        //故障类型
        else if (indexPath.column == 1)
        {
            BXTFaultInfo *fault = groupArray[indexPath.row];
            BXTFaultTypeInfo *faultType = fault.sub_data[indexPath.item];
            selectFaultType = faultType;
        }
    }
    else
    {
        //选择四个栏目中的第一个都要重新请求所有数据
        if (indexPath.row == 0)
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
                     andFaultType:@"0"
                      andTaskType:self.taskType];
            return;
        }
        //工单状态
        else if (indexPath.column == 0)
        {
            selectDepartment = indexPath.row;
        }
        //时间
        else if (indexPath.column == 3)
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
            
            repairBeginTime = [NSString stringWithFormat:@"%.0f",beginTime];
            repairEndTime = [NSString stringWithFormat:@"%.0f",endTime];
        }
    }
    
    NSString *place_id = selectArea ? selectArea.place_id : @"";
    NSString *department_id = [NSString stringWithFormat:@"%ld", selectDepartment];
    NSString *fault_type_id = selectFaultType ? [NSString stringWithFormat:@"%ld",(long)selectFaultType.fau_id] : @"";
    
    
    self.currentPage = 1;
    [self showLoadingMBP:@"努力加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairerList:@"1"
                  andPage:1
                 andPlace:place_id
            andDepartment:department_id
             andBeginTime:repairBeginTime
               andEndTime:repairEndTime
             andFaultType:fault_type_id
              andTaskType:self.taskType];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    [currentTableView.mj_header endRefreshing];
    [currentTableView.mj_footer endRefreshing];
    
    
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    
    if (type == RepairList)
    {
        if (self.currentPage == 1 && ordersArray.count != 0)
        {
            [ordersArray removeAllObjects];
        }
        
        if (data.count)
        {
            [BXTRepairInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"repairID":@"id"};
            }];
            NSArray *repairs = [BXTRepairInfo mj_objectArrayWithKeyValuesArray:data];
            [ordersArray addObjectsFromArray:repairs];
        }
        [currentTableView reloadData];
        
    }
    else if (type == ShopType)
    {
        [areasArray addObjectsFromArray:[BXTFloorInfo mj_objectArrayWithKeyValuesArray:data]];
    }
    else if (type == FaultType)
    {
        [BXTFaultInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"fault_id":@"id"};
        }];
        [BXTFaultTypeInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"fau_id":@"id"};
        }];
        [groupArray addObjectsFromArray:[BXTFaultInfo mj_objectArrayWithKeyValuesArray:data]];
    }
    
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
    [currentTableView.mj_header endRefreshing];
    [currentTableView.mj_footer endRefreshing];
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
