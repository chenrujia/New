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
#import "AppDelegate.h"

@implementation BXTOrderListView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame andState:(NSString *)state andRepairerIsReacive:(NSString *)reacive
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAllData) name:@"ReloadData" object:nil];
        
        refreshType = Down;
        currentPage = 1;
        self.isRequesting = NO;
        self.repairState = state;
        self.isReacive = reacive;
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
        if (![BXTGlobal shareGlobal].isRepair)
        {
            [currentTableView registerClass:[BXTRepairTableViewCell class] forCellReuseIdentifier:@"OrderListCell"];
        }
        else
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
    [currentTableView reloadData];
    [self loadNewData];
}

- (void)loadNewData
{
    if (_isRequesting) return;
    refreshType = Down;
    currentPage = 1;
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairsList:_repairState
                 andPage:1
     andIsMaintenanceMan:[BXTGlobal shareGlobal].isRepair ? YES : NO
    andRepairerIsReacive:_isReacive];
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
    andRepairerIsReacive:_isReacive];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (([BXTGlobal shareGlobal].isRepair && [_isReacive integerValue] != 1) || (![BXTGlobal shareGlobal].isRepair && [_repairState integerValue] == 1))
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
    if (![BXTGlobal shareGlobal].isRepair)
    {
        BXTRepairTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        BXTRepairInfo *repairInfo = [repairListArray objectAtIndex:indexPath.section];
        cell.repairID.text = [NSString stringWithFormat:@"工单号:%@",repairInfo.orderid];
        cell.time.text = repairInfo.repair_time;
        cell.place.text = [NSString stringWithFormat:@"位置:%@",repairInfo.area];
        cell.faultType.text = [NSString stringWithFormat:@"故障类型:%@",repairInfo.faulttype_name];
        cell.cause.text = [NSString stringWithFormat:@"故障描述:%@",repairInfo.cause];
        NSString *str;
        NSRange range;
        if (repairInfo.urgent == 2)
        {
            str = @"等级:一般";
            range = [str rangeOfString:@"一般"];
        }
        else
        {
            str = @"等级:紧急";
            range = [str rangeOfString:@"紧急"];
        }
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
        cell.level.attributedText = attributeStr;
        
        NSArray *usersArray = repairInfo.repair_user;
        NSString *components = [usersArray componentsJoinedByString:@","];
        cell.state.text = components;
        cell.tag = indexPath.section;
        cell.cancelRepair.hidden = YES;
        
        // TODO: -----------------  调试 维修状态  -----------------
        cell.repairState.text = repairInfo.receive_state;
        if ([self.repairState isEqualToString:@"1"]) {
            cell.repairState.hidden = YES;
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
        cell.cause.text = [NSString stringWithFormat:@"故障描述:%@",repairInfo.cause];
        if (repairInfo.order_type == 3)
        {
            cell.orderType.hidden = NO;
            cell.maintenanceProcess.hidden = YES;
            cell.orderType.text = @"特殊工单";
        }
        else
        {
            cell.orderType.hidden = YES;
            cell.maintenanceProcess.hidden = NO;
        }
        NSString *str;
        NSRange range;
        if (repairInfo.urgent == 2)
        {
            str = @"等级:一般";
            range = [str rangeOfString:@"一般"];
        }
        else
        {
            str = @"等级:紧急";
            range = [str rangeOfString:@"紧急"];
        }
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
        cell.level.attributedText = attributeStr;
        cell.tag = indexPath.section;
        
        if ([_isReacive integerValue] == 1)
        {
            cell.reaciveBtn.hidden = NO;
            cell.maintenanceProcess.hidden = YES;
            cell.reaciveBtn.tag = indexPath.section;
            [cell.reaciveBtn addTarget:self action:@selector(startRepairAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (repairInfo.repairstate == 2)
        {
            [cell.maintenanceProcess setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            cell.maintenanceProcess.userInteractionEnabled = YES;
            
            cell.reaciveBtn.hidden = YES;
            if (repairInfo.order_type == 3)
            {
                cell.maintenanceProcess.hidden = YES;
            }
            else
            {
                cell.maintenanceProcess.hidden = NO;
            }
        }
        else
        {
            cell.reaciveBtn.hidden = YES;
            cell.maintenanceProcess.hidden = YES;
        }
        
        cell.maintenanceProcess.tag = indexPath.section;
        [cell.maintenanceProcess addTarget:self action:@selector(maintenanceProcessClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTRepairInfo *repairInfo = [repairListArray objectAtIndex:indexPath.section];
    if (![BXTGlobal shareGlobal].isRepair)
    {
        BXTRepairDetailViewController *repairDetail = [[BXTRepairDetailViewController alloc] initWithRepair:repairInfo];
        [[self navigation] pushViewController:repairDetail animated:YES];
    }
    else
    {
        if (repairInfo.order_type != 3)
        {
            BXTOrderDetailViewController *repairDetailVC = [[BXTOrderDetailViewController alloc] initWithRepairID:[NSString stringWithFormat:@"%ld",(long)repairInfo.repairID]];
            [[self navigation] pushViewController:repairDetailVC animated:YES];
        }
        else
        {
            [self showAlertView:@"特殊工单不可点击"];
        }
    }
}

- (void)maintenanceProcessClick:(UIButton *)btn
{
    BXTRepairInfo *repairInfo = [repairListArray objectAtIndex:btn.tag];
    BXTMaintenanceProcessViewController *maintenanceProcossVC = [[BXTMaintenanceProcessViewController alloc] initWithCause:repairInfo.faulttype_name andCurrentFaultID:repairInfo.fault_id andRepairID:repairInfo.repairID andReaciveTime:repairInfo.start_time];
    [self.navigation pushViewController:maintenanceProcossVC animated:YES];
}

- (void)startRepairAction:(UIButton *)btn
{
    selectTag = btn.tag;
    BXTRepairInfo *repairInfo = repairListArray[selectTag];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request startRepair:[NSString stringWithFormat:@"%ld",(long)repairInfo.repairID]];
}

#pragma mark -
#pragma mark 请求返回代理
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    LogRed(@"dic......%@",dic);
    NSArray *data = [dic objectForKey:@"data"];
    if (type == StartRepair)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"维修已开始！";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2.f];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
        }
    }
    else
    {
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
}

- (void)requestError:(NSError *)error
{
    [currentTableView.header endRefreshing];
    [currentTableView.footer endRefreshing];
}

- (void)showAlertView:(NSString *)title
{
    if (IS_IOS_8)
    {
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertCtr addAction:doneAction];
        [self.window.rootViewController presentViewController:alertCtr animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

@end
