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
#import "BXTEvaluationViewController.h"

@interface BXTOrderListView ()

/**
 *  cell 高度
 */
@property (nonatomic, assign) CGFloat cellHeight;
/**
 *  cell 高度没有 - 开始维修 - 按钮
 */
@property (nonatomic, assign) CGFloat cellHeight_nobtn;

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
        
        refreshType = Down;
        currentPage = 1;
        self.repairState = state;
        self.isReacive = reacive;
        self.repairListArray = [NSMutableArray array];
        
        self.currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStyleGrouped];
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
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
        if (![BXTGlobal shareGlobal].isRepair)
        {
            [_currentTableView registerClass:[BXTRepairTableViewCell class] forCellReuseIdentifier:@"OrderListCell"];
        }
        else
        {
            [_currentTableView registerClass:[BXTMaintenanceManTableViewCell class] forCellReuseIdentifier:@"OrderListCell"];
        }
        _currentTableView.delegate = self;
        _currentTableView.dataSource = self;
        [self addSubview:_currentTableView];
        //请求
        [self loadNewData];
    }
    return self;
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

- (void)loadNewData
{
    if (_isRequesting) return;
    refreshType = Down;
    currentPage = 1;
    [self showLoadingMBP:@"努力加载中..."];
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairsList:_repairState
                 andPage:1
     andIsMaintenanceMan:[BXTGlobal shareGlobal].isRepair ? YES : NO
    andRepairerIsReacive:_repairState];
    _isRequesting = YES;
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
#pragma mark UITableViewDelegate & UITableViewDatasource
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
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (([BXTGlobal shareGlobal].isRepair && [_isReacive integerValue] != 1) || (![BXTGlobal shareGlobal].isRepair && [_repairState integerValue] == 1))
    {
        return self.cellHeight_nobtn;
    }
    return self.cellHeight;
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
    if (![BXTGlobal shareGlobal].isRepair)
    {
        BXTRepairTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        BXTRepairInfo *repairInfo = [_repairListArray objectAtIndex:indexPath.section];
        cell.repairID.text = [NSString stringWithFormat:@"工单号:%@",repairInfo.orderid];
        cell.time.text = repairInfo.repair_time;
        
        NSString *placeStr = [NSString stringWithFormat:@"位置:%@-%@-%@",repairInfo.area, repairInfo.place, repairInfo.stores_name];
        if ([BXTGlobal isBlankString:repairInfo.stores_name]) {
            placeStr = [NSString stringWithFormat:@"位置:%@-%@",repairInfo.area, repairInfo.place];
        }
        CGSize cause_size = MB_MULTILINE_TEXTSIZE(placeStr, [UIFont boldSystemFontOfSize:17.f], CGSizeMake(SCREEN_WIDTH - 30.f, 500), NSLineBreakByWordWrapping);
        cell.place.text = placeStr;
        // 更新所有控件位置
        cell.place.frame = CGRectMake(15.f, 50.f + 8.f, SCREEN_WIDTH - 30.f, cause_size.height);
        cell.faultType.frame = CGRectMake(15.f, CGRectGetMaxY(cell.place.frame) + 10.f, CGRectGetWidth(cell.place.frame), 20);
        cell.cause.frame = CGRectMake(15.f, CGRectGetMaxY(cell.faultType.frame) + 10.f, CGRectGetWidth(cell.faultType.frame), 20);
        cell.level.frame = CGRectMake(15.f, CGRectGetMaxY(cell.cause.frame) + 8.f, CGRectGetWidth(cell.cause.frame), 20);
        cell.lineViewTwo.frame = CGRectMake(10, CGRectGetMaxY(cell.level.frame) + 8.f, SCREEN_WIDTH - 20, 1.f);
        cell.state.frame = CGRectMake(15.f, CGRectGetMaxY(cell.lineViewTwo.frame) + 8.f, CGRectGetWidth(cell.cause.frame), 20);
        cell.repairState.frame = CGRectMake(15.f, CGRectGetMaxY(cell.state.frame) + 8.f, CGRectGetWidth(cell.cause.frame), 20);
        CGFloat width = IS_IPHONE6 ? 84.f : 56.f;
        cell.evaButton.frame = CGRectMake(SCREEN_WIDTH - width - 15.f, CGRectGetMaxY(cell.lineViewTwo.frame) + 15.f, width, 30.f);
        cell.cancelRepair.frame = CGRectMake(SCREEN_WIDTH - 114.f - 15.f, CGRectGetMaxY(cell.lineViewTwo.frame) + 10.f, 114.f, 40.f);
        self.cellHeight = CGRectGetMaxY(cell.repairState.frame) + 12;
        self.cellHeight_nobtn = CGRectGetMaxY(cell.repairState.frame) + 8 - 64;
        
        
        cell.faultType.text = [NSString stringWithFormat:@"故障类型:%@",repairInfo.faulttype_name];
        cell.cause.text = [NSString stringWithFormat:@"故障描述:%@",repairInfo.cause];
        if (repairInfo.urgent == 2)
        {
            cell.level.text = @"等级:一般";
        }
        else
        {
            NSString *str = @"等级:紧急";
            NSRange range = [str rangeOfString:@"紧急"];
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
            cell.level.attributedText = attributeStr;
        }
        
        NSArray *usersArray = repairInfo.repair_user;
        NSString *components = [usersArray componentsJoinedByString:@","];
        cell.state.text = components;
        cell.tag = indexPath.section;
        cell.cancelRepair.hidden = YES;
        
        // TODO: -----------------  调试 维修状态  -----------------
        cell.repairState.text = repairInfo.receive_state;
        if (repairInfo.repairstate == 1 || [repairInfo.is_repairing intValue] == 1)
        {
            cell.state.hidden = YES;
            cell.repairState.hidden = YES;
        }
        else if (repairInfo.repairstate == 3)
        {
            cell.evaButton.hidden = NO;
            @weakify(self);
            [[cell.evaButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                BXTRepairInfo *repairInfo = [self.repairListArray objectAtIndex:indexPath.section];
                BXTEvaluationViewController *evaluateVC = [[BXTEvaluationViewController alloc] initWithRepairID:[NSString stringWithFormat:@"%ld",(long)repairInfo.repairID]];
                [[self navigation] pushViewController:evaluateVC animated:YES];
            }];
        }
        else if (repairInfo.repairstate == 5)
        {
            cell.evaButton.hidden = YES;
        }
        
        return cell;
    }
    else
    {
        BXTMaintenanceManTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        BXTRepairInfo *repairInfo = [_repairListArray objectAtIndex:indexPath.section];
        cell.repairID.text = [NSString stringWithFormat:@"工单号:%@",repairInfo.orderid];
        cell.time.text = [NSString stringWithFormat:@"报修时间:%@",repairInfo.repair_time];
        
        // 位置自适应
        NSString *placeStr = [NSString stringWithFormat:@"位置:%@-%@-%@",repairInfo.area, repairInfo.place, repairInfo.stores_name];
        if ([BXTGlobal isBlankString:repairInfo.stores_name]) {
            placeStr = [NSString stringWithFormat:@"位置:%@-%@",repairInfo.area, repairInfo.place];
        }
        CGSize cause_size = MB_MULTILINE_TEXTSIZE(placeStr, [UIFont boldSystemFontOfSize:17.f], CGSizeMake(SCREEN_WIDTH - 30.f, 500), NSLineBreakByWordWrapping);
        cell.place.text = placeStr;
        // 更新所有控件位置
        cell.place.frame = CGRectMake(15.f, 50.f + 8.f, SCREEN_WIDTH - 30.f, cause_size.height);
        cell.cause.frame = CGRectMake(15.f, CGRectGetMaxY(cell.place.frame) + 10.f, CGRectGetWidth(cell.place.frame), 20);
        cell.level.frame = CGRectMake(15.f, CGRectGetMaxY(cell.cause.frame) + 10.f, CGRectGetWidth(cell.cause.frame), 20);
        cell.time.frame = CGRectMake(15.f, CGRectGetMaxY(cell.level.frame) + 8.f, CGRectGetWidth(cell.level.frame), 20);
        cell.lineViewTwo.frame = CGRectMake(10, CGRectGetMaxY(cell.time.frame) + 8.f, SCREEN_WIDTH - 20, 1.f);
        cell.reaciveBtn.frame = CGRectMake(0, CGRectGetMaxY(cell.lineViewTwo.frame) + 10.f, 230.f, 40.f);
        cell.reaciveBtn.center = CGPointMake(SCREEN_WIDTH/2.f, cell.reaciveBtn.center.y);
        self.cellHeight = CGRectGetMaxY(cell.reaciveBtn.frame) + 8;
        self.cellHeight_nobtn = CGRectGetMaxY(cell.reaciveBtn.frame) + 8 - 58;
        
        
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
        if (repairInfo.urgent == 2)
        {
            cell.level.text = @"等级:一般";
        }
        else
        {
            NSString *str = @"等级:紧急";
            NSRange range = [str rangeOfString:@"紧急"];
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
            cell.level.attributedText = attributeStr;
        }
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
        
        @weakify(self);
        [[cell.maintenanceProcess rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            BXTRepairInfo *repairInfo = [self.repairListArray objectAtIndex:indexPath.section];
            BXTMaintenanceProcessViewController *maintenanceProcossVC = [[BXTMaintenanceProcessViewController alloc] initWithCause:repairInfo.faulttype_name andCurrentFaultID:repairInfo.fault_id andRepairID:repairInfo.repairID andReaciveTime:repairInfo.start_time];
            [self.navigation pushViewController:maintenanceProcossVC animated:YES];
        }];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTRepairInfo *repairInfo = [_repairListArray objectAtIndex:indexPath.section];
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

- (void)startRepairAction:(UIButton *)btn
{
    selectTag = btn.tag;
    BXTRepairInfo *repairInfo = _repairListArray[selectTag];
    [self showLoadingMBP:@"请稍候..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request startRepair:[NSString stringWithFormat:@"%ld",(long)repairInfo.repairID]];
}

#pragma mark -
#pragma mark 请求返回代理
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
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
                [_repairListArray removeAllObjects];
                [_repairListArray addObjectsFromArray:tempArray];
            }
            else if (refreshType == Up)
            {
                [_repairListArray addObjectsFromArray:[[tempArray reverseObjectEnumerator] allObjects]];
            }
            currentPage++;
            [_currentTableView reloadData];
        }
        _isRequesting = NO;
        [_currentTableView.mj_header endRefreshing];
        [_currentTableView.mj_footer endRefreshing];
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
    _isRequesting = NO;
    [_currentTableView.mj_header endRefreshing];
    [_currentTableView.mj_footer endRefreshing];
}

@end
