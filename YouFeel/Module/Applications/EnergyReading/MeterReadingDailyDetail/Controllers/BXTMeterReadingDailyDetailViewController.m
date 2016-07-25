//
//  BXTMeterReadingDailyDetailViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/5.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMeterReadingDailyDetailViewController.h"
#import "BXTMeterReadingDailyDetailFilterView.h"
#import "BXTHistogramStatisticsView.h"
#import "BXTMeterReadingViewController.h"
#import "BXTMeterReadingRecordDayListInfo.h"

@interface BXTMeterReadingDailyDetailViewController () <BXTDataResponseDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) BXTMeterReadingDailyDetailFilterView *headerView;
@property (nonatomic, strong) BXTHistogramStatisticsView *hisView;

@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) BXTMeterReadingRecordDayListInfo *dayListInfo;

@property (copy, nonatomic) NSString *nowTimeStr;
@property (copy, nonatomic) NSString *showTimeStr;

@end

@implementation BXTMeterReadingDailyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"日详情" andRightTitle1:nil andRightImage1:nil andRightTitle2:nil andRightImage2:nil];
    
    NSArray *timeArray = [BXTGlobal yearAndmonthAndDay];
    self.nowTimeStr = [NSString stringWithFormat:@"%@年%@月", timeArray[0], timeArray[1]];
    self.showTimeStr = self.nowTimeStr;
    
    [self createUI];
    [self getResource];
}

- (void)getResource
{
    [BXTGlobal showLoadingMBP:@"数据加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request energyMeterRecordDayListsWithAboutID:self.transID date:@"2016-07"];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 70)];
    [self.view addSubview:self.scrollView];
    
    
    // headerView
    self.headerView = [BXTMeterReadingDailyDetailFilterView viewForBXTMeterReadingDailyDetailFilterView];
    self.headerView.frame = CGRectMake(10, 0 , SCREEN_WIDTH - 20, 50);
    @weakify(self);
    [[self.headerView.lastMonthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.headerView.timeView.text = [self transTime:self.showTimeStr isAdd:NO];
        self.headerView.nextMonthBtn.enabled = YES;
        self.headerView.nextMonthBtn.alpha = 1.0;
    }];
    [[self.headerView.nextMonthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.headerView.timeView.text = [self transTime:self.showTimeStr isAdd:YES];
        if ([self.showTimeStr isEqualToString:self.nowTimeStr]) {
            self.headerView.nextMonthBtn.enabled = NO;
            self.headerView.nextMonthBtn.alpha = 0.4;
        }
    }];
    [self.scrollView addSubview:self.headerView];
    
    
//    // BXTHistogramStatisticsView
//    //50° ~ -50°
//    NSArray *temperatureArray = @[@(20.f),@(45.f),@(-40.f),@(-10.f),@(-30.f),@(30.f),@(20.f),@(45.f),@(-40.f),@(-10.f),@(-30.f),@(30.f),@(20.f),@(45.f),@(-40.f),@(-10.f),@(-30.f),@(30.f),@(20.f),@(45.f),@(-40.f),@(-10.f),@(-30.f),@(30.f),@(20.f),@(45.f),@(-40.f),@(-10.f),@(-30.f),@(30.f)];
//    //0 ~ 100%rh
//    NSArray *humidityArray = @[@(30.f),@(80.f),@(40.f),@(70.f),@(20.f),@(50.f),@(30.f),@(80.f),@(40.f),@(70.f),@(20.f),@(50.f),@(30.f),@(80.f),@(40.f),@(70.f),@(20.f),@(50.f),@(30.f),@(80.f),@(40.f),@(70.f),@(20.f),@(50.f),@(30.f),@(80.f),@(40.f),@(70.f),@(20.f),@(50.f)];
//    //0 ~ 10级
//    NSArray *windPowerArray = @[@(8.f),@(2.f),@(6.f),@(1.f),@(7.f),@(5.f),@(8.f),@(2.f),@(6.f),@(1.f),@(7.f),@(5.f),@(8.f),@(2.f),@(6.f),@(1.f),@(7.f),@(5.f),@(8.f),@(2.f),@(6.f),@(1.f),@(7.f),@(5.f),@(8.f),@(2.f),@(6.f),@(1.f),@(7.f),@(5.f)];
//    //0 ~ 1000kwh
//    NSArray *totalEnergyArray = @[@[@(800.f),@(600.f),@(400.f)],
//                                  @[@(500.f),@(300.f),@(200.f)],
//                                  @[@(700.f),@(500.f),@(200.f)],
//                                  @[@(900.f),@(700.f),@(500.f)],
//                                  @[@(600.f),@(300.f),@(200.f)],
//                                  @[@(1000.f),@(600.f),@(300.f)],
//                                  @[@(800.f),@(600.f),@(400.f)],
//                                  @[@(500.f),@(300.f),@(200.f)],
//                                  @[@(700.f),@(500.f),@(200.f)],
//                                  @[@(900.f),@(700.f),@(500.f)],
//                                  @[@(600.f),@(300.f),@(200.f)],
//                                  @[@(1000.f),@(600.f),@(300.f)],
//                                  @[@(800.f),@(600.f),@(400.f)],
//                                  @[@(500.f),@(300.f),@(200.f)],
//                                  @[@(700.f),@(500.f),@(200.f)],
//                                  @[@(900.f),@(700.f),@(500.f)],
//                                  @[@(600.f),@(300.f),@(200.f)],
//                                  @[@(1000.f),@(600.f),@(300.f)],
//                                  @[@(800.f),@(600.f),@(400.f)],
//                                  @[@(500.f),@(300.f),@(200.f)],
//                                  @[@(700.f),@(500.f),@(200.f)],
//                                  @[@(900.f),@(700.f),@(500.f)],
//                                  @[@(600.f),@(300.f),@(200.f)],
//                                  @[@(1000.f),@(600.f),@(300.f)],
//                                  @[@(800.f),@(600.f),@(400.f)],
//                                  @[@(500.f),@(300.f),@(200.f)],
//                                  @[@(700.f),@(500.f),@(200.f)],
//                                  @[@(900.f),@(700.f),@(500.f)],
//                                  @[@(600.f),@(300.f),@(200.f)],
//                                  @[@(1000.f),@(600.f),@(300.f)]];
//    //TODO:12000是假数据！！！！
//    self.hisView = [[BXTHistogramStatisticsView alloc] initWithFrame:CGRectMake(10,  CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20.f, 470.f) temperatureArray:temperatureArray humidityArray:humidityArray windPowerArray:windPowerArray totalEnergyArray:totalEnergyArray kwhMeasure:12000 kwhNumber:6];
//    self.hisView.backgroundColor = [UIColor whiteColor];
//    self.hisView.layer.masksToBounds = YES;
//    self.hisView.layer.cornerRadius = 10.f;
//    self.hisView.footerView.checkDetailBtn.hidden = YES;
//    [self.scrollView addSubview:self.hisView];
    
    
    // footerView
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70, SCREEN_WIDTH, 70)];
    self.footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footerView];
    
    UIButton *newMeterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newMeterBtn.frame = CGRectMake((SCREEN_WIDTH - 180) / 2, 10, 180, 50);
    [newMeterBtn setBackgroundColor:colorWithHexString(@"#5DAFF9")];
    [newMeterBtn setTitle:@"新建抄表" forState:UIControlStateNormal];
    newMeterBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    newMeterBtn.layer.cornerRadius = 5;
    [[newMeterBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTMeterReadingViewController *mrvc = [[BXTMeterReadingViewController alloc] init];
        [self.navigationController pushViewController:mrvc animated:YES];
    }];
    [self.footerView addSubview:newMeterBtn];
    
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.hisView.frame) + 10);
}

#pragma mark -
#pragma mark - 处理时间
- (NSString *)transTime:(NSString *)time isAdd:(BOOL)add
{
    NSInteger year = [[self.showTimeStr substringToIndex:4] integerValue];
    NSInteger month = [[self.showTimeStr substringWithRange:NSMakeRange(5, self.showTimeStr.length-6)] integerValue];
    
    if (!add)
    { // 减法
        month -= 1;
        if (month <= 0)
        {
            year -= 1;
            month = 12;
        }
    }
    else
    {
        month += 1;
        if (month >= 12)
        {
            year += 1;
            month = 1;
        }
    }
    
    self.showTimeStr = [NSString stringWithFormat:@"%ld年%ld月", (long)year, (long)month];
    
    //    [self getResource];
    
    return self.showTimeStr;
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    // TODO: -----------------  调试 - 处理  -----------------
    if (type == EnergyMeterRecordDayLists && data.count > 0)
    {
        [BXTMeterReadingRecordDayListInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"meterReadingID":@"id"};
        }];
        self.dayListInfo = [BXTMeterReadingRecordDayListInfo mj_objectWithKeyValues:data[0]];
        
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
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
