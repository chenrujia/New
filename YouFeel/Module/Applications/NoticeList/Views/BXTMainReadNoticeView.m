//
//  BXTMainReadNoticeView.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMainReadNoticeView.h"
#import "BXTNoticeInformViewController.h"

@interface BXTMainReadNoticeView ()

@end

@implementation BXTMainReadNoticeView

#pragma mark -
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initial];
    }
    return self;
}

- (instancetype)init
{
    if (self == [super init])
    {
        [self initial];
    }
    return self;
}

- (void)initial
{
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self createUI];
}

- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
}

#pragma mark -
#pragma mark - getResource
- (void)requestNetResourceWithReadState:(NSInteger)readState
{
    NSString *readStateStr = [NSString stringWithFormat:@"%ld", (long)readState];
    self.currentPage = 1;
    __block __typeof(self) weakSelf = self;
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
    BXTReadNoticeCell *cell = [BXTReadNoticeCell cellWithTableView:tableView];
    
    cell.noticeModel = self.dataArray[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
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
    BXTReadNotice *model = self.dataArray[indexPath.section];
    
    BXTNoticeInformViewController *nivc = [[BXTNoticeInformViewController alloc] init];
    nivc.urlStr = model.view_url;
    [[self getNavigation] pushViewController:nivc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (self.currentPage == 1) {
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
        [self.tableView reloadData];
    }
}

- (void)requestError:(NSError *)error
{
    [BXTGlobal showText:@"请求失败，请重试" view:self completionBlock:nil];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark -
#pragma mark - 方法
- (UINavigationController *)getNavigation
{
    id rootVC = [AppDelegate appdelegete].window.rootViewController;
    UINavigationController *nav = nil;
    if ([rootVC isKindOfClass:[CYLTabBarController class]])
    {
        CYLTabBarController *tempVC = rootVC;
        nav = [tempVC.viewControllers objectAtIndex:tempVC.selectedIndex];
    }
    else if ([rootVC isKindOfClass:[UINavigationController class]])
    {
        nav = rootVC;
    }
    
    return nav;
}

@end
