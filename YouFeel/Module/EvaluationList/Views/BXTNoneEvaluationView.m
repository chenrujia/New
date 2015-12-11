//
//  BXTNoneEvaluationView.m
//  YouFeel
//
//  Created by Jason on 15/10/15.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTNoneEvaluationView.h"
#import "BXTNoneEVInfo.h"
#import "BXTHeaderForVC.h"
#import "BXTNoneEVTableViewCell.h"
#import "BXTEvaluationViewController.h"
#import "UIView+Nav.h"
#import "BXTRepairInfo.h"
#import "BXTRepairDetailViewController.h"

@implementation BXTNoneEvaluationView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"EvaluateSuccess" object:nil];
        
        datasource = [NSMutableArray array];
        currentTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        currentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        currentTable.backgroundColor = colorWithHexString(@"eff3f6");
        [currentTable registerClass:[BXTNoneEVTableViewCell class] forCellReuseIdentifier:@"Cell"];
        currentTable.delegate = self;
        currentTable.dataSource = self;
        [self addSubview:currentTable];
        
        [self showLoadingMBP:@"努力加载中..."];
        [self requestData];
    }
    return self;
}

#pragma mark -
#pragma mark 事件
- (void)requestData
{
    [datasource removeAllObjects];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request evaluationListWithType:3];
}

- (void)evaluateClick:(UIButton *)btn
{
    BXTNoneEVInfo *evaInfo = datasource[btn.tag];
    BXTEvaluationViewController *evaVC = [[BXTEvaluationViewController alloc] initWithRepairID:evaInfo.evaID];
    [[self navigation] pushViewController:evaVC animated:YES];
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
    BXTNoneEVInfo *evaInfo = datasource[indexPath.section];
    if (evaInfo.fixed_pic.count)
    {
        return 247.f;
    }
    else
    {
        return 157.f;
    }
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
    BXTNoneEVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BXTNoneEVInfo *evaInfo = datasource[indexPath.section];
    
    cell.repairID.text = [NSString stringWithFormat:@"工单号：%@",evaInfo.orderid];
    cell.place.text = evaInfo.area;
    cell.cause.text = evaInfo.cause;
    cell.evaButton.tag = indexPath.section;
    [cell.evaButton addTarget:self action:@selector(evaluateClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell reloadImageBackView];
    if (evaInfo.fixed_pic.count)
    {
        //frame
        cell.line.frame = CGRectMake(10, 210.f, SCREEN_WIDTH - 20, 0.7f);
        
        cell.picsArray = evaInfo.fixed_pic;
        cell.repairState.text = [NSString stringWithFormat:@"状态：%@",evaInfo.state_name];
        cell.consumeTime.text = [NSString stringWithFormat:@"工时：%ld小时",(long)evaInfo.man_hours];
    }
    else
    {
        //frame
        cell.line.frame = CGRectMake(10, 122.f, SCREEN_WIDTH - 20, 0.7f);
        
        cell.repairState.text = [NSString stringWithFormat:@"状态：%@",evaInfo.state_name];
        cell.consumeTime.text = [NSString stringWithFormat:@"工时：%ld小时",(long)evaInfo.man_hours];
    }
    cell.repairState.frame = CGRectMake(15.f, CGRectGetMaxY(cell.line.frame) + 8.f, 100.f, 17.f);
    cell.consumeTime.frame = CGRectMake(SCREEN_WIDTH - 100.f - 15.f, CGRectGetMaxY(cell.line.frame) + 8.f, 100.f, 17.f);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTNoneEVInfo *evaInfo = datasource[indexPath.section];
    BXTRepairInfo *repairInfo = [[BXTRepairInfo alloc] init];
    repairInfo.repairID = [evaInfo.evaID integerValue];
    BXTRepairDetailViewController *repairDetailVC = [[BXTRepairDetailViewController alloc] initWithRepair:repairInfo];
    [[self navigation] pushViewController:repairDetailVC animated:YES];
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    LogRed(@"%@",dic);
    
    NSArray *array = [dic objectForKey:@"data"];
    for (NSDictionary *dictionary in array)
    {
        DCParserConfiguration *config = [DCParserConfiguration configuration];
        DCObjectMapping *text = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"evaID" onClass:[BXTNoneEVInfo class]];
        [config addObjectMapping:text];
        
        DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTNoneEVInfo class] andConfiguration:config];
        BXTNoneEVInfo *noneEvaInfo = [parser parseDictionary:dictionary];
        
        [datasource addObject:noneEvaInfo];
    }
    [currentTable reloadData];
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

@end
