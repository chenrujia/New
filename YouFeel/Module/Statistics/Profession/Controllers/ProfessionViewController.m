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

@interface ProfessionViewController () <BXTDataResponseDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) ProfessionHeader *headerView;
@property (nonatomic, strong) MYPieView *pieView;

@end

@implementation ProfessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**饼状图**/
        NSArray *dateArray = [BXTGlobal yearStartAndEnd];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request statistics_subgroupWithTime_start:dateArray[0] time_end:dateArray[1]];
    });
    dispatch_async(concurrentQueue, ^{
        /**柱状图**/
//        NSArray *dateArray = [BXTGlobal yearAndmonthAndDay];
//        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
//        [request statistics_workload_dayWithYear:dateArray[0] month:dateArray[1]];
    });
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type {
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = dic[@"data"];
    if (type == Statistics_Subgroup && data.count > 0) {
        self.dataArray = dic[@"data"];
        [self createPieView];
        
    }
//    else if (type == Statistics_Workload_day && data.count > 0) {
//        self.monthArray = [[NSMutableArray alloc] initWithArray:data];
//        [self createBarTimeAxisView];
//    }
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
    
    NSDictionary *selectedDict = self.dataArray[0];
    self.headerView.groupView.text = [NSString stringWithFormat:@"%@", selectedDict[@"subgroup"]];
    self.headerView.percentView.text = [NSString stringWithFormat:@"%@%%", selectedDict[@"sum_percent"]];
    self.headerView.sumView.text = [NSString stringWithFormat:@"共计:%@单", selectedDict[@"sum_number"]];
    
    // 4. didClick
    __weak typeof(self) weakSelf = self;
    self.pieView.transSelected = ^(NSInteger index) {
        //NSLog(@"index -- %ld", index);
        NSDictionary *selectedDict = weakSelf.dataArray[index];
        weakSelf.headerView.groupView.text = [NSString stringWithFormat:@"%@", selectedDict[@"subgroup"]];
        weakSelf.headerView.percentView.text = [NSString stringWithFormat:@"%@%%", selectedDict[@"sum_percent"]];
        weakSelf.headerView.sumView.text = [NSString stringWithFormat:@"共计:%@单", selectedDict[@"sum_number"]];
    };
}

- (void)createBarTimeAxisView {
    
    // ProfessionFooter
    ProfessionFooter *footerView = [[[NSBundle mainBundle] loadNibNamed:@"ProfessionFooter" owner:nil options:nil] lastObject];
    footerView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame)+10, SCREEN_WIDTH, 370);
    [self.rootScrollView addSubview:footerView];
    self.rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(footerView.frame));
    
    
    //  ---------- 柱状图 ----------
    BarTimeAxisView *barTAV = [[BarTimeAxisView alloc] initWithFrame:CGRectMake(-10, 70, SCREEN_WIDTH, 225)];
    barTAV.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    [footerView addSubview:barTAV];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceReferenceDate:1];
    BarTimeAxisData *firstData = [BarTimeAxisData dataWithDate:nowDate andNumber:[NSNumber numberWithInt:3]];
    [dataArray addObject:firstData];
    
    for (int i=86400; i<864000; i+=86400) {
        int rand = 1+arc4random()%8;
        BarTimeAxisData *data = [BarTimeAxisData dataWithDate:[NSDate dateWithTimeInterval:i sinceDate:nowDate] andNumber:[NSNumber numberWithInt:rand+6]];
        [dataArray addObject:data];
    }
    
    barTAV.dataSource = dataArray;
    // barGraph.colorArray = @[@"#0dccc1", @"#fad063", @"#7c99db", @"fc7070"];
}

#pragma mark -
#pragma mark - 父类点击事件
- (void)didClicksegmentedControlAction:(UISegmentedControl *)segmented {
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
