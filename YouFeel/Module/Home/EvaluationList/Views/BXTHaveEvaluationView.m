//
//  BXTHaveEvaluationView.m
//  YouFeel
//
//  Created by Jason on 15/10/15.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTHaveEvaluationView.h"
#import "BXTHeaderForVC.h"
#import "BXTHaveEVTableViewCell.h"
#import "BXTNoneEVInfo.h"
#import "UIView+Nav.h"
#import "BXTRepairInfo.h"
#import "BXTMaintenanceDetailViewController.h"

@implementation BXTHaveEvaluationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        @weakify(self);
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"EvaluateSuccess" object:nil] subscribeNext:^(id x) {
            @strongify(self);
            [self requestData];
        }];
        
        datasource = [NSMutableArray array];
        currentTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        currentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        currentTable.backgroundColor = colorWithHexString(@"eff3f6");
        [currentTable registerClass:[BXTHaveEVTableViewCell class] forCellReuseIdentifier:@"Cell"];
        currentTable.delegate = self;
        currentTable.dataSource = self;
        currentTable.emptyDataSetDelegate = self;
        currentTable.emptyDataSetSource = self;
        [self addSubview:currentTable];
        
        [self showLoadingMBP:@"努力加载中..."];
        [self requestData];
    }
    return self;
}

- (void)requestData
{
    [datasource removeAllObjects];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request evaluationListWithType:5];
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
    return 200.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return datasource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTHaveEVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BXTNoneEVInfo *evaInfo = datasource[indexPath.section];
    
    cell.repairID.text = [NSString stringWithFormat:@"工单号：%@",evaInfo.orderid];
    cell.place.text = evaInfo.area;
    cell.cause.text = evaInfo.cause;
    cell.notes.text = [NSString stringWithFormat:@"备注：%@",evaInfo.evaluation_notes];
    [cell.ratingControl setRating:evaInfo.general_praise];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTNoneEVInfo *evaInfo = datasource[indexPath.section];
    BXTRepairInfo *repairInfo = [[BXTRepairInfo alloc] init];
    repairInfo.repairID = evaInfo.evaID;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
    BXTMaintenanceDetailViewController *repairDetailVC = (BXTMaintenanceDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTMaintenanceDetailViewController"];
    [repairDetailVC dataWithRepairID:repairInfo.repairID];
    [[self navigation] pushViewController:repairDetailVC animated:YES];}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideTheMBP];
    NSDictionary *dic = response;    
    NSArray *array = [dic objectForKey:@"data"];
    [BXTNoneEVInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"evaID":@"id"};
    }];
    [datasource addObjectsFromArray:[BXTNoneEVInfo mj_objectArrayWithKeyValuesArray:array]];
    [currentTable reloadData];
}

- (void)requestError:(NSError *)error
{
    [self hideTheMBP];
}

#pragma mark -
#pragma mark DZNEmptyDataSetDelegate & DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无已评价工单";
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor blackColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
