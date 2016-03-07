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
#import "BXTMaintenanceDetailViewController.h"
#import "UIView+Nav.h"
#import "BXTNewOrderViewController.h"
#import "BXTRejectOrderViewController.h"
#import "BXTAllOrdersViewController.h"

@interface BXTManagerOMView ()

@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation BXTManagerOMView

- (instancetype)initWithFrame:(CGRect)frame andOrderType:(OrderType )order_type WithArray:(NSArray *)transArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.orderType = order_type;
        
        groupID = @"";
        startTime = @"";
        endTime = @"";
        selectOT = @"";
        if (transArray)
        {
            startTime = transArray[0];
            endTime = transArray[1];
            if ([transArray[2] isEqualToString:@"SPECIAL"])
            {
                selectOT = @"3";
            }
            else if ([transArray[2] isEqualToString:@"UNDOWN"])
            {
                selectOT = @"1";
            }
        }
        groups = [NSArray array];
        BXTGroupingInfo *groupInfo = [BXTGlobal getUserProperty:U_GROUPINGINFO];
        if (_orderType == OutTimeType || _orderType == AllType)
        {
            if (groupInfo.subgroup.length > 0)
            {
                typesArray = @[@"时间排序",@"超时工单优先",@"特殊工单优先",@"本组优先"];
            }
            else
            {
                typesArray = @[@"时间排序",@"超时工单优先",@"特殊工单优先"];
            }
        }
        else
        {
            if (groupInfo.subgroup.length > 0)
            {
                typesArray = @[@"时间排序",@"本组优先"];
            }
            else
            {
                typesArray = @[@"时间排序"];
            }
        }
        repairListArray = [NSMutableArray array];
        priorityType = @"1";
        
        // 添加下拉菜单
        DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
        menu.delegate = self;
        menu.dataSource = self;
        [self addSubview:menu];
        
        @weakify(self);
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReloadListData" object:nil] subscribeNext:^(id x) {
            @strongify(self);
            [self loadNewData];
        }];
        
        currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(menu.frame), SCREEN_WIDTH, self.bounds.size.height - CGRectGetMaxY(menu.frame)) style:UITableViewStyleGrouped];
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        currentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self loadNewData];
        }];
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        currentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        // 设置了底部inset
        currentTableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        // 忽略掉底部inset
        currentTableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
        currentTableView.mj_footer.ignoredScrollViewContentInsetBottom = 40.f;
        [currentTableView registerClass:[BXTManagerOMTableViewCell class] forCellReuseIdentifier:@"Cell"];
        [currentTableView setDelegate:self];
        [currentTableView setDataSource:self];
        [currentTableView setEmptyDataSetSource:self];
        [currentTableView setEmptyDataSetDelegate:self];
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
    [self loadNewData];
}

- (void)loadNewData
{
    if (_isRequesting) return;
    
    [repairListArray removeAllObjects];
    [currentTableView reloadData];
    
    refreshType = Down;
    currentPage = 1;
    /**获取报修列表**/
    [self showLoadingMBP:@"努力加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    if (_orderType == OutTimeType)
    {
        [request repairsList:[[NSUserDefaults standardUserDefaults] objectForKey:@"LongTime"]
                  andDisUser:@""
                andCloseUser:@""
                andOrderType:priorityType
               andSubgroupID:groupID
                     andPage:1
                 close_state:@"all"];
    }
    else if (_orderType == DistributeType)
    {
        NSString *disUser = groupID.length > 0 ? @"" : [BXTGlobal getUserProperty:U_BRANCHUSERID];
        [request repairsList:@""
                  andDisUser:disUser
                andCloseUser:@""
                andOrderType:priorityType
               andSubgroupID:groupID
                     andPage:1
                 close_state:@"all"];
    }
    else if (_orderType == CloseType)
    {
        NSString *closeUser = groupID.length > 0 ? @"" : [BXTGlobal getUserProperty:U_BRANCHUSERID];
        [request repairsList:@""
                  andDisUser:@""
                andCloseUser:closeUser
                andOrderType:priorityType
               andSubgroupID:groupID
                     andPage:1
                 close_state:@"all"];
    }
    else if (_orderType == AllType)
    {
        NSString *collection = @"";
        NSString *state = @"";
        if ([selectOT integerValue] == 3)
        {
            state = @"";
            collection = @"all";
        }
        else if ([selectOT integerValue] == 1)
        {
            state = selectOT;
            collection = @"not_all";
        }
        else
        {
            state = selectOT;
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
                   andState:state
                    andPage:1];
    }
    _isRequesting = YES;
}

- (void)loadMoreData
{
    if (_isRequesting) return;
    refreshType = Up;
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    if (_orderType == OutTimeType)
    {
        NSString *outTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"LongTime"];
        [request repairsList:outTime
                  andDisUser:@""
                andCloseUser:@""
                andOrderType:priorityType
               andSubgroupID:groupID
                     andPage:currentPage
                 close_state:@"all"];
    }
    else if (_orderType == DistributeType)
    {
        NSString *disUser = groupID.length > 0 ? @"" : [BXTGlobal getUserProperty:U_BRANCHUSERID];
        [request repairsList:@""
                  andDisUser:disUser
                andCloseUser:@""
                andOrderType:priorityType
               andSubgroupID:groupID
                     andPage:currentPage
                 close_state:@"all"];
    }
    else if (_orderType == CloseType)
    {
        NSString *closeUser = groupID.length > 0 ? @"" : [BXTGlobal getUserProperty:U_BRANCHUSERID];
        [request repairsList:@""
                  andDisUser:@""
                andCloseUser:closeUser
                andOrderType:priorityType
               andSubgroupID:groupID
                     andPage:currentPage
                 close_state:@"all"];
    }
    else if (_orderType == AllType)
    {
        NSString *collection = @"";
        NSString *state = @"";
        if ([selectOT integerValue] == 3)
        {
            state = @"";
            collection = @"all";
        }
        else if ([selectOT integerValue] == 1)
        {
            state = selectOT;
            collection = @"not_all";
        } else {
            state = selectOT;
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
                   andState:state
                    andPage:currentPage];
    }
    _isRequesting = YES;
}

#pragma mark -
#pragma mark DOPDropDownMenuDataSource && DOPDropDownMenuDelegate
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    return typesArray.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return typesArray[indexPath.row];
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    BXTGroupingInfo *groupInfo = [BXTGlobal getUserProperty:U_GROUPINGINFO];
    NSInteger row;
    if (_orderType == OutTimeType || _orderType == AllType)
    {
        row = 3;
    }
    else
    {
        row = 1;
    }
    if (groupInfo.subgroup.length > 0 && indexPath.row == row)
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1f;//section头部高度
    }
    return 10.f;//section头部高度
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (section == 0)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1f)];
    }
    else
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    }
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.f;
}

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
    //蛋疼的IOS7
    if (!IS_IOS_8)
    {
        //place的y
        CGFloat height = 58.f;
        //place到cause的间距
        CGFloat spaceOne = 40.f;
        //cause到底部的间距
        CGFloat spaceTwo = 50.f;
        
        //计算位置的高度
        BXTRepairInfo *repairInfo = [repairListArray objectAtIndex:indexPath.section];
        NSString *placeStr = [NSString stringWithFormat:@"位置:%@-%@-%@",repairInfo.area, repairInfo.place, repairInfo.stores_name];
        if ([BXTGlobal isBlankString:repairInfo.stores_name])
        {
            placeStr = [NSString stringWithFormat:@"位置:%@-%@",repairInfo.area, repairInfo.place];
        }
        CGSize place_size = MB_MULTILINE_TEXTSIZE(placeStr, [UIFont systemFontOfSize:16.f], CGSizeMake(SCREEN_WIDTH - 30.f, 500), NSLineBreakByWordWrapping);
        height = height + spaceOne + place_size.height;
        
        //计算故障描述的高度
        NSString *causeStr = [NSString stringWithFormat:@"故障描述:%@",repairInfo.cause];
        CGSize cause_size = MB_MULTILINE_TEXTSIZE(causeStr, [UIFont systemFontOfSize:16.f], CGSizeMake(SCREEN_WIDTH - 30.f, 500), NSLineBreakByWordWrapping);
        height = height + cause_size.height + spaceTwo;
        
        return height;
    }
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTManagerOMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    BXTRepairInfo *repairInfo = [repairListArray objectAtIndex:indexPath.section];
    cell.orderNumber.text = [NSString stringWithFormat:@"工单号：%@",repairInfo.orderid];
    
    [cell refreshSubViewsFrame:repairInfo];
    
    if ([repairInfo.order_type integerValue] == 1)
    {
        cell.orderType.text = @"";
    }
    else if ([repairInfo.order_type integerValue] == 2)
    {
        cell.orderType.text = @"协作工单";
    }
    else if ([repairInfo.order_type integerValue] == 3)
    {
        cell.orderType.text = @"特殊工单";
    }
    else if ([repairInfo.order_type integerValue] == 4)
    {
        cell.orderType.text = @"超时工单";
    }
    
    cell.repairTime.text = [NSString stringWithFormat:@"报修时间:%@",repairInfo.repair_time];
    if (IS_IOS_8)
    {
        self.cellHeight = cell.cellHeight;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BXTRepairInfo *repairInfo = [repairListArray objectAtIndex:indexPath.section];
    if (_orderType == OutTimeType && [repairInfo.state integerValue] == 1 && [repairInfo.order_type integerValue] != 3)
    {
        BXTNewOrderViewController *assignOrderVC = [[BXTNewOrderViewController alloc] initWithIsAssign:YES andWithOrderID:[NSString stringWithFormat:@"%ld",(long)repairInfo.repairID]];
        [[self navigation] pushViewController:assignOrderVC animated:YES];
    }
    else if (_orderType == OutTimeType && [repairInfo.order_type integerValue] == 3)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
        BXTMaintenanceDetailViewController *repairDetailVC = (BXTMaintenanceDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTMaintenanceDetailViewController"];
        repairDetailVC.isRejectVC = YES;
        [repairDetailVC dataWithRepairID:repairInfo.repairID];
        [[self navigation] pushViewController:repairDetailVC animated:YES];
    }
    else if (_orderType == AllType || _orderType == CloseType)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
        BXTMaintenanceDetailViewController *repairDetailVC = (BXTMaintenanceDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTMaintenanceDetailViewController"];
        repairDetailVC.isAllOrderType = YES;
        [repairDetailVC dataWithRepairID:repairInfo.repairID];
        [[self navigation] pushViewController:repairDetailVC animated:YES];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
        BXTMaintenanceDetailViewController *repairDetailVC = (BXTMaintenanceDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTMaintenanceDetailViewController"];
        [repairDetailVC dataWithRepairID:repairInfo.repairID];
        [[self navigation] pushViewController:repairDetailVC animated:YES];
    }
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
    [self hideTheMBP];
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
    _isRequesting = NO;
    [currentTableView.mj_header endRefreshing];
    [currentTableView.mj_footer endRefreshing];
}

- (void)requestError:(NSError *)error
{
    _isRequesting = NO;
}

@end
