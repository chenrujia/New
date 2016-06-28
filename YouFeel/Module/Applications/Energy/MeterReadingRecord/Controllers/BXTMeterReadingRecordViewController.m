//
//  BXTMeterReadingViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/6/27.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMeterReadingRecordViewController.h"
#import "BXTEnergyConsumptionViewController.h"

@implementation BXTMeterReadingRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createNavigation];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createNavigation
{
    // naviView
    UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KNAVIVIEWHEIGHT)];
    naviView.image = [[UIImage imageNamed:@"Nav_Bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    naviView.userInteractionEnabled = YES;
    [self.view addSubview:naviView];
    
    // titleLabel
    UILabel *navi_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 20, SCREEN_WIDTH-128, 44)];
    navi_titleLabel.font = [UIFont systemFontOfSize:18.f];
    navi_titleLabel.textColor = [UIColor whiteColor];
    navi_titleLabel.textAlignment = NSTextAlignmentCenter;
    navi_titleLabel.text = @"能源抄表";
    [naviView addSubview:navi_titleLabel];
    
    // navi_leftButton
    UIButton *navi_leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navi_leftButton.frame = CGRectMake(0, 20, 44, 44);
    [navi_leftButton setImage:[UIImage imageNamed:@"arrowBack"] forState:UIControlStateNormal];
    [navi_leftButton addTarget:self action:@selector(navigationLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:navi_leftButton];
    
    // 能耗计算
    UIButton *calculateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [calculateBtn setFrame:CGRectMake(SCREEN_WIDTH - 44.f - 5.f, 20, 44.f, 44.f)];
    [calculateBtn setBackgroundImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    @weakify(self);
    [[calculateBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTEnergyConsumptionViewController *ecvc = [[BXTEnergyConsumptionViewController alloc] init];
        [self.navigationController pushViewController:ecvc animated:YES];
    }];
    [naviView addSubview:calculateBtn];
    
    
    // 列表
    UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [listBtn setFrame:CGRectMake(SCREEN_WIDTH - 44.f - 45, 20, 44.f, 44.f)];
    [listBtn setBackgroundImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    [[listBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
    }];
    [naviView addSubview:listBtn];
}

@end
