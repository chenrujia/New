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
                    @"notebook",
                    @"user",
                    @"evaluation",
                    @"Notice",
                    @"News",
                    @"Feedback",
                    @"Cuetomer_service",
                    @"About_us", nil];
    titleNameArray = [NSMutableArray arrayWithObjects:@"新工单",@"我的工单",@"业务申请",@"评价",@"消息",@"沟通记录",@"意见反馈",@"客服",@"关于我们", nil];
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
    BXTWorkOderViewController *workOrderVC = [[BXTWorkOderViewController alloc] init];
    [self.navigationController pushViewController:workOrderVC animated:YES];
}

#pragma mark -
#pragma mark 代理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            BXTRepairViewController *repairVC = [[BXTRepairViewController alloc] initWithVCType:ShopsVCType];
            [self.navigationController pushViewController:repairVC animated:YES];
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
            BXTEvaluationListViewController *achievementVC = [[BXTEvaluationListViewController alloc] init];
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
            break;
        }
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
