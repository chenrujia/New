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

@property (nonatomic, strong) UIScrollView                         *scrollView;
@property (nonatomic, strong) BXTMeterReadingDailyDetailFilterView *headerView;
@property (nonatomic, strong) BXTHistogramStatisticsView           *hisView;
@property (nonatomic, strong) UIView                               *footerView;
@property (nonatomic, strong) BXTMeterReadingRecordDayListInfo     *dayListInfo;

@end

@implementation BXTMeterReadingDailyDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"日详情" andRightTitle1:nil andRightImage1:nil andRightTitle2:nil andRightImage2:nil];
    NSArray *timeArray = [BXTGlobal yearAndmonthAndDay];
    self.nowTimeStr = [NSString stringWithFormat:@"%@年%@月", timeArray[0], timeArray[1]];
    [self createUI];
    [self getResource];
}

- (void)getResource
{
    NSString *yearStr = [self.showTimeStr substringToIndex:4];
    NSString *monthStr = [self.showTimeStr substringWithRange:NSMakeRange(5, self.showTimeStr.length - 6)];
    NSString *timeStr = [NSString stringWithFormat:@"%@-%@", yearStr, monthStr];
    
    [BXTGlobal showLoadingMBP:@"加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request energyMeterRecordDayListsWithAboutID:self.transID date:timeStr];
}

#pragma mark -
#pragma mark createUI
- (void)createUI
{
    // scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 70)];
    [self.view addSubview:self.scrollView];
    
    // headerView
    self.headerView = [BXTMeterReadingDailyDetailFilterView viewForBXTMeterReadingDailyDetailFilterView];
    self.headerView.frame = CGRectMake(10, 0 , SCREEN_WIDTH - 20, 50);
    if ([self.showTimeStr isEqualToString:self.nowTimeStr])
    {
        self.headerView.nextMonthBtn.enabled = NO;
        self.headerView.nextMonthBtn.alpha = 0.4;
    }
    self.headerView.timeView.text = self.showTimeStr;
    @weakify(self);
    [[self.headerView.lastMonthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.headerView.timeView.text = [self transTime:self.showTimeStr isAdd:NO];
        self.headerView.nextMonthBtn.enabled = YES;
        self.headerView.nextMonthBtn.alpha = 1.0;
        [self getResource];
    }];
    [[self.headerView.nextMonthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.headerView.timeView.text = [self transTime:self.showTimeStr isAdd:YES];
        if ([self.showTimeStr isEqualToString:self.nowTimeStr])
        {
            [self getResource];
            self.headerView.nextMonthBtn.enabled = NO;
            self.headerView.nextMonthBtn.alpha = 0.4;
        }
        else
        {
            [self getResource];
        }
    }];
    [self.scrollView addSubview:self.headerView];
    
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
        mrvc.transID = self.transID;
        mrvc.unlocked = self.unlocked;
        mrvc.delegateSignal = [RACSubject subject];
        [mrvc.delegateSignal subscribeNext:^(id x) {
            @strongify(self);
            if (self.delegateSignal)
            {
                [self.delegateSignal sendNext:nil];
            }
        }];
        [self.navigationController pushViewController:mrvc animated:YES];
    }];
    [self.footerView addSubview:newMeterBtn];
}

- (void)initialHisView:(NSInteger)maxNumber
{
    self.hisView = [[BXTHistogramStatisticsView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20.f, 470.f) lists:self.dayListInfo.lists kwhMeasure:maxNumber kwhNumber:6 statisticsType:DayType unit:self.dayListInfo.unit];
    self.hisView.backgroundColor = [UIColor whiteColor];
    self.hisView.layer.masksToBounds = YES;
    self.hisView.layer.cornerRadius = 10.f;
    self.hisView.footerView.checkDetailBtn.hidden = YES;
    [self.scrollView addSubview:self.hisView];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.hisView.frame) + 10);
    
    
    // 默认值
    BXTRecordDayListsInfo *recordInfo = self.dayListInfo.lists[self.dayListInfo.lists.count - 1];
    self.hisView.footerView.consumptionView.text = [NSString stringWithFormat:@"总能耗：%ld", (long)recordInfo.data.use_amount];
    self.hisView.footerView.peakNumView.text = [NSString stringWithFormat:@"尖峰量：%ld", (long)recordInfo.data.peak_segment_amount];
    self.hisView.footerView.apexNumView.text = [NSString stringWithFormat:@"峰段量：%ld", (long)recordInfo.data.peak_period_amount];
    self.hisView.footerView.levelNumView.text = [NSString stringWithFormat:@"平段量：%ld", (long)recordInfo.data.flat_section_amount];
    self.hisView.footerView.valleyNumView.text = [NSString stringWithFormat:@"谷段量：%ld", (long)recordInfo.data.valley_section_amount];
    
    if (![self.dayListInfo.price_type_id isEqualToString:@"2"]) {
        self.hisView.footerView.downView.hidden = YES;
        self.hisView.frame = CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20.f, 430.f);
         self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.hisView.frame) + 10);
    }
}

#pragma mark -
#pragma mark 处理时间
- (NSString *)transTime:(NSString *)time isAdd:(BOOL)add
{
    NSInteger year = [[self.showTimeStr substringToIndex:4] integerValue];
    NSInteger month = [[self.showTimeStr substringWithRange:NSMakeRange(5, self.showTimeStr.length-5)] integerValue];
    
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
    
    return self.showTimeStr;
}

#pragma mark -
#pragma mark getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == EnergyMeterRecordDayLists && data.count > 0)
    {
        [BXTMeterReadingRecordDayListInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"meterReadingID":@"id"};
        }];
        self.dayListInfo = [BXTMeterReadingRecordDayListInfo mj_objectWithKeyValues:data[0]];
        
        //如果是自动阶梯，则隐藏新建抄表
        NSString *power = [BXTGlobal getUserProperty:U_POWER];
        if (([self.dayListInfo.check_type isEqualToString:@"1"] && ![power containsString:@"80604"]) ||
            [self.dayListInfo.check_type isEqualToString:@"2"])
        {
            [self.footerView removeFromSuperview];
            self.scrollView.frame = CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT);
            self.headerView.frame = CGRectMake(10, 0 , SCREEN_WIDTH - 20, 50);
        }
        
        NSInteger count = self.dayListInfo.lists.count;
        if (count > 0)
        {
            //通过最大kwh推算左侧坐标最大值
            NSInteger max = 0;
            for (NSInteger i = 0; i < count; i++)
            {
                BXTRecordDayListsInfo *recordInfo = self.dayListInfo.lists[i];
                max = recordInfo.data.use_amount > max ? recordInfo.data.use_amount : max;
            }
            CGFloat fn = max/6.f;
            NSInteger inn = floor(fn);
            NSInteger i = 0;
            do {
                i++;
                inn = floor(inn/10.f);
            } while (inn > 10);
            inn++;
            do {
                inn *= 10;
                i--;
            } while (i > 0);
            inn *= 6;
            
            //创建统计
            [self initialHisView:inn];
        }
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
