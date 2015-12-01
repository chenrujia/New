//
//  CompletionViewController.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/25.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "CompletionViewController.h"
#import "CompletionHeader.h"
#import "CompletionFooter.h"

@interface CompletionViewController () <BXTDataResponseDelegate, SPChartDelegate>

@property (nonatomic, strong) NSMutableArray *percentArrat;
@property (nonatomic, strong) NSMutableArray *monthArray;

@property (nonatomic, strong) CompletionHeader *headerView;
@property (nonatomic, strong) CompletionFooter *footerView;
@property (weak, nonatomic) SPBarChart *barChartView;
@property (weak, nonatomic) SPChartPopup *popup;

@end

@implementation CompletionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**饼状图**/
        NSArray *dateArray = [BXTGlobal yearStartAndEnd];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request statistics_completeWithTime_start:dateArray[0] time_end:dateArray[1]];
    });
    dispatch_async(concurrentQueue, ^{
        /**柱状图**/
        NSArray *dateArray = [BXTGlobal yearAndmonthAndDay];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request statistics_workload_dayWithYear:dateArray[0] month:dateArray[1]];
    });
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type {
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = dic[@"data"];
    if (type == Statistics_Complete && data.count > 0) {
        self.percentArrat = dic[@"data"];
        [self createPieView];
        
    } else if (type == Statistics_Workload_day && data.count > 0) {
        self.monthArray = [[NSMutableArray alloc] initWithArray:data];
        [self createBarChartView];
    }
}

- (void)requestError:(NSError *)error {
    
}

#pragma mark -
#pragma mark - createUI
- (void)createPieView {
    //  ---------- 饼状图 ----------
    // CompletionHeader
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"CompletionHeader" owner:nil options:nil] lastObject];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 400);
    [self.rootScrollView addSubview:self.headerView];
    
    
    // MYPieView
    NSDictionary *dataDict = self.percentArrat[0];
    NSArray *pieArray = [[NSMutableArray alloc] initWithObjects:dataDict[@"yes_percent"], dataDict[@"collection_percent"], dataDict[@"no_percent"], nil];
    
    // 1. create pieView
    self.headerView.pieView.backgroundColor = [UIColor whiteColor];
    
    // 2. fill data
    NSArray *colorArray = [[NSArray alloc] initWithObjects:@"#0eccc0", @"#fbcf62", @"#ff6f6f", nil];
    for(int i=0; i<pieArray.count; i++){
        MYPieElement *elem = [MYPieElement pieElementWithValue:[pieArray[i] floatValue] color:colorWithHexString(colorArray[i])];
        elem.title = [NSString stringWithFormat:@"%@", pieArray[i]];
        [self.headerView.pieView.layer addValues:@[elem] animated:NO];
    }
    
    // 3. transform tilte
    self.headerView.pieView.layer.transformTitleBlock = ^(PieElement *elem, float percent){
        NSLog(@"percent -- %f", percent);
        return [(MYPieElement *)elem title];
    };
    self.headerView.pieView.layer.showTitles = ShowTitlesAlways;
    
    // 4. didClick
    self.headerView.pieView.transSelected = ^(NSInteger index) {
        NSLog(@"index -- %ld", index);
    };
    
    
    // Button
    NSString *allNumStr = [NSString stringWithFormat:@"保修总数：%@单", dataDict[@"sum_number"]];
    NSString *downNumStr = [NSString stringWithFormat:@"已完成：%@单", dataDict[@"yes_number"]];
    NSString *undownNumStr = [NSString stringWithFormat:@"未完成：%@单", dataDict[@"no_number"]];
    NSString *specialNumStr = [NSString stringWithFormat:@"特殊工单：%@单", dataDict[@"collection_number"]];
    [self.headerView.sumView setTitle:allNumStr forState:UIControlStateNormal];
    [self.headerView.downView setTitle:downNumStr forState:UIControlStateNormal];
    [self.headerView.undownView setTitle:undownNumStr forState:UIControlStateNormal];
    [self.headerView.specialView setTitle:specialNumStr forState:UIControlStateNormal];
    self.headerView.transBtnClick = ^(NSInteger tag) {
        NSLog(@"tag ---- %ld", tag);
    };
}

- (void)createBarChartView {
    //  ---------- 柱状图 ----------
    // CompletionFooter
    self.footerView = [[[NSBundle mainBundle] loadNibNamed:@"CompletionFooter" owner:nil options:nil] lastObject];
    self.footerView.frame = CGRectMake(0, 410, SCREEN_WIDTH, 410);
    [self.rootScrollView addSubview:self.footerView];
    self.rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.footerView.frame));
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 350)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 350);
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.footerView addSubview:scrollView];
    self.rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.footerView.frame));
    
    // SPBarChart
    SPBarChart *barChart = [[SPBarChart alloc] initWithFrame:CGRectMake(0, 0, 1100, scrollView.frame.size.height)];
    
    NSMutableArray *barArray = [[NSMutableArray alloc] init];
    NSMutableArray *heightArray = [[NSMutableArray alloc] init];
    NSArray *colorArray = @[colorWithHexString(@"#0FCCC0") , colorWithHexString(@"#F9D063") , colorWithHexString(@"#FD7070") ];
    
    for (NSDictionary *dict in self.monthArray) {
        NSString *downStr = [NSString stringWithFormat:@"%@", dict[@"yes_number"]];
        NSString *specialStr = [NSString stringWithFormat:@"%@", dict[@"collection_number"]];
        NSString *undownStr = [NSString stringWithFormat:@"%@", dict[@"no_number"]];
        NSNumber *downNum = [NSNumber numberWithInteger:[downStr integerValue]];
        NSNumber *specialNum = [NSNumber numberWithInteger:[specialStr integerValue]];
        NSNumber *undownNum = [NSNumber numberWithInteger:[undownStr integerValue]];

        NSArray *dataArray = @[downNum, specialNum, undownNum];
        [barArray addObject:[SPBarChartData dataWithValues:dataArray colors:colorArray description:[NSString stringWithFormat:@"%@", dict[@"day"]]]];
        
        NSInteger sumNum = [downStr integerValue] + [specialStr integerValue] + [undownStr integerValue];
        NSString *sumStr = [NSString stringWithFormat:@"%ld", sumNum];
        [heightArray addObject:sumStr];
    }
    
    [barChart setDatas:barArray];
    
    // Set maximum value
    NSNumber *maxNum = [heightArray valueForKeyPath:@"@max.floatValue"];
    int max = [maxNum intValue];
    max = ((max / 10) + 2) * 10;
    NSLog(@"maxNum == %@", maxNum);
    barChart.maxDataValue = max;
    // Show axis
    barChart.showAxis = YES;
    // and section lines inside
    barChart.showSectionLines = YES;
    // Show empty message, if the chart is empty
    barChart.emptyChartText = @"The chart is empty.";
    
    self.barChartView = barChart;
    [barChart drawChart];
    barChart.delegate = self;
    
    [scrollView addSubview:barChart];
    scrollView.contentSize = CGSizeMake(barChart.frame.size.width, barChart.frame.size.height);
}

#pragma mark -
#pragma mark SPChartDelegate
- (void)SPChart:(SPBarChart *)chart barSelected:(NSInteger)barIndex barFrame:(CGRect)barFrame touchPoint:(CGPoint)touchPoint {
    [self _dismissPopup];
    
    NSLog(@"Selected bar %ld", (long)barIndex);
    
    SPBarChartData * data = chart.datas[barIndex];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = [NSString stringWithFormat:@"%@ - %@ - %@", data.values[0], data.values[1], data.values[2]];
    label.font = chart.labelFont;
    label.textColor = [UIColor whiteColor];
    
    [label sizeToFit];
    
    NSLog(@"Selected bar %@", label.text);
    
    SPChartPopup * popup = [[SPChartPopup alloc] initWithContentView:label];
    [popup setPopupColor:colorWithHexString(@"#999999")];
    [popup sizeToFit];
    
    [popup showInView:chart withBottomAnchorPoint:CGPointMake(CGRectGetMidX(barFrame), CGRectGetMinY(barFrame))];
    self.popup = popup;
}

- (void)SPChartEmptySelection:(id)chart {
    NSLog(@"Touch outside chart bar/line/piece");
}

- (void)_dismissPopup
{
    if (self.popup) {
        [self.popup dismiss];
    }
}

#pragma mark -
#pragma mark - 父类点击事件
- (void)didClicksegmentedControlAction:(UISegmentedControl *)segmented {
    [self.rootCenterButton setTitle:[self weekdayStringFromDate:[NSDate date]] forState:UIControlStateNormal];
    
    NSMutableArray *dateArray;
    switch (segmented.selectedSegmentIndex) {
        case 0:
            dateArray = [[NSMutableArray alloc] initWithArray:[BXTGlobal yearStartAndEnd]];
            break;
        case 1:
            dateArray = [[NSMutableArray alloc] initWithArray:[BXTGlobal monthStartAndEnd]];
            break;
        case 2:
            dateArray = [[NSMutableArray alloc] initWithArray:[BXTGlobal dayStartAndEnd]];
            break;
        default:
            break;
    }
    
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request statistics_completeWithTime_start:dateArray[0] time_end:dateArray[1]];
}

- (void)datePickerBtnClick:(UIButton *)button {
    if (button.tag == 10001) {
        [self.headerView.pieView removeFromSuperview];
        
        /**饼状图**/
        if (!selectedDate) {
            selectedDate = [NSDate date];
        }
        [self.rootCenterButton setTitle:[self weekdayStringFromDate:selectedDate] forState:UIControlStateNormal];
        
        NSString *todayStr = [self transTimeWithDate:selectedDate];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request statistics_completeWithTime_start:todayStr time_end:todayStr];
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
