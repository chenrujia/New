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
    [self.imgNameArray addObject:[NSMutableArray arrayWithObjects:@"home_lights",nil]];
    [self.imgNameArray addObject:[NSMutableArray arrayWithObjects:@"home_notepad_ok",nil]];
    [self.imgNameArray addObject:[NSMutableArray arrayWithObjects:@"home_statistics",nil]];
    [self.imgNameArray addObject:[NSMutableArray arrayWithObjects:@"home_phone",nil]];
    
    self.titleNameArray = [NSMutableArray array];
    [self.titleNameArray addObject:[NSMutableArray arrayWithObjects:@"我的报修工单",nil]];
    [self.titleNameArray addObject:[NSMutableArray arrayWithObjects:@"其他事务",nil]];
    [self.titleNameArray addObject:[NSMutableArray arrayWithObjects:@"业务统计",nil]];

    
    NSString *permissonKeys = [BXTGlobal getUserProperty:PERMISSIONKEYS];
    //如果不包含业务统计
    if (![permissonKeys containsString:@"9995"])
    {
        [self.imgNameArray removeObjectAtIndex:2];
        [self.titleNameArray removeObjectAtIndex:2];
    }
    //如果不包含其他事物
    if (![permissonKeys containsString:@"9994"])
    {
        [self.imgNameArray removeObjectAtIndex:1];
        [self.titleNameArray removeObjectAtIndex:1];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    [shop_label setText:companyInfo.name];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *permissonKeys = [BXTGlobal getUserProperty:PERMISSIONKEYS];
    if (indexPath.section == 0)
    {
        [self pushMyOrdersIsRepair:NO];
    }
    else if (indexPath.section == 1 && [permissonKeys containsString:@"9994"])
    {
        [self pushOtherAffair];
    }
    else if (indexPath.section == 1 && ![permissonKeys containsString:@"9994"] && [permissonKeys containsString:@"9995"])
    {
        [self pushStatistics];
    }
    else if (indexPath.section == 1 && ![permissonKeys containsString:@"9995"] && ![permissonKeys containsString:@"9995"])
    {
        [self projectPhone];
    }
    else if (indexPath.section == 2 && [permissonKeys containsString:@"9995"])
    {
        [self pushStatistics];
    }
    else if (indexPath.section == 2 && ![permissonKeys containsString:@"9995"])
    {
        [self projectPhone];
    }
    else if (indexPath.section == 3)
    {
        [self projectPhone];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
