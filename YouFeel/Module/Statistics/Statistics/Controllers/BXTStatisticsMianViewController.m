//
//  StatisticsMianViewController.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/25.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "BXTStatisticsMianViewController.h"
#import "MBProgressHUD.h"

@interface BXTStatisticsMianViewController () <MBProgressHUDDelegate>

@end

@implementation BXTStatisticsMianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self createNavigationBar];
    
    
    self.rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 110.f, SCREEN_WIDTH, SCREEN_HEIGHT-110.f)];
    self.rootScrollView.backgroundColor = colorWithHexString(@"eff3f6");
    self.rootScrollView.showsVerticalScrollIndicator = NO;
    self.rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-110);
    [self.view addSubview:self.rootScrollView];
}

- (void)createNavigationBar {
    // backgroundView
    UIImageView *navBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110.f)];
    if ([BXTGlobal shareGlobal].isRepair) {
        navBarView.image = [UIImage imageNamed:@"Nav_Bars"];
    } else {
        navBarView.image = [UIImage imageNamed:@"Nav_Bar"];
    }
    navBarView.userInteractionEnabled = YES;
    [self.view addSubview:navBarView];
    
    // leftButton
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(6, 20, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"arrowBack"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(navigationLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    
    // centerButton
    self.rootCenterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rootCenterButton.frame = CGRectMake(60, 20, SCREEN_WIDTH-120, 44);
    [self.rootCenterButton setTitle:[self weekdayStringFromDate:[NSDate date]] forState:UIControlStateNormal];
    [self.rootCenterButton setImage:[UIImage imageNamed:@"small-triangles"] forState:UIControlStateNormal];
    self.rootCenterButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rootCenterButton addTarget:self action:@selector(navigationcenterButton) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:self.rootCenterButton];
    
    CGFloat titleW = 145;
    CGFloat padding = 20;
    [self.rootCenterButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [self.rootCenterButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleW+padding, 0, -titleW-padding)];
    
    
    // rightButton
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH-44-6, 20, 44, 44);
    [rightBtn setImage:[UIImage imageNamed:@"w_small_round"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(navigationRightButton) forControlEvents:UIControlEventTouchUpInside];
    //[navBarView addSubview:rightBtn];
    
    // UISegmentedControl
    [self createSegmentedCtr];
}

- (void)navigationLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightButton {
    NSLog(@"更多");
}

- (void)navigationcenterButton {
    [self createDatePicker];
}

#pragma mark -
#pragma mark - createSegmentedCtr
- (void)createSegmentedCtr {
    // 分页视图
    self.rootSegmentedCtr = [[SegmentView alloc] initWithFrame:CGRectMake(15, 110-30-10, SCREEN_WIDTH-30, 30) andTitles:@[@"年", @"月", @"日"] isWhiteBGColor:0];
    self.rootSegmentedCtr.layer.masksToBounds = YES;
    self.rootSegmentedCtr.layer.cornerRadius = 4.f;
    self.rootSegmentedCtr.delegate = self;
    [self.view addSubview:self.rootSegmentedCtr];
}

- (void)segmentView:(SegmentView *)segmentView didSelectedSegmentAtIndex:(NSInteger)index {
    NSLog(@"didSelectedSegmentAtIndex -- %ld", (long)index);
}

#pragma mark -
#pragma mark - createDatePicker
- (void)createDatePicker {
    pickerbgView = [[UIView alloc] initWithFrame:self.view.bounds];
    pickerbgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    pickerbgView.tag = 101;
    pickerbgView.alpha = 0.0;
    [self.view addSubview:pickerbgView];
    
    [UIView animateWithDuration:0.5 animations:^{
        pickerbgView.alpha = 1.0;
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-50-40, SCREEN_WIDTH, 40)];
    titleLabel.backgroundColor = colorWithHexString(@"ffffff");
    titleLabel.text = @"请选择时间";
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [pickerbgView addSubview:titleLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame)-1, SCREEN_WIDTH-30, 1)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [pickerbgView addSubview:line];
    
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216-50, SCREEN_WIDTH, 216)];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    datePicker.backgroundColor = colorWithHexString(@"ffffff");
    datePicker.maximumDate = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
    [pickerbgView addSubview:datePicker];
    
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    toolView.backgroundColor = colorWithHexString(@"ffffff");
    [pickerbgView addSubview:toolView];
    // sure
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 50)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(datePickerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.tag = 10001;
    sureBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    sureBtn.layer.borderWidth = 0.5;
    [toolView addSubview:sureBtn];
    // cancel
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 50)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(datePickerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    cancelBtn.layer.borderWidth = 0.5;
    cancelBtn.tag = 10002;
    [toolView addSubview:cancelBtn];
}

- (void)dateChange:(UIDatePicker *)picker {
    selectedDate = picker.date;
}

- (void)datePickerBtnClick:(UIButton *)button {
    [UIView animateWithDuration:0.5 animations:^{
        pickerbgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        datePicker = nil;
        [pickerbgView removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        [UIView animateWithDuration:0.5 animations:^{
            view.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (datePicker)
            {
                [datePicker removeFromSuperview];
                datePicker = nil;
            }
            [view removeFromSuperview];
        }];
    }
}

#pragma mark -
#pragma mark - 封装方法
// 时间戳转换成 2015-11-27 格式
- (NSString *)transTimeWithDate:(NSDate *)date {
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"YYYY-MM-dd"];
    return [formatter1 stringFromDate:date];
}

// 时间戳转换成 2015年11月27日 星期五 格式
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sunday", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    NSString *weekStr = [weekdays objectAtIndex:theComponents.weekday];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"YYYY年MM月dd日"];
    NSString *dateStr = [formatter1 stringFromDate:inputDate];
    
    return [NSString stringWithFormat:@"%@ %@", dateStr, weekStr];
}

- (void)showLoadingMBP:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.delegate = self;
    hud.removeFromSuperViewOnHide = YES;
}

- (void)hideMBP
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark -
#pragma mark - 日期处理
- (NSArray *)timeTypeOf_YearStartAndEnd:(NSString *)dateStr {
    NSString *yearStr = [dateStr substringToIndex:4];
    
    NSString *startTime = [NSString stringWithFormat:@"%@-1-1", yearStr];
    NSString *endTime = [NSString stringWithFormat:@"%@-12-31",yearStr];
    
    return [NSArray arrayWithObjects:startTime, endTime, nil];
}

- (NSArray *)timeTypeOf_YearAndMonth:(NSString *)dateStr {
    NSString *yearStr = [dateStr substringToIndex:4];
    NSString *monthStr = [dateStr substringWithRange:NSMakeRange(5, 2)];
    
    return [NSArray arrayWithObjects:yearStr, monthStr, nil];
}

- (NSArray *)timeTypeOf_MonthStartAndEnd:(NSString *)dateStr {
    NSString *yearStr = [dateStr substringToIndex:4];
    NSString *monthStr = [dateStr substringWithRange:NSMakeRange(5, 2)];
    
    int monthDays = [self howManyDaysInThisMonth:[yearStr intValue] month:[monthStr intValue]];
    NSString *startTime = [NSString stringWithFormat:@"%@-%@-1", yearStr, monthStr];
    NSString *endTime = [NSString stringWithFormat:@"%@-%@-%d",yearStr, monthStr, monthDays];
    
    return [NSArray arrayWithObjects:startTime, endTime, nil];
}

- (NSArray *)timeTypeOf_DayStartAndEnd:(NSString *)dateStr {
    NSString *yearStr = [dateStr substringToIndex:4];
    NSString *monthStr = [dateStr substringWithRange:NSMakeRange(5, 2)];
    NSString *dayStr = [dateStr substringWithRange:NSMakeRange(8, 2)];
    
    NSString *startTime = [NSString stringWithFormat:@"%@-%@-%@", yearStr, monthStr, dayStr];
    NSString *endTime = [NSString stringWithFormat:@"%@-%@-%@",yearStr, monthStr, dayStr];
    
    return [NSArray arrayWithObjects:startTime, endTime, nil];
}

- (int)howManyDaysInThisMonth:(int)year month:(int)imonth {
    if((imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12)) {
        return 31;
    }
    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11)) {
        return 30;
    }
    if((year%4 == 1)||(year%4 == 2)||(year%4 == 3)) {
        return 28;
    }
    if(year%400 == 0) {
        return 29;
    }
    if(year%100 == 0) {
        return 28;
    }
    return 29;
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
