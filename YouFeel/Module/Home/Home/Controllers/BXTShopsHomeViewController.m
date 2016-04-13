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
    
    
    self.imgNameArray = [NSMutableArray arrayWithObjects:@[@"home_calendar_add",@"home_Work_Order"],
                         @[@"home_my", @"home_lights"],
                         @[@"home_notepad_ok"],
                         @[@"home_integral"],
                         @[@"home_statistics"],
                         @[@"home_phone"] ,nil];
    self.titleNameArray = [NSMutableArray arrayWithObjects:@[@"日常工单",@"维保工单"],
                           @[@"我的维修工单", @"我的报修工单"],
                           @[@"其他事务"],
                           @[@"我的积分"],
                           @[@"业务统计"],
                           @[@"项目热线"], nil];
    
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
        case 2: [self pushOtherAffair]; break;
        case 3: [self pushMyIntegral]; break;
        case 4: [self pushStatistics]; break;
        case 5: [self projectPhone]; break;
        default: break;
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
