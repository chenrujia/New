//
//  StatisticsViewController.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/24.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "BXTStatisticsViewController.h"
#import "BXTStatisticsCell.h"
#import "BXTCompletionViewController.h"
#import "BXTProfessionViewController.h"
#import "BXTIncidenceViewController.h"
#import "BXTWorkloadViewController.h"
#import "BXStEvaluationViewController.h"
#import "BXTAllOrdersViewController.h"

#import "BXTHeaderForVC.h"

@interface BXTStatisticsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *imageArray1;
@property (nonatomic, strong) NSMutableArray *imageArray2;

@end

@implementation BXTStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"业务统计" andRightTitle:nil andRightImage:[UIImage imageNamed:@"w_small_round"]];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"维修完成率统计", @"专业分组统计", @"故障发生率统计", @"维修员工作量统计", @"维修评价统计",nil];
    self.imageArray1 = [[NSMutableArray alloc] init];
    self.imageArray2 = [[NSMutableArray alloc] init];
    for (int i=1; i<=5; i++) {
        [self.imageArray1 addObject:[NSString stringWithFormat:@"Statistics_%d", i]];
        [self.imageArray2 addObject:[NSString stringWithFormat:@"Round_%d", i]];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

- (void)navigationRightButton
{
    BXTAllOrdersViewController *allOrdersVC = [[BXTAllOrdersViewController alloc] init];
    [self.navigationController pushViewController:allOrdersVC animated:YES];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    BXTStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTStatisticsCell" owner:nil options:nil] lastObject];
    }
    
    cell.titleView.text = self.dataArray[indexPath.section];
    cell.detailView.text = self.dataArray[indexPath.section];
    [cell.imageView1 setImage:[UIImage imageNamed:self.imageArray1[indexPath.section]]];
    [cell.imageView2 setImage:[UIImage imageNamed:self.imageArray2[indexPath.section]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BXTCompletionViewController *clvc = [[BXTCompletionViewController alloc] init];
    BXTProfessionViewController *pfvc = [[BXTProfessionViewController alloc] init];
    BXTIncidenceViewController *idvc = [[BXTIncidenceViewController alloc] init];
    BXTWorkloadViewController *wlvc = [[BXTWorkloadViewController alloc] init];
    BXStEvaluationViewController *evvc = [[BXStEvaluationViewController alloc] init];
    
    switch (indexPath.section) {
        case 0: [self.navigationController pushViewController:clvc animated:YES]; break;
        case 1: [self.navigationController pushViewController:pfvc animated:YES]; break;
        case 2: [self.navigationController pushViewController:idvc animated:YES]; break;
        case 3: [self.navigationController pushViewController:wlvc animated:YES]; break;
        case 4: [self.navigationController pushViewController:evvc animated:YES]; break;
        default: break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12.5;
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
