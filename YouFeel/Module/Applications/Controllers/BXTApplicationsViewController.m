//
//  BXTApplicationsViewController.m
//  YouFeel
//
//  Created by Jason on 15/12/24.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTApplicationsViewController.h"
#import "BXTHeaderForVC.h"

@interface BXTApplicationsViewController ()

@end

@implementation BXTApplicationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"应用" andRightTitle:nil andRightImage:nil];
}

- (void)didReceiveMemoryWarning
{
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
