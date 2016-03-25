//
//  BXTOrderListView.m
//  BXT
//
//  Created by Jason on 15/9/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTOrderListView.h"
#import "BXTDataRequest.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BXTRepairTableViewCell.h"
#import "BXTHeaderForVC.h"
#import "BXTRepairInfo.h"
#import <MJRefresh.h>
#import "UIView+Nav.h"
#import "BXTMaintenanceDetailViewController.h"
#import "BXTMaintenanceProcessViewController.h"
#import "AppDelegate.h"
#import "BXTEvaluationViewController.h"
#import "DOPDropDownMenu.h"
#import "BXTMainTableViewCell.h"
#import "BXTPlace.h"

@interface BXTOrderListView () <DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    // 筛选数组
    NSMutableArray    *groupArray;
    NSMutableArray    *stateArray;
    NSMutableArray    *areasArray;
    NSMutableArray    *timesArray;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *ordersArray;

/**
 *  工单状态 - stateStr  2进行中  1已完成
 */
@property (nonatomic, copy) NSString *stateStr;
/**
 *  我的维修工单 - isRepair == YES
 */
@property (nonatomic, assign) BOOL isRepair;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, copy) NSString *filterOfTaskType;
@property (nonatomic, copy) NSString *filterOfRepairState;
// 指派中
@property (nonatomic, copy) NSString *filterOfDispatchUID;
@property (nonatomic, copy) NSString *filterOfState;
@property (nonatomic, copy) NSString *filterOfAreasID;
@property (nonatomic, copy) NSString *filterOfTimeBegain;
@property (nonatomic, copy) NSString *filterOfTimeEnd;

// 我的维修列表
@property (nonatomic, copy) NSString *filterOfRepairUID;
// 我的报修列表
@property (nonatomic, copy) NSString *filterOfFaultID;


@end

@implementation BXTOrderListView

- (instancetype)initWithFrame:(CGRect)frame andState:(NSString *)state andIsRepair:(BOOL)isRepair
{
    self = [super initWithFrame:frame];
    if (self)
    {
        @weakify(self);
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReloadData" object:nil] subscribeNext:^(id x) {
            @strongify(self);
            [self.ordersArray removeAllObjects];
            [self.tableView reloadData];
        }];
        
        
        self.stateStr = state;
        self.isRepair = isRepair;
        NSLog(@"%@ ----- %d", state, isRepair);
        
        [self createUIWithFrame:frame];
        
        [self requestData];
    }
    return self;
}

#pragma mark -
#pragma mark - createUI
- (void)createUIWithFrame:(CGRect)frame
{
    self.ordersArray = [[NSMutableArray alloc] init];
    self.filterOfTaskType = @"";
    self.filterOfRepairState = @"";
    self.filterOfDispatchUID = @"";
    self.filterOfState = @"";
    self.filterOfAreasID = @"";
    self.filterOfTimeBegain = @"";
    self.filterOfTimeEnd = @"";
    
    self.filterOfRepairUID = @"";
    self.filterOfFaultID = @"";
    if (self.isRepair) {
        self.filterOfRepairUID = @"31";
    } else {
        self.filterOfFaultID = @"31";
    }
    
    
    
    // 我的维修工单 - isRepair == YES
    if (self.isRepair) {
        // 工单状态 - stateStr  2进行中  1已完成
        if ([self.stateStr intValue] == 2) {
            stateArray = [NSMutableArray arrayWithObjects:@"状态", @"已接单", @"指派中", @"维修中", @"待确认", nil];
        }
        else {
            stateArray = [NSMutableArray arrayWithObjects:@"状态", @"未修好", nil];
        }
    }
    else {
        if ([self.stateStr intValue] == 2) {
            stateArray = [NSMutableArray arrayWithObjects:@"状态", @"待维修", @"维修中", @"待确认", nil];
        }
        else {
            stateArray = [NSMutableArray arrayWithObjects:@"状态", @"待评价", @"已评价", @"未修好", @"已修好", nil];
        }
    }
    
    groupArray = [NSMutableArray arrayWithObjects:@"类型", @"日常工单", @"维保工单", nil];
    areasArray = [NSMutableArray arrayWithObjects:@"位置", nil];
    timesArray = [NSMutableArray arrayWithObjects:@"时间",@"今天",@"3天内",@"7天内",@"本月",@"本年", nil];
    
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    menu.layer.borderWidth = 0.5;
    menu.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    [self addSubview:menu];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, frame.size.width, frame.size.height-44) style:UITableViewStyleGrouped];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
}

#pragma mark -
#pragma mark - requestData
- (void)requestData
{
    [self showLoadingMBP:@"努力加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**获取报修列表**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request listOfRepairOrderWithTaskType:self.filterOfTaskType
                                       FaultID:self.filterOfFaultID
                                   FaulttypeID:@""
                                         Order:@""
                                   DispatchUid:@""
                                     RepairUid:self.filterOfRepairUID
                                  DailyTimeout:@""
                             InspectionTimeout:@""
                                      TimeName:@"fault_time"
                                      TmeStart:@""
                                      TimeOver:@""
                                    SubgroupID:@""
                                       PlaceID:@""
                                   RepairState:@""
                                         State:@""
                                          Page:1];
    });
    dispatch_async(concurrentQueue, ^{
        /**请求位置**/
        BXTDataRequest *location_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [location_request listOFPlace];
    });
    
    
    self.currentPage = 1;
    __block __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf getResource];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf getResource];
    }];
}

- (void)getResource
{
    [self showLoadingMBP:@"努力加载中..."];
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request listOfRepairOrderWithTaskType:self.filterOfTaskType
                                   FaultID:self.filterOfFaultID
                               FaulttypeID:@""
                                     Order:@""
                               DispatchUid:self.filterOfDispatchUID
                                 RepairUid:self.filterOfRepairUID
                              DailyTimeout:@""
                         InspectionTimeout:@""
                                  TimeName:@"fault_time"
                                  TmeStart:self.filterOfTimeBegain
                                  TimeOver:self.filterOfTimeEnd
                                SubgroupID:@""
                                   PlaceID:self.filterOfAreasID
                               RepairState:self.filterOfRepairState
                                     State:self.filterOfState
                                      Page:self.currentPage];
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
        return groupArray[indexPath.row];
    }
    else if (indexPath.column == 1)
    {
        return stateArray[indexPath.row];
    }
    else if (indexPath.column == 2)
    {
        if (indexPath.row == 0) return areasArray[0];
        BXTPlace *place = areasArray[indexPath.row];
        return place.place;
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
        BXTPlace *place = areasArray[row];
        return place.lists.count;
    }
    
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 2)
    {
        if (indexPath.row == 0 || indexPath.row > areasArray.count - 1) return nil;
        BXTPlace *place = areasArray[indexPath.row];
        Lists *lists = place.lists[indexPath.item];
        return lists.place;
    }
    
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    //判断有无二级菜单
    if (indexPath.item >= 0)
    {
        // 位置
        if (indexPath.column == 2)
        {
            BXTPlace *place = areasArray[indexPath.row];
            Lists *lists = place.lists[indexPath.item];
            self.filterOfAreasID = lists.subPlaceID;
        }
    }
    else
    {
        // 分组
        if (indexPath.column == 0)
        {
            switch (indexPath.row) {
                case 0: self.filterOfTaskType = @""; break;
                case 1: self.filterOfTaskType = @"1"; break;
                case 2: self.filterOfTaskType = @"2"; break;
                default: break;
            }
        }
        // 状态
        else if (indexPath.column == 1)
        {
            // 我的维修工单 - isRepair == YES
            if (self.isRepair) {
                // 工单状态 - stateStr  2进行中  1已完成
                if ([self.stateStr intValue] == 2) {
                    // 参数归零 - 防止同时赋值
                    self.filterOfRepairState = @"";
                    self.filterOfDispatchUID = @"";
                    
                    switch (indexPath.row) {
                        case 0: self.filterOfRepairState = @""; break;
                        case 1: self.filterOfRepairState = @"2"; break;
                        case 2: self.filterOfDispatchUID = @"31"; break;
                        case 3: self.filterOfRepairState = @"3"; break;
                        case 4: self.filterOfRepairState = @"4"; break;
                        default: break;
                    }
                }
                else {
                    switch (indexPath.row) {
                        case 0: self.filterOfState = @""; break;
                        case 1: self.filterOfState = @"2"; break;
                        default: break;
                    }
                }
            }
            else {
                if ([self.stateStr intValue] == 2) {
                    switch (indexPath.row) {
                        case 0: self.filterOfRepairState = @""; break;
                        case 1: self.filterOfRepairState = @"2"; break;
                        case 2: self.filterOfRepairState = @"3"; break;
                        case 3: self.filterOfRepairState = @"4"; break;
                        default: break;
                    }
                }
                else {
                    // 参数归零 - 防止同时赋值
                    self.filterOfRepairState = @"";
                    self.filterOfState = @"";
                    
                    switch (indexPath.row) {
                        case 0: self.filterOfRepairState = @""; break;
                        case 1: self.filterOfRepairState = @"5"; break;
                        case 2: self.filterOfRepairState = @"6"; break;
                        case 3: self.filterOfState = @"2"; break;
                        case 4: self.filterOfState = @"1"; break;
                        default: break;
                    }
                }
            }
        }
        else if (indexPath.column == 2)
        {
            if (!indexPath.row) {
                self.filterOfAreasID = @"";
            }
            
        }
        //时间
        else if (indexPath.column == 3)
        {
            switch (indexPath.row) {
                case 0: {
                    self.filterOfTimeBegain = @"";
                    self.filterOfTimeEnd = @"";
                } break;
                case 1: {
                    [self transTimeToWhatWeNeed:[BXTGlobal dayStartAndEnd]];
                } break;
                case 2: {
                    [self transTimeToWhatWeNeed:[BXTGlobal dayOfCountStartAndEnd:3]];
                } break;
                case 3: {
                    [self transTimeToWhatWeNeed:[BXTGlobal dayOfCountStartAndEnd:7]];
                } break;
                case 4: {
                    [self transTimeToWhatWeNeed:[BXTGlobal monthStartAndEnd]];
                } break;
                case 5: {
                    [self transTimeToWhatWeNeed:[BXTGlobal yearStartAndEnd]];
                } break;
                default: break;
            }
        }
    }
    
    self.currentPage = 1;
    [self getResource];
}

- (void)transTimeToWhatWeNeed:(NSArray *)timeArray
{
    NSString *begainTime = [NSString stringWithFormat:@"%@ 00:00:00", timeArray[0]];
    NSString *endTime = [NSString stringWithFormat:@"%@ 23:59:59", timeArray[1]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *begainDate = [dateFormatter dateFromString:begainTime];
    self.filterOfTimeBegain = [NSString stringWithFormat:@"%ld", (long)[begainDate timeIntervalSince1970]];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    self.filterOfTimeEnd = [NSString stringWithFormat:@"%ld", (long)[endDate timeIntervalSince1970]];
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
    return self.ordersArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTMainTableViewCell *cell = [BXTMainTableViewCell cellWithTableView:tableView];
    
    cell.repairInfo = self.ordersArray[indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTRepairInfo *repairInfo = [self.ordersArray objectAtIndex:indexPath.section];
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
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    
    if (type == RepairList)
    {
        if (self.currentPage == 1 && self.ordersArray.count != 0)
        {
            [self.ordersArray removeAllObjects];
        }
        
        if (data.count)
        {
            [BXTRepairInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"repairID":@"id"};
            }];
            NSArray *repairs = [BXTRepairInfo mj_objectArrayWithKeyValuesArray:data];
            [self.ordersArray addObjectsFromArray:repairs];
        }
        [self.tableView reloadData];
        
    }
    else if (type == PlaceLists)
    {
        [BXTPlace mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"placeID": @"id"};
        }];
        [Lists mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"subPlaceID": @"id"};
        }];
        [areasArray addObjectsFromArray:[BXTPlace mj_objectArrayWithKeyValuesArray:data]];
    }
    
}

- (void)requestError:(NSError *)error
{
    [self hideTheMBP];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

@end
