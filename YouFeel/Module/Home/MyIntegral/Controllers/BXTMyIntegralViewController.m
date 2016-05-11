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
#import "BMDatePickerView.h"

@interface BXTMyIntegralViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;

@property (strong, nonatomic) BXTMyIntegralData *myIntegral;

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
    
    NSArray *timeArray = [BXTGlobal yearAndmonthAndDay];
    self.nowTimeStr = [NSString stringWithFormat:@"%@年%@月", timeArray[0], timeArray[1]];
    self.timeStr = self.nowTimeStr;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    self.tableView.rowHeight = 45;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self getResource];
}

- (void)getResource
{
    NSString *timeStr = [self.timeStr stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"月" withString:@""];
    
    [self showLoadingMBP:@"加载中..."];
    /**获取我的积分**/
    BXTDataRequest *dep_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [dep_request listOFMyIntegralWithDate:timeStr];
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
        
        if ([self.timeStr isEqualToString:self.nowTimeStr]) {
            firstCell.nextMonthBtn.enabled = NO;
        }
        
        // sameMonthBtn
        [firstCell.sameMonthBtn setTitle:self.timeStr forState:UIControlStateNormal];
        [[firstCell.sameMonthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @weakify(self);
            BMDatePickerView *datePickerView = [BMDatePickerView BMDatePickerViewCertainActionBlock:^(NSString *selectYearMonthString) {
                @strongify(self);
                NSLog(@"选择的时间是: %@", selectYearMonthString);
                
                self.timeStr = selectYearMonthString;
                [firstCell.sameMonthBtn setTitle:self.timeStr forState:UIControlStateNormal];
                firstCell.nextMonthBtn.enabled = YES;
                if ([self.timeStr isEqualToString:self.nowTimeStr]) {
                    firstCell.nextMonthBtn.enabled = NO;
                }
                [self getResource];
                
            }];
            [datePickerView show];
        }];
        
        // lastMonthBtn
        [[firstCell.lastMonthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [firstCell.sameMonthBtn setTitle:[self transTime:self.timeStr isAdd:NO] forState:UIControlStateNormal];
            firstCell.nextMonthBtn.enabled = YES;
        }];
        
        // nextMonthBtn
        [[firstCell.nextMonthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSString *timeStr = [self transTime:self.timeStr isAdd:YES];
            [firstCell.sameMonthBtn setTitle:timeStr forState:UIControlStateNormal];
        }];
        
        return firstCell;
    }
    else if (indexPath.section == 1) {
        BXTMyIntegralSecondCell *secondCell = [BXTMyIntegralSecondCell cellWithTableView:tableView];
        
        secondCell.myIntegral = self.myIntegral;
        
        return secondCell;
    }
    
    
    BXTMyIntegralThirdCell *thirdCell = [BXTMyIntegralThirdCell cellWithTableView:tableView cellForRowAtIndexPath:indexPath];
    
    thirdCell.titleView.text = self.titleArray[indexPath.section][indexPath.row];
    
    if (indexPath.row != 0 && indexPath.section == 2) {
        thirdCell.complate = self.myIntegral.complate_data[indexPath.row-1];
    }
    else if (indexPath.row != 0 && indexPath.section == 3) {
        thirdCell.praise = self.myIntegral.praise_data[indexPath.row-1];
    }
    
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
    if (indexPath.section == 1)
    {
        BXTRankingViewController *rankingVC = [[BXTRankingViewController alloc] init];
        rankingVC.transTime = self.timeStr;
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
    
    if (!add)
    { // 减法
        month -= 1;
        if (month <= 0)
        {
            year -= 1;
            month = 12;
        }
    }
    else
    {
        month += 1;
        if (month >= 12)
        {
            year += 1;
            month = 1;
        }
    }
    
    self.timeStr = [NSString stringWithFormat:@"%ld年%ld月", (long)year, (long)month];
    
    [self getResource];
    
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
        self.myIntegral = [BXTMyIntegralData mj_objectWithKeyValues:dic];
        
        [self.tableView reloadData];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
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
