//
//  BXTMyIntegralViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMyIntegralViewController.h"
#import "BXTMyIntegralFirstCell.h"
#import "BXTMyIntegralSecondCell.h"
#import "BXTMyIntegralThirdCell.h"
#import "BXTRankingViewController.h"

@interface BXTMyIntegralViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation BXTMyIntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"我的积分" andRightTitle:nil andRightImage:nil];
    
    self.titleArray = @[@[@""],
                        @[@""],
                        @[@"完成率", @"日常工单", @"维保工单", @"总计"],
                        @[@"好评率", @"响应速度", @"服务态度", @"维修质量", @"总计"]
                        ];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BXTMyIntegralFirstCell *firstCell = [BXTMyIntegralFirstCell cellWithTableView:tableView];
        
        
        
        return firstCell;
    }
    else if (indexPath.section == 1) {
        BXTMyIntegralSecondCell *SecondCell = [BXTMyIntegralSecondCell cellWithTableView:tableView];
        
        
        
        return SecondCell;
    }
    
    
    BXTMyIntegralThirdCell *ThirdCell = [BXTMyIntegralThirdCell cellWithTableView:tableView];
    
    ThirdCell.titleView.text = self.titleArray[indexPath.section][indexPath.row];
    
    return ThirdCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        BXTRankingViewController *rankingVC = [[BXTRankingViewController alloc] init];
        [self.navigationController pushViewController:rankingVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
