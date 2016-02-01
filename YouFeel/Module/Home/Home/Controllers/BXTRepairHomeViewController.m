//
//  BXTRepairHomeViewController.m
//  BXT
//
//  Created by Jason on 15/9/16.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTRepairHomeViewController.h"
#import "BXTGrabOrderViewController.h"
#import "BXTNewOrderViewController.h"
#import "BXTGlobal.h"
#import "BXTPublicSetting.h"

@interface BXTRepairHomeViewController ()

@property (nonatomic, assign) NSInteger whichHidden;

@end

@implementation BXTRepairHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    logoImgView.image = [UIImage imageNamed:@"Nav_Bar"];
    [logo_Btn setImage:[UIImage imageNamed:@"New_Ticket_icon"] forState:UIControlStateNormal];
    title_label.text = @"我的工单";
    
    self.imgNameArray = [NSMutableArray arrayWithObjects:@"My_Orders",
                         @[@"Day_Order",@"Maintenance_Orders"],
                         @"Special_Orders",
                         @"Business_Statistics",
                         @"My_Achievements",
                         @"Project_Phone",nil];
    self.titleNameArray = [NSMutableArray arrayWithObjects:@"我的工单",
                           @[@"日常工单",@"维保工单"],
                           @"特殊工单",
                           @"业务统计",
                           @"我的绩效",
                           @"项目热线",nil];
    
    NSArray *roleArray = [BXTGlobal getUserProperty:U_ROLEARRAY];
    if (![roleArray containsObject:@"116"] && ![roleArray containsObject:@"114"])
    {
        [self.titleNameArray removeObject:@"特殊工单"];
        [self.imgNameArray removeObject:@"Special_Orders"];
        [self.titleNameArray removeObject:@"业务统计"];
        [self.imgNameArray removeObject:@"Business_Statistics"];
        self.whichHidden = HiddenType_Both;
    }
    else if (![roleArray containsObject:@"116"])
    {
        [self.titleNameArray removeObject:@"特殊工单"];
        [self.imgNameArray removeObject:@"Special_Orders"];
        self.whichHidden = HiddenType_SpecialOrders;
    }
    else if (![roleArray containsObject:@"114"])
    {
        [self.titleNameArray removeObject:@"业务统计"];
        [self.imgNameArray removeObject:@"Business_Statistics"];
        self.whichHidden = HiddenType_BusinessStatistics;
    }
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

#pragma mark -
#pragma mark 事件处理
- (void)repairClick
{
    if ([self is_verify])
    {
        return;
    }
    [self pushMyOrders];
}

- (void)comingNewRepairs
{
    // 工单数 > 实时抢单页面数 -> 跳转
    BXTHeadquartersInfo *company = [BXTGlobal getUserProperty:U_COMPANY];
    if ([company.company_id isEqualToString:[BXTGlobal shareGlobal].newsShopID] &&
        [BXTGlobal shareGlobal].newsOrderIDs.count > [BXTGlobal shareGlobal].numOfPresented)
    {
        BXTGrabOrderViewController *grabOrderVC = [[BXTGrabOrderViewController alloc] init];
        grabOrderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:grabOrderVC animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.whichHidden == HiddenType_Both)
    {
        switch (indexPath.section)
        {
            case 0:
                [self pushMyOrders];
                break;
            case 1:
                if (indexPath.row == 0)
                {
                    [self pushNormalOrders];
                }
                else
                {
                    [self pushMaintenceOrders];
                }
                break;
            case 2:
                [self pushAchievements];
                break;
            case 3:
                [self projectPhone];
                break;
            default:
                break;
        }
    }
    else if (self.whichHidden == HiddenType_SpecialOrders)
    {
        switch (indexPath.section)
        {
            case 0:
                [self pushMyOrders];
                break;
            case 1:
                if (indexPath.row == 0)
                {
                    [self pushNormalOrders];
                }
                else
                {
                    [self pushMaintenceOrders];
                }
                break;
            case 2:
                [self pushStatistics];
                break;
            case 3:
                [self pushAchievements];
                break;
            case 4:
                [self projectPhone];
                break;
            default:
                break;
        }
    }
    else if (self.whichHidden == HiddenType_BusinessStatistics)
    {
        switch (indexPath.section)
        {
            case 0:
                [self pushMyOrders];
                break;
            case 1:
                if (indexPath.row == 0)
                {
                    [self pushNormalOrders];
                }
                else
                {
                    [self pushMaintenceOrders];
                }
                break;
            case 2:
                [self pushSpecialOrders];
                break;
            case 3:
                [self pushAchievements];
                break;
            case 4:
                [self projectPhone];
                break;
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.section)
        {
            case 0:
                [self pushMyOrders];
                break;
            case 1:
                if (indexPath.row == 0)
                {
                    [self pushNormalOrders];
                }
                else
                {
                    [self pushMaintenceOrders];
                }
                break;
            case 2:
                [self pushSpecialOrders];
                break;
            case 3:
                [self pushStatistics];
                break;
            case 4:
                [self pushAchievements];
                break;
            case 5:
                [self projectPhone];
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
