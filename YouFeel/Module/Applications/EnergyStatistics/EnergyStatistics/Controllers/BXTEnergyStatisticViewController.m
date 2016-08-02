//
//  BXTEnergyStatisticViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyStatisticViewController.h"
#import "BXTEnergyStatisticsView.h"
#import "BXTEnergyStatisticBaseViewController.h"
#import "BXTGlobal.h"

@interface BXTEnergyStatisticViewController ()

@end

@implementation BXTEnergyStatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"能源统计" andRightTitle:nil andRightImage:nil];
    
    [self createUI];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    
    BXTEnergyStatisticsView *esView = [BXTEnergyStatisticsView viewForEnergyStatisticsView];
    esView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 610 * (SCREEN_WIDTH / 375));
    @weakify(self);
    [[esView.surveyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTEnergyStatisticBaseViewController *vc = [[BXTEnergyStatisticBaseViewController alloc] init];
        vc.titleStr = @"建筑能效概况";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [[esView.distributionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTEnergyStatisticBaseViewController *vc = [[BXTEnergyStatisticBaseViewController alloc] init];
        vc.titleStr = @"建筑能效分布";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [[esView.trendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTEnergyStatisticBaseViewController *vc = [[BXTEnergyStatisticBaseViewController alloc] init];
        vc.titleStr = @"建筑能效趋势";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [scrollView addSubview:esView];
    
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, esView.frame.size.height);
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
