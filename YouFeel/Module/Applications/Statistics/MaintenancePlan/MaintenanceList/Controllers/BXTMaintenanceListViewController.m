//
//  BXTMaintenanceListViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMaintenanceListViewController.h"
#import "BXTMTFilterViewController.h"

@interface BXTMaintenanceListViewController ()

@end

@implementation BXTMaintenanceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"全部维保任务" andRightTitle:@"  筛选" andRightImage:nil];
}

- (void)navigationRightButton
{
    BXTMTFilterViewController *filterVC = [[BXTMTFilterViewController alloc] init];
    [self.navigationController pushViewController:filterVC animated:YES];
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
