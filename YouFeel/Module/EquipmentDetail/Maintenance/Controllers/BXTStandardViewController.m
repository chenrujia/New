//
//  BXTStandardViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/7.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTStandardViewController.h"

@interface BXTStandardViewController ()

@end

@implementation BXTStandardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"设备维保操作规范" andRightTitle:nil andRightImage:nil];
    
    NSDictionary *dict = ValueFUD(@"conditionDict");
    NSLog(@"title -- %@", dict[@"title"]);
    NSLog(@"content -- %@", dict[@"content"]);
    
    [self createUI];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // 我已阅读
    UIButton *readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    readBtn.frame = CGRectMake(20, SCREEN_HEIGHT - KNAVIVIEWHEIGHT, SCREEN_WIDTH-40, 50);
    [readBtn setTitle:@"我已阅读" forState:UIControlStateNormal];
    readBtn.backgroundColor = colorWithHexString(@"#36AFFD");
    readBtn.layer.cornerRadius = 5;
    @weakify(self);
    [[readBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:readBtn];
    
    // 内容显示
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
