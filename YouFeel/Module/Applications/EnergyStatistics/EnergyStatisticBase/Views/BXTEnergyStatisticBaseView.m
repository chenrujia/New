//
//  BXTEnergyStatisticBaseView.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyStatisticBaseView.h"
#import "BMDatePickerView.h"

#define headerViewH 256

@interface BXTEnergyStatisticBaseView () <UIPickerViewDelegate, UIPickerViewDataSource>

/** ---- 时间选择器 ---- */
@property (nonatomic, strong) BXTEnergyStatisticFilterView *filterView;

/** ---- 年份选择 ---- */
@property (nonatomic, strong) UIPickerView *yearPickerView;
/** ---- 年份数组 ---- */
@property (nonatomic, strong) NSMutableArray *yearArray;
/** ---- 当前月份 ---- */
@property (copy, nonatomic) NSString *nowTimeStr;

@end

@implementation BXTEnergyStatisticBaseView

- (instancetype)initWithFrame:(CGRect)frame VCType:(ViewControllerType)vcType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.vcType = vcType;
        [self initialize];
    }
    return self;
}

#pragma mark -
#pragma mark - 初始化
- (void)initialize
{
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2" , @"3", @"4", nil];
    
    NSArray *array = [BXTGlobal yearAndmonthAndDay];
    
    if (self.vcType == ViewControllerTypeOFYear) {
        self.timeStr = array[0];
        
        self.yearArray = [[NSMutableArray alloc] init];
        for (int i = 2001; i<=[self.timeStr intValue]; i++) {
            [self.yearArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    else {
        self.nowTimeStr = [NSString stringWithFormat:@"%@年%@月", array[0], array[1]];
        self.timeStr = self.nowTimeStr;
    }
    
    [self createTimerSelector];
    
    [self createTableView];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.filterView.frame), SCREEN_WIDTH, self.frame.size.height - CGRectGetMaxY(self.filterView.frame)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
}

- (void)createTimerSelector
{
    self.filterView = [BXTEnergyStatisticFilterView viewForEnergyStatisticFilterView];
    self.filterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    
    // 初始化数据
    if (self.vcType == ViewControllerTypeOFYear) {
        [self.filterView.thisTimeBtn setTitle:[self transYearStr:self.timeStr] forState:UIControlStateNormal];
        [self.filterView.lastTimeBtn setTitle:@"上一年" forState:UIControlStateNormal];
        [self.filterView.nextTimeBtn setTitle:@"下一年" forState:UIControlStateNormal];
        [self.filterView.thisTimeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, -60)];
    }
    else {
        [self.filterView.thisTimeBtn setTitle:self.timeStr forState:UIControlStateNormal];
    }
    
    // thisTimeBtn
    @weakify(self);
    [[self.filterView.thisTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.vcType == ViewControllerTypeOFYear) {
            [self createYearPickerView];
            [[self.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [self.filterView.thisTimeBtn setTitle:[self transYearStr:self.timeStr] forState:UIControlStateNormal];
                if ([self.timeStr integerValue] != [[BXTGlobal yearAndmonthAndDay][0] integerValue]) {
                    [self isNextTimeBtnCanEdit:YES];
                } else {
                    [self isNextTimeBtnCanEdit:NO];
                }
            }];
        }
        else {
            [self createMonthPickerView];
        }
    }];
    
    // lastTimeBtn
    [[self.filterView.lastTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.vcType == ViewControllerTypeOFYear) {
            self.timeStr = [self transYearIsAdd:NO];
            [self.filterView.thisTimeBtn setTitle:[self transYearStr:self.timeStr] forState:UIControlStateNormal];
        }
        else {
            [self.filterView.thisTimeBtn setTitle:[self transTime:self.timeStr isAdd:NO] forState:UIControlStateNormal];
            self.filterView.nextTimeBtn.enabled = YES;
        }
        
        [self isNextTimeBtnCanEdit:YES];
    }];
    
    // nextTimeBtn
    [[self.filterView.nextTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.vcType == ViewControllerTypeOFYear) {
            self.timeStr = [self transYearIsAdd:YES];
            [self.filterView.thisTimeBtn setTitle:[self transYearStr:self.timeStr] forState:UIControlStateNormal];
            
            if ([self.timeStr integerValue] == [[BXTGlobal yearAndmonthAndDay][0] integerValue]) {
                [self isNextTimeBtnCanEdit:NO];
            }
        }
        else {
            NSString *timeStr = [self transTime:self.timeStr isAdd:YES];
            [self.filterView.thisTimeBtn setTitle:timeStr forState:UIControlStateNormal];
            if ([self.timeStr isEqualToString:self.nowTimeStr]) {
                [self isNextTimeBtnCanEdit:NO];
            }
        }
    }];
    [self addSubview:self.filterView];
}

- (void)createMonthPickerView
{
    @weakify(self);
    BMDatePickerView *datePickerView = [BMDatePickerView BMDatePickerViewCertainActionBlock:^(NSString *selectYearMonthString) {
        @strongify(self);
        NSLog(@"选择的时间是: %@", selectYearMonthString);
        
        self.timeStr = selectYearMonthString;
        [self.filterView.thisTimeBtn setTitle:self.timeStr forState:UIControlStateNormal];
        if ([self.timeStr isEqualToString:self.nowTimeStr]) {
            [self isNextTimeBtnCanEdit:NO];
        } else {
            [self isNextTimeBtnCanEdit:YES];
        }
    }];
    [datePickerView show];
}

- (void)createYearPickerView
{
    // bgView
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    bgView.tag = 103;
    [self addSubview:bgView];
    
    
    // headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(40, (SCREEN_HEIGHT - headerViewH) / 2, SCREEN_WIDTH - 80, headerViewH)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.layer.cornerRadius = 5;
    [bgView addSubview:headerView];
    
    
    CGFloat headerViewW = headerView.frame.size.width;
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, headerViewW, 30)];
    titleLabel.text = @"选择时间";
    titleLabel.textColor = colorWithHexString(@"333333");
    titleLabel.font = [UIFont systemFontOfSize:18.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44, headerViewW, 1)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [headerView addSubview:line];
    
    
    // self.yearPickerView
    self.yearPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, headerViewW, 162)];
    self.yearPickerView.delegate = self;
    self.yearPickerView.dataSource = self;
    [headerView addSubview:self.yearPickerView];
    
    NSInteger index = [self.timeStr integerValue] - 2001;
    self.timeStr = self.yearArray[index];
    [self.yearPickerView selectRow:index inComponent:0 animated:YES];
    
    
    // 按钮
    UIButton *cancelBtn = [self createButtonWithTitle:@"取消" btnX:10 tilteColor:@"#FFFFFF"];
    [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (_yearPickerView)
        {
            [_yearPickerView removeFromSuperview];
            _yearPickerView = nil;
        }
        [bgView removeFromSuperview];
    }];
    [headerView addSubview:cancelBtn];
    
    self.commitBtn = [self createButtonWithTitle:@"确定" btnX:headerViewW / 2 + 5  tilteColor:@"#5DAFF9"];
    [[self.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (_yearPickerView)
        {
            [_yearPickerView removeFromSuperview];
            _yearPickerView = nil;
        }
        [bgView removeFromSuperview];
    }];
    [headerView addSubview:self.commitBtn];
}
#pragma mark -
#pragma mark - UIPickerView代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.yearArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self transYearStr:self.yearArray[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.timeStr = self.yearArray[row];
}


#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - other
- (UIButton *)createButtonWithTitle:(NSString *)titleStr btnX:(CGFloat)btnX tilteColor:(NSString *)colorStr
{
    UIButton *newMeterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newMeterBtn.frame = CGRectMake(btnX, headerViewH - 50, (SCREEN_WIDTH - 80 - 30) / 2, 40);
    [newMeterBtn setBackgroundColor:colorWithHexString(colorStr)];
    [newMeterBtn setTitle:titleStr forState:UIControlStateNormal];
    newMeterBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    newMeterBtn.layer.borderWidth = 1;
    if ([colorStr isEqualToString:@"#FFFFFF"]) {
        [newMeterBtn setTitleColor:colorWithHexString(@"#5DAFF9") forState:UIControlStateNormal];
    }
    newMeterBtn.layer.borderColor = [colorWithHexString(@"#5DAFF9") CGColor];
    newMeterBtn.layer.cornerRadius = 5;
    
    return newMeterBtn;
}

- (NSString *)transYearStr:(NSString *)time
{
    return [NSString stringWithFormat:@"%@年", time];
}

- (void)isNextTimeBtnCanEdit:(BOOL)canEdit
{
    if (canEdit) {
        self.filterView.nextTimeBtn.enabled = YES;
        self.filterView.nextTimeBtn.alpha = 1.0;
    }
    else {
        self.filterView.nextTimeBtn.enabled = NO;
        self.filterView.nextTimeBtn.alpha = 0.4;
    }
}

- (NSString *)transYearIsAdd:(BOOL)isAdd
{
    NSInteger year = [self.timeStr integerValue];
    if (!isAdd)
    { // 减法
        year -= 1;
    }
    else
    {
        year += 1;
    }
    self.timeStr = [NSString stringWithFormat:@"%ld", (long)year];
    
    return self.timeStr;
}

- (NSString *)transTime:(NSString *)time isAdd:(BOOL)add
{
    NSInteger year = [[self.timeStr substringToIndex:4] integerValue];
    NSInteger month = [[self.timeStr substringWithRange:NSMakeRange(5, self.timeStr.length-6)] integerValue];
    
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
    
    self.timeStr = [NSString stringWithFormat:@"%ld年%ld月", (long)year, (long)month];
    
    return self.timeStr;
}

@end
