//
//  CompletionViewController.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/25.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "BXTCompletionViewController.h"
#import "BXTCompletionHeader.h"
#import "BXTCompletionFooter.h"
#import "BXTDailyOrderListViewController.h"

#define Not_First_Launch @"not_first_launch"
typedef enum {
    year,
    month
}DateStr;

@interface BXTCompletionViewController () <BXTDataResponseDelegate, SPChartDelegate>

@property (nonatomic, strong) NSMutableArray *percentArrat;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, assign) NSInteger chooseType;

@property (nonatomic, strong) BXTCompletionHeader *headerView;
@property (nonatomic, strong) BXTCompletionFooter *footerView;
@property (weak, nonatomic) SPBarChart *barChartView;
@property (weak, nonatomic) SPChartPopup *popup;

@property (nonatomic, strong) NSMutableArray *transTimeArray;

@property (assign, nonatomic) NSInteger segementedIndex;

@end

@implementation BXTCompletionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.segementedIndex = 2;
    
    /**饼状图**/
    NSArray *dateArray = [BXTGlobal dayStartAndEnd];
    self.transTimeArray = [[NSMutableArray alloc] initWithArray:dateArray];
    [self getResourceWithArray:dateArray];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:Not_First_Launch])
    {
        //[self createIntroductionView];
    }
}

- (void)getResourceWithArray:(NSArray *)timeArray
{
    NSArray *finalTimeArray = [BXTGlobal transTimeToWhatWeNeed:timeArray];
    
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request statisticsCompleteWithTimeStart:finalTimeArray[0] timeEnd:finalTimeArray[1]];
}

- (void)createIntroductionView
{
    pickerbgView = [[UIView alloc] initWithFrame:self.view.bounds];
    pickerbgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
    pickerbgView.tag = 101;
    pickerbgView.alpha = 0.0;
    [self.view addSubview:pickerbgView];
    
    [UIView animateWithDuration:0.5 animations:^{
        pickerbgView.alpha = 1.0;
    }];
    
    UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 390, SCREEN_WIDTH-120, 30)];
    centerLabel.backgroundColor = [UIColor clearColor];
    centerLabel.text = @"点击可查看工单详情";
    centerLabel.textColor = [UIColor whiteColor];
    centerLabel.textAlignment = NSTextAlignmentCenter;
    centerLabel.font = [UIFont systemFontOfSize:21];
    [pickerbgView addSubview:centerLabel];
    
    UIImageView *leftArrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(140, 430, 18, 31)];
    leftArrowIV.image = [UIImage imageNamed:@"arrow_right"];
    [pickerbgView addSubview:leftArrowIV];
    UIImageView *rightArrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-160, 430, 18, 31)];
    rightArrowIV.image = [UIImage imageNamed:@"arrow_left"];
    [pickerbgView addSubview:rightArrowIV];
    
    UIImageView *leftIV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 470, 130, 30)];
    leftIV.image = [UIImage imageNamed:@"Unfinished_Work_Order"];
    [pickerbgView addSubview:leftIV];
    UIImageView *rightIV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-5-135, 470, 130, 30)];
    rightIV.image = [UIImage imageNamed:@"Special_tickets"];
    [pickerbgView addSubview:rightIV];
    
    [[NSUserDefaults standardUserDefaults] setBool:1 forKey:Not_First_Launch];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark - createUI
- (void)createPieView
{
    //  ---------- 饼状图 ----------
    // CompletionHeader
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"BXTCompletionHeader" owner:nil options:nil] lastObject];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 400);
    [self.rootScrollView addSubview:self.headerView];
    
    // MYPieView
    NSDictionary *dataDict = self.percentArrat[0];
    NSArray *pieArray = [[NSMutableArray alloc] initWithObjects:dataDict[@"yes_percent"], dataDict[@"not_completed_percent"], dataDict[@"no_percent"], nil];
    
    // 1. create pieView
    self.headerView.pieView.backgroundColor = [UIColor whiteColor];
    
    // 2. fill data
    NSArray *colorArray = [[NSArray alloc] initWithObjects:@"#0eccc0", @"#fbcf62", @"#ff6f6f", nil];
    for(int i=0; i<pieArray.count; i++)
    {
        MYPieElement *elem = [MYPieElement pieElementWithValue:[pieArray[i] floatValue] color:colorWithHexString(colorArray[i])];
        elem.title = [NSString stringWithFormat:@"%@", pieArray[i]];
        [self.headerView.pieView.layer addValues:@[elem] animated:NO];
    }
    
    // 无参数处理
    if ([pieArray[0] intValue] == 0 && [pieArray[1] intValue] == 0 && [pieArray[2] intValue] == 0)
    {
        MYPieElement *elem = [MYPieElement pieElementWithValue:1 color:colorWithHexString(colorArray[0])];
        elem.title = [NSString stringWithFormat:@"%@", @"暂无工单"];
        [self.headerView.pieView.layer addValues:@[elem] animated:NO];
    }
    
    // 3. transform tilte
    self.headerView.pieView.layer.transformTitleBlock = ^(PieElement *elem, float percent){
        //NSLog(@"percent -- %f", percent);
        return [(MYPieElement *)elem title];
    };
    self.headerView.pieView.layer.showTitles = ShowTitlesAlways;
    
    // 4. didClick
    self.headerView.pieView.transSelected = ^(NSInteger index) {
        NSLog(@"index -- %ld", (long)index);
    };
    
    self.headerView.roundTitleView.text = [NSString stringWithFormat:@"报修总数:%@单", dataDict[@"sum_number"]];
    // Button
    NSString *allNumStr = [NSString stringWithFormat:@"报修总数:%@单", dataDict[@"sum_number"]];
    NSString *downNumStr = [NSString stringWithFormat:@"已修好:%@单", dataDict[@"yes_number"]];
    NSString *undownNumStr = [NSString stringWithFormat:@"未修好:%@单", dataDict[@"no_number"]];
    NSString *specialNumStr = [NSString stringWithFormat:@"未完成:%@单", dataDict[@"not_completed_num"]];
    self.headerView.sumView.text = allNumStr;
    self.headerView.goodJobView.attributedText = [self transToRichLabelOfIndex:4 String:downNumStr];
    self.headerView.badJobView.attributedText = [self transToRichLabelOfIndex:4 String:undownNumStr];
    self.headerView.unCompleteView.attributedText = [self transToRichLabelOfIndex:4 String:specialNumStr];
    __weak typeof(self) weakSelf = self;
    self.headerView.transBtnClick = ^(NSInteger tag) {
        if (tag == 2222 || tag == 3333 || tag == 4444) {
            BXTDailyOrderListViewController *dyListVC = [[BXTDailyOrderListViewController alloc] init];
            
            if (tag == 2222) {
                dyListVC.transStateStr = @"2";
                dyListVC.transFaultCarriedState = @"2";
            } else if (tag == 3333) {
                dyListVC.transStateStr = @"1";
                dyListVC.transFaultCarriedState = @"2";
            } else if (tag == 4444) {
                dyListVC.transFaultCarriedState = @"1";
            }
            
            dyListVC.transTimeArray = (NSMutableArray *)[BXTGlobal transTimeToWhatWeNeed:weakSelf.transTimeArray];
            [weakSelf.navigationController pushViewController:dyListVC animated:YES];
        }
    };
}

- (void)createBarChartViewWithType:(DateStr)type
{
    //  ---------- 柱状图 ----------
    // CompletionFooter
    self.footerView = [[[NSBundle mainBundle] loadNibNamed:@"BXTCompletionFooter" owner:nil options:nil] lastObject];
    self.footerView.frame = CGRectMake(0, 410, SCREEN_WIDTH, 480);
    [self.rootScrollView addSubview:self.footerView];
    self.rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.footerView.frame));
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 350)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 350);
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.footerView addSubview:scrollView];
    self.rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.footerView.frame));
    
    
    // 初始化
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    NSString *xText;
    CGFloat barChartW;
    if (type == year)
    {
        self.chooseType = year;
        finalArray = self.yearArray;
        xText = @"month";
        barChartW = 50;
    }
    else if (type == month)
    {
        self.chooseType = month;
        finalArray = self.monthArray;
        xText = @"day";
        barChartW = 40;
    }
    
    // SPBarChart
    SPBarChart *barChart = [[SPBarChart alloc] initWithFrame:CGRectMake(0, 0, barChartW * finalArray.count, scrollView.frame.size.height)];
    
    NSMutableArray *barArray = [[NSMutableArray alloc] init];
    NSMutableArray *heightArray = [[NSMutableArray alloc] init];
    NSArray *colorArray = @[colorWithHexString(@"#0FCCC0") , colorWithHexString(@"#F9D063") , colorWithHexString(@"#FD7070") ];
    
    for (NSDictionary *dict in finalArray)
    {
        NSString *downStr = [NSString stringWithFormat:@"%@", dict[@"yes_number"]];
        NSString *specialStr = [NSString stringWithFormat:@"%@", dict[@"not_completed_num"]];
        NSString *undownStr = [NSString stringWithFormat:@"%@", dict[@"no_number"]];
        NSNumber *downNum = [NSNumber numberWithInteger:[downStr integerValue]];
        NSNumber *specialNum = [NSNumber numberWithInteger:[specialStr integerValue]];
        NSNumber *undownNum = [NSNumber numberWithInteger:[undownStr integerValue]];
        
        NSArray *dataArray = @[downNum, specialNum, undownNum];
        if (type == year) {
            [barArray addObject:[SPBarChartData dataWithValues:dataArray colors:colorArray description:[NSString stringWithFormat:@"%@月", dict[xText]]]];
        }
        else {
            [barArray addObject:[SPBarChartData dataWithValues:dataArray colors:colorArray description:[NSString stringWithFormat:@"%@日", dict[xText]]]];
        }
        
        
        NSInteger sumNum = [downStr integerValue] + [specialStr integerValue] + [undownStr integerValue];
        NSString *sumStr = [NSString stringWithFormat:@"%ld", (long)sumNum];
        [heightArray addObject:sumStr];
    }
    
    
    [barChart setDatas:barArray];
    
    // Set maximum value
    NSNumber *maxNum = [heightArray valueForKeyPath:@"@max.floatValue"];
    int max = [maxNum intValue];
    max = ((max / 10) + 1) * 10;
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
    
    
    NSDictionary *firstDict = finalArray[0];
    NSString *downStr = [NSString stringWithFormat:@"%@", firstDict[@"yes_number"]];
    NSString *specialStr = [NSString stringWithFormat:@"%@", firstDict[@"not_completed_num"]];
    NSString *undownStr = [NSString stringWithFormat:@"%@", firstDict[@"no_number"]];
    
    NSString *typeStr = self.chooseType == year ? @"月" : @"日";
    self.footerView.titleView.text = [NSString stringWithFormat:@"1%@", typeStr];
    NSInteger sum = [downStr integerValue] + [specialStr integerValue] + [undownStr integerValue];
    self.footerView.sumView.text = [NSString stringWithFormat:@"共计：%ld单", (long)sum];
    self.footerView.goodJobView.text = [NSString stringWithFormat:@"已修好:%@单", downStr];
    self.footerView.badJobView.text = [NSString stringWithFormat:@"未修好:%@单", undownStr];
    self.footerView.unCompleteView.text = [NSString stringWithFormat:@"未完成:%@单", specialStr];
}

#pragma mark -
#pragma mark SPChartDelegate
- (void)SPChart:(SPBarChart *)chart barSelected:(NSInteger)barIndex barFrame:(CGRect)barFrame touchPoint:(CGPoint)touchPoint
{
    [self _dismissPopup];
    
    NSLog(@"Selected bar %ld", (long)barIndex);
    
    SPBarChartData * data = chart.datas[barIndex];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = [NSString stringWithFormat:@"%@ - %@ - %@", data.values[0], data.values[1], data.values[2]];
    label.font = chart.labelFont;
    label.textColor = [UIColor whiteColor];
    
    [label sizeToFit];
    
    NSLog(@"Selected bar %@", label.text);
    
    NSString *typeStr = self.chooseType == year ? @"月" : @"日";
    self.footerView.titleView.text = [NSString stringWithFormat:@"%ld%@", (long)barIndex + 1, typeStr];
    NSInteger sum = [data.values[0] integerValue] + [data.values[1] integerValue] + [data.values[2] integerValue];
    self.footerView.sumView.text = [NSString stringWithFormat:@"共计：%ld单", (long)sum];
    self.footerView.goodJobView.text = [NSString stringWithFormat:@"已修好：%@单", data.values[0]];
    self.footerView.badJobView.text = [NSString stringWithFormat:@"未修好：%@单", data.values[1]];
    self.footerView.unCompleteView.text = [NSString stringWithFormat:@"未完成：%@单", data.values[2]];
    
    SPChartPopup * popup = [[SPChartPopup alloc] initWithContentView:label];
    [popup setPopupColor:colorWithHexString(@"#999999")];
    [popup sizeToFit];
    
    //[popup showInView:chart withBottomAnchorPoint:CGPointMake(CGRectGetMidX(barFrame), CGRectGetMinY(barFrame))];
    self.popup = popup;
}

- (void)SPChartEmptySelection:(id)chart
{
    NSLog(@"Touch outside chart bar/line/piece");
}

- (void)_dismissPopup
{
    if (self.popup)
    {
        [self.popup dismiss];
    }
}

#pragma mark -
#pragma mark - 父类点击事件
- (void)segmentView:(SegmentView *)segmentView didSelectedSegmentAtIndex:(NSInteger)index
{
    [self.footerView removeFromSuperview];
    self.segementedIndex = index;
    
    NSMutableArray *dateArray;
    switch (index)
    {
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
    [self.transTimeArray removeAllObjects];
    [self.transTimeArray addObject:dateArray[0]];
    [self.transTimeArray addObject:dateArray[1]];
    
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**饼状图**/
        [self getResourceWithArray:dateArray];
    });
    dispatch_async(concurrentQueue, ^{
        /**柱状图**/
        NSArray *dateArray = [self timeTypeOf_YearAndMonth:self.rootCenterButton.titleLabel.text];
        if (index == 0)
        {
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request statisticsWorkloadYearWithYear:dateArray[0]];
        }
        else if (index == 1)
        {
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request statisticsWorkloadDayWithYear:dateArray[0] month:dateArray[1]];
        }
    });
}

- (void)datePickerBtnClick:(UIButton *)button
{
    [self.footerView removeFromSuperview];
    if (button.tag == 10001)
    {
        [self.headerView.pieView removeFromSuperview];
        self.rootSegmentedCtr.selectedSegmentIndex = 2;
        
        /**饼状图**/
        if (!selectedDate)
        {
            selectedDate = [NSDate date];
        }
        [self.rootCenterButton setTitle:[self weekdayStringFromDate:selectedDate] forState:UIControlStateNormal];
        
        NSString *todayStr = [self transTimeWithDate:selectedDate];
        [self.transTimeArray removeAllObjects];
        [self.transTimeArray addObject:todayStr];
        [self.transTimeArray addObject:todayStr];
        
        
        /**饼状图**/
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
    NSArray *data = dic[@"data"];
    if (type == Statistics_Complete && data.count > 0)
    {
        self.percentArrat = dic[@"data"];
        [self createPieView];
    }
    else if (type == Statistics_Workload_day && data.count > 0)
    {
        self.monthArray = [[NSMutableArray alloc] initWithArray:data];
        [self createBarChartViewWithType:month];
    }
    else if (type == Statistics_Workload_year && data.count > 0)
    {
        self.yearArray = [[NSMutableArray alloc] initWithArray:data];
        [self createBarChartViewWithType:year];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

#pragma mark -
#pragma mark - 富文本转化
- (NSMutableAttributedString *)transToRichLabelOfIndex:(NSInteger)index String:(NSString *)originStr
{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:originStr];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:colorWithHexString(@"#3AB0FF")
                          range:NSMakeRange(index, originStr.length - index)];
    return AttributedStr;
}

- (NSString *)transDateToTimeStamp:(NSString *)time
{
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter1 dateFromString:time];
    NSString *confromTimespStr = [NSString stringWithFormat:@"%0.f", [date timeIntervalSince1970]];
    return confromTimespStr;
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
