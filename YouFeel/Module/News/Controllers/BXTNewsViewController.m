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
#import "BXTSelectBoxView.h"
#import "MJRefresh.h"

@interface BXTNewsViewController ()<UITableViewDelegate,UITableViewDataSource,BXTDataResponseDelegate,BXTBoxSelectedTitleDelegate>
{
    UITableView *currentTable;
    NSMutableArray *datasource;
    NSArray *comeTimeArray;
    BXTSelectBoxView *boxView;
    NSInteger selectSection;
}

@end

@implementation BXTNewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"消息" andRightTitle:nil andRightImage:nil];
    [self createTableView];
    
    datasource = [NSMutableArray array];
    comeTimeArray = @[@"半小时内",@"1小时内",@"3小时内",@"6小时内"];
    currentPage = 1;
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request newsListWithPage:currentPage];
    _isRequesting = YES;
}

#pragma mark - 
#pragma mark 创建视图
- (void)createTableView
{
    currentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    currentTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    currentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    currentTable.backgroundColor = colorWithHexString(@"eff3f6");
    [currentTable registerClass:[BXTNewsTableViewCell class] forCellReuseIdentifier:@"Cell"];
    currentTable.delegate = self;
    currentTable.dataSource = self;
    [self.view addSubview:currentTable];
}

#pragma mark -
#pragma makr 事件
- (void)evaButtonClick:(UIButton *)btn
{
    selectSection = btn.tag;
    [self reaciveOrder];
}

- (void)reaciveOrder
{
    /**接单**/
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6f;
    backView.tag = 101;
    [self.view addSubview:backView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewTapAction:)];
    [backView addGestureRecognizer:tapGesture];
    [self.view addSubview:backView];
    
    if (boxView)
    {
        [boxView boxTitle:@"请选择到达时间" boxSelectedViewType:Other listDataSource:comeTimeArray];
        [self.view bringSubviewToFront:boxView];
    }
    else
    {
        boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:@"请选择到达时间" boxSelectedViewType:Other listDataSource:comeTimeArray markID:nil actionDelegate:self];
        [self.view addSubview:boxView];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH, 180.f)];
    }];
}

- (void)loadMoreData
{
    if (_isRequesting) return;
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request newsListWithPage:currentPage];
    _isRequesting = YES;
}

- (void)backViewTapAction:(UITapGestureRecognizer *)tap
{
    UIView *view = tap.view;
    [view removeFromSuperview];
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
    }];
}

#pragma mark -
#pragma mark 代理
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
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    NSString *str = [NSString stringWithFormat:@"%@21",companyInfo.company_id];
    if ([[dic objectForKey:@"handle_state"] integerValue] == 1 && [str isEqualToString:[dic objectForKey:@"handle_type"]])
    {
        cell.evaButton.hidden = NO;
        cell.evaButton.tag = indexPath.section;
        [cell.evaButton addTarget:self action:@selector(evaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        cell.evaButton.hidden = YES;
    }
    
    return cell;
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = (NSDictionary *)response;
    LogRed(@"%@",dic);
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
    [currentTable.footer endRefreshing];
}

- (void)requestError:(NSError *)error
{
    _isRequesting = NO;
}

- (void)boxSelectedObj:(id)obj selectedType:(BoxSelectedType)type
{
    UIView *view = [self.view viewWithTag:101];
    [view removeFromSuperview];
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
    }];
    
    if ([obj isKindOfClass:[NSString class]])
    {
        NSString *arrivalTime;
        NSString *tempStr = (NSString *)obj;
        if ([tempStr isEqualToString:@"半小时内"])
        {
            arrivalTime = @"1800";
        }
        else if ([tempStr isEqualToString:@"1小时内"])
        {
            arrivalTime = @"3600";
        }
        else if ([tempStr isEqualToString:@"3小时内"])
        {
            arrivalTime = @"10800";
        }
        else if ([tempStr isEqualToString:@"6小时内"])
        {
            arrivalTime = @"31600";
        }
        
        NSDictionary *dic = datasource[selectSection];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request updateTime:arrivalTime andRepairID:[dic objectForKey:@"about_id"]];
    }
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