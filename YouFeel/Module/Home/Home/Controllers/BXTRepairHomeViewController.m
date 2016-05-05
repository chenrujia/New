//
//  BXTRepairHomeViewController.m
//  BXT
//
//  Created by Jason on 15/9/16.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTRepairHomeViewController.h"
#import "BXTGrabOrderViewController.h"
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
    
    self.imgNameArray = [NSMutableArray array];
    [self.imgNameArray addObject:[NSMutableArray arrayWithObjects:@"home_calendar_add",@"home_Work_Order",nil]];
    [self.imgNameArray addObject:[NSMutableArray arrayWithObjects:@"home_my",@"home_lights",nil]];
    [self.imgNameArray addObject:[NSMutableArray arrayWithObjects:@"home_notepad_ok",nil]];
    [self.imgNameArray addObject:[NSMutableArray arrayWithObjects:@"home_integral",nil]];
    [self.imgNameArray addObject:[NSMutableArray arrayWithObjects:@"home_statistics",nil]];
    [self.imgNameArray addObject:[NSMutableArray arrayWithObjects:@"home_phone",nil]];
    
    self.titleNameArray = [NSMutableArray array];
    [self.titleNameArray addObject:[NSMutableArray arrayWithObjects:@"日常工单",@"维保工单",nil]];
    [self.titleNameArray addObject:[NSMutableArray arrayWithObjects:@"我的维修工单",@"我的报修工单",nil]];
    [self.titleNameArray addObject:[NSMutableArray arrayWithObjects:@"其他事务",nil]];
    [self.titleNameArray addObject:[NSMutableArray arrayWithObjects:@"我的积分",nil]];
    [self.titleNameArray addObject:[NSMutableArray arrayWithObjects:@"业务统计",nil]];
    
    
    NSString *permissonKeys = [BXTGlobal getUserProperty:PERMISSIONKEYS];
    //如果不包含业务统计
    if (![permissonKeys containsString:@"9995"])
    {
        [self.imgNameArray removeObjectAtIndex:4];
        [self.titleNameArray removeObjectAtIndex:4];
    }
    //如果不包含其他事物
    if (![permissonKeys containsString:@"9994"])
    {
        [self.imgNameArray removeObjectAtIndex:2];
        [self.titleNameArray removeObjectAtIndex:2];
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
    
    NSString *permissonKeys = [BXTGlobal getUserProperty:PERMISSIONKEYS];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [self pushNormalOrders];
        }
        else if (indexPath.row == 1)
        {
            [self pushMaintenceOrders];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            [self pushMyOrdersIsRepair:YES];
        }
        else if (indexPath.row == 1)
        {
            [self pushMyOrdersIsRepair:NO];
        }
    }
    else if (indexPath.section == 2 && [permissonKeys containsString:@"9994"])
    {
        [self pushOtherAffair];
    }
    else if (indexPath.section == 2 && ![permissonKeys containsString:@"9994"])
    {
        [self pushMyIntegral];
    }
    else if (indexPath.section == 3 && [permissonKeys containsString:@"9994"])
    {
        [self pushMyIntegral];
    }
    else if (indexPath.section == 3 && ![permissonKeys containsString:@"9994"] && [permissonKeys containsString:@"9995"])
    {
        [self pushStatistics];
    }
    else if (indexPath.section == 3 && ![permissonKeys containsString:@"9994"] && ![permissonKeys containsString:@"9995"])
    {
        [self projectPhone];
    }
    else if (indexPath.section == 4 && [permissonKeys containsString:@"9994"] && [permissonKeys containsString:@"9995"])
    {
        [self pushStatistics];
    }
    else if (indexPath.section == 4 && [permissonKeys containsString:@"9994"] && ![permissonKeys containsString:@"9995"])
    {
        [self projectPhone];
    }
    else if (indexPath.section == 4 && ![permissonKeys containsString:@"9994"])
    {
        [self projectPhone];
    }
    else if (indexPath.section == 5)
    {
        [self projectPhone];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
