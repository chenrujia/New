//
//  CompletionViewController.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/25.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "CompletionViewController.h"

@interface CompletionViewController () <BXTDataResponseDelegate>

@property (nonatomic, strong) NSMutableArray *percentArrat;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) MYPieView *pieView;

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
        [self createBarTimeAxisView];
    }
}

- (void)requestError:(NSError *)error {
    
}

#pragma mark -
#pragma mark - createUI
- (void)createPieView {
    NSDictionary *dataDict = self.percentArrat[0];
    NSArray *pieArray = [[NSMutableArray alloc] initWithObjects:dataDict[@"yes_percent"], dataDict[@"collection_percent"], dataDict[@"no_percent"], nil];
    
    //  ---------- 饼状图 ----------
    // 1. create pieView
    CGFloat pieViewH = 300;
    
    self.pieView = [[MYPieView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, pieViewH)];
    self.pieView.backgroundColor = [UIColor whiteColor];
    [self.rootScrollView addSubview:self.pieView];
    
    NSArray *colorArray = [[NSArray alloc] initWithObjects:@"#0eccc0", @"#fbcf62", @"#ff6f6f", nil];
    // 2. fill data
    for(int i=0; i<pieArray.count; i++){
        MYPieElement *elem = [MYPieElement pieElementWithValue:[pieArray[i] floatValue] color:colorWithHexString(colorArray[i])];
        elem.title = [NSString stringWithFormat:@"%@", pieArray[i]];
        [self.pieView.layer addValues:@[elem] animated:NO];
    }
    
    // 3. transform tilte
    self.pieView.layer.transformTitleBlock = ^(PieElement *elem, float percent){
        NSLog(@"percent -- %f", percent);
        return [(MYPieElement *)elem title];
    };
    self.pieView.layer.showTitles = ShowTitlesAlways;
    
    // 4. didClick
    self.pieView.transSelected = ^(NSInteger index) {
        NSLog(@"index -- %ld", index);
    };
    
    
    NSString *allNumStr = [NSString stringWithFormat:@"保修总数：%@", dataDict[@"sum_number"]];
    NSString *downNumStr = [NSString stringWithFormat:@"已完成：%@", dataDict[@"yes_number"]];
    NSString *undownNumStr = [NSString stringWithFormat:@"未完成：%@", dataDict[@"no_number"]];
    NSString *specialNumStr = [NSString stringWithFormat:@"特殊工单：%@", dataDict[@"collection_number"]];
    
    // downView
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, pieViewH, SCREEN_WIDTH, 75)];
    downView.backgroundColor = [UIColor whiteColor];
    [self.rootScrollView addSubview:downView];
    UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 1)];
    downLine.backgroundColor = colorWithHexString(@"#d9d9d9");
    [downView addSubview:downLine];
    
    // downView - contentView
    // 保修总数
    UIButton *btn_all = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_all.frame = CGRectMake(15, 5, 120, 30);
    [btn_all setTitle:allNumStr forState:UIControlStateNormal];
    [btn_all setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn_all.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn_all addTarget:self action:@selector(downBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn_all.tag = 1001;
    [downView addSubview:btn_all];
    // 已完成
    UIButton *btn_done = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_done.frame = CGRectMake(SCREEN_WIDTH-30-120, 5, 120, 30);
    [btn_done setTitle:downNumStr forState:UIControlStateNormal];
    [btn_done setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn_done.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn_done addTarget:self action:@selector(downBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn_done.tag = 1002;
    [downView addSubview:btn_done];
    // 未完成
    UIButton *btn_undone = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_undone.frame = CGRectMake(15, 35, 120, 30);
    [btn_undone setTitle:undownNumStr forState:UIControlStateNormal];
    [btn_undone setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn_undone.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn_undone addTarget:self action:@selector(downBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn_undone.tag = 1003;
    [downView addSubview:btn_undone];
    // 特殊工单
    UIButton *btn_special = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_special.frame = CGRectMake(SCREEN_WIDTH-30-120, 35, 120, 30);
    [btn_special setTitle:specialNumStr forState:UIControlStateNormal];
    [btn_special setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn_special.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn_special addTarget:self action:@selector(downBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn_special.tag = 1004;
    [downView addSubview:btn_special];
    
    
    
}

- (void)createBarTimeAxisView {
    //  ---------- 柱状图 ----------
    // upView
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 375+10, SCREEN_WIDTH, 40)];
    upView.backgroundColor = [UIColor whiteColor];
    [self.rootScrollView addSubview:upView];
    UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(10, 39, SCREEN_WIDTH-20, 1)];
    upLine.backgroundColor = colorWithHexString(@"#d9d9d9");
    [upView addSubview:upLine];
    
    UILabel *upLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 90, 20)];
    upLabel.text = @"单月统计量";
    upLabel.font = [UIFont systemFontOfSize:15];
    upLabel.textColor = colorWithHexString(@"#666666");
    [upView addSubview:upLabel];
    
    // create BarTimeAxisView
    BarTimeAxisView *barTAV = [[BarTimeAxisView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upView.frame), SCREEN_WIDTH, 250)];
    barTAV.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    [self.rootScrollView addSubview:barTAV];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceReferenceDate:1];
    BarTimeAxisData *firstData = [BarTimeAxisData dataWithDate:nowDate andNumber:[NSNumber numberWithInt:3]];
    [dataArray addObject:firstData];
    
    for (NSDictionary *dict in self.monthArray) {
        BarTimeAxisData *data = [BarTimeAxisData dataWithDate:[NSDate dateWithTimeInterval:[dict[@"day"] intValue]*86400 sinceDate:nowDate] andNumber:[NSNumber numberWithInt:[dict[@"yes_number"] intValue]]];
        [dataArray addObject:data];
    }
    
    barTAV.dataSource = dataArray;
    // barGraph.colorArray = @[@"#0dccc1", @"#fad063", @"#7c99db", @"fc7070"];
    
    self.rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(barTAV.frame));
}

#pragma mark -
#pragma mark - downBtnClick
- (void)downBtnClick:(UIButton *)button {
    NSLog(@"button.tag -- %ld", button.tag);
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
    [request statistics_completeWithTime_start:dateArray[0] time_end:dateArray[1]];
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
