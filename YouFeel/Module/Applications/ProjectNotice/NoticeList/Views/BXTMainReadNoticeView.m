//
//  BXTMainReadNoticeView.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMainReadNoticeView.h"
#import "UIView+Nav.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BXTHeaderFile.h"
#import "BXTReadNoticeCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "CYLTabBarController.h"
#import "AppDelegate.h"
#import "BXTReadNotice.h"
#import "BXTNoticeInformViewController.h"

#define REFRESHMAINREADNOTICEVIEW @"refreshMainReadNoticeView"

@interface BXTMainReadNoticeView () <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate, BXTDataResponseDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;

@property (assign, nonatomic) NSInteger readStr;

@end

@implementation BXTMainReadNoticeView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)readState
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.dataArray = [[NSMutableArray alloc] init];
        self.currentPage = 1;
        self.readStr = readState;
        [self createUI];
        [self requestNetResourceWithReadState:readState];
        
        @weakify(self);
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:REFRESHMAINREADNOTICEVIEW object:nil] subscribeNext:^(id x) {
            @strongify(self);
            if (self.readStr == 2)
            {
                self.currentPage = 1;
                [self.tableView.mj_header beginRefreshing];
            }
        }];
    }
    return self;
}

- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.rowHeight = 80;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self addSubview:self.tableView];
}

#pragma mark -
#pragma mark - getResource
- (void)requestNetResourceWithReadState:(NSInteger)readState
{
    NSString *readStateStr = [NSString stringWithFormat:@"%ld", (long)readState];
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf getResourcereadWithReadState:readStateStr];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf getResourcereadWithReadState:readStateStr];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)getResourcereadWithReadState:(NSString *)readState
{
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request announcementListWithReadState:readState pagesize:@"5" page:[NSString stringWithFormat:@"%ld", (long)self.currentPage]];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTReadNoticeCell *cell = [BXTReadNoticeCell cellWithTableView:tableView];
    
    cell.noticeModel = self.dataArray[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BXTReadNotice *model = self.dataArray[indexPath.section];
    BXTNoticeInformViewController *nivc = [[BXTNoticeInformViewController alloc] init];
    nivc.titleStr = @"公告详情";
    nivc.urlStr = model.view_url;
    nivc.delegateSignal = [RACSubject subject];
    @weakify(self);
    [nivc.delegateSignal subscribeNext:^(id x) {
        @strongify(self);
        if (self.readStr == 1)
        {
            self.currentPage = 1;
            [self.tableView.mj_header beginRefreshing];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHMAINREADNOTICEVIEW object:nil];
        }
    }];
    [[self navigation] pushViewController:nivc animated:YES];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (self.currentPage == 1 && self.dataArray.count != 0)
    {
        [self.dataArray removeAllObjects];
    }
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (data.count > 0)
    {
        for (NSDictionary *dataDict in data)
        {
            BXTReadNotice *model = [BXTReadNotice modelWithDict:dataDict];
            [self.dataArray addObject:model];
        }
    }
    
    [self.tableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal showText:@"请求失败，请重试" completionBlock:nil];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark -
#pragma mark DZNEmptyDataSetDelegate & DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有符合条件的项目公告";
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor blackColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
