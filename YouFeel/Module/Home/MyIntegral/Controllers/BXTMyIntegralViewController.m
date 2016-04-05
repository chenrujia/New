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
#import "BXTMyIntegralData.h"

@interface BXTMyIntegralViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;

@property (copy, nonatomic) NSString *nowTimeStr;
@property (copy, nonatomic) NSString *timeStr;

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
    self.nowTimeStr = @"2016年3月";
    self.timeStr = @"2016年3月";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    self.tableView.rowHeight = 45;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    [self showLoadingMBP:@"努力加载中..."];
    /**请求分店位置**/
    BXTDataRequest *dep_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [dep_request listOFMyIntegralWithDate:@""];
    
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
        
        [firstCell.sameMonthBtn setTitle:self.timeStr forState:UIControlStateNormal];
        
        [[firstCell.lastMonthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [firstCell.sameMonthBtn setTitle:[self transTime:self.timeStr isAdd:NO] forState:UIControlStateNormal];
            firstCell.nextMonthBtn.enabled = YES;
        }];
        
        [[firstCell.nextMonthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSString *timeStr = [self transTime:self.timeStr isAdd:YES];
            [firstCell.sameMonthBtn setTitle:timeStr forState:UIControlStateNormal];
            
            if ([timeStr isEqualToString:self.nowTimeStr]) {
                firstCell.nextMonthBtn.enabled = NO;
            }
        }];
        
        return firstCell;
    }
    else if (indexPath.section == 1) {
        BXTMyIntegralSecondCell *secondCell = [BXTMyIntegralSecondCell cellWithTableView:tableView];
        
        
        return secondCell;
    }
    
    
    BXTMyIntegralThirdCell *thirdCell = [BXTMyIntegralThirdCell cellWithTableView:tableView];
    
    if (indexPath.row == 0) {
        if (indexPath.section == 2) {
            thirdCell.backgroundColor = colorWithHexString(@"#76e3c7");
        } else if (indexPath.section == 3) {
            thirdCell.backgroundColor = colorWithHexString(@"#f99e8c");
        }
        
        thirdCell.titleView.textColor = [UIColor whiteColor];
        thirdCell.orderView.textColor = [UIColor whiteColor];
        thirdCell.percentView.textColor = [UIColor whiteColor];
        thirdCell.rankingView.textColor = [UIColor whiteColor];
    }
    
    
    thirdCell.titleView.text = self.titleArray[indexPath.section][indexPath.row];
    
    return thirdCell;
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

#pragma mark -
#pragma mark - 处理时间
- (NSString *)transTime:(NSString *)time isAdd:(BOOL)add
{
    NSInteger year = [[self.timeStr substringToIndex:4] integerValue];
    NSInteger month = [[self.timeStr substringWithRange:NSMakeRange(5, self.timeStr.length-6)] integerValue];
    
    if (!add) { // 减法
        month -= 1;
        if (month <= 0) {
            year -= 1;
            month = 12;
        }
    }
    else {
        month += 1;
        if (month >= 12) {
            year += 1;
            month = 1;
        }
    }
    
    self.timeStr = [NSString stringWithFormat:@"%ld年%ld月", year, month];
    
    return self.timeStr;
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    
    if (type == MyIntegral)
    {
        BXTMyIntegralData *myIntegralModel = [BXTMyIntegralData mj_objectWithKeyValues:dic];
        PraiseData *praiseData = myIntegralModel.praise_data[0];
        
        NSLog(@"%@  %@", myIntegralModel.ranking, praiseData.name);
        
        [self.tableView reloadData];
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
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
