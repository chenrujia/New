//
//  EvaluationViewController.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/26.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "BXStEvaluationViewController.h"
#import "BXTStEvaluationHeader.h"
#import "BXTStEvaluationFooter.h"
#import "DOPDropDownMenu.h"

@interface BXStEvaluationViewController () <PNChartDelegate, BXTDataResponseDelegate, DOPDropDownMenuDataSource, DOPDropDownMenuDelegate>

@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) PNBarChart * barChart;
@property (nonatomic, strong) BXTStEvaluationFooter *footerView;

@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, copy) NSString *typeStr;

@end

@implementation BXStEvaluationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.typeArray = @[@"全部维修评价统计", @"日常维修评价统计", @"维保维修评价统计"];
    self.typeStr = @"0";
    
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.rootScrollView addSubview:menu];
    [menu selectDefalutIndexPath];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // EvaluationHeader
    BXTStEvaluationHeader *headerView = [[[NSBundle mainBundle] loadNibNamed:@"BXTStEvaluationHeader" owner:nil options:nil] lastObject];
    headerView.frame = CGRectMake(0, 54, SCREEN_WIDTH, 160);
    [self.rootScrollView addSubview:headerView];
    
    // 好评率
    int downNum = [self.dataDict[@"praise_sum_number"] intValue];
    int pariseNum = [self.dataDict[@"praise_number"] intValue];
    headerView.doneView.text = [NSString stringWithFormat:@"共完成:%d", downNum];
    headerView.praiseView.text = [NSString stringWithFormat:@"好评:%d", pariseNum];
    headerView.praiseRateView.text = [NSString stringWithFormat:@"好评率:%.1f%@", [self.dataDict[@"percent"] floatValue], @"%"];
    headerView.persentView.text = [NSString stringWithFormat:@"%.1f%@", [self.dataDict[@"percent"] floatValue], @"%"];
    
    [headerView.pieChartView clearChart];
    //straightPieChart.isVertical = YES;
    [headerView.pieChartView addDataToRepresent:pariseNum WithColor:colorWithHexString(@"#F86494")];
    [headerView.pieChartView addDataToRepresent:downNum-pariseNum WithColor:colorWithHexString(@"#0C88CC")];
    if (downNum == 0)
    {
        [headerView.pieChartView addDataToRepresent:1 WithColor:colorWithHexString(@"#d9d9d9")];
    }
    
    
    // EvaluationFooter
    self.footerView = [[[NSBundle mainBundle] loadNibNamed:@"BXTStEvaluationFooter" owner:nil options:nil] lastObject];
    self.footerView.frame = CGRectMake(0, CGRectGetMaxY(headerView.frame)+10, SCREEN_WIDTH, 350);
    [self.rootScrollView addSubview:self.footerView];
    self.rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.footerView.frame));
    
    // 好评率分组
    static NSNumberFormatter *barChartFormatter;
    if (!barChartFormatter)
    {
        barChartFormatter = [[NSNumberFormatter alloc] init];
        barChartFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        barChartFormatter.allowsFloats = NO;
        barChartFormatter.maximumFractionDigits = 0;
    }
    
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(10, 60.0, SCREEN_WIDTH-20, 200.0)];
    //        self.barChart.showLabel = NO;
    self.barChart.backgroundColor = [UIColor clearColor];
    self.barChart.yLabelFormatter = ^(CGFloat yValue){
        return [barChartFormatter stringFromNumber:[NSNumber numberWithFloat:yValue]];
    };
    
    self.barChart.yChartLabelWidth = 20.0;
    self.barChart.chartMarginLeft = 30.0;
    self.barChart.chartMarginRight = 10.0;
    self.barChart.chartMarginTop = 5.0;
    self.barChart.chartMarginBottom = 10.0;
    
    self.barChart.labelMarginTop = 5.0;
    self.barChart.showChartBorder = YES;
    self.barChart.isGradientShow = NO;
    self.barChart.isShowNumbers = YES;
    
    
    [self.dataArray removeAllObjects];
    NSMutableArray *subgroupArray = [[NSMutableArray alloc] init];
    NSMutableArray *percentArray = [[NSMutableArray alloc] init];
    NSMutableArray *colorArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in self.dataDict[@"data"])
    {
        [self.dataArray addObject:dict];
        [subgroupArray addObject:dict[@"subgroup"]];
        [percentArray addObject:dict[@"percent"]];
        [colorArray addObject:[BXTGlobal randomColor]];
    }
    
    [self.barChart setXLabels:subgroupArray];
    //self.barChart.yLabels = @[@-10,@0,@10];
    [self.barChart setYValues:percentArray];
    [self.barChart setStrokeColors:colorArray];
    
    [self.barChart strokeChart];
    self.barChart.delegate = self;
    [self.footerView addSubview:self.barChart];
    
    
    NSDictionary *dict = self.dataArray[0];
    self.footerView.groupView.text = [NSString stringWithFormat:@"%@", dict[@"subgroup"]];
    self.footerView.doneView.text = [NSString stringWithFormat:@"已评价:%@", dict[@"sum_number"]];
    self.footerView.praiseView.text = [NSString stringWithFormat:@"好评:%@", dict[@"praise_number"]];
    self.footerView.praiseRateView.text = [NSString stringWithFormat:@"好评率:%.1f%@", [self.dataDict[@"percent"] floatValue], @"%"];
}

#pragma mark -
#pragma mark DOPDropDownMenuDataSource && DOPDropDownMenuDelegate
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    return self.typeArray.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return self.typeArray[indexPath.row];
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: self.typeStr = @"0"; break;
        case 1: self.typeStr = @"1"; break;
        case 2: self.typeStr = @"2"; break;
        default: break;
    }
    
    self.rootSegmentedCtr.selectedSegmentIndex = 2;
    
    NSArray *dateArray = [BXTGlobal dayStartAndEnd];
    [self getResourceWithArray:dateArray];
}

- (void)getResourceWithArray:(NSArray *)timeArray
{
    NSArray *finalTimeArray = [BXTGlobal transTimeToWhatWeNeed:timeArray];
    
    [BXTGlobal showLoadingMBP:@"加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request statisticsPraiseWithTimeStart:finalTimeArray[0] timeEnd:finalTimeArray[1] Type:self.typeStr];
}

#pragma mark -
#pragma mark - PNChartDelegate
- (void)userClickedOnBarAtIndex:(NSInteger)barIndex
{
    NSLog(@"Click on bar %@", @(barIndex));
    
    PNBar * bar = [self.barChart.bars objectAtIndex:barIndex];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.toValue = @1.1;
    animation.duration = 0.2;
    animation.repeatCount = 0;
    animation.autoreverses = YES;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    [bar.layer addAnimation:animation forKey:@"Float"];
    
    NSDictionary *dict = self.dataArray[barIndex];
    self.footerView.groupView.text = [NSString stringWithFormat:@"%@", dict[@"subgroup"]];
    self.footerView.doneView.text = [NSString stringWithFormat:@"共完成:%@", dict[@"sum_number"]];
    self.footerView.praiseView.text = [NSString stringWithFormat:@"好评:%@", dict[@"praise_number"]];
    self.footerView.praiseRateView.text = [NSString stringWithFormat:@"好评率:%.1f%@", [dict[@"percent"] floatValue], @"%"];
}

#pragma mark -
#pragma mark - 父类点击事件
- (void)segmentView:(SegmentView *)segmentView didSelectedSegmentAtIndex:(NSInteger)index
{
    NSMutableArray *dateArray;
    switch (index) {
        case 0:
            dateArray = [[NSMutableArray alloc] initWithArray:[self timeTypeOf_YearStartAndEnd:self.rootCenterButton.titleLabel.text]];
            break;
        case 1:
            dateArray = [[NSMutableArray alloc] initWithArray:[self timeTypeOf_MonthStartAndEnd:self.rootCenterButton.titleLabel.text]];
            break;
        case 2:
            dateArray = [[NSMutableArray alloc] initWithArray:[self timeTypeOf_DayStartAndEnd:self.rootCenterButton.titleLabel.text]];
            break;
        default:
            break;
    }
    
    
    [self getResourceWithArray:dateArray];
}

- (void)datePickerBtnClick:(UIButton *)button
{
    if (button.tag == 10001)
    {
        self.rootSegmentedCtr.selectedSegmentIndex = 2;
        
        if (!selectedDate)
        {
            selectedDate = [NSDate date];
        }
        [self.rootCenterButton setTitle:[self weekdayStringFromDate:selectedDate] forState:UIControlStateNormal];
        
        NSString *todayStr = [self transTimeWithDate:selectedDate];
        [self getResourceWithArray:@[todayStr, todayStr]];
    }
    
    [super datePickerBtnClick:button];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == Statistics_Praise && data.count > 0)
    {
        self.dataDict = dic;
        [self createUI];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

- (void)didReceiveMemoryWarning
{
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
