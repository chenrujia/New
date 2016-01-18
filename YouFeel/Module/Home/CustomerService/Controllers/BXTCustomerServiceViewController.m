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
    [self navigationSetting:@"项目热线" andRightTitle:nil andRightImage:nil];
    [self loadingViews];
}

- (void)loadingViews
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10.f, KNAVIVIEWHEIGHT + 10.f, SCREEN_WIDTH - 20.f, (SCREEN_WIDTH - 20.f) * 1.12f)];
    [button setBackgroundImage:[UIImage imageNamed:@"CustomerService"] forState:UIControlStateNormal];
    @weakify(self);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", @"4008937878"];
        UIWebView *callWeb = [[UIWebView alloc] init];
        [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
        [self.view addSubview:callWeb];
    }];
    [self.view addSubview:button];
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
