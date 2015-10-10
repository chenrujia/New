//
//  BXTGrabOrderViewController.m
//  YFBX
//
//  Created by Jason on 15/10/10.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTGrabOrderViewController.h"
#import "BXTHeaderForVC.h"

@interface BXTGrabOrderViewController ()

@end

@implementation BXTGrabOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetting:@"实时抢单" andRightTitle:nil andRightImage:nil];
    [self createSubviews];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createSubviews
{
    CGFloat bv_height = IS_IPHONE6 ? 180.f : 120.f;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - bv_height, SCREEN_WIDTH, bv_height)];
    backView.backgroundColor = colorWithHexString(@"febc2d");
    [self.view addSubview:backView];
    
    CGFloat arc_height = IS_IPHONE6 ? 168.f : 112.f;
    UIView *arc_View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, arc_height, arc_height)];
    arc_View.center = CGPointMake(SCREEN_WIDTH/2.f, 0);
    arc_View.layer.masksToBounds = YES;
    arc_View.layer.cornerRadius = arc_height/2.f;
    arc_View.backgroundColor = colorWithHexString(@"febc2d");
    [backView addSubview:arc_View];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

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
