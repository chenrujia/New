//
//  BXTManagerOMView.m
//  YouFeel
//
//  Created by Jason on 15/11/26.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTManagerOMView.h"
#import "BXTHeaderForVC.h"
#import "BXTManagerOMTableViewCell.h"
#import "MJRefresh.h"
#import "BXTRepairInfo.h"
#import "BXTOrderDetailViewController.h"
#import "UIView+Nav.h"

@implementation BXTManagerOMView

- (instancetype)initWithFrame:(CGRect)frame andOrderType:(OrderType )order_type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.orderType = order_type;
        groupID = @"";
        BXTGroupingInfo *groupInfo = [BXTGlobal getUserProperty:U_GROUPINGINFO];
        if (groupInfo.subgroup.length > 0)
        {
            typesArray = @[@"时间排序",@"超时工单优先",@"特殊工单优先",@"本组优先"];
        }
        else
        {
            typesArray = @[@"时间排序",@"超时工单优先",@"特殊工单优先"];
        }
        repairListArray = [NSMutableArray array];
        priorityType = @"1";
        
        // 添加下拉菜单
        DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
        menu.delegate = self;
        menu.dataSource = self;
        [self addSubview:menu];
        
        currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(menu.frame), SCREEN_WIDTH, self.bounds.size.height - CGRectGetMaxY(menu.frame)) style:UITableViewStyleGrouped];
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
        [currentTableView registerClass:[BXTManagerOMTableViewCell class] forCellReuseIdentifier:@"Cell"];
        [currentTableView setDelegate:self];
        [currentTableView setDataSource:self];
        [self addSubview:currentTableView];
        //请求
        [self loadNewData];
    }
    return self;
}

- (void)reloadAllType:(NSString *)startStr
           andEndTime:(NSString *)endStr
            andGourps:(NSArray *)theGroups
          andSelectOT:(NSString *)theOT
{
    startTime = startStr;
    endTime = endStr;
    selectOT = theOT;
    groups = theGroups;
    NSString *collection = @"";
    if ([selectOT integerValue] == 3)
    {
        selectOT = @"";
        collection = @"all";
    }
    else
    {
        collection = @"";
    }
    NSString *timeName = @"";
    if (startTime.length)
    {
        timeName = @"repair_time";
    }
    else
    {
        timeName = @"";
    }
    
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request allRepairs:collection
            andTimeName:timeName
           andStartTime:startTime
             andEndTime:endTime
           andOrderType:priorityType
             andGroupID:groupID
           andSubgroups:groups
               andState:selectOT
                andPage:1];
}

- (void)loadNewData
{
    if (_isRequesting) return;
    
    [repairListArray removeAllObjects];
    [currentTableView reloadData];
    
    refreshType = Down;
    currentPage = 1;
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    if (_orderType == OutTimeType)
    {
        NSString *outTime = groupID.length > 0 ? @"" : @"3600";
        [request repairsList:outTime
                  andDisUser:@""
                andCloseUser:@""
                andOrderType:priorityType
               andSubgroupID:groupID
                     andPage:1];
    }
    else if (_orderType == DistributeType)
    {
        NSString *disUser = groupID.length > 0 ? @"" : [BXTGlobal getUserProperty:U_BRANCHUSERID];
        [request repairsList:@""
                  andDisUser:disUser
                andCloseUser:@""
                andOrderType:priorityType
               andSubgroupID:groupID
                     andPage:1];
    }
    else if (_orderType == DoneType)
    {
        NSString *closeUser = groupID.length > 0 ? @"" : [BXTGlobal getUserProperty:U_BRANCHUSERID];
        [request repairsList:@""
                  andDisUser:@""
                andCloseUser:closeUser
                andOrderType:priorityType
               andSubgroupID:groupID
                     andPage:1];
    }
    else if (_orderType == AllType)
    {
        NSString *collection = @"";
        if ([selectOT integerValue] == 3)
        {
            selectOT = @"";
            collection = @"all";
        }
        else
        {
            collection = @"";
        }
        NSString *timeName = @"";
        if (startTime.length)
        {
            timeName = @"repair_time";
        }
        else
        {
            timeName = @"";
        }
        [request allRepairs:collection
                andTimeName:timeName
               andStartTime:startTime
                 andEndTime:endTime
               andOrderType:priorityType
                 andGroupID:groupID
               andSubgroups:groups
                   andState:selectOT
                    andPage:1];
    }
}

- (void)loadMoreData
{
    if (_isRequesting) return;
    refreshType = Up;
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    if (_orderType == OutTimeType)
    {
        NSString *outTime = groupID.length > 0 ? @"" : @"3600";
        [request repairsList:outTime
                  andDisUser:@""
                andCloseUser:@""
                andOrderType:priorityType
               andSubgroupID:groupID
                     andPage:currentPage];
    }
    else if (_orderType == DistributeType)
    {
        NSString *disUser = groupID.length > 0 ? @"" : [BXTGlobal getUserProperty:U_BRANCHUSERID];
        [request repairsList:@""
                  andDisUser:disUser
                andCloseUser:@""
                andOrderType:priorityType
               andSubgroupID:groupID
                     andPage:currentPage];
    }
    else if (_orderType == DistributeType)
    {
        NSString *closeUser = groupID.length > 0 ? @"" : [BXTGlobal getUserProperty:U_BRANCHUSERID];
        [request repairsList:@""
                  andDisUser:@""
                andCloseUser:closeUser
                andOrderType:priorityType
               andSubgroupID:groupID
                     andPage:currentPage];
    }
    else if (_orderType == AllType)
    {
        NSString *collection = @"";
        if ([selectOT integerValue] == 3)
        {
            selectOT = @"";
            collection = @"all";
        }
        else
        {
            collection = @"";
        }
        NSString *timeName = @"";
        if (startTime.length)
        {
            timeName = @"repair_time";
        }
        else
        {
            timeName = @"";
        }
        [request allRepairs:collection
                andTimeName:timeName
               andStartTime:startTime
                 andEndTime:endTime
               andOrderType:priorityType
                 andGroupID:groupID
               andSubgroups:groups
                   andState:selectOT
                    andPage:currentPage];
    }
}

#pragma mark -
#pragma mark 代理事件
#pragma mark -
#pragma mark DOPDropDownMenuDataSource && DOPDropDownMenuDelegate
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    return 4;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return typesArray[indexPath.row];
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    BXTGroupingInfo *groupInfo = [BXTGlobal getUserProperty:U_GROUPINGINFO];
    if (groupInfo.subgroup.length > 0 && indexPath.row == 3)
    {
        groupID = groupInfo.group_id;
        priorityType = @"4";
    }
    else
    {
        priorityType = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
        groupID = @"";
    }
    [self loadNewData];
}

#pragma mark -
#pragma mark UITableViewDatasource && UITableViewDelegate
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1f;//section头部高度
    }
    return 10.f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (section == 0)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1f)];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return repairListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTRepairInfo *repairInfo = [repairListArray objectAtIndex:indexPath.section];
    UIFont *font = [UIFont boldSystemFontOfSize:16.f];
    NSString *cause = [NSString stringWithFormat:@"故障描述:%@",repairInfo.cause];
    CGSize size = MB_MULTILINE_TEXTSIZE(cause, font, CGSizeMake(SCREEN_WIDTH - 30.f, 500), NSLineBreakByWordWrapping);
    
    return 170.f + size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTManagerOMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    BXTRepairInfo *repairInfo = [repairListArray objectAtIndex:indexPath.section];
    cell.orderNumber.text = [NSString stringWithFormat:@"工单号：%@",repairInfo.orderid];
    
    [cell refreshSubViewsFrame:repairInfo];
    
    if (repairInfo.order_type == 1)
    {
        cell.orderType.text = @"";
    }
    else if (repairInfo.order_type == 2)
    {
        cell.orderType.text = @"协作工单";
    }
    else if (repairInfo.order_type == 3)
    {
        cell.orderType.text = @"特殊工单";
    }
    else if (repairInfo.order_type == 4)
    {
        cell.orderType.text = @"超时工单";
    }
        
    cell.repairTime.text = [NSString stringWithFormat:@"报修时间:%@",repairInfo.repair_time];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BXTRepairInfo *repairInfo = [repairListArray objectAtIndex:indexPath.section];
    BXTOrderDetailViewController *repairDetailVC = [[BXTOrderDetailViewController alloc] initWithRepairID:[NSString stringWithFormat:@"%ld",(long)repairInfo.repairID]];
    [[self navigation] pushViewController:repairDetailVC animated:YES];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    LogRed(@"dic....%@",dic);
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
    
}

@end
