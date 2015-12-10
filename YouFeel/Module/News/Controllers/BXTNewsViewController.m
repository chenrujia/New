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
#import "BXTOrderDetailViewController.h"
#import "BXTReaciveOrdersViewController.h"
#import "BXTRepairDetailViewController.h"
#import "BXTManagerOMViewController.h"

@interface BXTNewsViewController ()<UITableViewDelegate,UITableViewDataSource,BXTDataResponseDelegate,BXTBoxSelectedTitleDelegate>
{
    UITableView *currentTable;
    NSMutableArray *datasource;
    NSArray *comeTimeArray;
    BXTSelectBoxView *boxView;
    NSInteger selectSection;
    
    UIView *bgView;
    UIDatePicker *datePicker;
    NSDate *originDate;
    NSTimeInterval timeInterval;
}

@end

@implementation BXTNewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"消息" andRightTitle:nil andRightImage:nil];
    [self createTableView];
    
    datasource = [NSMutableArray array];
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    for (NSString *timeStr in [BXTGlobal readFileWithfileName:@"arriveArray"]) {
        [timeArray addObject:[NSString stringWithFormat:@"%@分钟内", timeStr]];
    }
    [timeArray addObject:@"自定义"];
    comeTimeArray = timeArray;
    currentPage = 1;
    [self showLoadingMBP:@"努力加载中..."];
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
    
    if ([dic[@"handle_type"] isEqual:[NSString stringWithFormat:@"%@%@%@",companyInfo.company_id,notice_type,@"1"]] ||
        [dic[@"handle_type"] isEqual:[NSString stringWithFormat:@"%@%@%@",companyInfo.company_id,notice_type,@"2"]])
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
        repairInfo.repairID = [dic[@"about_id"] integerValue];
        BXTRepairDetailViewController *repairDetailVC = [[BXTRepairDetailViewController alloc] initWithRepair:repairInfo];
        [self.navigationController pushViewController:repairDetailVC animated:YES];
    }
    else if ([dic[@"handle_type"] isEqual:[NSString stringWithFormat:@"%@%@%@",companyInfo.company_id,notice_type,@"5"]])
    {
        BXTOrderDetailViewController *orderDetailVC = [[BXTOrderDetailViewController alloc] initWithRepairID:dic[@"about_id"]];
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
    else if ([dic[@"handle_type"] isEqual:[NSString stringWithFormat:@"%@%@%@",companyInfo.company_id,notice_type,@"6"]] ||
             [dic[@"handle_type"] isEqual:[NSString stringWithFormat:@"%@%@%@",companyInfo.company_id,notice_type,@"7"]])
    {
        // 特殊工单
        BXTManagerOMViewController *serviceVC = [[BXTManagerOMViewController alloc] init];
        [self.navigationController pushViewController:serviceVC animated:YES];
    }
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        if (datePicker)
        {
            [datePicker removeFromSuperview];
            datePicker = nil;
            [currentTable reloadData];
        }
        else
        {
            [UIView animateWithDuration:0.3f animations:^{
                [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
            }];
        }
        
        [view removeFromSuperview];
    }
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
        NSString *tempStr = (NSString *)obj;
        if ([tempStr isEqualToString:@"自定义"])
        {
            [self createDatePicker];
            return;
        }
        
        NSString *timeStr = [tempStr stringByReplacingOccurrencesOfString:@"分钟内" withString:@""];
        NSTimeInterval timer = [[NSDate date] timeIntervalSince1970] + [timeStr intValue]*60;
        timeStr = [NSString stringWithFormat:@"%.0f", timer];
        
        NSDictionary *dic = datasource[selectSection];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request updateTime:timeStr andRepairID:[dic objectForKey:@"about_id"]];
    }
}

#pragma mark -
#pragma mark - UIDatePicker
- (void)createDatePicker
{
    bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    bgView.tag = 101;
    [self.view addSubview:bgView];
    
    originDate = [NSDate date];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-50-40, SCREEN_WIDTH, 40)];
    titleLabel.backgroundColor = colorWithHexString(@"ffffff");
    titleLabel.text = @"请选择到达时间";
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame)-1, SCREEN_WIDTH-30, 1)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [bgView addSubview:line];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216-50, SCREEN_WIDTH, 216)];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    datePicker.backgroundColor = colorWithHexString(@"ffffff");
    datePicker.minimumDate = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
    [bgView addSubview:datePicker];
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    toolView.backgroundColor = colorWithHexString(@"ffffff");
    [bgView addSubview:toolView];
    // sure
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 50)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(datePickerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.tag = 10001;
    sureBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    sureBtn.layer.borderWidth = 0.5;
    [toolView addSubview:sureBtn];
    // cancel
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 50)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(datePickerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    cancelBtn.layer.borderWidth = 0.5;
    cancelBtn.tag = 10002;
    [toolView addSubview:cancelBtn];
}

- (void)dateChange:(UIDatePicker *)picker
{
    // 获取分钟数
    //timeInterval = [picker.date timeIntervalSinceDate:originDate];
    timeInterval = [picker.date timeIntervalSince1970];
}

- (void)datePickerBtnClick:(UIButton *)button
{
    if (button.tag == 10001)
    {
        NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)timeInterval];
        NSDictionary *dic = datasource[selectSection];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request updateTime:timeStr andRepairID:[dic objectForKey:@"about_id"]];
    }
    datePicker = nil;
    [bgView removeFromSuperview];
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
