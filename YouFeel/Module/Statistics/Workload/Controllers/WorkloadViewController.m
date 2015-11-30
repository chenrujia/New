//
//  WorkloadViewController.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/26.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "WorkloadViewController.h"

@interface WorkloadViewController ()

@end

@implementation WorkloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AksStraightPieChart *straightPieChart = [[AksStraightPieChart alloc] initWithFrame:CGRectMake(100, 100, 30, 200)];
    [self.rootScrollView addSubview:straightPieChart];
    
    [straightPieChart clearChart];
    straightPieChart.isVertical = YES;
    [straightPieChart addDataToRepresent:12 WithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1.000]];
    [straightPieChart addDataToRepresent:34 WithColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:1.000]];
    [straightPieChart addDataToRepresent:15 WithColor:[UIColor colorWithRed:1 green:1 blue:0 alpha:1.000]];
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
