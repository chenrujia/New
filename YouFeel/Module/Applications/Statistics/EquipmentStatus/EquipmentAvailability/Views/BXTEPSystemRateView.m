//
//  BXTEPSystemRateView.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEPSystemRateView.h"
#import "BXTWorkloadCell.h"
#import "BXTHeaderFile.h"
#import "BXTDataRequest.h"
#import "AksStraightPieChart.h"
#import "BXTEPSystemRate.h"
#import "BXTEPSystemRateCell.h"

#define Margin 5

@interface BXTEPSystemRateView () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>
{
    CGFloat bgViewH;
    UIImageView *arrow;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *isShowArray;

@end

@implementation BXTEPSystemRateView

#pragma mark -
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initial];
    }
    return self;
}

- (instancetype)init
{
    if (self == [super init])
    {
        [self initial];
    }
    return self;
}

- (void)initial
{
    self.dataArray = [[NSMutableArray alloc] init];
    self.isShowArray = [[NSMutableArray alloc] initWithObjects:@"1", nil];
    
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request deviceTypeStaticsWithDate:@""];
    
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"BXTEPSummaryViewAndBXTEPSystemRateView" object:nil] subscribeNext:^(NSNotification *notify) {
        NSDictionary *dict = [notify userInfo];
        
        /**条形图**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request deviceTypeStaticsWithDate:dict[@"timeStr"]];
    }];
    
    [self createUI];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
}

- (void)createWorkIoadViewOfIndex:(NSInteger)index WithTableViewCell:(BXTEPSystemRateCell *)newCell
{
    AksStraightPieChart *straightPieChart = [[AksStraightPieChart alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, bgViewH)];
    straightPieChart.transPieClick = ^(void) {
        
    };
    [newCell.contentView addSubview:straightPieChart];
    
    BXTEPSystemRate *model = self.dataArray[index];
    
    [straightPieChart clearChart];
    straightPieChart.isVertical = NO;
    [straightPieChart addDataToRepresent:[model.working_per intValue] WithColor:colorWithHexString(@"#34B47E")];
    [straightPieChart addDataToRepresent:[model.stop_per intValue] WithColor:colorWithHexString(@"#D6AD5B")];
    
    UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 80, bgViewH)];
    rateLabel.text = [NSString stringWithFormat:@"%@%%", model.working_per];
    rateLabel.textColor = [UIColor whiteColor];
    [straightPieChart addSubview:rateLabel];
    
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.isShowArray[section] isEqualToString:@"1"]) {
        return  1;
    }
    return  0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    BXTEPSystemRateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEPSystemRateCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    bgViewH = 40;
    cell.epList = self.dataArray[indexPath.section];
    
    [self createWorkIoadViewOfIndex:indexPath.section WithTableViewCell:cell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld - %ld", (long)indexPath.section, (long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"headerTitle";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BXTEPSystemRate *model = self.dataArray[section];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = section;
    btn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    btn.layer.borderWidth = 0.5;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 250, 21)];
    title.text = model.type_name;
    title.textColor = colorWithHexString(@"#666666");
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:15];
    [btn addSubview:title];
    
    arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 18.5, 15, 8)];
    arrow.image = [UIImage imageNamed:@"down_arrow_gray"];
    if ([self.isShowArray[section] isEqualToString:@"1"])
    {
        arrow.image = [UIImage imageNamed:@"up_arrow_gray"];
    }
    [btn addSubview:arrow];
    
    
    return btn;
}

#pragma mark -
#pragma mark - viewForHeader点击事件
- (void)btnClick:(UIButton *)btn
{
    
    // 改变组的显示状态
    if ([self.isShowArray[btn.tag] isEqualToString:@"1"])
    {
        [self.isShowArray replaceObjectAtIndex:btn.tag withObject:@"0"];
    }
    else
    {
        [self.isShowArray replaceObjectAtIndex:btn.tag withObject:@"1"];
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    //    [self hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == Device_AvailableType && data.count > 0) {
        for (NSDictionary *dict in data) {
            BXTEPSystemRate *rateModel = [BXTEPSystemRate modelWithDict:dict];
            [self.dataArray addObject:rateModel];
        }
        
        for (int i=0; i<self.dataArray.count-1; i++)
        {
            [self.isShowArray addObject:@"0"];
        }
    }
    
    if (data.count == 0) {
        [self.dataArray removeAllObjects];
    }
    
    [self.tableView reloadData];
}

- (void)requestError:(NSError *)error
{
    //    [self hideMBP];
}

@end