//
//  BXTOtherAffairView.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTOtherAffairView.h"
#import "BXTOtherAffairCell.h"
#import "BXTOtherAffair.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BXTHeaderForVC.h"
#import <MJRefresh.h>
#import "UIView+Nav.h"
#import "AppDelegate.h"
#import "BXTCertificationManageViewController.h"
#import "BXTMaintenanceDetailViewController.h"
#import "BXTCertificationCompleteViewController.h"

#define REFRESHOTHERAFFAIRVIEW @"refreshOtherAffairView "

@interface BXTOtherAffairView () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger currentPage;

@property (copy, nonatomic) NSString *stateStr;

@end

@implementation BXTOtherAffairView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame HandleState:(NSString *)handle_state
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dataArray = [[NSMutableArray alloc] init];
        self.stateStr = handle_state;
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        self.tableView.rowHeight = 100;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        [self addSubview:self.tableView];
        
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
        
        // 进行中页面刷新后 - 已完成刷新
        @weakify(self);
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:REFRESHOTHERAFFAIRVIEW object:nil] subscribeNext:^(id x) {
            @strongify(self);
            
            if ([self.stateStr integerValue] == 2) {
                self.currentPage = 1;
                [self.tableView.mj_header beginRefreshing];
            }
        }];
        
        [self.tableView.mj_header beginRefreshing];
    }
    return self;
}

- (void)getResource
{
    [self showLoadingMBP:@"加载中..."];
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request listOFOtherAffairWithHandleState:self.stateStr page:self.currentPage];
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
    BXTOtherAffairCell *cell = [BXTOtherAffairCell cellWithTableView:tableView];
    
    cell.affairModel = self.dataArray[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTOtherAffair *affairModel = self.dataArray[indexPath.section];
    
    /** ---- 事件类别 1.认证审批 11.维修确认 12待评价工单 ---- */
    if ([affairModel.affairs_type isEqualToString:@"1"])
    {
        if ([self.stateStr isEqualToString:@"1"])
        {
            BXTCertificationManageViewController *cmvc = [[BXTCertificationManageViewController alloc] init];
            cmvc.isRunning = YES;
            cmvc.transID = affairModel.about_id;
            cmvc.affairs_id = affairModel.messageID;
            cmvc.delegateSignal = [RACSubject subject];
            @weakify(self);
            [cmvc.delegateSignal subscribeNext:^(id x) {
                @strongify(self);
                
                if ([self.stateStr integerValue] == 1) {
                    self.currentPage = 1;
                    [self.tableView.mj_header beginRefreshing];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHOTHERAFFAIRVIEW object:nil];
                }
            }];
            [[self navigation] pushViewController:cmvc animated:YES];
        }
        else
        {
            BXTCertificationCompleteViewController *ccvc = [[BXTCertificationCompleteViewController alloc] init];
            BXTOtherAffair *affairModel = self.dataArray[indexPath.section];
            ccvc.transApplicantID = affairModel.about_id;
            [[self navigation] pushViewController:ccvc animated:YES];
        }
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
        BXTMaintenanceDetailViewController *repairDetailVC = (BXTMaintenanceDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTMaintenanceDetailViewController"];
        [repairDetailVC dataWithRepairID:affairModel.about_id sceneType:OtherAffairType];
        repairDetailVC.affairID = affairModel.messageID;
        repairDetailVC.delegateSignal = [RACSubject subject];
        @weakify(self);
        [repairDetailVC.delegateSignal subscribeNext:^(id x) {
            @strongify(self);
            
            if ([self.stateStr integerValue] == 1) {
                self.currentPage = 1;
                [self.tableView.mj_header beginRefreshing];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHOTHERAFFAIRVIEW object:nil];
            }
        }];
        [[self navigation] pushViewController:repairDetailVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark DZNEmptyDataSetDelegate & DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有符合条件的事务";
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
    
    if (type == OtherAffairLists)
    {
        if (self.currentPage == 1 && self.self.dataArray.count != 0)
        {
            [self.dataArray removeAllObjects];
        }
        
        if (data.count)
        {
            [BXTOtherAffair mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"messageID":@"id"};
            }];
            NSArray *repairs = [BXTOtherAffair mj_objectArrayWithKeyValuesArray:data];
            [self.dataArray addObjectsFromArray:repairs];
        }
        [self.tableView reloadData];
        
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideTheMBP];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

@end
