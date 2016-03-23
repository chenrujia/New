//
//  BXTOrderListView.m
//  BXT
//
//  Created by Jason on 15/9/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTOrderListView.h"
#import "BXTRepairTableViewCell.h"
#import "BXTHeaderForVC.h"
#import "BXTRepairInfo.h"
#import "MJRefresh.h"
#import "UIView+Nav.h"
#import "BXTMaintenanceDetailViewController.h"
#import "BXTMaintenanceProcessViewController.h"
#import "AppDelegate.h"
#import "BXTEvaluationViewController.h"
#import "DOPDropDownMenu.h"
#import "BXTMainTableViewCell.h"

@interface BXTOrderListView () <DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{
    NSMutableArray    *typeArray;
    NSMutableArray    *stateArray;
    NSMutableArray    *areasArray;
    NSMutableArray    *timesArray;
    
    BXTAreaInfo       *selectArea;
    NSInteger  selectFaultType;
    NSInteger  selectDepartment;
    NSString          *repairBeginTime;
    NSString          *repairEndTime;
}

@property (nonatomic, assign) NSInteger pushIndex;

@end

@implementation BXTOrderListView

- (instancetype)initWithFrame:(CGRect)frame andState:(NSString *)state andRepairerIsReacive:(NSString *)reacive
{
    self = [super initWithFrame:frame];
    if (self)
    {
        @weakify(self);
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReloadData" object:nil] subscribeNext:^(id x) {
            @strongify(self);
            [self.repairListArray removeAllObjects];
            [self.currentTableView reloadData];
            [self loadNewData];
        }];
        
        self.pushIndex = 1;
        refreshType = Down;
        currentPage = 1;
        self.repairState = state;
        self.isReacive = reacive;
        self.repairListArray = [NSMutableArray array];
        
        [self createUIWithFrame:frame];
        
        //请求
        [self loadNewData];
    }
    return self;
}

#pragma mark -
#pragma mark - createUI
- (void)createUIWithFrame:(CGRect)frame
{
    repairBeginTime = @"";
    repairEndTime = @"";
    typeArray = [NSMutableArray arrayWithObjects:@"类型", @"日常工单", @"维保工单", nil];
    stateArray = [NSMutableArray arrayWithObjects:@"状态", @"全部", @"已接单", @"维修中", @"待确认", @"待评价", @"已完成", @"未修好", nil];
    areasArray = [NSMutableArray arrayWithObjects:@"位置", nil];
    timesArray = [NSMutableArray arrayWithObjects:@"时间",@"1天",@"2天",@"3天",@"1周",@"1个月",@"3个月", nil];
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    menu.layer.borderWidth = 0.5;
    menu.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    [self addSubview:menu];
    
    
    self.currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, frame.size.width, frame.size.height-44) style:UITableViewStyleGrouped];
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    @weakify(self);
    _currentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadNewData];
    }];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    _currentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置了底部inset
    _currentTableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    // 忽略掉底部inset
    _currentTableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
    _currentTableView.mj_footer.ignoredScrollViewContentInsetBottom = 40.f;
    _currentTableView.emptyDataSetSource = self;
    _currentTableView.emptyDataSetDelegate = self;
    _currentTableView.delegate = self;
    _currentTableView.dataSource = self;
    [self addSubview:_currentTableView];
}

#pragma mark -
#pragma mark - loadData
- (void)loadNewData
{
    if (_isRequesting) return;
    refreshType = Down;
    currentPage = 1;
    
    [self showLoadingMBP:@"努力加载中..."];
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**获取报修列表**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request repairsList:_repairState
                     andPage:1
         andIsMaintenanceMan:[BXTGlobal shareGlobal].isRepair ? YES : NO
        andRepairerIsReacive:_repairState];
        _isRequesting = YES;
    });
    dispatch_async(concurrentQueue, ^{
        /**请求位置**/
        BXTDataRequest *location_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [location_request shopLocation];
    });
}

- (void)loadMoreData
{
    if (_isRequesting) return;
    refreshType = Up;
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairsList:_repairState
                 andPage:currentPage
     andIsMaintenanceMan:[BXTGlobal shareGlobal].isRepair ? YES : NO
    andRepairerIsReacive:_repairState];
    _isRequesting = YES;
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
        return typeArray.count;
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
        return typeArray[indexPath.row];
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
                      andTaskType:self.repairState];
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
    NSString *fault_type_id = [NSString stringWithFormat:@"%ld", selectFaultType];
    
    [self showLoadingMBP:@"努力加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairerList:@"1"
                  andPage:1
                 andPlace:place_id
            andDepartment:department_id
             andBeginTime:repairBeginTime
               andEndTime:repairEndTime
             andFaultType:fault_type_id
              andTaskType:self.repairState];
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
    return 140;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _repairListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTMainTableViewCell *cell = [BXTMainTableViewCell cellWithTableView:tableView];
    
    BXTRepairInfo *repairInfo = [_repairListArray objectAtIndex:indexPath.section];
    
    cell.orderNumView.text = [NSString stringWithFormat:@"编号:%@", repairInfo.orderid];
    cell.orderTypeView.text = @"日常";
    cell.orderGroupView.text = [NSString stringWithFormat:@"%@  ", repairInfo.subgroup_name];
    cell.orderStateView.text = [NSString stringWithFormat:@"%@", repairInfo.repairstate_name];
    
    cell.firstView.text = [NSString stringWithFormat:@"时间：%@", repairInfo.fault_time_name];
    cell.secondView.text = [NSString stringWithFormat:@"项目：%@", repairInfo.faulttype_name];
    cell.thirdView.text = [NSString stringWithFormat:@"位置：%@", repairInfo.place_name];
    cell.forthView.text = [NSString stringWithFormat:@"内容：%@", repairInfo.cause];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTRepairInfo *repairInfo = [_repairListArray objectAtIndex:indexPath.section];
#pragma mark -
#pragma mark -  修改下
//    if ([BXTGlobal shareGlobal].isRepair && [repairInfo.order_type integerValue] == 3)
//    {
//        [BXTGlobal showText:@"特殊工单不可点击" view:self completionBlock:nil];
//    }
//    else
//    {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
//        BXTMaintenanceDetailViewController *repairDetailVC = (BXTMaintenanceDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTMaintenanceDetailViewController"];
//        [repairDetailVC dataWithRepairID:repairInfo.repairID];
//        [[self navigation] pushViewController:repairDetailVC animated:YES];
//    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
#pragma mark 请求返回代理
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideTheMBP];
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    
    if (type == ShopType)
    {
        [areasArray addObjectsFromArray:[BXTFloorInfo mj_objectArrayWithKeyValuesArray:data]];
    }
    else if (type == RepairList)
    {
        if (data.count > 0)
        {
            [BXTRepairInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"repairID":@"id"};
            }];
            NSMutableArray *tempArray = [NSMutableArray array];
            NSArray *repairs = [BXTRepairInfo mj_objectArrayWithKeyValuesArray:data];
            [tempArray addObjectsFromArray:repairs];
            
            if (refreshType == Down)
            {
                [_repairListArray removeAllObjects];
                [_repairListArray addObjectsFromArray:tempArray];
            }
            else if (refreshType == Up)
            {
                [_repairListArray addObjectsFromArray:[[tempArray reverseObjectEnumerator] allObjects]];
            }
            currentPage++;
            [_currentTableView reloadData];
            if (!IS_IOS_8)
            {
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self.currentTableView reloadData];
                });
            }
        }
        _isRequesting = NO;
        [_currentTableView.mj_header endRefreshing];
        [_currentTableView.mj_footer endRefreshing];
    }
}

- (void)requestError:(NSError *)error
{
    [self hideTheMBP];
    _isRequesting = NO;
    [_currentTableView.mj_header endRefreshing];
    [_currentTableView.mj_footer endRefreshing];
}

@end
