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
#import "BXTSubgroupInfo.h"
#import "BXTPlaceInfo.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BXTMaintenanceDetailViewController.h"
#import <MJRefresh.h>
#import "ANKeyValueTable.h"
#import "BXTMainTableViewCell.h"


@interface BXTReaciveOrdersViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource,BXTDataResponseDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
{
    // 筛选数组
    NSMutableArray *groupArray;
    NSMutableArray *stateArray;
    NSMutableArray *areasArray;
    NSMutableArray *timesArray;
}

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *ordersArray;
@property (nonatomic, copy  ) NSString       *taskType;
@property (nonatomic, assign) NSInteger      currentPage;
@property (nonatomic, copy  ) NSString       *filterOfGroupID;
@property (nonatomic, copy  ) NSString       *filterOfStateDaily;
@property (nonatomic, copy  ) NSString       *filterOfAreasID;
@property (nonatomic, copy  ) NSString       *filterOfTimeBegain;
@property (nonatomic, copy  ) NSString       *filterOfTimeEnd;
// 维保
@property (nonatomic, copy  ) NSString       *filterOfStateInspection;

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
    [self showLoadingMBP:@"加载中..."];
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request listOfRepairOrderWithTaskType:self.taskType
                            repairListType:OtherList
                               faulttypeID:@""
                                     order:@""
                               dispatchUid:@""
                              dailyTimeout:self.filterOfStateDaily
                         inspectionTimeout:self.filterOfStateInspection
                                  timeName:@"fault_time"
                                  tmeStart:self.filterOfTimeBegain
                                  timeOver:self.filterOfTimeEnd
                                subgroupID:self.filterOfGroupID
                                   placeID:self.filterOfAreasID
                               repairState:@"1"
                                     state:@""
                         faultCarriedState:@""
                        repairCarriedState:@""
                              collectionID:@""
                                  deviceID:@""
                                      page:self.currentPage
                                closeState:@"1"];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createDOP
{
    groupArray = [NSMutableArray arrayWithObjects:@"分组", nil];
    if ([_taskType integerValue] == 1)
    {
        stateArray = [NSMutableArray arrayWithObjects:@"状态", @"正常工单", @"超时工单", nil];
    }
    else
    {
        stateArray = [NSMutableArray arrayWithObjects:@"状态", @"未到期", @"即将到期", @"已过期", nil];
    }
    areasArray = [NSMutableArray arrayWithObjects:@"位置", nil];
    [areasArray addObjectsFromArray:[[ANKeyValueTable userDefaultTable] valueWithKey:YPLACESAVE]];
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
        self.currentPage = 1;
        [self requestData];
    }];
}

- (void)requestData
{
    [self showLoadingMBP:@"加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**获取报修列表**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request listOfRepairOrderWithTaskType:self.taskType
                                repairListType:OtherList
                                   faulttypeID:@""
                                         order:@""
                                   dispatchUid:@""
                                  dailyTimeout:@""
                             inspectionTimeout:@""
                                      timeName:@"fault_time"
                                      tmeStart:@""
                                      timeOver:@""
                                    subgroupID:@""
                                       placeID:@""
                                   repairState:@"1"
                                         state:@""
                             faultCarriedState:@""
                            repairCarriedState:@""
                                  collectionID:@""
                                      deviceID:@""
                                          page:1
                                    closeState:@"1"];
    });
    dispatch_async(concurrentQueue, ^{
        /**请求故障类型列表**/
        BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
        BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
        [fau_request listOFSubgroupShopID:companyInfo.company_id];
    });
    
    
    self.currentPage = 1;
    __weak __typeof(self) weakSelf = self;
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
        BXTSubgroupInfo *subgroup = groupArray[indexPath.row];
        return subgroup.subgroup;
    }
    else if (indexPath.column == 1)
    {
        return stateArray[indexPath.row];
    }
    else if (indexPath.column == 2)
    {
        if (indexPath.row == 0) return areasArray[0];
        BXTPlaceInfo *place = areasArray[indexPath.row];
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
        BXTPlaceInfo *place = areasArray[row];
        return place.lists.count;
    }
    
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 2)
    {
        if (indexPath.row == 0 || indexPath.row > areasArray.count - 1) return nil;
        BXTPlaceInfo *place = areasArray[indexPath.row];
        BXTPlaceInfo *lists = place.lists[indexPath.item];
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
            BXTPlaceInfo *place = areasArray[indexPath.row];
            BXTPlaceInfo *lists = place.lists[indexPath.item];
            self.filterOfAreasID = lists.placeID;
        }
    }
    else
    {
        // 分组
        if (indexPath.column == 0)
        {
            if (indexPath.row == 0)
            {
                self.filterOfGroupID = @"";
            }
            else
            {
                BXTSubgroupInfo *subgroup = groupArray[indexPath.row];
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
            if (!indexPath.row)
            {
                self.filterOfAreasID = @"";
            }
        }
        //时间
        else if (indexPath.column == 3)
        {
            NSMutableArray *allTimeArray = [[NSMutableArray alloc] init];
            switch (indexPath.row) {
                case 0: {
                    allTimeArray = (NSMutableArray *)@[@"", @""];
                } break;
                case 1: {
                    allTimeArray = (NSMutableArray *)[BXTGlobal transTimeToWhatWeNeed:[BXTGlobal dayStartAndEnd]];
                } break;
                case 2: {
                    allTimeArray = (NSMutableArray *)[BXTGlobal transTimeToWhatWeNeed:[BXTGlobal dayOfCountStartAndEnd:3]];
                } break;
                case 3: {
                    allTimeArray = (NSMutableArray *)[BXTGlobal transTimeToWhatWeNeed:[BXTGlobal dayOfCountStartAndEnd:7]];
                } break;
                case 4: {
                    allTimeArray = (NSMutableArray *)[BXTGlobal transTimeToWhatWeNeed:[BXTGlobal monthStartAndEnd]];
                } break;
                case 5: {
                    allTimeArray = (NSMutableArray *)[BXTGlobal transTimeToWhatWeNeed:[BXTGlobal yearStartAndEnd]];
                } break;
                default: break;
            }
            
            self.filterOfTimeBegain = allTimeArray[0];
            self.filterOfTimeEnd = allTimeArray[1];
        }
    }
    
    
    self.currentPage = 1;
    [self getResource];
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
    SceneType sceneType = [self.taskType integerValue] == 1 ? DailyType : MaintainType;
    [repairDetailVC dataWithRepairID:repairInfo.repairID sceneType:sceneType];
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
        if (self.currentPage == 1 && self.ordersArray.count > 0)
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
    //    else if (type == PlaceLists)
    //    {
    //        [BXTPlaceInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
    //            return @{@"placeID": @"id"};
    //        }];
    //
    //    }
    else if (type == SubgroupLists)
    {
        [BXTSubgroupInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"subgroupID":@"id"};
        }];
        [groupArray addObjectsFromArray:[BXTSubgroupInfo mj_objectArrayWithKeyValuesArray:data]];
    }
    
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
