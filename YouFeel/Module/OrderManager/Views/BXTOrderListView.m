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
#import "BXTRepairDetailViewController.h"
#import "UIView+Nav.h"
#import "BXTMaintenanceManTableViewCell.h"
#import "BXTOrderDetailViewController.h"
#import "BXTMaintenanceProcessViewController.h"

@implementation BXTOrderListView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame andState:(NSString *)state andListViewType:(ListViewType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAllData) name:@"ReloadData" object:nil];
        
        refreshType = Down;
        self.viewType = type;
        currentPage = 1;
        self.isRequesting = NO;
        self.repairState = state;
        repairListArray = [NSMutableArray array];

        currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStyleGrouped];
        __weak __typeof(self) weakSelf = self;
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        currentTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadNewData];
        }];
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        currentTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        // 设置了底部inset
        currentTableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        // 忽略掉底部inset
        currentTableView.footer.ignoredScrollViewContentInsetBottom = 30;
        currentTableView.footer.ignoredScrollViewContentInsetBottom = 40.f;
        if (_viewType == RepairViewType)
        {
            [currentTableView registerClass:[BXTRepairTableViewCell class] forCellReuseIdentifier:@"OrderListCell"];
        }
        else if (_viewType == MaintenanceManViewType)
        {
            [currentTableView registerClass:[BXTMaintenanceManTableViewCell class] forCellReuseIdentifier:@"OrderListCell"];
        }
        currentTableView.delegate = self;
        currentTableView.dataSource = self;
        [self addSubview:currentTableView];
        //请求
        [self loadNewData];
    }
    return self;
}

- (void)reloadAllData
{
    [repairListArray removeAllObjects];
    [self loadNewData];
}

- (void)loadNewData
{
    if (_isRequesting) return;
    refreshType = Down;
    currentPage = 1;
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairList:_repairState andPage:1 andIsMaintenanceMan:_viewType == MaintenanceManViewType ? YES : NO];
}

- (void)loadMoreData
{
    if (_isRequesting) return;
    refreshType = Up;
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairList:_repairState andPage:currentPage andIsMaintenanceMan:_viewType == MaintenanceManViewType ? YES : NO];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
//section头部间距
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
    if (_viewType == MaintenanceManViewType)
    {
        return 175.f;
    }
    return 236.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return repairListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_viewType == RepairViewType)
    {
        BXTRepairTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        BXTRepairInfo *repairInfo = [repairListArray objectAtIndex:indexPath.section];
        cell.repairID.text = [NSString stringWithFormat:@"工单号:%@",repairInfo.orderid];
        cell.time.text = repairInfo.repair_time;
        cell.place.text = [NSString stringWithFormat:@"位置:%@",repairInfo.area];
        cell.name.text = [NSString stringWithFormat:@"报修人:%@",repairInfo.fault];
        cell.cause.text = [NSString stringWithFormat:@"故障描述:%@",repairInfo.faulttype_name];
        NSString *str;
        NSRange range;
        if (repairInfo.urgent == 2)
        {
            str = @"等级:一般";
            range = [str rangeOfString:@"一般"];
        }
        else if (repairInfo.urgent == 1)
        {
            str = @"等级:紧急";
            range = [str rangeOfString:@"紧急"];
        }
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
        cell.level.attributedText = attributeStr;
        
        cell.state.text = repairInfo.receive_state;
        cell.repairState.text = repairInfo.workprocess;
        
        cell.tag = indexPath.section;
        [cell.cancelRepair setTitle:@"联系Ta" forState:UIControlStateNormal];
        if (repairInfo.repairstate == 1)
        {
            [cell.cancelRepair setTitleColor:colorWithHexString(@"e2e6e8") forState:UIControlStateNormal];
            cell.cancelRepair.userInteractionEnabled = NO;
        }
        else
        {
            [cell.cancelRepair setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            cell.cancelRepair.userInteractionEnabled = YES;
        }
        return cell;
    }
    else
    {
        BXTMaintenanceManTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        BXTRepairInfo *repairInfo = [repairListArray objectAtIndex:indexPath.section];
        cell.repairID.text = [NSString stringWithFormat:@"工单号:%@",repairInfo.orderid];
        cell.time.text = [NSString stringWithFormat:@"响应时间:%@",repairInfo.repair_time];
        cell.place.text = [NSString stringWithFormat:@"位置:%@",repairInfo.area];
        cell.cause.text = [NSString stringWithFormat:@"故障描述:%@",repairInfo.faulttype_name];
        NSString *str;
        NSRange range;
        if (repairInfo.urgent == 2)
        {
            str = @"等级:一般";
            range = [str rangeOfString:@"一般"];
        }
        else if (repairInfo.urgent == 1)
        {
            str = @"等级:紧急";
            range = [str rangeOfString:@"紧急"];
        }
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
        cell.level.attributedText = attributeStr;
        cell.tag = indexPath.section;
        if (repairInfo.repairstate == 1)
        {
            [cell.maintenanceProcess setTitleColor:colorWithHexString(@"e2e6e8") forState:UIControlStateNormal];
            cell.maintenanceProcess.userInteractionEnabled = NO;
        }
        else
        {
            [cell.maintenanceProcess setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            cell.maintenanceProcess.userInteractionEnabled = YES;
        }
        cell.maintenanceProcess.tag = indexPath.section;
        [cell.maintenanceProcess addTarget:self action:@selector(maintenanceProcessClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTRepairInfo *repairInfo = [repairListArray objectAtIndex:indexPath.section];
    if (_viewType == RepairViewType)
    {
        BXTRepairDetailViewController *repairDetail = [[BXTRepairDetailViewController alloc] initWithRepair:repairInfo];
        [[self navigation] pushViewController:repairDetail animated:YES];
    }
    else
    {
        BXTOrderDetailViewController *repairDetailVC = [[BXTOrderDetailViewController alloc] initWithRepairID:[NSString stringWithFormat:@"%ld",(long)repairInfo.repairID]];
        [[self navigation] pushViewController:repairDetailVC animated:YES];
    }
}

- (void)maintenanceProcessClick:(UIButton *)btn
{
    BXTRepairInfo *repairInfo = [repairListArray objectAtIndex:btn.tag];
    BXTMaintenanceProcessViewController *maintenanceProcossVC = [[BXTMaintenanceProcessViewController alloc] initWithCause:repairInfo.faulttype_name andCurrentFaultID:repairInfo.fault_id andRepairID:repairInfo.repairID andReaciveTime:repairInfo.receive_time];
    [self.navigation pushViewController:maintenanceProcossVC animated:YES];
}

#pragma mark -
#pragma mark 请求返回代理
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    if (data.count > 0)
    {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dictionary in data)
        {
            DCParserConfiguration *config = [DCParserConfiguration configuration];
            DCObjectMapping *map = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"repairID" onClass:[BXTRepairInfo class]];
            [config addObjectMapping:map];
            
            DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTRepairInfo class] andConfiguration:config];
            BXTRepairInfo *repairInfo = [parser parseDictionary:dictionary];
            
            [tempArray addObject:repairInfo];
        }
        if (refreshType == Down)
        {
            [repairListArray removeAllObjects];
            [repairListArray addObjectsFromArray:tempArray];
        }
        else if (refreshType == Up)
        {
            [repairListArray addObjectsFromArray:[[tempArray reverseObjectEnumerator] allObjects]];
        }
        currentPage++;
        [currentTableView reloadData];
    }
    
    [currentTableView.header endRefreshing];
    [currentTableView.footer endRefreshing];
}

- (void)requestError:(NSError *)error
{
    [currentTableView.header endRefreshing];
    [currentTableView.footer endRefreshing];
}

@end
