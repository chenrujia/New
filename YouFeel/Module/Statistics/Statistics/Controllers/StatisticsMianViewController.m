//
//  StatisticsMianViewController.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/25.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "StatisticsMianViewController.h"
#import "MBProgressHUD.h"

@interface StatisticsMianViewController () <MBProgressHUDDelegate>

@end

@implementation StatisticsMianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
    navBarView.image = [UIImage imageNamed:@"Nav_Bar"];
    navBarView.userInteractionEnabled = YES;
    [self.view addSubview:navBarView];
    
    // leftButton
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(6, 20, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"arrowBack"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(navigationLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    
    // centerButton
    UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    centerButton.frame = CGRectMake(60, 20, SCREEN_WIDTH-120, 44);
    [centerButton setTitle:@"2015年11月25日 星期三" forState:UIControlStateNormal];
    centerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [centerButton addTarget:self action:@selector(navigationcenterButton) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:centerButton];
    
    // rightButton
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH-44-6, 20, 44, 44);
    [rightBtn setImage:[UIImage imageNamed:@"arrowBack"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(navigationRightButton) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:rightBtn];
    
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
    self.rootSegmentedCtr = [[UISegmentedControl alloc] initWithItems:@[@"年", @"月", @"日"]];
    self.rootSegmentedCtr.frame = CGRectMake(15, 110-30-10, SCREEN_WIDTH-30, 30);
    
    //        self.segmentedCtr.tintColor = [UIColor clearColor];
    //        self.segmentedCtr.backgroundColor = [UIColor whiteColor];
    //        NSDictionary *unselectedDict = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName:colorWithHexString(@"#333333")};
    //        [self.segmentedCtr setTitleTextAttributes:unselectedDict forState:UIControlStateNormal];
    //        [self.segmentedCtr setTitleTextAttributes:unselectedDict forState:UIControlStateSelected];
    
    [self.rootSegmentedCtr addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.rootSegmentedCtr];
    
    self.rootSegmentedCtr.selectedSegmentIndex = 0;
}

- (void)didClicksegmentedControlAction:(UISegmentedControl *)segmented {
    //NSLog(@"selectedSegmentIndex -- %ld", segmented.selectedSegmentIndex);
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

// 时间戳转换成 2015-11-27 格式
- (NSString *)transTimeWithDate:(NSDate *)date {
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"YYYY-MM-dd"];
    return [formatter1 stringFromDate:date];
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
