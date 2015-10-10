//
//  BXTMMOrderManagerViewController.m
//  BXT
//
//  Created by Jason on 15/10/8.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTMMOrderManagerViewController.h"
#import "BXTRepairWordOrderViewController.h"
#import "BXTHeaderForVC.h"

@interface BXTMMOrderManagerViewController ()

@end

@implementation BXTMMOrderManagerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"工单管理" andRightTitle:nil andRightImage:nil];
    [self createNewRepair];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createNewRepair
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 66.f, SCREEN_WIDTH, 66.f)];
    backView.backgroundColor = colorWithHexString(@"e0e0e0");
    
    UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [newBtn setFrame:CGRectMake(40.f, 13.f, SCREEN_WIDTH - 80.f, 40.f)];
    newBtn.layer.masksToBounds = YES;
    newBtn.layer.cornerRadius = 4.f;
    newBtn.backgroundColor = colorWithHexString(@"ffffff");
    [newBtn addTarget:self action:@selector(newRepairClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:newBtn];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21.f, 21.f)];
    imgView.image = [UIImage imageNamed:@"Small_buttons"];
    [imgView setCenter:CGPointMake(newBtn.bounds.size.width/2.f - 24.f, newBtn.bounds.size.height/2.f)];
    [newBtn addSubview:imgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80.f, 40.f)];
    titleLabel.text = @"新建工单";
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.textColor = colorWithHexString(@"3cafff");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = CGPointMake(newBtn.bounds.size.width/2.f + 22.f, 20.f);
    [newBtn addSubview:titleLabel];
    
    [self.view addSubview:backView];
}

#pragma mark -
#pragma mark 事件处理
- (void)newRepairClick
{
    BXTRepairWordOrderViewController *workOderVC = [[BXTRepairWordOrderViewController alloc] init];
    [self.navigationController pushViewController:workOderVC animated:YES];
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
