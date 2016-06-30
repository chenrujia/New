//
//  BXTEnergyConsumptionViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/6/27.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyConsumptionViewController.h"
#import "BXTMeterReadingHeaderCell.h"
#import "BXTEnergyConsumptionFiterCell.h"

@interface BXTEnergyConsumptionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BXTEnergyConsumptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetting:@"能耗计算" andRightTitle1:nil andRightImage1:nil andRightTitle2:nil andRightImage2:nil];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"", @"", nil];
    
    [self createUI];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
}


#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BXTMeterReadingHeaderCell *cell = [BXTMeterReadingHeaderCell cellWithTableView:tableView];
        
        cell.backgroundColor = colorWithHexString(@"#E36760");
        
        return cell;
    }
    
    BXTEnergyConsumptionFiterCell *cell = [BXTEnergyConsumptionFiterCell cellWithTableView:tableView];
    
    @weakify(self);
    [[cell.filterBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
    }];
    [[cell.resetBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
    }];
    
    cell.backgroundColor = colorWithHexString(@"#E36760");
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110;
    }
    
    return SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
