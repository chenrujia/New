//
//  EvaluationViewController.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/26.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "EvaluationViewController.h"
#import "EvaluationHeader.h"
#import "EvaluationFooter.h"

@interface EvaluationViewController () <PNChartDelegate, BXTDataResponseDelegate>

@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) PNBarChart * barChart;
@property (nonatomic, strong) EvaluationFooter *footerView;

@end

@implementation EvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    
    NSArray *dateArray = [BXTGlobal yearStartAndEnd];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request statistics_praiseWithTime_start:dateArray[0] time_end:dateArray[1]];
    
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type {
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == Statistics_Praise && data.count > 0) {
        self.dataDict = dic;
        [self createUI];
    }
}

- (void)requestError:(NSError *)error {
    
}

#pragma mark -
#pragma mark - createUI
- (void)createUI {
    // EvaluationHeader
    EvaluationHeader *headerView = [[[NSBundle mainBundle] loadNibNamed:@"EvaluationHeader" owner:nil options:nil] lastObject];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 210);
    [self.rootScrollView addSubview:headerView];
    
    // 好评率
    int downNum = [self.dataDict[@"sum_number"] intValue];
    int pariseNum = [self.dataDict[@"praise_sum_number"] intValue];
    headerView.doneView.text = [NSString stringWithFormat:@"共完成:%d", downNum];
    headerView.praiseView.text = [NSString stringWithFormat:@"好评:%d", pariseNum];
    headerView.praiseRateView.text = [NSString stringWithFormat:@"好评率:%@%@", self.dataDict[@"praise_percent"], @"%"];
    headerView.persentView.text = [NSString stringWithFormat:@"%@%@", self.dataDict[@"praise_percent"], @"%"];
    
    [headerView.pieChartView clearChart];
    //straightPieChart.isVertical = YES;
    [headerView.pieChartView addDataToRepresent:pariseNum WithColor:colorWithHexString(@"#F86494")];
    [headerView.pieChartView addDataToRepresent:downNum-pariseNum WithColor:colorWithHexString(@"#0C88CC")];
    
    
    // EvaluationFooter
    self.footerView = [[[NSBundle mainBundle] loadNibNamed:@"EvaluationFooter" owner:nil options:nil] lastObject];
    self.footerView.frame = CGRectMake(0, CGRectGetMaxY(headerView.frame)+10, SCREEN_WIDTH, 350);
    [self.rootScrollView addSubview:self.footerView];
    self.rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.footerView.frame));
    
    // 好评率分组
    static NSNumberFormatter *barChartFormatter;
    if (!barChartFormatter){
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

    for (NSDictionary *dict in self.dataDict[@"data"]) {
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
    self.footerView.doneView.text = [NSString stringWithFormat:@"共完成:%@", dict[@"sum_number"]];
    self.footerView.praiseView.text = [NSString stringWithFormat:@"好评:%@", dict[@"praise_number"]];
    self.footerView.praiseRateView.text = [NSString stringWithFormat:@"好评率:%@%@", dict[@"percent"], @"%"];
}

- (void)userClickedOnBarAtIndex:(NSInteger)barIndex {
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
    self.footerView.praiseRateView.text = [NSString stringWithFormat:@"好评率:%@%@", dict[@"percent"], @"%"];
}

#pragma mark -
#pragma mark - 父类点击事件
- (void)didClicksegmentedControlAction:(UISegmentedControl *)segmented {
    NSMutableArray *dateArray;
    switch (segmented.selectedSegmentIndex) {
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
    
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request statistics_praiseWithTime_start:dateArray[0] time_end:dateArray[1]];
}

- (void)datePickerBtnClick:(UIButton *)button {
    if (button.tag == 10001) {
        self.rootSegmentedCtr.selectedSegmentIndex = 2;
        
        if (!selectedDate) {
            selectedDate = [NSDate date];
        }
        [self.rootCenterButton setTitle:[self weekdayStringFromDate:selectedDate] forState:UIControlStateNormal];
        
        NSString *todayStr = [self transTimeWithDate:selectedDate];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request statistics_praiseWithTime_start:todayStr time_end:todayStr];
    }
    [UIView animateWithDuration:0.5 animations:^{
        pickerbgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        datePicker = nil;
        [pickerbgView removeFromSuperview];
    }];
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
