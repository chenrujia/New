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
#import "BXTEnergyConsumptionInfo.h"
#import "MJExtension.h"
#import "MYAlertAction.h"

@interface BXTEnergyConsumptionViewController () <UITableViewDelegate, UITableViewDataSource, BXTDataResponseDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *startTimeStr;
@property (nonatomic, copy) NSString *endTimeStr;

@property (nonatomic, strong) BXTEnergyConsumptionInfo *energyConsInfo;

@end

@implementation BXTEnergyConsumptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetting:@"能耗计算" andRightTitle1:nil andRightImage1:nil andRightTitle2:nil andRightImage2:nil];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"", @"", nil];
    self.startTimeStr = @"起始日期";
    self.endTimeStr = @"结束日期";
    
    [self createUI];
    
    [self getResource];
}

#pragma mark -
#pragma mark - getResource
- (void)getResource
{
    [BXTGlobal showLoadingMBP:@"数据加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request energyMeterRecordCalculateWithAboutID:self.transID
                                         startTime:self.startTimeStr
                                           endTime:self.endTimeStr];
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
        
        cell.lastTimeView.hidden = YES;
        cell.energyConsumptionInfo = self.energyConsInfo;
        
        return cell;
    }
    
    BXTEnergyConsumptionFiterCell *cell = [BXTEnergyConsumptionFiterCell cellWithTableView:tableView];
    
    cell.calculateInfo = self.energyConsInfo.calc;
    [cell.startTimeBtn setTitle:self.startTimeStr forState:UIControlStateNormal];
    [cell.endTimeBtn setTitle:self.endTimeStr forState:UIControlStateNormal];
    
    @weakify(self);
    // 起始日期
    [[cell.startTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self createDatePickerIsStart:YES];
        [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            self.startTimeStr = self.timeStr;
            [cell.startTimeBtn setTitle:self.startTimeStr forState:UIControlStateNormal];
        }];
    }];
    // 结束日期
    [[cell.endTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self createDatePickerIsStart:NO];
        [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            self.endTimeStr = self.timeStr;
            [cell.endTimeBtn setTitle:self.endTimeStr forState:UIControlStateNormal];
        }];
    }];
    
    // 计算
    [[cell.filterBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if ([self.startTimeStr isEqualToString:@"起始日期"] || [self.endTimeStr isEqualToString:@"结束日期"]) {
            [MYAlertAction showAlertWithTitle:@"请选择筛选日期" msg:nil chooseBlock:^(NSInteger buttonIdx) {
            } buttonsStatement:@"确定", nil];
            return ;
        }
        [self getResource];
    }];
    // 重置
    [[cell.resetBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.startTimeStr = @"起始日期";
        self.endTimeStr = @"结束日期";
        [cell.startTimeBtn setTitle:self.startTimeStr forState:UIControlStateNormal];
        [cell.endTimeBtn setTitle:self.endTimeStr forState:UIControlStateNormal];
        cell.sumValueView.text = @"0";
        cell.peakValueView.text = @"0";
        cell.apexValueView.text = @"0";
        cell.levelValueView.text = @"0";
        cell.valleyValueView.text = @"0";
    }];
    
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


#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == EnergyMeterRecordCalculate && data.count > 0)
    {
        [BXTEnergyConsumptionInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"meterRecordID":@"id"};
        }];
        self.energyConsInfo = [BXTEnergyConsumptionInfo mj_objectWithKeyValues:data[0]];
    }
    
    [self.tableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

@end
