//
//  BXTEnergyTrendView.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyTrendView.h"
#import "BXTEnergyTrendHeaderCell.h"
#import "BXTEnergyTrendLegendCell.h"
#import "BXTEnergyTrendCell.h"
#import "BXTEnergyTrendBudgetCell.h"
#import "BXTEnergyTrendInfo.h"
#import "BXTHistogramStatisticsView.h"

@interface BXTEnergyTrendView () <BXTDataResponseDelegate>

@property (nonatomic, strong) BXTHistogramStatisticsView *hisView;
@property (nonatomic, strong) NSMutableArray *energyArray;
@property (nonatomic, assign) NSInteger inn;
@property (nonatomic, assign) NSInteger maxNum;

/** ---- 选中的柱状图 ---- */
@property (nonatomic, assign) NSInteger selectedIndex;

/** ---- 显示费用 ---- */
@property (nonatomic, assign) BOOL showCost;

@end

@implementation BXTEnergyTrendView

- (instancetype)initWithFrame:(CGRect)frame VCType:(ViewControllerType)vcType
{
    self = [super initWithFrame:frame VCType:vcType];
    
    [self getResource];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"BXTHistogramViewSelectIndex" object:nil] subscribeNext:^(NSNotification *notify) {
        @strongify(self);
        
        NSDictionary *dict = [notify userInfo];
        NSLog(@"%@", dict[@"index"]);
        self.selectedIndex = [dict[@"index"] integerValue];
        
        [self.tableView reloadData];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ESSHOWCOST" object:nil] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        
        NSDictionary *dict = [notification userInfo];
        self.showCost = [dict[@"showCost"] integerValue] == 1;
        [self dealDataSourceIsShowCost:self.showCost];
        
        [self.tableView reloadData];
    }];
    
    return self;
}

#pragma mark -
#pragma mark - getResource
- (void)getResource
{
    // TODO: -----------------  月统计 - ViewControllerTypeOFYear -----------------
    // TODO: -----------------  年统计 - ViewControllerTypeOFNone -----------------
    if (self.vcType == ViewControllerTypeOFNone) {
        // 建筑能效概况 - 年统计
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request efficiencyTrendYearWithDate:@"" ppath:@""];
    }
    else
    {
        // 建筑能效概况 - 月统计
        [BXTGlobal showLoadingMBP:@"数据加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request efficiencyTrendMonthWithDate:@"" ppath:@""];
    }
}

#pragma mark -
#pragma mark - tableView代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTEnergyTrendInfo *trendInfo = self.energyArray[self.selectedIndex];
    
    if (indexPath.section == 0)
    {
        BXTEnergyTrendHeaderCell *cell = [BXTEnergyTrendHeaderCell cellWithTableView:tableView];
        
        if (self.showCost) {
            self.hisView = [[BXTHistogramStatisticsView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20.f, 370) lists:self.energyArray kwhMeasure:self.inn kwhNumber:4 statisticsType:BudgetType];
            
        }
        else {
            self.hisView = [[BXTHistogramStatisticsView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20.f, 370) lists:self.energyArray kwhMeasure:self.inn kwhNumber:4 statisticsType:EnergyType];
        }
        
        self.hisView.backgroundColor = [UIColor whiteColor];
        self.hisView.layer.masksToBounds = YES;
        self.hisView.layer.cornerRadius = 10.f;
        self.hisView.footerView.hidden = YES;
        [cell.hisBgView addSubview:self.hisView];
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        BXTEnergyTrendLegendCell *cell = [BXTEnergyTrendLegendCell cellWithTableView:tableView];
        
        cell.temperatureView.text = [NSString stringWithFormat:@"气温：%@℃", trendInfo.temperature];
        cell.humidityView.text = [NSString stringWithFormat:@"湿度：%@%%", trendInfo.humidity];
        if ([trendInfo.temperature isEqualToString:@"-"]) {
            cell.temperatureView.text = @"气温：-";
        }
        if ([trendInfo.humidity isEqualToString:@"-"]) {
            cell.humidityView.text = @"气温：-";
        }
        
        return cell;
    }
    else if (indexPath.section == 2)
    {
        BXTEnergyTrendCell *cell = [BXTEnergyTrendCell cellWithTableView:tableView];
        
        if (self.showCost) {
            cell.moneyTrendInfo = trendInfo;
        } else {
            cell.energyTrendInfo = trendInfo;
        }
        
        return cell;
    }
    
    BXTEnergyTrendBudgetCell *cell = [BXTEnergyTrendBudgetCell cellWithTableView:tableView];
    
    if (self.showCost) {
        cell.moneyTrendInfo = trendInfo;
    } else {
        cell.energyTrendInfo = trendInfo;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 485;
    } else if (indexPath.section == 1) {
        return 50;
    } else if (indexPath.section == 2) {
        return 125;
    }
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = dic[@"data"];
    if (type == EfficiencyTrendMonth)
    {
        self.energyArray = [[NSMutableArray alloc] init];
        [self.energyArray addObjectsFromArray:[BXTEnergyTrendInfo mj_objectArrayWithKeyValuesArray:data]];
        
        [self dealDataSourceIsShowCost:NO];
    }
    else if (type == EfficiencyTrendYear)
    {
        //        self.esInfo = [BXTEnergySurveyInfo mj_objectWithKeyValues:dic[@"data"]];
    }
    
    [self.tableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

#pragma mark -
#pragma mark - other
- (void)dealDataSourceIsShowCost:(BOOL)showCost
{
    NSInteger count = self.energyArray.count;
    if (count > 0)
    {
        //通过最大kwh推算左侧坐标最大值
        NSInteger max = 0;
        for (NSInteger i = 0; i < count; i++)
        {
            BXTEnergyTrendInfo *recordInfo = self.energyArray[i];
            if (showCost) {
                max = recordInfo.energy_consumption > max ? recordInfo.energy_consumption : max;
            } else {
                max = recordInfo.money > max ? recordInfo.money : max;
            }
        }
        CGFloat fn = max/4.f;
        self.inn = floor(fn);
        NSInteger i = 0;
        do {
            i++;
            self.inn = floor(self.inn/10.f);
        } while (self.inn > 10);
        self.inn++;
        do {
            self.inn *= 10;
            i--;
        } while (i > 0);
        self.inn *= 4;
    }
}

@end
