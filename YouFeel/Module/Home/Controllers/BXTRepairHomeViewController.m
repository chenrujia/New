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
//#import "BXTNewOrderViewController.h"
#import "BXTGlobal.h"
#import "BXTPublicSetting.h"
#import "BXTMessageListViewController.h"
#import "BXTFeedbackViewController.h"
#import "BXTCustomerServiceViewController.h"
#import "BXTAboutUsViewController.h"
#import "BXTChatListViewController.h"
#import "BXTRepairWordOrderViewController.h"
#import "BXTExaminationViewController.h"

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
    title_label.text = @"我的新工单";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comingNewRepairs) name:@"NewRepairComing" object:nil];

    imgNameArray = [NSMutableArray arrayWithObjects:@"grab_one",
                    @"notebook",
                    @"user",
                    @"evaluation",
                    @"Notice",
                    @"News",
                    @"Feedback",
                    @"Cuetomer_service",
                    @"About_us", nil];
    titleNameArray = [NSMutableArray arrayWithObjects:@"抢单",@"我的工单",@"业务申请",@"我的绩效",@"消息",@"会话",@"反馈",@"客服",@"关于", nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BXTHeadquartersInfo *company = [BXTGlobal getUserProperty:U_COMPANY];
    if ([company.company_id isEqualToString:[BXTGlobal shareGlobal].newsShopID] &&[BXTGlobal shareGlobal].orderIDs.count > 0)
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
    if ((SCREEN_WIDTH == 320 && titleW > 160) || (SCREEN_WIDTH == 375 && titleW > 210) || (SCREEN_WIDTH == 414 && titleW > 250) ) {
        padding = 10;
    }
    [shop_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [shop_btn setImageEdgeInsets:UIEdgeInsetsMake(0, titleW+padding, 0, -titleW-padding)];
}

#pragma mark -
#pragma mark 事件处理
- (void)repairClick
{
    BXTRepairWordOrderViewController *newOrderVC = [[BXTRepairWordOrderViewController alloc] init];
    [self.navigationController pushViewController:newOrderVC animated:YES];
}

- (void)comingNewRepairs
{
    BXTGrabOrderViewController *grabOrderVC = [[BXTGrabOrderViewController alloc] init];
    [self.navigationController pushViewController:grabOrderVC animated:YES];
}

#pragma mark -
#pragma mark 代理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            BXTReaciveOrdersViewController *reaciveVC = [[BXTReaciveOrdersViewController alloc] init];
            [self.navigationController pushViewController:reaciveVC animated:YES];
        }
            break;
        case 1:
        {
            BXTOrderManagerViewController *orderManagerVC = [[BXTOrderManagerViewController alloc] init];
            [self.navigationController pushViewController:orderManagerVC animated:YES];
        }
            break;
        case 2:
        {
            BXTExaminationViewController *examinationVC = [[BXTExaminationViewController alloc] init];
            [self.navigationController pushViewController:examinationVC animated:YES];
        }
            break;
        case 3:
        {
            BXTAchievementsViewController *achievementVC = [[BXTAchievementsViewController alloc] init];
            [self.navigationController pushViewController:achievementVC animated:YES];
        }
            break;
        case 4:
        {
            BXTMessageListViewController *messageVC = [[BXTMessageListViewController alloc] initWithDataSourch:datasource];
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        case 5:
        {
            BXTChatListViewController *chatListViewController = [[BXTChatListViewController alloc]init];
            [self.navigationController pushViewController:chatListViewController animated:YES];
            self.navigationController.navigationBar.hidden = NO;
        }
            break;
        case 6:
        {
            BXTFeedbackViewController *feedbackVC = [[BXTFeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
        case 7:
        {
            BXTCustomerServiceViewController *serviceVC = [[BXTCustomerServiceViewController alloc] init];
            [self.navigationController pushViewController:serviceVC animated:YES];
        }
            break;
        case 8:
        {
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
