//
//  BXTNoticeListViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTNoticeListViewController.h"

@interface BXTNoticeListViewController ()

@end

@implementation BXTNoticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"项目公告" andRightTitle:nil andRightImage:nil];
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
