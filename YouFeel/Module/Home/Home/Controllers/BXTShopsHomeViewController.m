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
#import "BXTExaminationViewController.h"

typedef NS_ENUM(NSInteger, HiddenType) {
    HiddenType_SpecialOrders = 1,
    HiddenType_BusinessStatistics,
    HiddenType_Both
};

@interface BXTShopsHomeViewController ()

@property (nonatomic, assign) NSInteger whichHidden;

@end

@implementation BXTShopsHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    logoImgView.image = [UIImage imageNamed:@"Nav_Bar"];
    
    
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
    
#warning 改。。。。
//    NSArray *roleArray = [BXTGlobal getUserProperty:U_ROLEARRAY];
//    if (![roleArray containsObject:@"116"] && ![roleArray containsObject:@"114"])
//    {
//        [self.titleNameArray removeObject:@"特殊工单"];
//        [self.imgNameArray removeObject:@"Special_Orders"];
//        [self.titleNameArray removeObject:@"业务统计"];
//        [self.imgNameArray removeObject:@"Business_Statistics"];
//        self.whichHidden = HiddenType_Both;
//    }
//    else if (![roleArray containsObject:@"116"])
//    {
//        [self.titleNameArray removeObject:@"特殊工单"];
//        [self.imgNameArray removeObject:@"Special_Orders"];
//        self.whichHidden = HiddenType_SpecialOrders;
//    }
//    else if (![roleArray containsObject:@"114"])
//    {
//        [self.titleNameArray removeObject:@"业务统计"];
//        [self.imgNameArray removeObject:@"Business_Statistics"];
//        self.whichHidden = HiddenType_BusinessStatistics;
//    }
    
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
    // 我的工单
    BXTOrderManagerViewController *orderManagerVC = [[BXTOrderManagerViewController alloc] init];
    orderManagerVC.hidesBottomBarWhenPushed = YES;
    // 评价
    BXTEvaluationListViewController *achievementVC = [[BXTEvaluationListViewController alloc] init];
    achievementVC.hidesBottomBarWhenPushed = YES;
    // 特殊工单
    BXTManagerOMViewController *serviceVC = [[BXTManagerOMViewController alloc] init];
    serviceVC.hidesBottomBarWhenPushed = YES;
    // 业务统计
    BXTStatisticsViewController *statisticsVC = [[BXTStatisticsViewController alloc] init];
    statisticsVC.hidesBottomBarWhenPushed = YES;
    // 审批
    BXTExaminationViewController *examinationVC = [[BXTExaminationViewController alloc] init];
    examinationVC.hidesBottomBarWhenPushed = YES;
    
    switch (indexPath.section) {
        case 0:  {
            [self.navigationController pushViewController:orderManagerVC animated:YES];
        } break;
        case 1: {
            [self.navigationController pushViewController:achievementVC animated:YES];
        } break;
        case 2: {
            [self.navigationController pushViewController:serviceVC animated:YES];
        } break;
        case 3: {
            [self.navigationController pushViewController:statisticsVC animated:YES];
        } break;
        case 4: {
            [self.navigationController pushViewController:examinationVC animated:YES];
        } break;
        case 5: {
            NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", ValueFUD(@"shop_tel")];
            UIWebView *callWeb = [[UIWebView alloc] init];
            [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
            [self.view addSubview:callWeb];
        } break;
        default: break;
    }
    
//    if (self.whichHidden == HiddenType_Both) {
//        switch (indexPath.section) {
//            case 0:  {
//                [self.navigationController pushViewController:orderManagerVC animated:YES];
//            } break;
//            case 1: {
//                [self.navigationController pushViewController:achievementVC animated:YES];
//            } break;
//            case 2: {
//                [self.navigationController pushViewController:examinationVC animated:YES];
//            } break;
//            case 3: {
//                NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", ValueFUD(@"shop_tel")];
//                UIWebView *callWeb = [[UIWebView alloc] init];
//                [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
//                [self.view addSubview:callWeb];
//            } break;
//            default: break;
//        }
//    }
//    else if (self.whichHidden == HiddenType_SpecialOrders) {
//        switch (indexPath.section) {
//            case 0:  {
//                [self.navigationController pushViewController:orderManagerVC animated:YES];
//            } break;
//            case 1: {
//                [self.navigationController pushViewController:achievementVC animated:YES];
//            } break;
//            case 2: {
//                [self.navigationController pushViewController:statisticsVC animated:YES];
//            } break;
//            case 3: {
//                [self.navigationController pushViewController:examinationVC animated:YES];
//            } break;
//            case 4: {
//                NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", ValueFUD(@"shop_tel")];
//                UIWebView *callWeb = [[UIWebView alloc] init];
//                [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
//                [self.view addSubview:callWeb];
//            } break;
//            default: break;
//        }
//    }
//    else if (self.whichHidden == HiddenType_BusinessStatistics) {
//        switch (indexPath.section) {
//            case 0:  {
//                [self.navigationController pushViewController:orderManagerVC animated:YES];
//            } break;
//            case 1: {
//                [self.navigationController pushViewController:achievementVC animated:YES];
//            } break;
//            case 2: {
//                [self.navigationController pushViewController:serviceVC animated:YES];
//            } break;
//            case 3: {
//                [self.navigationController pushViewController:examinationVC animated:YES];
//            } break;
//            case 4: {
//                NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", ValueFUD(@"shop_tel")];
//                UIWebView *callWeb = [[UIWebView alloc] init];
//                [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
//                [self.view addSubview:callWeb];
//            } break;
//            default: break;
//        }
//    }
//    else {
//        switch (indexPath.section) {
//            case 0:  {
//                [self.navigationController pushViewController:orderManagerVC animated:YES];
//            } break;
//            case 1: {
//                [self.navigationController pushViewController:achievementVC animated:YES];
//            } break;
//            case 2: {
//                [self.navigationController pushViewController:serviceVC animated:YES];
//            } break;
//            case 3: {
//                [self.navigationController pushViewController:statisticsVC animated:YES];
//            } break;
//            case 4: {
//                [self.navigationController pushViewController:examinationVC animated:YES];
//            } break;
//            case 5: {
//                NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", ValueFUD(@"shop_tel")];
//                UIWebView *callWeb = [[UIWebView alloc] init];
//                [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
//                [self.view addSubview:callWeb];
//            } break;
//            default: break;
//        }
//    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
