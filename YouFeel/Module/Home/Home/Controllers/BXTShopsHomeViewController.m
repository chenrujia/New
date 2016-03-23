//
//  BXTShopsHomeViewController.m
//  BXT
//
//  Created by Jason on 15/9/16.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTShopsHomeViewController.h"
#import "BXTWorkOderViewController.h"
#import "BXTHeadquartersInfo.h"
#import "BXTGlobal.h"
#import "BXTPublicSetting.h"

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
    
    self.imgNameArray = [NSMutableArray arrayWithObjects:@[@"home_calendar_add"],
                         @[@"home_my"],
                         @[@"home_lights"],
                         @[@"home_statistics"],
                        @[@"home_phone"], nil];
    self.titleNameArray = [NSMutableArray arrayWithObjects:@[@"我的工单" ],
                           @[@"我的评价" ],
                           @[@"特殊工单" ],
                           @[@"业务统计" ],
                           @[@"项目热线" ], nil];
    
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
    if (self.whichHidden == HiddenType_Both)
    {
        switch (indexPath.section) {
            case 0:
                [self pushMyOrders];
                break;
            case 1:
                [self pushEvaluationList];
                break;
            case 2:
                [self projectPhone];
                break;
            default: break;
        }
    }
    else if (self.whichHidden == HiddenType_SpecialOrders)
    {
        switch (indexPath.section) {
            case 0:
                [self pushMyOrders];
                break;
            case 1:
                [self pushEvaluationList];
                break;
            case 2:
                [self pushStatistics];
                break;
            case 3:
                [self projectPhone];
                break;
            default: break;
        }
    }
    else if (self.whichHidden == HiddenType_BusinessStatistics)
    {
        switch (indexPath.section) {
            case 0:
                [self pushMyOrders];
                break;
            case 1:
                [self pushEvaluationList];
                break;
            case 2:
                [self pushSpecialOrders];
                break;
            case 3:
                [self projectPhone];
                break;
            default: break;
        }
    }
    else {
        switch (indexPath.section) {
            case 0:
                [self pushNormalOrders];
                break;
            case 1:
                [self pushMaintenceOrders];
//                [self pushEvaluationList];
                break;
            case 2:
                [self pushSpecialOrders];
                break;
            case 3:
                [self pushStatistics];
                break;
            case 4:
                [self projectPhone];
                break;
            default: break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
