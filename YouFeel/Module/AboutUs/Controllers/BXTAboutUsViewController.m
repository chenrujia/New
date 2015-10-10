//
//  BXTAboutUsViewController.m
//  BXT
//
//  Created by Jason on 15/10/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTAboutUsViewController.h"
#import "BXTHeaderForVC.h"

@interface BXTAboutUsViewController ()

@end

@implementation BXTAboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetting:@"关于我们" andRightTitle:nil andRightImage:nil];
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
