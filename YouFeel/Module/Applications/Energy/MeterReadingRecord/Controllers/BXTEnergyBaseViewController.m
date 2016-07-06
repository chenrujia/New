//
//  BXTEnergyBaseViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/6/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyBaseViewController.h"

@interface BXTEnergyBaseViewController ()

@property (nonatomic, strong) UIDatePicker *datePicker;

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
    
    self.view.backgroundColor = colorWithHexString(@"#f45b5b");
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
    
    
    if (!(image1 || right_title1)) {
        return;
    }
    // rightButton1
    self.rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton1 setFrame:CGRectMake(SCREEN_WIDTH - 64.f - 5.f, 20, 64.f, 44.f)];
    if (image1) {
        self.rightButton1.frame = CGRectMake(SCREEN_WIDTH - 44.f - 5.f, 20, 44.f, 44.f);
        [self.rightButton1 setImage:image1 forState:UIControlStateNormal];
    } else {
        [self.rightButton1 setTitle:right_title1 forState:UIControlStateNormal];
    }
    self.rightButton1.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.rightButton1 addTarget:self action:@selector(navigationRightButton1) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:self.rightButton1];
    
    
    if (!(image2 || right_title2)) {
        return;
    }
    // rightButton2
    UIButton *rightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton2 setFrame:CGRectMake(CGRectGetMinX(self.rightButton1.frame) - 65, 20, 64.f, 44.f)];
    if (image2) {
        [rightButton2 setImage:image2 forState:UIControlStateNormal];
    } else {
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
#pragma mark - TimerFilter
- (void)createDatePickerIsStart:(BOOL)isStart
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
    titleLabel.text = @"开始时间";
    if (!isStart) {
        titleLabel.text = @"结束时间";
    }
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
    //    self.datePicker.minimumDate = [NSDate date];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [[self.datePicker rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
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
    @weakify(self);
    [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.timeStr = timeLabel.text;
        
        self.datePicker = nil;
        [bgView removeFromSuperview];
    }];
    self.sureBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    self.sureBtn.layer.borderWidth = 0.5;
    [toolView addSubview:self.sureBtn];
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
