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
@property (nonatomic, copy  ) NSString     *safetyGuidelines;

@end

@implementation BXTStandardViewController

- (instancetype)initWithSafetyGuidelines:(NSString *)safety
{
    self = [super init];
    if (self)
    {
        self.safetyGuidelines = safety;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"安全指引" andRightTitle:nil andRightImage:nil];
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
    readBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
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
    NSString *contentStr = self.safetyGuidelines;
    CGSize size = MB_MULTILINE_TEXTSIZE(contentStr, [UIFont systemFontOfSize:16], CGSizeMake(SCREEN_WIDTH-30, CGFLOAT_MAX), NSLineBreakByWordWrapping);
    self.scrollView.contentSize = CGSizeMake(size.width, size.height + 20);
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, size.height)];
    contentLabel.text = contentStr;
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.numberOfLines = 0;
    [self.scrollView addSubview:contentLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
