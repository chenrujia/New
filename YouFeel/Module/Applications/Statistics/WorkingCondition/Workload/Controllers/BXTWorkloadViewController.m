//
//  WorkloadViewController.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/26.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "BXTWorkloadViewController.h"
#import "BXTWorkloadCell.h"
#import "DOPDropDownMenu.h"

#define Margin 5

@interface BXTWorkloadViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate, DOPDropDownMenuDataSource, DOPDropDownMenuDelegate>
{
    CGFloat bgViewH;
    UIImageView *arrow;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *isShowArray;

@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, copy) NSString *typeStr;

@end

@implementation BXTWorkloadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.isShowArray = [[NSMutableArray alloc] initWithObjects:@"1", nil];
    self.typeArray = @[@"员工全部工作量统计", @"员工日常工作量统计", @"员工维保工作量统计"];
    self.typeStr = @"0";
    
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.rootScrollView addSubview:menu];
    [menu selectDefalutIndexPath];
    
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    [self.tableView removeFromSuperview];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 54, SCREEN_WIDTH, SCREEN_HEIGHT-100-54) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.rootScrollView addSubview:self.tableView];
    
}

- (void)createWorkIoadViewOfIndex:(NSInteger)index WithTableViewCell:(BXTWorkloadCell *)newCell
{
    
    NSDictionary *dataDict = self.dataArray[index];
    NSArray *workloadArray = dataDict[@"workload"];
    NSMutableArray *sumArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in workloadArray)
    {
        [sumArray addObject:[NSString stringWithFormat:@"%@", dict[@"sum_number"]]];
    }
    NSNumber *maxNum = [sumArray valueForKeyPath:@"@max.floatValue"];
    double maxDouble = [maxNum doubleValue];
    if (maxDouble == 0)
    {
        maxDouble = 1;
    }
    
    CGFloat bgViewY = 20;
    
    
    UILabel *lineY = [[UILabel alloc] initWithFrame:CGRectMake(85, 10, SCREEN_WIDTH-120, 1)];
    lineY.backgroundColor = colorWithHexString(@"#d9d9d9");
    [newCell.contentView addSubview:lineY];
    UILabel *lineYMax = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-33, 5, 33, 15)];
    lineYMax.text = [NSString stringWithFormat:@"%@", maxNum];
    lineYMax.textColor = colorWithHexString(@"#666666");
    lineYMax.font = [UIFont systemFontOfSize:12];
    [newCell addSubview:lineYMax];
    UILabel *lineX = [[UILabel alloc] initWithFrame:CGRectMake(84, 10, 1, workloadArray.count*(bgViewH+Margin)+15)];
    lineX.backgroundColor = colorWithHexString(@"#d9d9d9");
    [newCell.contentView addSubview:lineX];
    
    
    for (int i=0; i<workloadArray.count; i++)
    {
        NSDictionary *dict = workloadArray[i];
        int count = [[NSString stringWithFormat:@"%@", dict[@"sum_number"]] doubleValue];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(15, bgViewY+(bgViewH+Margin)*i, SCREEN_WIDTH-15, bgViewH)];
        bgView.backgroundColor = [UIColor clearColor];
        [newCell.contentView addSubview:bgView];
        
        // name
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 70, 30)];
        nameLabel.text = dict[@"name"];
        nameLabel.textColor = colorWithHexString(@"#666666");
        nameLabel.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:nameLabel];
        
        // chart
        if (count == 0)
        {
            count = maxDouble;
        }
        AksStraightPieChart *straightPieChart = [[AksStraightPieChart alloc] initWithFrame:CGRectMake(70, 0, (bgView.frame.size.width-105)*(count/maxDouble), bgViewH)];
        straightPieChart.transPieClick = ^(void) {
            newCell.nameView.text = [NSString stringWithFormat:@"%@", dict[@"name"]];
            newCell.downView.text = [NSString stringWithFormat:@"已完成:%@", dict[@"yes_number"]];
            newCell.specialView.text = [NSString stringWithFormat:@"特殊工单:%@", dict[@"collection_number"]];
            newCell.undownView.text = [NSString stringWithFormat:@"未完成:%@", dict[@"no_number"]];
        };
        [bgView addSubview:straightPieChart];
        
        [straightPieChart clearChart];
        straightPieChart.isVertical = NO;
        [straightPieChart addDataToRepresent:[dict[@"yes_number"] intValue] WithColor:colorWithHexString(@"#0FCCC0")];
        [straightPieChart addDataToRepresent:[dict[@"collection_number"] intValue] WithColor:colorWithHexString(@"#F9D063")];
        [straightPieChart addDataToRepresent:[dict[@"no_number"] intValue] WithColor:colorWithHexString(@"#FD7070")];
    }
}

#pragma mark -
#pragma mark DOPDropDownMenuDataSource && DOPDropDownMenuDelegate
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    return self.typeArray.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return self.typeArray[indexPath.row];
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: self.typeStr = @"0"; break;
        case 1: self.typeStr = @"1"; break;
        case 2: self.typeStr = @"2"; break;
        default: break;
    }
    
    self.rootSegmentedCtr.selectedSegmentIndex = 2;
    
    [self showLoadingMBP:@"数据加载中..."];
    NSArray *dateArray = [BXTGlobal dayStartAndEnd];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request statisticsWorkloadWithTimeStart:dateArray[0] timeEnd:dateArray[1] Type:self.typeStr];
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
    BXTWorkloadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTWorkloadCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    bgViewH = 40;
    NSDictionary *dataDict = self.dataArray[indexPath.section];
    NSArray *workloadArray = dataDict[@"workload"];
    
    NSDictionary *dict = workloadArray[0];
    cell.nameView.text = [NSString stringWithFormat:@"%@", dict[@"name"]];
    cell.downView.text = [NSString stringWithFormat:@"已完成:%@", dict[@"yes_number"]];
    cell.specialView.text = [NSString stringWithFormat:@"特殊工单:%@", dict[@"collection_number"]];
    cell.undownView.text = [NSString stringWithFormat:@"未完成:%@", dict[@"no_number"]];
    
    [self createWorkIoadViewOfIndex:indexPath.section WithTableViewCell:cell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDict = self.dataArray[indexPath.section];
    NSArray *workloadArray = dataDict[@"workload"];
    CGFloat viViewH = (workloadArray.count-1) * (bgViewH+Margin) + 150;
    return viViewH;
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
    NSDictionary *dict = self.dataArray[section];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = section;
    btn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    btn.layer.borderWidth = 0.5;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 100, 21)];
    title.text = dict[@"subgroup"];
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
#pragma mark - 父类点击事件
- (void)segmentView:(SegmentView *)segmentView didSelectedSegmentAtIndex:(NSInteger)index {
    NSMutableArray *dateArray;
    switch (index) {
        case 0:
            dateArray = [[NSMutableArray alloc] initWithArray:[self timeTypeOf_YearStartAndEnd:self.rootCenterButton.titleLabel.text]];
            break;
        case 1:
            dateArray = [[NSMutableArray alloc] initWithArray:[self timeTypeOf_MonthStartAndEnd:self.rootCenterButton.titleLabel.text]];
            break;
        case 2:
            dateArray = [[NSMutableArray alloc] initWithArray:[self timeTypeOf_DayStartAndEnd:self.rootCenterButton.titleLabel.text]];
            break;
        default:
            break;
    }
    
    [self showLoadingMBP:@"数据加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request statisticsWorkloadWithTimeStart:dateArray[0] timeEnd:dateArray[1] Type:self.typeStr];
}

- (void)datePickerBtnClick:(UIButton *)button
{
    if (button.tag == 10001)
    {
        self.rootSegmentedCtr.selectedSegmentIndex = 2;
        [self showLoadingMBP:@"数据加载中..."];
        
        /**饼状图**/
        if (!selectedDate)
        {
            selectedDate = [NSDate date];
        }
        [self.rootCenterButton setTitle:[self weekdayStringFromDate:selectedDate] forState:UIControlStateNormal];
        
        NSString *todayStr = [self transTimeWithDate:selectedDate];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request statisticsWorkloadWithTimeStart:todayStr timeEnd:todayStr Type:self.typeStr];
    }
    [super datePickerBtnClick:button];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == Statistics_Workload && data.count > 0) {
        self.dataArray = dic[@"data"];
        for (int i=0; i<self.dataArray.count-1; i++)
        {
            [self.isShowArray addObject:@"0"];
        }
        
        [self createUI];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
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
