//
//  BXTRepairViewController.m
//  BXT
//
//  Created by Jason on 15/8/31.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTRepairViewController.h"
#import "BXTHeaderForVC.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BXTWorkOderViewController.h"
#import "BXTRepairWordOrderViewController.h"
#import "BXTRepairInfo.h"
#import "MJRefresh.h"
#import "BXTRepairTableViewCell.h"
#import "BXTMaintenanceDetailViewController.h"

@interface BXTRepairViewController () <UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,BXTDataResponseDelegate>
{
    UITableView    *currentTableView;
    NSMutableArray *repairListArray;
    NSInteger      selectIndex;
    NSInteger      currentPage;
}

@property (nonatomic ,assign) RepairVCType repairVCType;
@property (nonatomic ,assign) BOOL         isRequesting;

@end

@implementation BXTRepairViewController

- (instancetype)initWithVCType:(RepairVCType)vcType
{
    self = [super init];
    if (self)
    {
        self.repairVCType = vcType;
        currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RequestRepairList" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self loadNewData];
    }];
    
    repairListArray = [[NSMutableArray alloc] init];
    if (_repairVCType == ShopsVCType)
    {
        [self navigationSetting:@"我要报修" andRightTitle:nil andRightImage:nil];
    }
    else
    {
        [self navigationSetting:@"工单管理" andRightTitle:nil andRightImage:nil];
    }
    [self createTableView];
    [self loadNewData];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createTableView
{
    currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 66.f) style:UITableViewStyleGrouped];
    __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    currentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    currentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置了底部inset
    currentTableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    // 忽略掉底部inset
    currentTableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
    currentTableView.mj_footer.ignoredScrollViewContentInsetBottom = 40.f;
    [currentTableView registerClass:[BXTRepairTableViewCell class] forCellReuseIdentifier:@"RepairCell"];
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    currentTableView.emptyDataSetDelegate = self;
    currentTableView.emptyDataSetSource = self;
    [self.view addSubview:currentTableView];
    
    [self createNewRepair];
}

- (void)createNewRepair
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 66.f, SCREEN_WIDTH, 66.f)];
    backView.backgroundColor = colorWithHexString(@"e0e0e0");
    
    UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [newBtn setFrame:CGRectMake(40.f, 13.f, SCREEN_WIDTH - 80.f, 40.f)];
    newBtn.layer.masksToBounds = YES;
    newBtn.layer.cornerRadius = 4.f;
    newBtn.backgroundColor = colorWithHexString(@"ffffff");
    @weakify(self);
    [[newBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.repairVCType == ShopsVCType)
        {
            BXTWorkOderViewController *workOderVC = [[BXTWorkOderViewController alloc] init];
            [self.navigationController pushViewController:workOderVC animated:YES];
        }
        else
        {
            BXTRepairWordOrderViewController *workOderVC = [[BXTRepairWordOrderViewController alloc] init];
            [self.navigationController pushViewController:workOderVC animated:YES];
        }
    }];
    [backView addSubview:newBtn];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21.f, 21.f)];
    imgView.image = [UIImage imageNamed:@"Small_buttons"];
    [imgView setCenter:CGPointMake(newBtn.bounds.size.width/2.f - 24.f, newBtn.bounds.size.height/2.f)];
    [newBtn addSubview:imgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80.f, 40.f)];
    titleLabel.text = @"新建工单";
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    titleLabel.textColor = colorWithHexString(@"3cafff");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = CGPointMake(newBtn.bounds.size.width/2.f + 22.f, 20.f);
    [newBtn addSubview:titleLabel];
    
    [self.view addSubview:backView];
}

#pragma mark -
#pragma mark 事件处理
- (void)navigationLeftButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadNewData
{
    if (_isRequesting) return;
    
    [repairListArray removeAllObjects];
    [currentTableView reloadData];
    
    refreshType = RefreshDown;
    currentPage = 1;
    [self showLoadingMBP:@"努力加载中..."];
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairsList:@"0"
                 andPage:currentPage
     andIsMaintenanceMan:NO
    andRepairerIsReacive:@""];
    _isRequesting = YES;
}

- (void)loadMoreData
{
    if (_isRequesting) return;
    
    refreshType = RefreshUp;
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairsList:@"0"
                 andPage:currentPage
     andIsMaintenanceMan:NO
    andRepairerIsReacive:@""];
    _isRequesting = YES;
}

- (void)cancelRepair:(UIButton *)btn
{
    selectIndex = btn.tag;
    BXTRepairInfo *repairInfo = repairListArray[selectIndex];
    if (repairInfo.repairstate == 1)
    {
        if (IS_IOS_8)
        {
            UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"您确定要取消此工单?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertCtr addAction:cancelAction];
            @weakify(self);
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                @strongify(self);
                /**删除工单**/
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request deleteRepair:[NSString stringWithFormat:@"%ld",(long)repairInfo.repairID]];
            }];
            [alertCtr addAction:doneAction];
            [self presentViewController:alertCtr animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要取消此工单?"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
            @weakify(self);
            [[alert rac_buttonClickedSignal] subscribeNext:^(id x) {
                @strongify(self);
                if ([x integerValue] == 1)
                {
                    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                    [request deleteRepair:[NSString stringWithFormat:@"%ld",(long)repairInfo.repairID]];
                }
            }];
            [alert show];
        }
    }
    else
    {
        [self showMBP:@"此工单正在进行中，不允许删除!" withBlock:nil];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 16.f;//section头部高度
    }
    return 10.f;//section头部高度
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (section == 0)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16.f)];
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
    return 236.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [repairListArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTRepairTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepairCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BXTRepairInfo *repairInfo = [repairListArray objectAtIndex:indexPath.section];
    cell.repairID.text = [NSString stringWithFormat:@"工单号:%@",repairInfo.orderid];
    cell.time.text = repairInfo.repair_time;
    cell.place.text = [NSString stringWithFormat:@"位置:%@",repairInfo.area];
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
    cell.repairState.text = repairInfo.receive_state;
    
    cell.tag = indexPath.section;
    if (repairInfo.repairstate != 1)
    {
        cell.cancelRepair.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
        [cell.cancelRepair setTitleColor:colorWithHexString(@"e2e6e8") forState:UIControlStateNormal];
        cell.cancelRepair.userInteractionEnabled = NO;
    }
    else
    {
        cell.cancelRepair.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
        [cell.cancelRepair setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
        cell.cancelRepair.userInteractionEnabled = YES;
    }
    [cell.cancelRepair addTarget:self action:@selector(cancelRepair:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTRepairInfo *repairInfo = [repairListArray objectAtIndex:indexPath.section];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
    BXTMaintenanceDetailViewController *repairDetailVC = (BXTMaintenanceDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTMaintenanceDetailViewController"];
    [repairDetailVC dataWithRepairID:[NSString stringWithFormat:@"%ld",(long)repairInfo.repairID]];
    [self.navigationController pushViewController:repairDetailVC animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        BXTRepairInfo *repairInfo = repairListArray[selectIndex];
        /**删除工单**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request deleteRepair:[NSString stringWithFormat:@"%ld",(long)repairInfo.repairID]];
    }
}

#pragma mark -
#pragma mark DZNEmptyDataSetDelegate & DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"new_ticke_ticon"];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == RepairList)
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
        
        if (refreshType == RefreshDown)
        {
            [repairListArray removeAllObjects];
            [repairListArray addObjectsFromArray:tempArray];
        }
        else if (refreshType == RefreshUp)
        {
            [repairListArray addObjectsFromArray:[[tempArray reverseObjectEnumerator] allObjects]];
        }
        currentPage++;
        [currentTableView reloadData];
        _isRequesting = NO;
        [currentTableView.mj_header endRefreshing];
        [currentTableView.mj_footer endRefreshing];
    }
    else if (type == DeleteRepair)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [repairListArray removeObjectAtIndex:selectIndex];
            [currentTableView reloadData];
            [self showMBP:@"删除成功!" withBlock:nil];
        }
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
    _isRequesting = NO;
    [currentTableView.mj_header endRefreshing];
    [currentTableView.mj_footer endRefreshing];
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
