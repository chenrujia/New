//
//  BXTRepairHomeViewController.m
//  BXT
//
//  Created by Jason on 15/9/16.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTRepairHomeViewController.h"
#import "BXTReaciveOrdersViewController.h"
#import "BXTOrderManagerViewController.h"
#import "BXTGrabOrderViewController.h"
#import "BXTAchievementsViewController.h"
#import "BXTEvaluationListViewController.h"
#import "BXTGlobal.h"
#import "BXTPublicSetting.h"
#import "BXTMessageListViewController.h"
#import "BXTFeedbackViewController.h"
#import "BXTCustomerServiceViewController.h"
#import "BXTAboutUsViewController.h"
#import "BXTRepairWordOrderViewController.h"
#import "BXTExaminationViewController.h"
#import "BXTManagerOMViewController.h"
#import "BXTNewOrderViewController.h"
#import "BXTMMOrderManagerViewController.h"
#import "BXTAuthorityListViewController.h"
#import "BXTSettingViewController.h"
#import "BXTReaciveOrdersViewController.h"

@interface BXTRepairHomeViewController ()

@end

@implementation BXTRepairHomeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    logoImgView.image = [UIImage imageNamed:@"Nav_Bars"];
    
    [logo_Btn setImage:[UIImage imageNamed:@"New_Ticket_icon"] forState:UIControlStateNormal];
    title_label.text = @"我的工单";
    
    [self addGrabAndAssignOrderNotifications];
    self.imgNameArray = [NSMutableArray arrayWithObjects:@"My_Orders",@[@"Day_Order",@"Maintenance_Orders"],@"My_Achievements",@"Project_Phone",nil];
    self.titleNameArray = [NSMutableArray arrayWithObjects:@"我的工单",@[@"日常工单",@"维保工单"],@"我的绩效",@"项目热线",nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    [shop_label setText:companyInfo.name];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([BXTGlobal shareGlobal].newsOrderIDs.count > 0)
    {
        for (NSInteger i = 0; i < [BXTGlobal shareGlobal].newsOrderIDs.count; i++)
        {
            sleep(1);
            [self comingNewRepairs];
        }
    }
}

- (void)addGrabAndAssignOrderNotifications
{
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"GrabOrder" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self comingNewRepairs];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"AssignOrderComing" object:nil] subscribeNext:^(id x) {
        if ([BXTGlobal shareGlobal].assignOrderIDs.count > [BXTGlobal shareGlobal].assignNumber)
        {
            @strongify(self);
            BXTNewOrderViewController *newOrderVC = [[BXTNewOrderViewController alloc] initWithIsAssign:NO andWithOrderID:nil];
            [self.navigationController pushViewController:newOrderVC animated:YES];
        }
    }];
}

#pragma mark -
#pragma mark 事件处理
- (void)repairClick
{
    if ([self is_verify])
    {
        return;
    }
    // 我的工单
    BXTOrderManagerViewController *orderManagerVC = [[BXTOrderManagerViewController alloc] init];
    [self.navigationController pushViewController:orderManagerVC animated:YES];
}

- (void)comingNewRepairs
{
    // 工单数 > 实时抢单页面数 -> 跳转
    BXTHeadquartersInfo *company = [BXTGlobal getUserProperty:U_COMPANY];
    if ([company.company_id isEqualToString:[BXTGlobal shareGlobal].newsShopID] &&
        [BXTGlobal shareGlobal].newsOrderIDs.count > [BXTGlobal shareGlobal].numOfPresented)
    {
        BXTGrabOrderViewController *grabOrderVC = [[BXTGrabOrderViewController alloc] init];
        [self.navigationController pushViewController:grabOrderVC animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        // 我的工单
        BXTOrderManagerViewController *orderManagerVC = [[BXTOrderManagerViewController alloc] init];
        orderManagerVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderManagerVC animated:YES];
        
    }
    else if (indexPath.section == 1)
    {
        
        if (indexPath.row == 0)
        {
            [BXTRemindNum sharedManager].timeStart_Daily = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            BXTReaciveOrdersViewController *reaciveVC = [[BXTReaciveOrdersViewController alloc] initWithTaskType:1];
            reaciveVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:reaciveVC animated:YES];
        }
        else
        {
            [BXTRemindNum sharedManager].timeStart_Inspectio = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            BXTReaciveOrdersViewController *reaciveVC = [[BXTReaciveOrdersViewController alloc] initWithTaskType:2];
            reaciveVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:reaciveVC animated:YES];
        }
    }
    else if (indexPath.section == 2)
    {
        // 我的绩效
        BXTAchievementsViewController *achievementVC = [[BXTAchievementsViewController alloc] init];
        achievementVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:achievementVC animated:YES];
    }
    else if (indexPath.section == 3)
    {
        BXTCustomerServiceViewController *csvc = [[BXTCustomerServiceViewController alloc] init];
        csvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:csvc animated:YES];
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
