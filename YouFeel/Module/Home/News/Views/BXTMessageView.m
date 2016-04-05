//
//  BXTMessageView.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/31.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMessageView.h"
#import "BXTOtherAffairCell.h"
#import "BXTOtherAffair.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BXTHeaderForVC.h"
#import <MJRefresh.h>
#import "UIView+Nav.h"
#import "AppDelegate.h"

@interface BXTMessageView () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger currentPage;

@property (copy, nonatomic) NSString *stateStr;

@end

@implementation BXTMessageView

- (instancetype)initWithFrame:(CGRect)frame eventType:(NSString *)event_type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dataArray = [[NSMutableArray alloc] init];
        self.stateStr = event_type;
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
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
    [request newsListWithPage:self.currentPage noticeType:@"2" eventType:self.stateStr];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
