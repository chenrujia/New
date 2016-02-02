//
//  BXTStandardViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/7.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTStandardViewController.h"

@interface BXTStandardViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    LogRed(@"nav.navigationBar.hidden:%d",self.navigationController.navigationBar.hidden);
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
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-80)];
    [self.view addSubview:self.scrollView];
    
    // 取值
    NSDictionary *dict = ValueFUD(@"conditionDict");
    
    CGSize size = MB_MULTILINE_TEXTSIZE(dict[@"content"], [UIFont systemFontOfSize:16], CGSizeMake(SCREEN_WIDTH-30, CGFLOAT_MAX), NSLineBreakByWordWrapping);
    self.scrollView.contentSize = CGSizeMake(size.width, size.height + 20);
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, size.height)];
    contentLabel.text = dict[@"content"];
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.numberOfLines = 0;
    [self.scrollView addSubview:contentLabel];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
