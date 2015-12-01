//
//  WorkloadViewController.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/26.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "WorkloadViewController.h"
#import "WorkIoadView.h"

@interface WorkloadViewController () <BXTDataResponseDelegate>
{
    CGFloat bgViewH;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) WorkIoadView *viView;

@end

@implementation WorkloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self showLoadingMBP:@"数据加载中"];
    
    NSArray *dateArray = [BXTGlobal yearStartAndEnd];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request statistics_workloadWithTime_start:dateArray[0] time_end:dateArray[1]];
    
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type {
    [self hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == Statistics_Workload && data.count > 0) {
        self.dataArray = dic[@"data"];
        [self createUI];
    }
}

- (void)requestError:(NSError *)error {
    [self hideMBP];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI {
    
    CGFloat viViewH = 0;
    CGFloat viViewY = 0;
    CGFloat margin = 10;
    bgViewH = 40;
    
    for (int i=0; i<self.dataArray.count; i++) {
        NSDictionary *dataDict = self.dataArray[i];
        NSArray *workloadArray = dataDict[@"workload"];
        viViewH = workloadArray.count * bgViewH + 100 + 90;
        viViewY = 10 + (viViewH + margin)*i;
        self.viView = [[[NSBundle mainBundle] loadNibNamed:@"WorkIoadView" owner:nil options:nil] lastObject];
        self.viView.frame = CGRectMake(0, viViewY, SCREEN_WIDTH, viViewH);
        [self.rootScrollView addSubview:self.viView];
        
        [self createWorkIoadViewOfIndex:i];
    }
    
    self.rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.viView.frame));
}

- (void)createWorkIoadViewOfIndex:(int)index {
    
    NSDictionary *dataDict = self.dataArray[index];
    NSArray *workloadArray = dataDict[@"workload"];
    
    CGFloat bgViewY = 60;
    CGFloat margin = 5;
    for (int i=0; i<workloadArray.count; i++) {
        NSDictionary *dict = workloadArray[i];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(15, bgViewY+(bgViewH+margin)*i, SCREEN_WIDTH-15, bgViewH)];
        bgView.backgroundColor = [UIColor clearColor];
        [self.viView addSubview:bgView];
        
        // name
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 80, 30)];
        nameLabel.text = dict[@"name"];
        nameLabel.textColor = colorWithHexString(@"#666666");
        nameLabel.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:nameLabel];
        
        // chart
        AksStraightPieChart *straightPieChart = [[AksStraightPieChart alloc] initWithFrame:CGRectMake(80, 0, bgView.frame.size.width-95, bgViewH)];
       // straightPieChart.tag = 1000 + i;
        straightPieChart.transPieClick = ^(void) {
            NSLog(@"gfgdfgdfgdffgfd");
        };
        [bgView addSubview:straightPieChart];
        
        [straightPieChart clearChart];
        straightPieChart.isVertical = NO;
        [straightPieChart addDataToRepresent:[dict[@"yes_number"] intValue] WithColor:colorWithHexString(@"#0FCCC0")];
        [straightPieChart addDataToRepresent:[dict[@"collection_number"] intValue] WithColor:colorWithHexString(@"#F9D063")];
        [straightPieChart addDataToRepresent:[dict[@"no_number"] intValue] WithColor:colorWithHexString(@"#FD7070")];
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
