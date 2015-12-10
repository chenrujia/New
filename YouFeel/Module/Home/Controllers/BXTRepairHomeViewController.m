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
#import "BXTChatListViewController.h"
#import "BXTRepairWordOrderViewController.h"
#import "BXTExaminationViewController.h"
#import "BXTManagerOMViewController.h"
#import "BXTNewOrderViewController.h"
#import "BXTStatisticsViewController.h"
#import "BXTMMOrderManagerViewController.h"
#import "BXTShopListViewController.h"

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
    
    if (IS_IPHONE6P)
    {
        logoImgView.image = [UIImage imageNamed:@"ReBackgroundsIphone6P"];
    }
    else if (IS_IPHONE6)
    {
        logoImgView.image = [UIImage imageNamed:@"ReBackgroundsIphone6"];
    }
    else if (IS_IPHONE5)
    {
        logoImgView.image = [UIImage imageNamed:@"ReBackgroundsIphone5s"];
    }
    else
    {
        logoImgView.image = [UIImage imageNamed:@"ReBackgroundsIphone4s"];
    }
    
    [logo_Btn setImage:[UIImage imageNamed:@"New_Ticket_icon"] forState:UIControlStateNormal];
    title_label.text = @"我的工单";
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comingNewRepairs) name:@"NewRepairComing" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assignOrderComing) name:@"AssignOrderComing" object:nil];
    imgNameArray = [NSMutableArray arrayWithObjects:@"grab_-one",
                    @"repair",
                    @"new",
                    @"square_-bars",
                    @"specialOrder",
                    @"statistics",
                    @"notices",
                    @"list",
                    @"round", nil];
    titleNameArray = [NSMutableArray arrayWithObjects:@"抢单",@"报修",@"沟通记录",@"我的绩效",@"特殊工单",@"业务统计",@"消息",@"意见反馈",@"关于我们", nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BXTHeadquartersInfo *company = [BXTGlobal getUserProperty:U_COMPANY];
    if ([company.company_id isEqualToString:[BXTGlobal shareGlobal].newsShopID] &&[BXTGlobal shareGlobal].newsOrderIDs.count > 0)
    {
        [self comingNewRepairs];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    [shop_btn setTitle:companyInfo.name forState:UIControlStateNormal];
    [shop_btn layoutIfNeeded];
    CGFloat padding = 20;
    CGFloat titleW = shop_btn.titleLabel.bounds.size.width;
    if ((SCREEN_WIDTH == 320 && titleW > 160) || (SCREEN_WIDTH == 375 && titleW > 210) || (SCREEN_WIDTH == 414 && titleW > 250) )
    {
        padding = 10;
    }
    [shop_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [shop_btn setImageEdgeInsets:UIEdgeInsetsMake(0, titleW+padding, 0, -titleW-padding)];
}

#pragma mark -
#pragma mark 事件处理
- (void)repairClick
{
    // 我的工单
    BXTOrderManagerViewController *orderManagerVC = [[BXTOrderManagerViewController alloc] init];
    [self.navigationController pushViewController:orderManagerVC animated:YES];
}

- (void)comingNewRepairs
{
    // 工单数 > 实时抢单页面数 -> 跳转
    if ([BXTGlobal shareGlobal].newsOrderIDs.count > [BXTGlobal shareGlobal].numOfPresented)
    {
        BXTGrabOrderViewController *grabOrderVC = [[BXTGrabOrderViewController alloc] init];
        [self.navigationController pushViewController:grabOrderVC animated:YES];
    }
}

- (void)assignOrderComing
{
    if ([BXTGlobal shareGlobal].assignOrderIDs.count > [BXTGlobal shareGlobal].assignNumber)
    {
        BXTNewOrderViewController *newOrderVC = [[BXTNewOrderViewController alloc] initWithIsAssign:NO andWithOrderID:nil];
        [self.navigationController pushViewController:newOrderVC animated:YES];
    }
}

#pragma mark -
#pragma mark 代理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *roleArray = [BXTGlobal getUserProperty:U_ROLEARRAY];
    
    switch (indexPath.row) {
        case 0:
        {
            // 抢单
            BXTReaciveOrdersViewController *reaciveVC = [[BXTReaciveOrdersViewController alloc] init];
            [self.navigationController pushViewController:reaciveVC animated:YES];
        }
            break;
        case 1:
        {
            // 报修
            //            BXTRepairWordOrderViewController *newOrderVC = [[BXTRepairWordOrderViewController alloc] init];
            BXTMMOrderManagerViewController *newOrderVC = [[BXTMMOrderManagerViewController alloc] init];
            [self.navigationController pushViewController:newOrderVC animated:YES];
        }
            break;
        case 2:
        {
            // 沟通记录
            BXTChatListViewController *chatListViewController = [[BXTChatListViewController alloc]init];
            [self.navigationController pushViewController:chatListViewController animated:YES];
            self.navigationController.navigationBar.hidden = NO;
        }
            break;
        case 3:
        {
            // 我的绩效
            BXTAchievementsViewController *achievementVC = [[BXTAchievementsViewController alloc] init];
            [self.navigationController pushViewController:achievementVC animated:YES];
        }
            break;
        case 4:
        {
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
            if (![roleArray containsObject:@"114"]) {
                [BXTGlobal showText:@"抱歉，您无查看权限" view:self.view completionBlock:nil];
                return;
            }
            BXTStatisticsViewController *StatisticsVC = [[BXTStatisticsViewController alloc] init];
            [self.navigationController pushViewController:StatisticsVC animated:YES];
            
            
//            NSArray *dataArray = [BXTGlobal getUserProperty:U_MYSHOP];
//            if (dataArray.count == 1) {
//                // 业务统计
//                NSDictionary *dict = dataArray[0];
//                BXTStatisticsViewController *StatisticsVC = [[BXTStatisticsViewController alloc] init];
//                NSString *url = [NSString stringWithFormat:@"http://api.51bxt.com/?c=Port&m=actionGet_iPhone_v2_Port&shop_id=%@", dict[@"id"]];
//                [BXTGlobal shareGlobal].BranchURL = url;
//                [self.navigationController pushViewController:StatisticsVC animated:YES];
//            } else {
//                // 商铺列表
//                BXTShopListViewController *shopListVC = [[BXTShopListViewController alloc] init];
//                [self.navigationController pushViewController:shopListVC animated:YES];
//            }
        }
            break;
        case 6:
        {
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
    
    // 业务申请
    //BXTExaminationViewController *examinationVC = [[BXTExaminationViewController alloc] init];
    //[self.navigationController pushViewController:examinationVC animated:YES];
    
    // 客服
    //BXTCustomerServiceViewController *serviceVC = [[BXTCustomerServiceViewController alloc] init];
    //[self.navigationController pushViewController:serviceVC animated:YES];
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
