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
#pragma mark createUI
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

- (void)initialHisView:(NSInteger)maxNumber
{
    self.hisView = [[BXTHistogramStatisticsView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, SCREEN_WIDTH - 20.f, 470.f) lists:self.dayListInfo.lists kwhMeasure:maxNumber kwhNumber:6];
    self.hisView.backgroundColor = [UIColor whiteColor];
    self.hisView.layer.masksToBounds = YES;
    self.hisView.layer.cornerRadius = 10.f;
    @weakify(self);
    [[self.hisView.footerView.checkDetailBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTMeterReadingDailyDetailViewController *mrddvc = [[BXTMeterReadingDailyDetailViewController alloc] init];
        mrddvc.transID = self.transID;
        [self.navigationController pushViewController:mrddvc animated:YES];
    }];
    [self.scrollView addSubview:self.hisView];
}

#pragma mark -
#pragma mark 处理时间
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
