//
//  BXTReaciveOrdersViewController.m
//  BXT
//
//  Created by Jason on 15/9/16.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTReaciveOrdersViewController.h"
#import "BXTHeaderForVC.h"
#import "DOPDropDownMenu.h"
#import "BXTRepairInfo.h"
#import "BXTSubgroup.h"
#import "BXTPlace.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BXTMaintenanceDetailViewController.h"
#import <MJRefresh.h>

#import "BXTMainTableViewCell.h"

@interface BXTReaciveOrdersViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource,BXTDataResponseDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
{
    // 筛选数组
    NSMutableArray *groupArray;
    NSMutableArray *stateArray;
    NSMutableArray *areasArray;
    NSMutableArray *timesArray;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *ordersArray;

@property (nonatomic, copy) NSString *taskType;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, copy) NSString *filterOfGroupID;
@property (nonatomic, copy) NSString *filterOfStateDaily;
@property (nonatomic, copy) NSString *filterOfAreasID;
@property (nonatomic, copy) NSString *filterOfTimeBegain;
@property (nonatomic, copy) NSString *filterOfTimeEnd;

// 维保
@property (nonatomic, copy) NSString *filterOfStateInspection;

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
    
    if ([_taskType integerValue] == 1)
    {
        [self navigationSetting:@"日常工单" andRightTitle:nil andRightImage:nil];
    }
    else
    {
        [self navigationSetting:@"维保工单" andRightTitle:nil andRightImage:nil];
    }
    
    self.filterOfGroupID = @"";
    self.filterOfStateDaily = @"";
    self.filterOfAreasID = @"";
    self.filterOfTimeBegain = @"";
    self.filterOfTimeEnd = @"";
    
    self.filterOfStateInspection = @"";
    
    [self resignNotifacation];
    [self createDOP];
    [self createTableView];
    [self requestData];
}

- (void)getResource
{
    [self showLoadingMBP:@"努力加载中..."];
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request listOfRepairOrderWithTaskType:self.taskType
                                   faultID:@""
                               faulttypeID:@""
                                     order:@""
                               dispatchUid:@""
                                 repairUid:@""
                              dailyTimeout:self.filterOfStateDaily
                         inspectionTimeout:self.filterOfStateInspection
                                  timeName:@"fault_time"
                                  tmeStart:self.filterOfTimeBegain
                                  timeOver:self.filterOfTimeEnd
                                subgroupID:self.filterOfGroupID
                                   placeID:self.filterOfAreasID
                               repairState:@""
                                     state:@""
                         faultCarriedState:@""
                        repairCarriedState:@""
                                      page:self.currentPage];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createDOP
{
    groupArray = [NSMutableArray arrayWithObjects:@"分组", nil];
    if ([_taskType integerValue] == 1) {
        stateArray = [NSMutableArray arrayWithObjects:@"状态", @"正常工单", @"超时工单", nil];
    }
    else {
        stateArray = [NSMutableArray arrayWithObjects:@"状态", @"未到期", @"即将到期", @"已过期", nil];
    }
    areasArray = [NSMutableArray arrayWithObjects:@"位置", nil];
    timesArray = [NSMutableArray arrayWithObjects:@"时间",@"今天",@"3天内",@"7天内",@"本月",@"本年", nil];
    
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
}

- (void)createTableView
{
    self.ordersArray = [[NSMutableArray alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:UITableViewStyleGrouped];
    self.tableView.rowHeight = 140.f;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark 事件处理
- (void)resignNotifacation
{
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReaciveOrderSuccess" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)requestData
{
    [self showLoadingMBP:@"努力加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**获取报修列表**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request listOfRepairOrderWithTaskType:self.taskType
                                       faultID:@""
                                   faulttypeID:@""
                                         order:@""
                                   dispatchUid:@""
                                     repairUid:@""
                                  dailyTimeout:@""
                             inspectionTimeout:@""
                                      timeName:@"fault_time"
                                      tmeStart:@""
                                      timeOver:@""
                                    subgroupID:@""
                                       placeID:@""
                                   repairState:@""
                                         state:@""
                             faultCarriedState:@""
                            repairCarriedState:@""
                                          page:1];
    });
    dispatch_async(concurrentQueue, ^{
        /**请求位置**/
        BXTDataRequest *location_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [location_request listOFPlaceIsAllPlace:NO];
    });
    dispatch_async(concurrentQueue, ^{
        /**请求故障类型列表**/
        BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [fau_request listOFSubgroup];
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
        BXTSubgroup *subgroup = groupArray[indexPath.row];
        return subgroup.subgroup;
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
        BXTPlace *lists = place.lists[indexPath.item];
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
            BXTPlace *lists = place.lists[indexPath.item];
            self.filterOfAreasID = lists.placeID;
        }
    }
    else
    {
        // 分组
        if (indexPath.column == 0)
        {
            if (indexPath.row == 0) {
                self.filterOfGroupID = @"";
            }
            else {
                BXTSubgroup *subgroup = groupArray[indexPath.row];
                self.filterOfGroupID = subgroup.subgroupID;
            }
        }
        // 状态
        else if (indexPath.column == 1)
        {
            if ([_taskType integerValue] == 1)
            {
                switch (indexPath.row) {
                    case 0: self.filterOfStateDaily = @""; break;
                    case 1: self.filterOfStateDaily = @"2"; break;
                    case 2: self.filterOfStateDaily = @"1"; break;
                    default: break;
                }
            }
            else
            {
                switch (indexPath.row) {
                    case 0: self.filterOfStateInspection = @""; break;
                    case 1: self.filterOfStateInspection = @"3"; break;
                    case 2: self.filterOfStateInspection = @"2"; break;
                    case 3: self.filterOfStateInspection = @"1"; break;
                    default: break;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BXTRepairInfo *repairInfo = [self.ordersArray objectAtIndex:indexPath.section];
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
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    
    if (type == RepairList)
    {
        [self hideMBP];
        
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
        [areasArray addObjectsFromArray:[BXTPlace mj_objectArrayWithKeyValuesArray:data]];
    }
    else if (type == SubgroupLists)
    {
        [BXTSubgroup mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"subgroupID":@"id"};
        }];
        [groupArray addObjectsFromArray:[BXTSubgroup mj_objectArrayWithKeyValuesArray:data]];
    }
    
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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
