//
//  BXTMessageView.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/31.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMessageView.h"
#import "BXTMessageTableViewCell.h"
#import "BXTMessageInfo.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BXTHeaderForVC.h"
#import <MJRefresh.h>
#import "UIView+Nav.h"
#import "AppDelegate.h"
#import "BXTMaintenanceDetailViewController.h"
#import "BXTProjectManageViewController.h"
#import "BXTReaciveOrdersViewController.h"
#import "BXTRemindNum.h"

@interface BXTMessageView () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation BXTMessageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.dataArray = [[NSMutableArray alloc] init];
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [self.tableView registerNib:[UINib nibWithNibName:@"BXTMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageCell"];
        self.tableView.rowHeight = 86;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        [self addSubview:self.tableView];
        
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
        [self.tableView.mj_header beginRefreshing];
    }
    return self;
}

- (void)getResource
{
    [self showLoadingMBP:@"努力加载中..."];
    /**获取消息**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request newsListWithPage:self.currentPage];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    
    BXTMessageInfo *messageInfo = self.dataArray[indexPath.row];
    cell.headImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@",messageInfo.notice_type,messageInfo.event_type]];
    cell.titleLabel.text = messageInfo.notice_title;
    cell.detailLabel.text = messageInfo.notice_desc;
    cell.timeLabel.text = messageInfo.send_time_name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BXTMessageInfo *messageInfo = self.dataArray[indexPath.row];
    if ([messageInfo.notice_type integerValue] == 1)
    {
        BXTProjectManageViewController *pivc = [[BXTProjectManageViewController alloc] init];
        [[self navigation] pushViewController:pivc animated:YES];
    }
    else if ([messageInfo.notice_type integerValue] == 2)
    {
        //2.1 用户上传了一条新的工单 2.2 已接单通知 2.3 已到场通知 2.4 已修完通知 2.5 被指派工单通知 2.6 客户确认通知 2.7 指派驳回通知 2.8 工单取消通知 2.9 客户驳回通知 2.10 超时工单通知 2.11 默认评价 2.12新维保的通知 2.13 维保将要过期 2.14已过期维保通知
        if ([messageInfo.event_type isEqualToString:@"2.1"] || [messageInfo.event_type isEqualToString:@"2.10"])
        {
            //日常工单
            [BXTRemindNum sharedManager].timeStart_Daily = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            SaveValueTUD(@"timeStart_Daily", [BXTRemindNum sharedManager].timeStart_Daily);
            
            BXTReaciveOrdersViewController *reaciveVC = [[BXTReaciveOrdersViewController alloc] initWithTaskType:1];
            reaciveVC.hidesBottomBarWhenPushed = YES;
            [self.navigation pushViewController:reaciveVC animated:YES];
        }
        else if ([messageInfo.event_type isEqualToString:@"2.13"] || [messageInfo.event_type isEqualToString:@"2.14"])
        {
            //维保工单
            [BXTRemindNum sharedManager].timeStart_Inspection = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            SaveValueTUD(@"timeStart_Inspectio", [BXTRemindNum sharedManager].timeStart_Inspection);
            
            BXTReaciveOrdersViewController *reaciveVC = [[BXTReaciveOrdersViewController alloc] initWithTaskType:2];
            reaciveVC.hidesBottomBarWhenPushed = YES;
            [self.navigation pushViewController:reaciveVC animated:YES];
        }
        else if (![messageInfo.event_type isEqualToString:@"2.12"])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
            BXTMaintenanceDetailViewController *repairDetailVC = (BXTMaintenanceDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTMaintenanceDetailViewController"];
            [repairDetailVC dataWithRepairID:messageInfo.about_id sceneType:MessageType];
            [[self navigation] pushViewController:repairDetailVC animated:YES];
        }
    }
}

#pragma mark -
#pragma mark DZNEmptyDataSetDelegate & DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有符合条件的消息";
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
    if (type == MessageList)
    {
        if (self.currentPage == 1 && self.dataArray.count != 0)
        {
            [self.dataArray removeAllObjects];
        }
        if (data.count)
        {
            [BXTMessageInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"messageID":@"id"};
            }];
            NSArray *repairs = [BXTMessageInfo mj_objectArrayWithKeyValuesArray:data];
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
