//
//  BXTShopsHomeViewController.m
//  BXT
//
//  Created by Jason on 15/9/16.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTShopsHomeViewController.h"
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
    
    self.imgNameArray = [NSMutableArray array];
    [self.imgNameArray addObject:[NSMutableArray arrayWithObjects:@"home_calendar_add",@"home_Work_Order",nil]];
    [self.imgNameArray addObject:[NSMutableArray arrayWithObjects:@"home_lights",nil]];
    [self.imgNameArray addObject:[NSMutableArray arrayWithObjects:@"home_notepad_ok",nil]];
    [self.imgNameArray addObject:[NSMutableArray arrayWithObjects:@"home_statistics",nil]];
    
    self.titleNameArray = [NSMutableArray array];
    [self.titleNameArray addObject:[NSMutableArray arrayWithObjects:@"日常工单",@"维保工单",nil]];
    [self.titleNameArray addObject:[NSMutableArray arrayWithObjects:@"我的报修工单",nil]];
    [self.titleNameArray addObject:[NSMutableArray arrayWithObjects:@"其他事务",nil]];
    [self.titleNameArray addObject:[NSMutableArray arrayWithObjects:@"业务统计",nil]];
    
    NSString *power = [BXTGlobal getUserProperty:U_POWER];
    
    //如果不包含业务统计
    if (![power containsString:@"40101"] && ![power containsString:@"40102"] && ![power containsString:@"40103"] &&
        ![power containsString:@"40201"] && ![power containsString:@"40202"] && ![power containsString:@"40203"] &&
        ![power containsString:@"40300"] && ![power containsString:@"40403"] && ![power containsString:@"40404"])
    {
        [self.imgNameArray removeObjectAtIndex:3];
        [self.titleNameArray removeObjectAtIndex:3];
    }
    
    //如果不包含其他事物
    if (![power containsString:@"10305"])
    {
        [self.imgNameArray removeObjectAtIndex:2];
        [self.titleNameArray removeObjectAtIndex:2];
    }
    
    //如果日常工单和维保工单都不包含
    if (![power containsString:@"10200"] && ![power containsString:@"30201"])
    {
        [self.imgNameArray removeObjectAtIndex:0];
        [self.titleNameArray removeObjectAtIndex:0];
    }
    //如果不包含维保工单
    else if ([power containsString:@"10200"] && ![power containsString:@"30201"])
    {
        NSMutableArray *imageNameArray = self.imgNameArray[0];
        [imageNameArray removeObjectAtIndex:1];
        NSMutableArray *titleNameArray = self.titleNameArray[0];
        [titleNameArray removeObjectAtIndex:1];
    }
    //如果不包含日常工单
    else if (![power containsString:@"10200"] && [power containsString:@"30201"])
    {
        NSMutableArray *imageNameArray = self.imgNameArray[0];
        [imageNameArray removeObjectAtIndex:0];
        NSMutableArray *titleNameArray = self.titleNameArray[0];
        [titleNameArray removeObjectAtIndex:0];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if (tableView == self.currentTableView)
    {
        NSString *title = self.titleNameArray[indexPath.section][indexPath.row];
        if ([title isEqualToString:@"日常工单"])
        {
            [self pushNormalOrders];
        }
        else if ([title isEqualToString:@"维保工单"])
        {
            [self pushMaintenceOrders];
        }
        else if ([title isEqualToString:@"我的报修工单"])
        {
            [self pushMyOrdersIsRepair:NO];
        }
        else if ([title isEqualToString:@"其他事务"])
        {
            [self pushOtherAffair];
        }
        else if ([title isEqualToString:@"快捷抄表"])
        {
            [self pushQuickEnergyReading];
        }
        else if ([title isEqualToString:@"业务统计"])
        {
            [self pushStatistics];
        }
        else if ([title isEqualToString:@"项目热线"])
        {
            [self projectPhone];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
