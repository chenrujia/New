//
//  BXTShopsHomeViewController.m
//  BXT
//
//  Created by Jason on 15/9/16.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTShopsHomeViewController.h"
#import "BXTRepairViewController.h"
#import "BXTOrderManagerViewController.h"
#import "BXTExaminationViewController.h"
#import "BXTWorkOderViewController.h"
#import "BXTEvaluationListViewController.h"
#import "BXTHeadquartersInfo.h"
#import "BXTGlobal.h"
#import "BXTPublicSetting.h"
#import "BXTMessageListViewController.h"
#import "BXTFeedbackViewController.h"
#import "BXTCustomerServiceViewController.h"
#import "BXTAboutUsViewController.h"
#import "BXTAchievementsViewController.h"
#import "BXTManagerOMViewController.h"
#import "BXTStatisticsViewController.h"
#import "BXTGrabOrderViewController.h"

@interface BXTShopsHomeViewController ()

@end

@implementation BXTShopsHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IS_IPHONE6P)
    {
        logoImgView.image = [UIImage imageNamed:@"backgroundIphone6P"];
    }
    else if (IS_IPHONE6)
    {
        logoImgView.image = [UIImage imageNamed:@"backgroundIphone6"];
    }
    else if (IS_IPHONE5)
    {
        logoImgView.image = [UIImage imageNamed:@"backgroundIphone5s"];
    }
    else
    {
        logoImgView.image = [UIImage imageNamed:@"backgroundIphone4s"];
    }
    
    [logo_Btn setImage:[UIImage imageNamed:@"WarrantyIcon"] forState:UIControlStateNormal];
    title_label.text = @"我要报修";
    
    self.imgNameArray = [NSMutableArray arrayWithObjects:@"My_Orders",
                         @"My_Evaluation",
                         @"Special_Orders",
                         @"Business_Statistics",
                         @"My_Examination",
                         @"Project_Phone",nil];
    self.titleNameArray = [NSMutableArray arrayWithObjects:@"我的工单",
                           @"我的评价",
                           @"特殊工单",
                           @"业务统计",
                           @"我的审批",
                           @"项目热线",nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    [shop_label setText:companyInfo.name];
}

#pragma mark -
#pragma mark 事件处理
- (void)repairClick
{
    if ([self is_verify])
    {
        return;
    }
    // 新建工单
    BXTWorkOderViewController *workOrderVC = [[BXTWorkOderViewController alloc] init];
    [self.navigationController pushViewController:workOrderVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *roleArray = [BXTGlobal getUserProperty:U_ROLEARRAY];
    switch (indexPath.section) {
        case 0:
        {
            // 我的工单
            BXTOrderManagerViewController *orderManagerVC = [[BXTOrderManagerViewController alloc] init];
            orderManagerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderManagerVC animated:YES];
        }
            break;
        case 1:
        {
            // 评价
            BXTEvaluationListViewController *achievementVC = [[BXTEvaluationListViewController alloc] init];
            achievementVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:achievementVC animated:YES];
        }
            break;
        case 2:
        {
            if (![roleArray containsObject:@"116"])
            {
                [BXTGlobal showText:@"抱歉，您无查看权限" view:self.view completionBlock:nil];
                return;
            }
            // 特殊工单
            BXTManagerOMViewController *serviceVC = [[BXTManagerOMViewController alloc] init];
            serviceVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:serviceVC animated:YES];
        }
            break;
        case 3:
        {
            if (![roleArray containsObject:@"114"])
            {
                [BXTGlobal showText:@"抱歉，您无查看权限" view:self.view completionBlock:nil];
                return;
            }
            // 业务统计
            BXTStatisticsViewController *statisticsVC = [[BXTStatisticsViewController alloc] init];
            statisticsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:statisticsVC animated:YES];
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        {
            
        }
            break;
        default:
            break;
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
