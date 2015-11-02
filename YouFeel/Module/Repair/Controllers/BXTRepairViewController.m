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
#import "BXTRepairTableViewCell.h"
#import "BXTRepairDetailViewController.h"

@interface BXTRepairViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,BXTDataResponseDelegate>
{
    UITableView *currentTableView;
    NSMutableArray *repairListArray;
    NSInteger selectIndex;
}

@property (nonatomic ,assign) RepairVCType repairVCType;

@end

@implementation BXTRepairViewController

- (instancetype)initWithVCType:(RepairVCType)vcType
{
    self = [super init];
    if (self)
    {
        self.repairVCType = vcType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestReqairList) name:@"RequestRepairList" object:nil];
    
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
    [self requestReqairList];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createTableView
{
    currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 66.f) style:UITableViewStyleGrouped];
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
    [newBtn addTarget:self action:@selector(newRepairClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:newBtn];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21.f, 21.f)];
    imgView.image = [UIImage imageNamed:@"Small_buttons"];
    [imgView setCenter:CGPointMake(newBtn.bounds.size.width/2.f - 24.f, newBtn.bounds.size.height/2.f)];
    [newBtn addSubview:imgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80.f, 40.f)];
    titleLabel.text = @"新建工单";
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.textColor = colorWithHexString(@"3cafff");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = CGPointMake(newBtn.bounds.size.width/2.f + 22.f, 20.f);
    [newBtn addSubview:titleLabel];
    
    [self.view addSubview:backView];
}

#pragma mark -
#pragma mark 事件处理
- (void)requestReqairList
{
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairList:@"0" andPage:1 andIsMaintenanceMan:NO];
}

- (void)newRepairClick
{
    if (_repairVCType == ShopsVCType)
    {
        BXTWorkOderViewController *workOderVC = [[BXTWorkOderViewController alloc] init];
        [self.navigationController pushViewController:workOderVC animated:YES];
    }
    else
    {
        BXTRepairWordOrderViewController *workOderVC = [[BXTRepairWordOrderViewController alloc] init];
        [self.navigationController pushViewController:workOderVC animated:YES];
    }
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
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
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
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
            [alert show];
        }
    }
    else
    {
        [self showMBP:@"此工单正在进行中，不允许删除!" withBlock:nil];
    }
}

#pragma mark -
#pragma mark 代理
/**
 *  UITableViewDelegate & UITableViewDatasource
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 16.f;//section头部高度
    }
    return 10.f;//section头部高度
}
//section头部视图
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
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.f;
}
//section底部视图
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
    cell.name.text = [NSString stringWithFormat:@"报修人:%@",repairInfo.fault];
    cell.cause.text = [NSString stringWithFormat:@"故障描述:%@",repairInfo.faulttype_name];
    NSString *str;
    NSRange range;
    if (repairInfo.urgent == 2)
    {
        str = @"等级:一般";
        range = [str rangeOfString:@"一般"];
    }
    else if (repairInfo.urgent == 1)
    {
        str = @"等级:紧急";
        range = [str rangeOfString:@"紧急"];
    }
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
    cell.level.attributedText = attributeStr;
    
    NSArray *usersArray = repairInfo.repair_user;
    NSString *components = [usersArray componentsJoinedByString:@","];
    cell.state.text = components;
    cell.repairState.text = repairInfo.receive_state;
    
    cell.tag = indexPath.section;
    if (repairInfo.repairstate == 3)
    {
        [cell.cancelRepair setTitleColor:colorWithHexString(@"e2e6e8") forState:UIControlStateNormal];
        cell.cancelRepair.userInteractionEnabled = NO;
    }
    else
    {
        [cell.cancelRepair setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
        cell.cancelRepair.userInteractionEnabled = YES;
    }
    [cell.cancelRepair addTarget:self action:@selector(cancelRepair:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTRepairInfo *repairInfo = [repairListArray objectAtIndex:indexPath.section];
    BXTRepairDetailViewController *repairDetailVC = [[BXTRepairDetailViewController alloc] initWithRepair:repairInfo];
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

/**
 *  DZNEmptyDataSetDelegate & DZNEmptyDataSetSource
 */
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"new_ticke_ticon"];
}

/**
 *  请求返回代理
 */
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == RepairList && data.count)
    {
        [repairListArray removeAllObjects];
        for (NSDictionary *dictionary in data)
        {
            DCParserConfiguration *config = [DCParserConfiguration configuration];
            DCObjectMapping *map = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"repairID" onClass:[BXTRepairInfo class]];
            [config addObjectMapping:map];
            
            DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTRepairInfo class] andConfiguration:config];
            BXTRepairInfo *repairInfo = [parser parseDictionary:dictionary];
            
            [repairListArray addObject:repairInfo];
        }
        [currentTableView reloadData];
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
