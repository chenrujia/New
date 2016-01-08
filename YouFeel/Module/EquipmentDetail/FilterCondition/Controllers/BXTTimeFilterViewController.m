//
//  BXTTimeFilterViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/7.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTTimeFilterViewController.h"
#import "BXTHeaderForVC.h"

typedef NS_ENUM(NSInteger, timeType) {
    timeTypeStart,
    timeTypeEnd
};

@interface BXTTimeFilterViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;

@end

@implementation BXTTimeFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"时间范围" andRightTitle:nil andRightImage:nil];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:self.scrollView];
    
    
    [self createDatePicker:0 timeType:timeTypeStart];
    [self createDatePicker:340-64 timeType:timeTypeEnd];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(20, 340-64+266+20, SCREEN_WIDTH-40, 50);
    sureBtn.layer.cornerRadius = 5;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:colorWithHexString(@"#36AFFD")];
    @weakify(self);
    [[sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.startTime.length == 0) {
            [MYAlertAction showAlertWithTitle:@"请选择开始时间" msg:nil chooseBlock:nil buttonsStatement:@"确定", nil];
        } else if (self.endTime.length == 0) {
            [MYAlertAction showAlertWithTitle:@"请选择结束时间" msg:nil chooseBlock:nil buttonsStatement:@"确定", nil];
        } else {
            if (self.delegateSignal) {
                NSString *timeStart = [BXTGlobal transTimeStampWithTime:self.startTime withType:@"yyyy/MM/dd"];
                NSString *timeEnd = [BXTGlobal transTimeStampWithTime:self.endTime withType:@"yyyy/MM/dd"];
                NSArray *array = [[NSArray alloc] initWithObjects:timeStart, timeEnd, nil];
                [self.delegateSignal sendNext:array];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [self.scrollView addSubview:sureBtn];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(sureBtn.frame)+20);
}

- (void)createDatePicker:(CGFloat)viewY timeType:(timeType)type
{
    // bgView
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, SCREEN_WIDTH, 266)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    bgView.layer.borderWidth = 0.5;
    [self.scrollView addSubview:bgView];
    
    // titleView
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 30)];
    if (type == timeTypeStart) {
        titleView.text = @"开始时间";
    } else {
        titleView.text = @"结束时间";
    }
    [bgView addSubview:titleView];
    
    // timeView
    UILabel *timeView = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-115, 10, 100, 30)];
    timeView.textColor = colorWithHexString(@"#36AFFD");
    timeView.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:timeView];
    
    // line
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = colorWithHexString(@"#d9d9d9");
    [bgView addSubview:lineView];
    
    // datePicker
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 216)];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    datePicker.backgroundColor = colorWithHexString(@"ffffff");
    datePicker.datePickerMode = UIDatePickerModeDate;
    @weakify(self);
    [[datePicker rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UIDatePicker *picker) {
        @strongify(self);
        NSString *dateStr = [BXTGlobal transTimeWithDate:picker.date withType:@"yyyy/MM/dd"];
        timeView.text = dateStr;
        if (type == timeTypeStart) {
            self.startTime = dateStr;
        } else {
            self.endTime = dateStr;
        }
    }];
    [bgView addSubview:datePicker];
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
