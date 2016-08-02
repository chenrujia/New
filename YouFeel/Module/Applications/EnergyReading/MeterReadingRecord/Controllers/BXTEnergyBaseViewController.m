//
//  BXTEnergyBaseViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/6/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyBaseViewController.h"

#define headerViewH 256

@interface BXTEnergyBaseViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

// 日期选择
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, assign) NSDate *startDate;
@property (nonatomic, assign) NSDate *endDate;

// 年份选择
@property (nonatomic, strong) UIPickerView *yearPickerView;
@property (nonatomic, strong) NSMutableArray *yearArray;

@end

@implementation BXTEnergyBaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = colorWithHexString(ValueFUD(EnergyReadingColorStr));
    
    NSArray *array = [BXTGlobal yearAndmonthAndDay];
    self.yearStr = array[0];
    
    self.yearArray = [[NSMutableArray alloc] init];
    for (int i = 2001; i<=[self.yearStr intValue]; i++)
    {
        [self.yearArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
}

#pragma mark -
#pragma mark 设置导航条
- (void)navigationSetting:(NSString *)title
           andRightTitle1:(NSString *)right_title1
           andRightImage1:(UIImage *)image1
           andRightTitle2:(NSString *)right_title2
           andRightImage2:(UIImage *)image2
{
    // navView
    UIView *navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KNAVIVIEWHEIGHT)];
    navView.backgroundColor = [UIColor clearColor];
    navView.userInteractionEnabled = YES;
    [self.view addSubview:navView];
    
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 20, SCREEN_WIDTH-128, 44)];
    titleLabel.font = [UIFont systemFontOfSize:18.f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [navView addSubview:titleLabel];
    
    // leftButton
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 20, 44, 44);
    [leftButton setImage:[UIImage imageNamed:@"arrowBack"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(navigationLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:leftButton];
    
    if (!(image1 || right_title1))
    {
        return;
    }
    // rightButton1
    self.rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton1 setFrame:CGRectMake(SCREEN_WIDTH - 64.f - 5.f, 20, 64.f, 44.f)];
    if (image1)
    {
        self.rightButton1.frame = CGRectMake(SCREEN_WIDTH - 44.f - 5.f, 20, 44.f, 44.f);
        [self.rightButton1 setImage:image1 forState:UIControlStateNormal];
    }
    else
    {
        [self.rightButton1 setTitle:right_title1 forState:UIControlStateNormal];
    }
    self.rightButton1.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.rightButton1 addTarget:self action:@selector(navigationRightButton1) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:self.rightButton1];
    
    if (!(image2 || right_title2))
    {
        return;
    }
    // rightButton2
    UIButton *rightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton2 setFrame:CGRectMake(CGRectGetMinX(self.rightButton1.frame) - 65, 20, 64.f, 44.f)];
    if (image2)
    {
        [rightButton2 setImage:image2 forState:UIControlStateNormal];
    }
    else
    {
        [rightButton2 setTitle:right_title2 forState:UIControlStateNormal];
    }
    rightButton2.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [rightButton2 addTarget:self action:@selector(navigationRightButton2) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rightButton2];
}

- (void)navigationLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightButton1
{
    
}

- (void)navigationRightButton2
{
    
}

#pragma mark -
#pragma mark - createYearPickerView
- (void)createYearPickerView
{
    // bgView
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    bgView.tag = 103;
    [self.view addSubview:bgView];
    
    // headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(40, (SCREEN_HEIGHT - headerViewH) / 2, SCREEN_WIDTH - 80, headerViewH)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.layer.cornerRadius = 5;
    [bgView addSubview:headerView];
    
    
    CGFloat headerViewW = headerView.frame.size.width;
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, headerViewW, 30)];
    titleLabel.text = @"选择时间";
    titleLabel.textColor = colorWithHexString(@"333333");
    titleLabel.font = [UIFont systemFontOfSize:18.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44, headerViewW, 1)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [headerView addSubview:line];
    
    // self.yearPickerView
    self.yearPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, headerViewW, 162)];
    self.yearPickerView.delegate = self;
    self.yearPickerView.dataSource = self;
    [headerView addSubview:self.yearPickerView];
    
    NSInteger index = [self.yearStr integerValue] - 2001;
    self.yearStr = self.yearArray[index];
    [self.yearPickerView selectRow:index inComponent:0 animated:YES];
    
    // 按钮
    UIButton *cancelBtn = [self createButtonWithTitle:@"取消" btnX:10 tilteColor:@"#FFFFFF"];
    [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (_yearPickerView)
        {
            [_yearPickerView removeFromSuperview];
            _yearPickerView = nil;
        }
        [bgView removeFromSuperview];
    }];
    [headerView addSubview:cancelBtn];
    
    self.commitBtn = [self createButtonWithTitle:@"确定" btnX:headerViewW / 2 + 5  tilteColor:@"#5DAFF9"];
    [[self.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (_yearPickerView)
        {
            [_yearPickerView removeFromSuperview];
            _yearPickerView = nil;
        }
        [bgView removeFromSuperview];
    }];
    [headerView addSubview:self.commitBtn];
}

#pragma mark -
#pragma mark - UIPickerView代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.yearArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.yearArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.yearStr = self.yearArray[row];
    //    NSLog(@"title ------ %@", self.yearStr);
}

#pragma mark -
#pragma mark - other
- (UIButton *)createButtonWithTitle:(NSString *)titleStr btnX:(CGFloat)btnX tilteColor:(NSString *)colorStr
{
    UIButton *newMeterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newMeterBtn.frame = CGRectMake(btnX, headerViewH - 50, (SCREEN_WIDTH - 80 - 30) / 2, 40);
    [newMeterBtn setBackgroundColor:colorWithHexString(colorStr)];
    [newMeterBtn setTitle:titleStr forState:UIControlStateNormal];
    newMeterBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    newMeterBtn.layer.borderWidth = 1;
    if ([colorStr isEqualToString:@"#FFFFFF"]) {
        [newMeterBtn setTitleColor:colorWithHexString(@"#5DAFF9") forState:UIControlStateNormal];
    }
    newMeterBtn.layer.borderColor = [colorWithHexString(@"#5DAFF9") CGColor];
    newMeterBtn.layer.cornerRadius = 5;
    
    return newMeterBtn;
}

#pragma mark -
#pragma mark - TimerFilter
- (void)createDatePickerWithType:(NSInteger)pickerType
{
    // bgView
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    bgView.tag = 101;
    [self.view addSubview:bgView];
    
    
    // headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-50-50, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:headerView];
    
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 30)];
    titleLabel.text = [self getPickerTypeString:pickerType];
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    [headerView addSubview:titleLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [headerView addSubview:line];
    
    // timeLabel
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 165, 10, 150, 30)];
    timeLabel.text = [self weekdayStringFromDate:[NSDate date]];
    timeLabel.textColor = colorWithHexString(@"#3BAFFF");
    timeLabel.font = [UIFont systemFontOfSize:16.f];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:timeLabel];
    
    
    // datePicker
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216-50, SCREEN_WIDTH, 216)];
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    self.datePicker.backgroundColor = colorWithHexString(@"ffffff");
    self.datePicker.maximumDate = [NSDate date];
    if ([titleLabel.text isEqualToString:@"开始时间"]) {
        if (self.endDate) {
            self.datePicker.maximumDate = self.endDate;
        }
    }
    if ([titleLabel.text isEqualToString:@"结束时间"]) {
        if (self.startDate) {
            self.datePicker.minimumDate = self.startDate;
        }
    }
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    @weakify(self);
    [[self.datePicker rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self);
        // 显示时间
        timeLabel.text = [self weekdayStringFromDate:self.datePicker.date];
    }];
    [bgView addSubview:self.datePicker];
    
    
    // toolView
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    toolView.backgroundColor = colorWithHexString(@"#EEF3F6");
    [bgView addSubview:toolView];
    
    // sure
    self.sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 50)];
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.sureBtn.backgroundColor = [UIColor whiteColor];
    [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.timeStr = timeLabel.text;
        
        if ([titleLabel.text isEqualToString:@"开始时间"]) {
            self.startDate = self.datePicker.date;
        }
        if ([titleLabel.text isEqualToString:@"结束时间"]) {
            self.endDate = self.datePicker.date;
        }
        
        self.datePicker = nil;
        [bgView removeFromSuperview];
    }];
    self.sureBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    self.sureBtn.layer.borderWidth = 0.5;
    [toolView addSubview:self.sureBtn];
}

- (NSString *)getPickerTypeString:(PickerType)pickerType {
    NSString *titleStr;
    switch (pickerType) {
        case PickerTypeOFStart: titleStr = @"开始时间"; break;
        case PickerTypeOFEnd: titleStr = @"结束时间"; break;
        case PickerTypeOFRange: titleStr = @"时间范围"; break;
        default: break;
    }
    return titleStr;
}

// 时间戳转换成 2015年11月27日 星期五 格式
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate
{
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter1 stringFromDate:inputDate];
    
    return dateStr;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        if (_datePicker)
        {
            [_datePicker removeFromSuperview];
            _datePicker = nil;
        }
        [view removeFromSuperview];
    }
    else if (view.tag == 103)
    {
        if (_yearPickerView)
        {
            [_yearPickerView removeFromSuperview];
            _yearPickerView = nil;
        }
        [view removeFromSuperview];
    }
}

//计量表接口，添加一个返回字段：check_price_type
//值 ：1-6
//1.手动，单一
//2.手动，峰谷
//3.手动，阶梯
//4.自动，单一
//5.自动，峰谷
//6.自动，阶梯
- (UIImage *)returnIconImageWithCheckPriceType:(NSString *)check_price_type
{
    NSString *imageStr;
    switch ([check_price_type integerValue]) {
        case 1: imageStr = @"energy_Manual_single"; break;
        case 2: imageStr = @"energy_Manual_Gu_Feng"; break;
        case 3: imageStr = @"energy_Manual_ladder"; break;
        case 4: imageStr = @"energy_Automatic_Translation"; break;
        case 5: imageStr = @"energy_Automatic_valley"; break;
        case 6: imageStr = @"energy_Automatic_ladder"; break;
        default: break;
    }
    return [UIImage imageNamed:imageStr];
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
