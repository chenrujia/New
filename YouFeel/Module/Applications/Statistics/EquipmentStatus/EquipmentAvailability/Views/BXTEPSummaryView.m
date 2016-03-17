//
//  BXTEPSummaryView.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEPSummaryView.h"
#import "MYPieView.h"
#import "MYPieElement.h"
#import "AksStraightPieChart.h"
#import "BXTGlobal.h"
#import "BXTHeaderFile.h"
#import "BXTDataRequest.h"
#import "BXTEquipmentListViewController.h"
#import "AppDelegate.h"
#import "CYLTabBarController.h"

@interface BXTEPSummaryView () <BXTDataResponseDelegate>

@property (nonatomic, strong) NSDictionary *percentDict;
@property (nonatomic, strong) MYPieView *pieView;

@property (nonatomic, copy) NSString *timeStr;

@end

@implementation BXTEPSummaryView

- (void)awakeFromNib {
    // Initialization code
    
    NSLog(@"dfaasdfadsfasd");
    
    self.roundView1.layer.cornerRadius = 5;
    self.roundView2.layer.cornerRadius = 5;
    self.roundView3.layer.cornerRadius = 5;
    
    //    [self showLoadingMBP:@"数据加载中..."];
    
    /**饼状图**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request deviceAvailableStaticsWithDate:@""];
    
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"BXTEPSummaryViewAndBXTEPSystemRateView" object:nil] subscribeNext:^(NSNotification *notify) {
        NSDictionary *dict = [notify userInfo];
        
        self.timeStr = dict[@"timeStr"];
        
        /**饼状图**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request deviceAvailableStaticsWithDate:dict[@"timeStr"]];
    }];
}

#pragma mark -
#pragma mark - createUI
- (void)createPieView
{
    //  ---------- 饼状图 ----------
    // MYPieView
    NSArray *pieArray = [[NSMutableArray alloc] initWithObjects:self.percentDict[@"working_per"], self.percentDict[@"stop_per"], nil];
    
    
    // 1. create pieView
    self.pieView = [[MYPieView alloc] initWithFrame:self.bgView.bounds];
    self.pieView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.pieView];
    
    // 2. fill data
    NSArray *colorArray = [[NSArray alloc] initWithObjects:@"#34B47E", @"#D6AD5B", nil];
    for(int i=0; i<pieArray.count; i++)
    {
        MYPieElement *elem = [MYPieElement pieElementWithValue:[pieArray[i] floatValue] color:colorWithHexString(colorArray[i])];
        elem.title = [NSString stringWithFormat:@"%@%%", pieArray[i]];
        [self.pieView.layer addValues:@[elem] animated:NO];
    }
    
    // 无参数处理
    if ([pieArray[0] intValue] == 0 && [pieArray[1] intValue] == 0)
    {
        MYPieElement *elem = [MYPieElement pieElementWithValue:1 color:colorWithHexString(colorArray[0])];
        elem.title = [NSString stringWithFormat:@"%@", @"暂无工单"];
        [self.pieView.layer addValues:@[elem] animated:NO];
    }
    
    // 3. transform tilte
    self.pieView.layer.transformTitleBlock = ^(PieElement *elem, float percent){
        //NSLog(@"percent -- %f", percent);
        return [(MYPieElement *)elem title];
    };
    self.pieView.layer.showTitles = ShowTitlesAlways;
    
    // 4. didClick
    self.pieView.transSelected = ^(NSInteger index) {
        NSLog(@"index -- %ld", (long)index);
    };
    
    
    // Button
    self.sumView.text = [NSString stringWithFormat:@"总计：%@", self.percentDict[@"total"]];
    self.allView.text = [NSString stringWithFormat:@"%@", self.percentDict[@"total"]];
    self.runningView.text = [NSString stringWithFormat:@"%@", self.percentDict[@"working"]];
    self.stopView.text = [NSString stringWithFormat:@"%@", self.percentDict[@"stop"]];
    self.unableView.text = [NSString stringWithFormat:@"%@", self.percentDict[@"unused"]];
}

- (IBAction)btnClick:(UIButton *)sender
{
    NSLog(@"----------------- %ld", (long)sender.tag);
    BXTEquipmentListViewController *listVC = [[BXTEquipmentListViewController alloc] init];
    listVC.date = self.timeStr;
    
    switch (sender.tag) {
        case 111: listVC.state = @"0"; break;
        case 222: listVC.state = @"1"; break;
        case 333: listVC.state = @"2"; break;
        case 444: listVC.state = @"3"; break;
        default: break;
    }
    
    [[self navigation] pushViewController:listVC animated:YES];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    //    [self hideMBP];
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = dic[@"data"];
    if (type == Device_AvailableStatics && data.count > 0)
    {
        self.percentDict = dic[@"data"];
        [self createPieView];
    }
}

- (void)requestError:(NSError *)error
{
    //    [self hideMBP];
}

- (UINavigationController *)navigation
{
    id rootVC = [AppDelegate appdelegete].window.rootViewController;
    UINavigationController *nav = nil;
    if ([BXTGlobal shareGlobal].presentNav)
    {
        nav = [BXTGlobal shareGlobal].presentNav;
    }
    else if ([rootVC isKindOfClass:[UINavigationController class]])
    {
        nav = rootVC;
    }
    else if ([rootVC isKindOfClass:[CYLTabBarController class]])
    {
        CYLTabBarController *tempVC = (CYLTabBarController *)rootVC;
        nav = [tempVC.viewControllers objectAtIndex:tempVC.selectedIndex];
    }
    
    return nav;
}

@end
