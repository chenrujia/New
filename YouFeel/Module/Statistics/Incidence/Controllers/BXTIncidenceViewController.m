//
//  IncidenceViewController.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/25.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "BXTIncidenceViewController.h"
#import "BXTIncidenceView.h"

@interface BXTIncidenceViewController () <BXTDataResponseDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) BarChatItemView *bciv;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSString *titleStr;

@end

@implementation BXTIncidenceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self showLoadingMBP:@"数据加载中..."];
    
    NSArray *dateArray = [BXTGlobal dayStartAndEnd];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request statisticsFaulttypeWithTimeStart:dateArray[0] timeEnd:dateArray[1]];
    
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // headerView
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 12, SCREEN_WIDTH-160, 26)];
    titlelabel.text = @"故障发生率";
    titlelabel.textColor = [UIColor darkGrayColor];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    [self.rootScrollView addSubview:titlelabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = colorWithHexString(@"#d9d9d9");
    [self.rootScrollView addSubview:line];
    
    
    // 故障发生率
    NSMutableArray *xArray = [[NSMutableArray alloc] init];
    NSMutableArray *yArray = [[NSMutableArray alloc] init];
    int count = 1;
    for (NSDictionary *dict in self.dataArray)
    {
        [xArray addObject:[NSString stringWithFormat:@"%d", count++]];
        [yArray addObject:[NSString stringWithFormat:@"%@", dict[@"percent"]]];
    }
    
    // 无参数处理
    if (self.dataArray.count == 0)
    {
        for (int i=0; i<30; i++)
        {
            [xArray addObject:[NSString stringWithFormat:@"%d", count++]];
            [yArray addObject:[NSString stringWithFormat:@"%@", @"0"]];
        }
    }
    
    NSArray *dataArray = [NSArray arrayWithObjects:xArray, yArray, nil];
    
    self.bciv = [[BarChatItemView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, SCREEN_HEIGHT-KNAVIVIEWHEIGHT-70)];
    self.bciv.dataArray = dataArray;
    __weak typeof(self)weakSelf = self;
    self.bciv.transSelected2 = ^(NSInteger index) {
        //NSLog(@"index --- %ld", index);
        
        [weakSelf barChartDidClicked:index];
    };
    [self.rootScrollView addSubview:self.bciv];
    //self.rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(bciv.frame));
}

#pragma mark -
#pragma mark - barChart 点击事件
- (void)barChartDidClicked:(NSInteger)index
{
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    self.backgroundView.tag = 101;
    self.backgroundView.alpha = 0.0;
    [self.view addSubview:self.backgroundView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundView.alpha = 1.0;
    }];
    
    
    BXTIncidenceView *view = [[BXTIncidenceView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH, 250)];
    view.transClick = ^ {
        [UIView animateWithDuration:0.5 animations:^{
            self.backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.backgroundView removeFromSuperview];
        }];
    };
    [self.backgroundView addSubview:view];
    
    NSDictionary *dict = self.dataArray[index];
    
    NSString *faulttypeStr = [NSString stringWithFormat:@"%@", dict[@"faulttype"]];
    NSRange range = [faulttypeStr rangeOfString:@"-"];
    NSString *groupStr = [faulttypeStr substringToIndex:range.location];
    
    view.titleView.text = self.titleStr;
    view.rangkingView.text = [NSString stringWithFormat:@"排名：%@", dict[@"rank"]];
    view.groupView.text = [NSString stringWithFormat:@"故障分类：%@", groupStr];
    view.typeView.text = [NSString stringWithFormat:@"故障类型：%@", dict[@"faulttype"]];
    view.repairView.text = [NSString stringWithFormat:@"报修：%@单", dict[@"number"]];
    view.ratioView.text = [NSString stringWithFormat:@"比例：%@%@", dict[@"percent"], @"%"];
}

#pragma mark -
#pragma mark - 父类点击事件
- (void)segmentView:(SegmentView *)segmentView didSelectedSegmentAtIndex:(NSInteger)index
{
    NSMutableArray *dateArray;
    switch (index) {
        case 0:
        {
            dateArray = [[NSMutableArray alloc] initWithArray:[self timeTypeOf_YearStartAndEnd:self.rootCenterButton.titleLabel.text]];
            self.titleStr = @"年度排名";
        }
            break;
        case 1:
        {
            dateArray = [[NSMutableArray alloc] initWithArray:[self timeTypeOf_MonthStartAndEnd:self.rootCenterButton.titleLabel.text]];
            self.titleStr = @"月度排名";
        }
            break;
        case 2:
        {
            dateArray = [[NSMutableArray alloc] initWithArray:[self timeTypeOf_DayStartAndEnd:self.rootCenterButton.titleLabel.text]];
            self.titleStr = @"每日排名";
        }
            break;
        default:
            break;
    }
    
    [self showLoadingMBP:@"数据加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request statisticsFaulttypeWithTimeStart:dateArray[0] timeEnd:dateArray[1]];
}

- (void)datePickerBtnClick:(UIButton *)button
{
    self.titleStr = @"每日排名";
    if (button.tag == 10001)
    {
        self.rootSegmentedCtr.selectedSegmentIndex = 2;
        [self showLoadingMBP:@"数据加载中..."];
        if (!selectedDate)
        {
            selectedDate = [NSDate date];
        }
        [self.rootCenterButton setTitle:[self weekdayStringFromDate:selectedDate] forState:UIControlStateNormal];
        
        NSString *todayStr = [self transTimeWithDate:selectedDate];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request statisticsFaulttypeWithTimeStart:todayStr timeEnd:todayStr];
    }
    [super datePickerBtnClick:button];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    if (self.bciv)
    {
        [self.bciv removeFromSuperview];
    }
    
    NSDictionary *dic = (NSDictionary *)response;
    if (type == Statistics_Faulttype)
    {
        self.dataArray = dic[@"data"];
        [self createUI];
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

- (void)didReceiveMemoryWarning
{
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
