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
    
    self.imgNameArray = [NSMutableArray arrayWithObjects:@[@"home_calendar_add",@"home_Work_Order"],
                         @[@"home_my", @"home_lights"],
                         @[@"home_notepad_ok", @"home_integral"],
                         @[@"home_statistics"],
                         @[@"home_phone"] ,nil];
    self.titleNameArray = [NSMutableArray arrayWithObjects:@[@"日常工单",@"维保工单"],
                           @[@"我的维修工单", @"我的报修工单"],
                           @[@"待处理事项", @"我的积分"],
                           @[@"业务统计"],
                           @[@"项目热线"], nil];
    
    
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
//    [self pushMyOrders];
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
    
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: [self pushNormalOrders]; break;
                case 1: [self pushMaintenceOrders]; break;
                default: break;
            }
        } break;
        case 1: {
            switch (indexPath.row) {
                case 0: [self pushMyOrdersIsRepair:YES]; break;
                case 1: [self pushMyOrdersIsRepair:NO]; break;
                default: break;
            }
        } break;
        case 2: {
            switch (indexPath.row) {
                case 0: [self pushSpecialOrders]; break;
                case 1: [self pushAchievements]; break;
                default: break;
            }
        } break;
        case 3:  [self pushStatistics]; break;
        case 4: [self projectPhone]; break;
        default: break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
