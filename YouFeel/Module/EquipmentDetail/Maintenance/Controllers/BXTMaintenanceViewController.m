//
//  BXTMaintenanceViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/7.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMaintenanceViewController.h"

@interface BXTMaintenanceViewController ()

@end

@implementation BXTMaintenanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"维保作业" andRightTitle:nil andRightImage:nil];
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
