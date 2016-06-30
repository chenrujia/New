//
//  BXTMeterReadingViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/6/27.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMeterReadingRecordViewController.h"
#import "BXTMeterReadingHeaderView.h"
#import "BXTMeterReadingFilterView.h"
#import "BXTEnergyConsumptionViewController.h"
#import "BXTMeterReadingViewController.h"

@interface BXTMeterReadingRecordViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BXTMeterReadingHeaderView *headerView;
@property (nonatomic, strong) BXTMeterReadingFilterView *filterView;

@property (nonatomic, strong) UIView *footerView;

@end

@implementation BXTMeterReadingRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetting:@"能源抄表" andRightTitle1:nil andRightImage1:[UIImage imageNamed:@"news"] andRightTitle2:@"能耗计算" andRightImage2:nil];
    
    [self createUI];
}

- (void)navigationRightButton1
{
    
}

- (void)navigationRightButton2
{
    BXTEnergyConsumptionViewController *ecvc = [[BXTEnergyConsumptionViewController alloc] init];
    [self.navigationController pushViewController:ecvc animated:YES];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 70)];
    [self.view addSubview:self.scrollView];
    
    // headerView
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"BXTMeterReadingHeaderView" owner:nil options:nil] lastObject];
    [self hideBgFooterView:YES];
    @weakify(self);
    [[self.headerView.bgViewBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self hideBgFooterView:self.headerView.bgViewBtn.selected];
    }];
    [self.scrollView addSubview:self.headerView];
    
    // filterView
    self.filterView = [[[NSBundle mainBundle] loadNibNamed:@"BXTMeterReadingFilterView" owner:nil options:nil] lastObject];
    self.filterView.frame = CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20, 50);
    [self.scrollView addSubview:self.filterView];
    
    
    // footerView
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70, SCREEN_WIDTH, 70)];
    self.footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footerView];
    
    UIButton *newMeterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newMeterBtn.frame = CGRectMake((SCREEN_WIDTH - 180) / 2, 10, 180, 50);
    [newMeterBtn setBackgroundColor:colorWithHexString(@"#5DAFF9")];
    [newMeterBtn setTitle:@"新建抄表" forState:UIControlStateNormal];
    newMeterBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    newMeterBtn.layer.cornerRadius = 5;
    [[newMeterBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTMeterReadingViewController *mrvc = [[BXTMeterReadingViewController alloc] init];
        [self.navigationController pushViewController:mrvc animated:YES];
    }];
    [self.footerView addSubview:newMeterBtn];
}

#pragma mark -
#pragma mark - 方法
- (void)hideBgFooterView:(BOOL)isSelected
{
    if (isSelected) {
        self.headerView.bgViewBtn.selected = NO;
        self.headerView.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, 100);
        self.headerView.bgFooterView.hidden = YES;
    } else {
        self.headerView.bgViewBtn.selected = YES;
        self.headerView.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, 200);
        self.headerView.bgFooterView.hidden = NO;
    }
    
    self.filterView.frame = CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20, 50);
}

@end
