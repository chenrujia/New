//
//  BXTMaintenanceListViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMaintenanceListViewController.h"
#import "BXTMTFilterViewController.h"
#import "DOPDropDownMenu.h"
#import "BXTMTPlanListCell.h"
#import "BXTMTPlanList.h"
#import <MJRefresh.h>

@interface BXTMaintenanceListViewController () <DOPDropDownMenuDelegate, DOPDropDownMenuDataSource, UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *typeArray;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, copy) NSString *order;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;



@end

@implementation BXTMaintenanceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"全部维保任务" andRightTitle:@"  筛选" andRightImage:nil];
    
    self.typeArray = [[NSArray alloc] initWithObjects:@"时间逆序", @"时间正序", nil];
    self.dataArray = [[NSMutableArray alloc] init];
    self.currentPage = 1;
    self.order = @"desc";
    self.startTime = @"";
    self.endTime = @"";

    if (!self.subgroupIDs) {
        self.subgroupIDs = @"";
    }
    if (!self.faulttypeIDs) {
        self.faulttypeIDs = @"";
    }
    if (!self.stateStr) {
        self.stateStr = @"";
    }
    
    [self createUI];
}

- (void)navigationRightButton
{
    BXTMTFilterViewController *filterVC = [[BXTMTFilterViewController alloc] init];
    filterVC.delegateSignal = [RACSubject subject];
    [filterVC.delegateSignal subscribeNext:^(NSArray *transArray) {
        NSLog(@"transArray -= ---------- %@", transArray);
        self.startTime = transArray[0];
        self.endTime = transArray[1];
        self.subgroupIDs = transArray[2];
        self.faulttypeIDs = transArray[3];
        self.stateStr = transArray[4];
        
        self.currentPage = 1;
        [self getResource];
    }];
    [self.navigationController pushViewController:filterVC animated:YES];
}

- (void)getResource
{
    [self showLoadingMBP:@"数据加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request statisticsMTPlanListWithTimeStart:self.startTime TimeEnd:self.endTime SubgroupIDs:self.subgroupIDs FaulttypeTypeIDs:self.faulttypeIDs State:self.stateStr Order:self.order Pagesize:@"5" Page:[NSString stringWithFormat:@"%ld", (long)self.currentPage]];
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
    
    self.order = indexPath.row == 0 ? @"desc" : @"asc";
    
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
    BXTMTPlanListCell *cell = [BXTMTPlanListCell cellWithTableView:tableView];
    
    cell.planList = self.dataArray[indexPath.section];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    self.cellHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
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
    BXTMTPlanList *list = self.dataArray[indexPath.section];
    NSLog(@"%@", list.PlanID);
    
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
    if (type == Statistics_MTPlanList && data.count > 0)
    {
        for (NSDictionary *dataDict in data)
        {
            BXTMTPlanList *planModel = [BXTMTPlanList modelWithDict:dataDict];
            [self.dataArray addObject:planModel];
        }
        
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

- (void)requestError:(NSError *)error
{
    [self hideMBP];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
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
