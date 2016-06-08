//
//  BXTDailyOrderListViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/18.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTDailyOrderListViewController.h"
#import "DOPDropDownMenu.h"
#import "BXTDataRequest.h"
#import "UIScrollView+EmptyDataSet.h"
#import <MJRefresh.h>
#import "BXTMainTableViewCell.h"
#import "BXTRepairInfo.h"
#import "BXTDOFilterViewController.h"
#import "BXTMaintenanceDetailViewController.h"

@interface BXTDailyOrderListViewController () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource, UITableViewDelegate,BXTDataResponseDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *typeArray;

@property (nonatomic, copy) NSString *order;

/** ---- 专业分组 ---- */
@property (copy, nonatomic) NSString *transGroupStr;
/** ---- 工单状态 1未接单 2 待维修 3 维修中 4待确认 5待评价 6已评价 ---- */
@property (copy, nonatomic) NSString *transRepairStateStr;
/** ---- 未修好原因ID ---- */
@property (copy, nonatomic) NSString *transCollectionID;

@end

@implementation BXTDailyOrderListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"全部工单" andRightTitle:@"   筛选" andRightImage:nil];
    self.typeArray = [[NSArray alloc] initWithObjects:@"时间逆序", @"时间正序", nil];
    self.dataArray = [[NSMutableArray alloc] init];
    self.currentPage = 1;
    
    self.transGroupStr = @"";
    self.transRepairStateStr = @"";
    self.transCollectionID = @"";
    if (!self.transTimeArray)
    {
        self.transTimeArray = [[NSMutableArray alloc] initWithObjects:@"", @"", nil];
    }
    if (!self.transStateStr)
    {
        self.transStateStr = @"";
    }
    if (!self.transFaultCarriedState)
    {
        self.transFaultCarriedState = @"";
    }
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)navigationRightButton
{
    BXTDOFilterViewController *doFilterVC = [[BXTDOFilterViewController alloc] init];
    doFilterVC.delegateSignal = [RACSubject subject];
    [doFilterVC.delegateSignal subscribeNext:^(NSArray *transArray) {
        NSLog(@"transArray --- %@", transArray);
        self.transTimeArray = transArray[0];
        self.transGroupStr = transArray[1];
        
        NSArray *stateArray = transArray[2];
        self.transStateStr = stateArray[0];
        self.transFaultCarriedState = transArray[1];
        
        if (transArray.count == 4)
        {
            self.transCollectionID = transArray[3];
        }
        [self getResource];
    }];
    [self.navigationController pushViewController:doFilterVC animated:YES];
}

- (void)getResource
{
    [self showLoadingMBP:@"数据加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request listOfRepairOrderWithTaskType:@"1"
                            repairListType:OtherList
                               faulttypeID:@""
                                     order:self.order
                               dispatchUid:@""
                              dailyTimeout:@""
                         inspectionTimeout:@""
                                  timeName:@"fault_time"
                                  tmeStart:self.transTimeArray[0]
                                  timeOver:self.transTimeArray[1]
                                subgroupID:self.transGroupStr
                                   placeID:@""
                               repairState:self.transRepairStateStr
                                     state:self.transStateStr
                         faultCarriedState:self.transFaultCarriedState
                        repairCarriedState:@""
                              collectionID:self.transCollectionID
                                  deviceID:@""
                                      page:self.currentPage
                                closeState:@"1"];
    
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, KNAVIVIEWHEIGHT) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    [menu selectDefalutIndexPath];
    
    // UITableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(menu.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(menu.frame)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
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
#pragma mark DOPDropDownMenuDataSource && DOPDropDownMenuDelegate
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    return self.typeArray.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return self.typeArray[indexPath.row];
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    self.currentPage = 1;
    
    self.order = indexPath.row == 0 ? @"2" : @"1";
    
    [self getResource];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTMainTableViewCell *cell = [BXTMainTableViewCell cellWithTableView:tableView];
    
    cell.repairInfo = self.dataArray[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTRepairInfo *repairInfo = self.dataArray[indexPath.section];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
    BXTMaintenanceDetailViewController *repairDetailVC = (BXTMaintenanceDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTMaintenanceDetailViewController"];
    SceneType sceneType = AllOrderType;
    [repairDetailVC dataWithRepairID:repairInfo.repairID sceneType:sceneType];
    [self.navigationController pushViewController:repairDetailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (self.currentPage == 1)
    {
        [self.dataArray removeAllObjects];
    }
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == RepairList && data.count > 0)
    {
        [BXTRepairInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"repairID":@"id"};
        }];
        NSArray *repairs = [BXTRepairInfo mj_objectArrayWithKeyValuesArray:data];
        [self.dataArray addObjectsFromArray:repairs];
        
        if (!IS_IOS_8)
        {
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.tableView reloadData];
            });
        }
    }
    [self.tableView reloadData];
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
