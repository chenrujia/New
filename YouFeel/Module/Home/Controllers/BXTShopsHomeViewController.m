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
#import "BXTChatListViewController.h"
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
    
    imgNameArray = [NSMutableArray arrayWithObjects:@"calendar",
                    @"user",
                    @"new",
                    @"hand",
                    @"specialOrder",
                    @"statistics",
                    @"notices",
                    @"list",
                    @"round", nil];
    titleNameArray = [NSMutableArray arrayWithObjects:@"新工单",@"我的工单",@"沟通记录",@"评价",@"特殊工单",@"业务统计",@"消息",@"意见反馈",@"关于我们", nil];
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
    if ([self is_verify]) {
        return;
    }
    BXTWorkOderViewController *workOrderVC = [[BXTWorkOderViewController alloc] init];
    [self.navigationController pushViewController:workOrderVC animated:YES];
}

#pragma mark -
#pragma mark 代理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *roleArray = [BXTGlobal getUserProperty:U_ROLEARRAY];
    
    switch (indexPath.row) {
        case 0:
        {
            if ([self is_verify]) {
                return;
            }
            // 新工单
            BXTRepairViewController *repairVC = [[BXTRepairViewController alloc] initWithVCType:ShopsVCType];
            [self.navigationController pushViewController:repairVC animated:YES];
        }
            break;
        case 1:
        {
            if ([self is_verify]) {
                return;
            }
            // 我的工单
            BXTOrderManagerViewController *orderManagerVC = [[BXTOrderManagerViewController alloc] init];
            [self.navigationController pushViewController:orderManagerVC animated:YES];
        }
            break;
        case 2:
        {
            if ([self is_verify]) {
                return;
            }
            // 沟通记录
            BXTChatListViewController *chatListViewController = [[BXTChatListViewController alloc]init];
            [self.navigationController pushViewController:chatListViewController animated:YES];
            self.navigationController.navigationBar.hidden = NO;
        }
            break;
        case 3:
        {
            if ([self is_verify]) {
                return;
            }
            // 评价
            BXTEvaluationListViewController *achievementVC = [[BXTEvaluationListViewController alloc] init];
            [self.navigationController pushViewController:achievementVC animated:YES];
        }
            break;
        case 4:
        {
            if ([self is_verify]) {
                return;
            }
            if (![roleArray containsObject:@"116"]) {
                [BXTGlobal showText:@"抱歉，您无查看权限" view:self.view completionBlock:nil];
                return;
            }
            // 特殊工单
            BXTManagerOMViewController *serviceVC = [[BXTManagerOMViewController alloc] init];
            [self.navigationController pushViewController:serviceVC animated:YES];
        }
            break;
        case 5:
        {
            if ([self is_verify]) {
                return;
            }
            if (![roleArray containsObject:@"114"]) {
                [BXTGlobal showText:@"抱歉，您无查看权限" view:self.view completionBlock:nil];
                return;
            }
            BXTStatisticsViewController *StatisticsVC = [[BXTStatisticsViewController alloc] init];
            [self.navigationController pushViewController:StatisticsVC animated:YES];
            
        }
            break;
        case 6:
        {
            if ([self is_verify]) {
                return;
            }
            // 消息
            BXTMessageListViewController *messageVC = [[BXTMessageListViewController alloc] initWithDataSourch:datasource];
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        case 7:
        {
            // 意见反馈
            BXTFeedbackViewController *feedbackVC = [[BXTFeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
        case 8:
        {
            // 关于我们
            BXTAboutUsViewController *aboutVC = [[BXTAboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
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
