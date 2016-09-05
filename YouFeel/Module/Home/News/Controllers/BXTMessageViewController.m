//
//  BXTMessageViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/31.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMessageViewController.h"
#import "BXTMessageTableViewCell.h"
#import "BXTMessageInfo.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BXTHeaderForVC.h"
#import <MJRefresh.h>
#import "UIView+Nav.h"
#import "AppDelegate.h"
#import "BXTRemindNum.h"
#import "BXTMaintenanceDetailViewController.h"
#import "BXTProjectInformViewController.h"
#import "BXTReaciveOrdersViewController.h"
#import "BXTNewOrderViewController.h"
#import "BXTGlobal.h"
#import "MYAlertAction.h"

@interface BXTMessageViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView    *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger      currentPage;
/** ---- 是否全选 ---- */
@property (nonatomic ,assign) BOOL           isAllSelected;
@property (nonatomic, strong) UIView         *footerView;
@property (nonatomic, strong) UIButton       *selectAllBtn;
@property (nonatomic, strong) UIButton       *deleteBtn;
@property (strong, nonatomic) NSMutableArray *selectedArray;

@end

@implementation BXTMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"消息" andRightTitle:@"    编辑" andRightImage:nil];
    [self createUI];
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
    [self.tableView.mj_header beginRefreshing];
}

- (void)navigationRightButton
{
    [self changeSelectedState:self.tableView.isEditing];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    self.dataArray = [[NSMutableArray alloc] init];
    self.selectedArray = [[NSMutableArray alloc] init];
    
    // self.tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStylePlain];
    [self.tableView registerNib:[UINib nibWithNibName:@"BXTMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageCell"];
    self.tableView.rowHeight = 86;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.view addSubview:self.tableView];
    
    // self.footerView
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
    self.footerView.backgroundColor = colorWithHexString(@"#F6F7F9");
    self.footerView.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    self.footerView.layer.borderWidth = 0.5;
    [self.view addSubview:self.footerView];
    
    self.selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectAllBtn.frame = CGRectMake(0, 5, 80, 40);
    [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectAllBtn setTitleColor:colorWithHexString(@"#5BABF5") forState:UIControlStateNormal];
    [self.footerView addSubview:self.selectAllBtn];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.frame = CGRectMake(SCREEN_WIDTH - 80, 5, 80, 40);
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:colorWithHexString(@"#5BABF5") forState:UIControlStateNormal];
    [self.footerView addSubview:self.deleteBtn];
    
    @weakify(self);
    [[self.selectAllBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.isAllSelected = !self.isAllSelected;
        for (int i = 0; i<self.dataArray.count; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            if (self.isAllSelected)
            {   // 全选
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
            else
            {    //反选
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
    }];
    
    [[self.deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        [MYAlertAction showAlertWithTitle:@"确定删除所选消息" msg:nil chooseBlock:^(NSInteger buttonIdx) {
            if (buttonIdx == 0)
            {
                NSMutableArray *deleteArrarys = [NSMutableArray array];
                
                for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows)
                {
                    [deleteArrarys addObject:self.dataArray[indexPath.row]];
                }

                NSMutableArray *idsArray = [[NSMutableArray alloc] init];
                
                for (BXTMessageInfo *messageInfo in deleteArrarys)
                {
                    [idsArray addObject:messageInfo.messageID];
                }
                
                NSString *idsStr = [idsArray componentsJoinedByString:@","];
                
                [self showLoadingMBP:@"删除中..."];
                /**获取消息**/
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request deleteNewsWithIDs:idsStr];
            }
        } buttonsStatement:@"确定", @"取消", nil];
    }];
}

- (void)changeSelectedState:(BOOL)selectedState
{
    if (selectedState)
    {
        [self navigationSetting:@"消息" andRightTitle:@"    编辑" andRightImage:nil];
        [self.tableView setEditing:NO animated:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.frame = CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT);
            self.footerView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT + 25);
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [self navigationSetting:@"消息" andRightTitle:@"    取消" andRightImage:nil];
        [self.tableView setEditing:YES animated:YES];
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.frame = CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 50);
            self.footerView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 25);
        } completion:^(BOOL finished) {
            self.isAllSelected = NO;
        }];
    }
}

#pragma mark -
#pragma mark - getResource
- (void)getResource
{
    [self showLoadingMBP:@"加载中..."];
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
    
    if (tableView.isEditing)
    {
        return;
    }
    BXTMessageInfo *messageInfo = self.dataArray[indexPath.row];
    if ([messageInfo.notice_type integerValue] == 1)
    {
        // 1.1 认证通过 1.2 认证未通过 1.3 有新的审核消息
        // 只有1.1有反应
        if ([messageInfo.event_type isEqualToString:@"1"])
        {
            BXTMyProject *myProjectInform = [[BXTMyProject alloc] init];
            BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
            myProjectInform.shop_id = companyInfo.company_id;
            myProjectInform.user_id = messageInfo.about_id;
            myProjectInform.verify_state = @"2";
            
            BXTProjectInformViewController *pivc = [[BXTProjectInformViewController alloc] init];
            pivc.hiddenChangeBtn = YES;
            pivc.transMyProject = myProjectInform;
            [self.navigationController pushViewController:pivc animated:YES];
        }
    }
    else if ([messageInfo.notice_type integerValue] == 2)
    {
        // 2.1 用户上传了一条新的工单 2.2 已接单通知 2.3 已到场通知 2.4 已修完通知 2.5 被指派工单通知 2.6 客户确认通知 2.7 指派驳回通知 2.8 工单取消通知 2.9 客户驳回通知 2.10 超时工单通知 2.11 默认评价 2.12新维保的通知 2.13 维保将要过期 2.14已过期维保通知
        if ([messageInfo.event_type isEqualToString:@"1"] || [messageInfo.event_type isEqualToString:@"10"])
        {
            //日常工单
            [BXTRemindNum sharedManager].timeStart_Daily = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            SaveValueTUD(@"timeStart_Daily", [BXTRemindNum sharedManager].timeStart_Daily);
            
            BXTReaciveOrdersViewController *reaciveVC = [[BXTReaciveOrdersViewController alloc] initWithTaskType:1];
            reaciveVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:reaciveVC animated:YES];
        }
        else if ([messageInfo.event_type isEqualToString:@"13"] || [messageInfo.event_type isEqualToString:@"14"])
        {
            //维保工单
            [BXTRemindNum sharedManager].timeStart_Inspection = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            SaveValueTUD(@"timeStart_Inspectio", [BXTRemindNum sharedManager].timeStart_Inspection);
            
            BXTReaciveOrdersViewController *reaciveVC = [[BXTReaciveOrdersViewController alloc] initWithTaskType:2];
            [self.navigationController pushViewController:reaciveVC animated:YES];
        }
        else if (![messageInfo.event_type isEqualToString:@"12"])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
            BXTMaintenanceDetailViewController *repairDetailVC = (BXTMaintenanceDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTMaintenanceDetailViewController"];
            [repairDetailVC dataWithRepairID:messageInfo.about_id sceneType:MessageType];
            [self.navigationController pushViewController:repairDetailVC animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataArray removeObject:self.dataArray[indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    [self hideMBP];
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
    else if (type == DeleteNews) {
        self.isAllSelected = NO;
        
        NSMutableArray *deleteArrarys = [NSMutableArray array];
        for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
            [deleteArrarys addObject:self.dataArray[indexPath.row]];
        }
        
        [self.dataArray removeObjectsInArray:deleteArrarys];
        
        if (!self.dataArray.count) {
            [self changeSelectedState:YES];
            
            self.currentPage = 1;
            [self getResource];
        } else {
            [self.tableView reloadData];
        }
        
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
