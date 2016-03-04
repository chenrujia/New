//
//  BXTNewsViewController.m
//  YouFeel
//
//  Created by Jason on 15/10/19.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTNewsViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTNewsTableViewCell.h"
#import "MJRefresh.h"
#import "BXTRepairInfo.h"
#import "BXTMaintenanceDetailViewController.h"
#import "BXTReaciveOrdersViewController.h"
#import "BXTManagerOMViewController.h"

@interface BXTNewsViewController ()<UITableViewDelegate,UITableViewDataSource,BXTDataResponseDelegate>
{
    UITableView      *currentTable;
    NSMutableArray   *datasource;
    NSInteger        selectSection;
}

@end

@implementation BXTNewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"消息" andRightTitle:nil andRightImage:nil];
    [self createTableView];
    
    datasource = [NSMutableArray array];
    currentPage = 1;
    [self showLoadingMBP:@"努力加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request newsListWithPage:currentPage noticeType:@"2"];
    _isRequesting = YES;
}

#pragma mark - 
#pragma mark 创建视图
- (void)createTableView
{
    currentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    currentTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    currentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    currentTable.backgroundColor = colorWithHexString(@"eff3f6");
    [currentTable registerClass:[BXTNewsTableViewCell class] forCellReuseIdentifier:@"Cell"];
    currentTable.delegate = self;
    currentTable.dataSource = self;
    [self.view addSubview:currentTable];
}

#pragma mark -
#pragma makr 事件
- (void)loadMoreData
{
    if (_isRequesting) return;
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request newsListWithPage:currentPage noticeType:@"2"];
    _isRequesting = YES;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.5f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5f)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 4.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [datasource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = datasource[indexPath.section];
    cell.titleLabel.text = [dic objectForKey:@"notice_title"];
    cell.detailLabel.text = [dic objectForKey:@"notice_body"];
    cell.timeLabel.text = [BXTGlobal transformationTime:@"yyyy-MM-dd HH:mm" withTime:[dic objectForKey:@"send_time"]];
    cell.evaButton.hidden = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     1 收到抢单信息：进入接单列表
     2 收到派工或者维修邀请：进入接单列表
     3 抢单后或者确认通知后回馈报修者到达时间： 进入工单详情
     4 维修完成后通知后报修者+评价（需要加自动好评的提示信息）：进入工单详情
     5 维修者获取好评：进入工单详情
     6 超时工单提醒：进入“特殊工单”的待处理列表（进行指派）
     7 收到无人响应：进入“特殊工单”的待处理列表（进行指派）
     8 您的工单已经开始维修了：进入工单详情
     **/
    NSDictionary *dic = datasource[indexPath.section];
    
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    NSString *notice_type = dic[@"notice_type"];
    
    if ([dic[@"handle_type"] isEqual:[NSString stringWithFormat:@"%@%@%@",companyInfo.company_id,notice_type,@"2"]])
    {
        // 抢单
        BXTReaciveOrdersViewController *reaciveVC = [[BXTReaciveOrdersViewController alloc] init];
        [self.navigationController pushViewController:reaciveVC animated:YES];
    }
    else if ([dic[@"handle_type"] isEqual:[NSString stringWithFormat:@"%@%@%@",companyInfo.company_id,notice_type,@"3"]] ||
             [dic[@"handle_type"] isEqual:[NSString stringWithFormat:@"%@%@%@",companyInfo.company_id,notice_type,@"4"]] ||
             [dic[@"handle_type"] isEqual:[NSString stringWithFormat:@"%@%@%@",companyInfo.company_id,notice_type,@"8"]])
    {
        //工单详情
        BXTRepairInfo *repairInfo = [[BXTRepairInfo alloc] init];
        repairInfo.repairID = dic[@"about_id"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
        BXTMaintenanceDetailViewController *repairDetailVC = (BXTMaintenanceDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTMaintenanceDetailViewController"];
        [repairDetailVC dataWithRepairID:[NSString stringWithFormat:@"%ld",(long)repairInfo.repairID]];
        [self.navigationController pushViewController:repairDetailVC animated:YES];    }
    else if ([dic[@"handle_type"] isEqual:[NSString stringWithFormat:@"%@%@%@",companyInfo.company_id,notice_type,@"1"]] ||
             [dic[@"handle_type"] isEqual:[NSString stringWithFormat:@"%@%@%@",companyInfo.company_id,notice_type,@"5"]])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
        BXTMaintenanceDetailViewController *repairDetailVC = (BXTMaintenanceDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTMaintenanceDetailViewController"];
        [repairDetailVC dataWithRepairID:dic[@"about_id"]];
        [self.navigationController pushViewController:repairDetailVC animated:YES];
    }
    else if ([dic[@"handle_type"] isEqual:[NSString stringWithFormat:@"%@%@%@",companyInfo.company_id,notice_type,@"6"]] ||
             [dic[@"handle_type"] isEqual:[NSString stringWithFormat:@"%@%@%@",companyInfo.company_id,notice_type,@"7"]])
    {
        // 特殊工单
        BXTManagerOMViewController *serviceVC = [[BXTManagerOMViewController alloc] init];
        [self.navigationController pushViewController:serviceVC animated:YES];
    }
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = (NSDictionary *)response;
    if (type == UpdateTime)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            NSDictionary *diction = datasource[selectSection];
            NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:diction];
            [muDic setObject:@"2" forKey:@"handle_state"];
            [datasource replaceObjectAtIndex:selectSection withObject:muDic];
            [currentTable reloadData];
        }
    }
    else
    {
        NSArray *array = [dic objectForKey:@"data"];
        if (array.count > 0)
        {
            [datasource addObjectsFromArray:array];
            [currentTable reloadData];
            currentPage++;
        }
        _isRequesting = NO;
    }
    [currentTable.mj_footer endRefreshing];
}

- (void)requestError:(NSError *)error
{
    _isRequesting = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
