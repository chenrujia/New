//
//  BXTMTProfessionBaseViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMTProfessionBaseViewController.h"
#import "BXTMTProfessionHeader.h"
#import "BXTMTCompletionFooter.h"
#import "BXTDataRequest.h"
#import "BXTGlobal.h"
#import "BXTHeaderFile.h"
#import "MYPieElement.h"
#import "BXTMaintenanceListViewController.h"

@interface BXTMTProfessionBaseViewController () <BXTDataResponseDelegate>

@property (nonatomic, strong) NSMutableDictionary *percentDict;

@property (nonatomic, strong) UIScrollView *rootScrollView;
@property (nonatomic, strong) BXTMTProfessionHeader *headerView;
@property (nonatomic, strong) BXTMTCompletionFooter *footerView;

@property (nonatomic, copy) NSString *dateStr;

@end

@implementation BXTMTProfessionBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (!self.transSubgroupID) {
        self.transSubgroupID = @"";
    }
    if (!self.transFaulttypeTypeID) {
        self.transFaulttypeTypeID = @"";
    }
    
    /**饼状图**/
    [BXTGlobal showLoadingMBP:@"数据加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request statisticsMTCompleteWithDate:@"" Subgroup:self.transSubgroupID FaulttypeType:self.transFaulttypeTypeID];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"BXTMTProfessionBaseViewController" object:nil] subscribeNext:^(NSNotification *notification) {
        NSDictionary *dict = [notification userInfo];
        
        self.dateStr = dict[@"date"];
        
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request statisticsMTCompleteWithDate:dict[@"date"] Subgroup:self.transSubgroupID FaulttypeType:self.transFaulttypeTypeID];
    }];
}

#pragma mark -
#pragma mark - createUI
- (void)createPieView
{
    // self.rootScrollView
    self.rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 7, SCREEN_WIDTH, SCREEN_HEIGHT-164)];
    [self.view addSubview:self.rootScrollView];
    
    
    //  ---------- 饼状图 ----------
    // CompletionHeader
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"BXTMTProfessionHeader" owner:nil options:nil] lastObject];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 450);
    [self.rootScrollView addSubview:self.headerView];
    
    
    // MYPieView
    NSDictionary *dataDict = self.percentDict[@"year"];
    NSArray *pieArray = [[NSMutableArray alloc] initWithObjects:dataDict[@"over_per"], dataDict[@"working_per"], dataDict[@"unover_per"], dataDict[@"unstart_per"], nil];
    
    // 1. create pieView
    self.headerView.pieView.backgroundColor = [UIColor whiteColor];
    
    // 2. fill data
    NSArray *colorArray = [[NSArray alloc] initWithObjects:@"#0FCCC0", @"#0C88CC", @"#FD7070", @"#DEE7E8", nil];
    
    if ([dataDict[@"over_per"] intValue] == 0 && [dataDict[@"working_per"] intValue] == 0 && [dataDict[@"unover_per"] intValue] == 0 && [dataDict[@"unstart_per"] intValue] == 0)
    {
        MYPieElement *elem = [MYPieElement pieElementWithValue:0.1 color:colorWithHexString(@"#DEE7E8")];
        elem.title = [NSString stringWithFormat:@"%@%%", @"0"];
        [self.headerView.pieView.layer addValues:@[elem] animated:NO];
    }
    else {
        for(int i=0; i<pieArray.count; i++)
        {
            MYPieElement *elem = [MYPieElement pieElementWithValue:[pieArray[i] floatValue] color:colorWithHexString(colorArray[i])];
            NSString *persentStr = [NSString stringWithFormat:@"%@", pieArray[i]];
            elem.title = [NSString stringWithFormat:@"%.1f%%", [persentStr floatValue]];
            [self.headerView.pieView.layer addValues:@[elem] animated:NO];
        }
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
    
    
    
    
    self.headerView.roundTitleView.text = [NSString stringWithFormat:@"总计：%@", dataDict[@"total"]];
    // Button
    self.headerView.allNumLabelView.text = [NSString stringWithFormat:@"全年维保总量为：%@", dataDict[@"total"]];
    NSString *downNumStr = [NSString stringWithFormat:@"已完成：%@", dataDict[@"over"]];
    NSString *doingNumStr = [NSString stringWithFormat:@"进行中：%@", dataDict[@"working"]];
    NSString *undownNumStr = [NSString stringWithFormat:@"未完成：%@", dataDict[@"unover"]];
    NSString *unbeginNumStr = [NSString stringWithFormat:@"未开始：%@", dataDict[@"unstart"]];
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
    self.footerView.frame = CGRectMake(0, 460, SCREEN_WIDTH, 280+20);
    self.rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 760+15);
    [self.rootScrollView addSubview:self.footerView];
    
    
    NSDictionary *dataDict = self.percentDict[@"now"];
    
    [self.footerView.pieView clearChart];
    [self.footerView.pieView addDataToRepresent:[dataDict[@"over"] intValue] WithColor:colorWithHexString(@"#0C88CC")];
    [self.footerView.pieView addDataToRepresent:[dataDict[@"working"] intValue] WithColor:colorWithHexString(@"#FD7070")];
    [self.footerView.pieView addDataToRepresent:[dataDict[@"unover"] intValue] WithColor:colorWithHexString(@"#DEE7E8")];
    self.footerView.pieView.userInteractionEnabled = NO;
    self.footerView.pieView.backgroundColor = colorWithHexString(@"#d9d9d9");
    
    self.footerView.allView.text = [NSString stringWithFormat:@"%@", dataDict[@"total"]];
    self.footerView.downView.text = [NSString stringWithFormat:@"%@", dataDict[@"over"]];
    self.footerView.doingView.text = [NSString stringWithFormat:@"%@", dataDict[@"working"]];
    self.footerView.undownView.text = [NSString stringWithFormat:@"%@", dataDict[@"unover"]];
    
    
    CGFloat rate = [dataDict[@"over"] intValue] / [dataDict[@"total"] intValue];
    CGFloat labelX = rate < 0.2 ? 0 : ((SCREEN_WIDTH-30) * rate - 60) / 2;
    UILabel *persentLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 12.5, 60, 20)];
    persentLabel.text = [NSString stringWithFormat:@"%.1f%%", [dataDict[@"over_per"] floatValue]];
    if ([dataDict[@"over"] intValue] == 0) {
        persentLabel.text = [NSString stringWithFormat:@"%.1f%%", [dataDict[@"working_per"] floatValue]];
        
        if ([dataDict[@"working"] intValue] == 0) {
            persentLabel.text = [NSString stringWithFormat:@"%.1f%%", [dataDict[@"unover_per"] floatValue]];
        }
    }
    persentLabel.textColor = [UIColor whiteColor];
    persentLabel.textAlignment = NSTextAlignmentCenter;
    persentLabel.font = [UIFont systemFontOfSize:14];
    [self.footerView.pieView addSubview:persentLabel];
    
    
    @weakify(self);
    [[self.footerView.btn0 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
        NSLog(@"%ld", (long)button.tag);
        @strongify(self);
        
        BXTMaintenanceListViewController *listVC = [[BXTMaintenanceListViewController alloc] init];
        listVC.stateStr = @"0";
        listVC.endTime = self.dateStr;
        if (!self.isSystemPush) {
            listVC.subgroupIDs = self.transSubgroupID;
        } else {
            listVC.faulttypeIDs = self.transFaulttypeTypeID;
        }
        [self.navigationController pushViewController:listVC animated:YES];
    }];
    [[self.footerView.btn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
        NSLog(@"%ld", (long)button.tag);
        @strongify(self);
        
        BXTMaintenanceListViewController *listVC = [[BXTMaintenanceListViewController alloc] init];
        listVC.stateStr = @"2";
        listVC.endTime = self.dateStr;
        if (!self.isSystemPush) {
            listVC.subgroupIDs = self.transSubgroupID;
        } else {
            listVC.faulttypeIDs = self.transFaulttypeTypeID;
        }
        [self.navigationController pushViewController:listVC animated:YES];
    }];
    [[self.footerView.btn3 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
        NSLog(@"%ld", (long)button.tag);
        @strongify(self);
        
        BXTMaintenanceListViewController *listVC = [[BXTMaintenanceListViewController alloc] init];
        listVC.stateStr = @"1";
        listVC.endTime = self.dateStr;
        if (!self.isSystemPush) {
            listVC.subgroupIDs = self.transSubgroupID;
        } else {
            listVC.faulttypeIDs = self.transFaulttypeTypeID;
        }
        [self.navigationController pushViewController:listVC animated:YES];
    }];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    
    [self.headerView removeFromSuperview];
    [self.footerView removeFromSuperview];
    
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
