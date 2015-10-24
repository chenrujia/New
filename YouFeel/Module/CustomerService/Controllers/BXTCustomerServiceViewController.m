//
//  BXTCustomerServiceViewController.m
//  YouFeel
//
//  Created by Jason on 15/10/24.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTCustomerServiceViewController.h"
#import "BXTPublicSetting.h"

@interface BXTCustomerServiceViewController ()

@end

@implementation BXTCustomerServiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"客服" andRightTitle:nil andRightImage:nil];
    [self loadingViews];
}

- (void)loadingViews
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, KNAVIVIEWHEIGHT + 10.f, SCREEN_WIDTH - 20.f, (SCREEN_WIDTH - 20.f) * 1.12f)];
    imgView.image = [UIImage imageNamed:@"CustomerService"];
    [self.view addSubview:imgView];
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
