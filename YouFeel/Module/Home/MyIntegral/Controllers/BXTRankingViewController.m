//
//  BXTRankingViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTRankingViewController.h"
#import "BXTMyIntegralFirstCell.h"
#import "BXTRankingCell.h"
#import "BXTRankingData.h"
#import "BMDatePickerView.h"

@interface BXTRankingViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (copy, nonatomic) NSString *nowTimeStr;
@property (copy, nonatomic) NSString *timeStr;

@end

@implementation BXTRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"排名" andRightTitle:nil andRightImage:nil];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    NSArray *timeArray = [BXTGlobal yearAndmonthAndDay];
    self.nowTimeStr = [NSString stringWithFormat:@"%@年%@月", timeArray[0], timeArray[1]];
    self.timeStr = self.transTime;
    
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
    
    [self showLoadingMBP:@"努力加载中..."];
    /**积分排名列表**/
    BXTDataRequest *dep_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [dep_request listOFIntegralRankingWithDate:timeStr];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return self.dataArray.count;
    }
    
    return 1;
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
    
    
    BXTRankingCell *cell = [BXTRankingCell cellWithTableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 2) {
        cell.ranking = self.dataArray[indexPath.row];
    }
    
    return cell;
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
    
    if (type == IntegarlRanking)
    {
        self.dataArray = [BXTRankingData mj_objectArrayWithKeyValuesArray:dic[@"data"]];
        
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
