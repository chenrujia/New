//
//  ProfessionViewController.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/26.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "ProfessionViewController.h"
#import "ProfessionHeader.h"
#import "ProfessionFooter.h"
#import "MYPieElement.h"

@interface ProfessionViewController () <BXTDataResponseDelegate, SPChartDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) ProfessionHeader *headerView;
@property (nonatomic, strong) MYPieView *pieView;
@property (nonatomic, strong) ProfessionFooter *footerView;
@property (weak, nonatomic) SPBarChart *barChartView;
@property (weak, nonatomic) SPChartPopup *popup;

@end

@implementation ProfessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    
    NSArray *dateArray = [BXTGlobal yearStartAndEnd];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request statistics_subgroupWithTime_start:dateArray[0] time_end:dateArray[1]];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type {
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = dic[@"data"];
    if (type == Statistics_Subgroup && data.count > 0) {
        self.dataArray = dic[@"data"];
        [self createPieView];
        [self createBarChartView];
    }
}

- (void)requestError:(NSError *)error {
    
}

#pragma mark -
#pragma mark - createUI
- (void)createPieView {
    // ProfessionHeader
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"ProfessionHeader" owner:nil options:nil] lastObject];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 400);
    [self.rootScrollView addSubview:self.headerView];
    
    //  ---------- 饼状图 ----------
    // 1. create pieView
    CGFloat pieViewH = 260;
    self.pieView = [[MYPieView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, pieViewH)];
    self.pieView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:self.pieView];
    
    // 2. fill data
    NSArray *colorArray = [[NSArray alloc] initWithObjects:@"#f1a161", @"#74bde9", @"#93c322", @"#a17bb5", nil];
    for(int i=0; i<self.dataArray.count; i++){
        UIColor *elemColor = [BXTGlobal randomColor];
        if (i<4) {
            elemColor = colorWithHexString(colorArray[i]);
        }
        NSDictionary *elemDict = self.dataArray[i];
        MYPieElement *elem = [MYPieElement pieElementWithValue:[elemDict[@"sum_percent"] floatValue] color:elemColor];
        elem.title = [NSString stringWithFormat:@"%@ %@", elemDict[@"subgroup"], elemDict[@"sum_percent"]];
        [self.pieView.layer addValues:@[elem] animated:NO];
    }
    
    // 3. transform tilte
    self.pieView.layer.transformTitleBlock = ^(PieElement *elem, float percent){
        //NSLog(@"percent -- %f", percent);
        return [(MYPieElement *)elem title];
    };
    self.pieView.layer.showTitles = ShowTitlesAlways;
    
    // 4. didClick
    __weak typeof(self) weakSelf = self;
    self.pieView.transSelected = ^(NSInteger index) {
        //NSLog(@"index -- %ld", index);
        NSDictionary *selectedDict = weakSelf.dataArray[index];
        weakSelf.headerView.groupView.text = [NSString stringWithFormat:@"%@", selectedDict[@"subgroup"]];
        weakSelf.headerView.percentView.text = [NSString stringWithFormat:@"%@%%", selectedDict[@"sum_percent"]];
        weakSelf.headerView.sumView.text = [NSString stringWithFormat:@"共计:%@单", selectedDict[@"sum_number"]];
    };
    
    NSDictionary *selectedDict = self.dataArray[0];
    self.headerView.groupView.text = [NSString stringWithFormat:@"%@", selectedDict[@"subgroup"]];
    self.headerView.percentView.text = [NSString stringWithFormat:@"%@%%", selectedDict[@"sum_percent"]];
    self.headerView.sumView.text = [NSString stringWithFormat:@"共计:%@单", selectedDict[@"sum_number"]];
}

- (void)createBarChartView {
    // ProfessionFooter
    self.footerView = [[[NSBundle mainBundle] loadNibNamed:@"ProfessionFooter" owner:nil options:nil] lastObject];
    self.footerView.frame = CGRectMake(0, 410, SCREEN_WIDTH, 420);
    [self.rootScrollView addSubview:self.footerView];
    self.rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.footerView.frame));
    
    
    //  ---------- 柱状图 ----------
    // SPBarChart
    SPBarChart *barChart = [[SPBarChart alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 300)];
    
    NSMutableArray *barArray = [[NSMutableArray alloc] init];
    NSMutableArray *heightArray = [[NSMutableArray alloc] init];
    NSArray *colorArray = @[colorWithHexString(@"#0FCCC0") , colorWithHexString(@"#F9D063") , colorWithHexString(@"#FD7070") ];
    
    for (NSDictionary *dict in self.dataArray) {
        NSString *downStr = [NSString stringWithFormat:@"%@", dict[@"yes_number"] ];
        NSString *specialStr = [NSString stringWithFormat:@"%@", dict[@"collection_number"] ];
        NSString *undownStr = [NSString stringWithFormat:@"%@", dict[@"no_number"] ];
        NSNumber *downNum = [NSNumber numberWithInteger:[downStr integerValue]];
        NSNumber *specialNum = [NSNumber numberWithInteger:[specialStr integerValue]];
        NSNumber *undownNum = [NSNumber numberWithInteger:[undownStr integerValue]];
        
        NSArray *dataArray = @[downNum, specialNum, undownNum];
        [barArray addObject:[SPBarChartData dataWithValues:dataArray colors:colorArray description:[NSString stringWithFormat:@"%@", dict[@"subgroup"]]]];
        
        NSString *sumStr = [NSString stringWithFormat:@"%@", dict[@"sum_number"] ];
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
    
    [self.footerView addSubview:barChart];
    
    NSDictionary *selecteDict = self.dataArray[0];
    self.footerView.groupView.text = [NSString stringWithFormat:@"%@", selecteDict[@"subgroup"]];
    self.footerView.sumView.text = [NSString stringWithFormat:@"共计:%@单", selecteDict[@"sum_number"]];
    self.footerView.downView.text = [NSString stringWithFormat:@"完成:%@单", selecteDict[@"yes_number"]];
    self.footerView.undownView.text = [NSString stringWithFormat:@"未完成:%@单", selecteDict[@"no_number"]];
}

#pragma mark -
#pragma mark SPChartDelegate
- (void)SPChart:(SPBarChart *)chart barSelected:(NSInteger)barIndex barFrame:(CGRect)barFrame touchPoint:(CGPoint)touchPoint {
    [self _dismissPopup];
    
    SPBarChartData * data = chart.datas[barIndex];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = [NSString stringWithFormat:@"%@ - %@ - %@", data.values[0], data.values[1], data.values[2]];
    label.font = chart.labelFont;
    label.textColor = [UIColor whiteColor];
    
    [label sizeToFit];
    
    //NSLog(@"Selected bar %@", label.text);
    NSDictionary *selecteDict = self.dataArray[barIndex];
    self.footerView.groupView.text = [NSString stringWithFormat:@"%@", selecteDict[@"subgroup"]];
    self.footerView.sumView.text = [NSString stringWithFormat:@"共计:%@单", selecteDict[@"sum_number"]];
    self.footerView.downView.text = [NSString stringWithFormat:@"完成:%@单", selecteDict[@"yes_number"]];
    self.footerView.undownView.text = [NSString stringWithFormat:@"未完成:%@单", selecteDict[@"no_number"]];
    
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
    [request statistics_subgroupWithTime_start:dateArray[0] time_end:dateArray[1]];
}

- (void)datePickerBtnClick:(UIButton *)button {
    if (button.tag == 10001) {
        [self.pieView removeFromSuperview];
        
        /**饼状图**/
        if (!selectedDate) {
            selectedDate = [NSDate date];
        }
        [self.rootCenterButton setTitle:[self weekdayStringFromDate:selectedDate] forState:UIControlStateNormal];
        
        NSString *todayStr = [self transTimeWithDate:selectedDate];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request statistics_subgroupWithTime_start:todayStr time_end:todayStr];
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
