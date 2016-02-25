//
//  BXTMTCompletionViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/22.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMTCompletionViewController.h"
#import "BXTMTCompletionHeader.h"
#import "BXTMTCompletionFooter.h"

@interface BXTMTCompletionViewController () <BXTDataResponseDelegate>

@property (nonatomic, strong) NSMutableDictionary *percentDict;

@property (nonatomic, strong) BXTMTCompletionHeader *headerView;
@property (nonatomic, strong) BXTMTCompletionFooter *footerView;

@property (nonatomic, strong) NSMutableArray *transTimeArray;

@end

@implementation BXTMTCompletionViewController

- (void)viewDidLoad {
    // 隐藏年月日选择项
    self.hideDatePicker = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self showLoadingMBP:@"数据加载中..."];
    
    /**饼状图**/
    NSArray *dateArray = [BXTGlobal dayStartAndEnd];
    self.transTimeArray = [[NSMutableArray alloc] initWithArray:dateArray];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request statisticsMTCompleteWithTimeStart:dateArray[0] timeEnd:dateArray[1]];
    
}

#pragma mark -
#pragma mark - createUI
- (void)createPieView
{
    //  ---------- 饼状图 ----------
    // CompletionHeader
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"BXTMTCompletionHeader" owner:nil options:nil] lastObject];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 450);
    [self.rootScrollView addSubview:self.headerView];
    
    
    // MYPieView
    NSDictionary *dataDict = self.percentDict[@"year"];
    NSArray *pieArray = [[NSMutableArray alloc] initWithObjects:dataDict[@"over_per"], dataDict[@"working_per"], dataDict[@"unover_per"], dataDict[@"unstart_per"], nil];
    
    // 1. create pieView
    self.headerView.pieView.backgroundColor = [UIColor whiteColor];
    
    // 2. fill data
    NSArray *colorArray = [[NSArray alloc] initWithObjects:@"#0FCCC0", @"#0C88CC", @"#FD7070", @"#DEE7E8", nil];
    for(int i=0; i<pieArray.count; i++)
    {
        MYPieElement *elem = [MYPieElement pieElementWithValue:[pieArray[i] floatValue] color:colorWithHexString(colorArray[i])];
        elem.title = [NSString stringWithFormat:@"%@%%", pieArray[i]];
        [self.headerView.pieView.layer addValues:@[elem] animated:NO];
    }
    
    // 3. transform tilte
    self.headerView.pieView.layer.transformTitleBlock = ^(PieElement *elem, float percent){
        //NSLog(@"percent -- %f", percent);
        return [(MYPieElement *)elem title];
    };
    self.headerView.pieView.layer.showTitles = ShowTitlesAlways;
    
    // 4. didClick
    self.headerView.pieView.transSelected = ^(NSInteger index) {
        NSLog(@"index -- %ld", (long)index);
    };
    
    
    self.headerView.roundTitleView.text = [NSString stringWithFormat:@"总计：100"];
    // Button
    NSString *downNumStr = [NSString stringWithFormat:@"已完成：%@", dataDict[@"over_per"]];
    NSString *doingNumStr = [NSString stringWithFormat:@"进行中：%@", dataDict[@"working_per"]];
    NSString *undownNumStr = [NSString stringWithFormat:@"未完成：%@", dataDict[@"unover_per"]];
    NSString *unbeginNumStr = [NSString stringWithFormat:@"未开始：%@", dataDict[@"unstart_per"]];
    self.headerView.downLabelView.text = downNumStr;
    self.headerView.doingLabelView.text = doingNumStr;
    self.headerView.undownLabelView.text = undownNumStr;
    self.headerView.unbeginLabelView.text = unbeginNumStr;
}

- (void)createList
{
    //  ---------- 条形图 ----------
    // CompletionFooter
    self.footerView = [[[NSBundle mainBundle] loadNibNamed:@"BXTMTCompletionFooter" owner:nil options:nil] lastObject];
    self.footerView.frame = CGRectMake(0, 460, SCREEN_WIDTH, 320);
    self.rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 800);
    [self.rootScrollView addSubview:self.footerView];
    
    
    NSDictionary *dataDict = self.percentDict[@"now"];
    
    [self.footerView.pieView clearChart];
    [self.footerView.pieView addDataToRepresent:[dataDict[@"total"] intValue] WithColor:colorWithHexString(@"#0FCCC0")];
    [self.footerView.pieView addDataToRepresent:[dataDict[@"over"] intValue] WithColor:colorWithHexString(@"#0C88CC")];
    [self.footerView.pieView addDataToRepresent:[dataDict[@"working"] intValue] WithColor:colorWithHexString(@"#FD7070")];
    [self.footerView.pieView addDataToRepresent:[dataDict[@"unover"] intValue] WithColor:colorWithHexString(@"#DEE7E8")];
    self.footerView.pieView.userInteractionEnabled = NO;
    
    self.footerView.allView.text = [NSString stringWithFormat:@"%@", dataDict[@"total"]];
    self.footerView.downView.text = [NSString stringWithFormat:@"%@", dataDict[@"over"]];
    self.footerView.doingView.text = [NSString stringWithFormat:@"%@", dataDict[@"working"]];
    self.footerView.undownView.text = [NSString stringWithFormat:@"%@", dataDict[@"unover"]];
}

#pragma mark -
#pragma mark - 父类点击事件
- (void)datePickerBtnClick:(UIButton *)button
{
    if (button.tag == 10001)
    {
        [self.headerView.pieView removeFromSuperview];
        
        /**饼状图**/
        if (!selectedDate)
        {
            selectedDate = [NSDate date];
        }
        [self.rootCenterButton setTitle:[self weekdayStringFromDate:selectedDate] forState:UIControlStateNormal];
        
        NSString *todayStr = [self transTimeWithDate:selectedDate];
        [self.transTimeArray removeAllObjects];
        [self.transTimeArray addObject:todayStr];
        [self.transTimeArray addObject:todayStr];
        
        [self showLoadingMBP:@"数据加载中..."];
        /**饼状图**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request statisticsMTCompleteWithTimeStart:todayStr timeEnd:todayStr];
    }
    [super datePickerBtnClick:button];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = dic[@"data"];
    if (type == Statistics_MTComplete && data.count > 0)
    {
        self.percentDict = dic[@"data"];
        
        [self createPieView];
        [self createList];
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
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
