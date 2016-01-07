//
//  BXTMailViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/6.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMailViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTMailListViewController.h"

@interface BXTMailViewController ()

@end

@implementation BXTMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"通讯" andRightTitle:nil andRightImage:nil];
    
    UIButton * nav_rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nav_rightButton.frame = CGRectMake(SCREEN_WIDTH - 60, 20, 60, 44);
    nav_rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [nav_rightButton setImage:[UIImage imageNamed:@"mail_address_book"] forState:UIControlStateNormal];
    [nav_rightButton setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    @weakify(self);
    [[nav_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTMailListViewController *mlvc = [[BXTMailListViewController alloc] init];
        mlvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mlvc animated:YES];
    }];
    [self.view addSubview:nav_rightButton];
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
