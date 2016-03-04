//
//  BXTEPFilterViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/23.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMTFilterViewController.h"
#import "BXTEPFilterCell.h"

@interface BXTMTFilterViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>
{
    UIView *bgView;
    UIView *selectBgView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *transArray;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UITableView *selectTableView;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *mulitSelectArray;
@property (nonatomic, assign) int selectRow;
@property (nonatomic, assign) int showSelectedRow;

@property (nonatomic, strong) NSMutableArray *subgroupArray;
@property (nonatomic, strong) NSMutableArray *subgroupIDArray;
@property (nonatomic, strong) NSMutableArray *faulttypeArray;
@property (nonatomic, strong) NSMutableArray *faulttypeIDArray;

@end

@implementation BXTMTFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"筛选" andRightTitle:nil andRightImage:nil];
    
    self.titleArray = @[@"开始时间", @"结束时间", @"专业分组", @"系统分组", @"工单分类"];
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"待完善", @"待完善", @"待完善", @"待完善", @"待完善", nil];
    self.transArray = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", nil];
    self.subgroupArray = [[NSMutableArray alloc] init];
    self.subgroupIDArray = [[NSMutableArray alloc] init];
    self.faulttypeArray = [[NSMutableArray alloc] init];
    self.faulttypeIDArray = [[NSMutableArray alloc] init];
    
    //设置初始值，不要默认选中第0行
    self.selectRow = -1;
    self.mulitSelectArray = [[NSMutableArray alloc] init];
    
    
    [self showLoadingMBP:@"数据加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**专业分组**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request propertyGrouping];
    });
    dispatch_async(concurrentQueue, ^{
        /**系统分组**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request faultTypeListWithRTaskType:@"2"];
    });
    
    
    [self createUI];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT- KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(20, 30, SCREEN_WIDTH - 40, 50.f);
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [doneBtn setBackgroundColor:colorWithHexString(@"3cafff")];
    doneBtn.layer.masksToBounds = YES;
    doneBtn.layer.cornerRadius = 4.f;
    @weakify(self);
    [[doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        int count = 0;
        for (NSString *titleStr in self.dataArray) {
            if ([titleStr isEqualToString:@"待完善"]) {
                count++;
            }
        }
        
        if (count == self.dataArray.count) {
            [MYAlertAction showAlertWithTitle:@"温馨提示" msg:@"请填写筛选条件" chooseBlock:^(NSInteger buttonIdx) {
                
            } buttonsStatement:@"确定", nil];
        }
        else {
            [BXTGlobal showText:@"填写完成" view:self.view completionBlock:^{
                if (self.delegateSignal) {
                    [self.delegateSignal sendNext:self.transArray];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }];
    [footerView addSubview:doneBtn];
    
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.selectTableView) {
        return 1;
    }
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.selectTableView) {
        return self.selectArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectTableView) {
        static NSString *cellID = @"cellSelect";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        
        //字符串
        NSString *selectRow = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        
        //数组中包含当前行号，设置对号
        if ([self.mulitSelectArray containsObject:selectRow]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.textLabel.text = self.selectArray[indexPath.row];
        
        return cell;
    }
    
    static NSString *cellID = @"cell";
    BXTEPFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEPFilterCell" owner:nil options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.titleView.text = self.titleArray[indexPath.section];
    cell.detailView.text = self.dataArray[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.selectTableView) {
        return 0.1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectTableView) {
        NSString *selectRow  = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        
        if (self.showSelectedRow == 4) {
            //判断数组中有没有被选中行的行号,
            if ([self.mulitSelectArray containsObject:selectRow]) {
                [self.mulitSelectArray removeObject:selectRow];
            }
            else {
                if (self.mulitSelectArray.count == 1) {
                    [self.mulitSelectArray replaceObjectAtIndex:0 withObject:selectRow];
                } else {
                    [self.mulitSelectArray addObject:selectRow];
                }
            }
        }
        else {
            //判断数组中有没有被选中行的行号,
            if ([self.mulitSelectArray containsObject:selectRow]) {
                [self.mulitSelectArray removeObject:selectRow];
            }
            else {
                [self.mulitSelectArray addObject:selectRow];
            }
        }
        
        [tableView reloadData];
        return;
    }
    
    
    if (indexPath.section <= 1) {
        [self createDatePickerWithIndex:indexPath.section];
    }
    else {
        [self createTableViewWithIndex:indexPath.section];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - 方法
- (void)createTableViewWithIndex:(NSInteger)index
{
    self.showSelectedRow = 0;
    if (index == 2) {
        self.selectArray = self.subgroupArray;
    }
    else if (index == 3) {
        self.selectArray = self.faulttypeArray;
    }
    else if (index == 4) {
        self.selectArray = [[NSMutableArray alloc] initWithObjects:@"全部", @"进行中", @"已完成", nil];
        self.showSelectedRow = 4;
    }
    
    selectBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    selectBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    selectBgView.tag = 102;
    [self.view addSubview:selectBgView];
    
    
    // selectTableView
    CGFloat tableViewH = self.selectArray.count * 50 + 60;
    self.selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - tableViewH, SCREEN_WIDTH, tableViewH) style:UITableViewStylePlain];
    self.selectTableView.delegate = self;
    self.selectTableView.dataSource = self;
    self.selectTableView.scrollEnabled = NO;
    [self.view addSubview:self.selectTableView];
    
    
    // toolView
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    toolView.backgroundColor = colorWithHexString(@"#EEF3F6");
    self.selectTableView.tableFooterView = toolView;
    
    // sure
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 50)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    [[sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        NSString *finalStr =@"";
        NSString *finalNumStr = @"";
        for (id object in self.mulitSelectArray) {
            finalStr = [finalStr stringByAppendingString:[NSString stringWithFormat:@" %@", self.selectArray[[object intValue]]]];
            
            if (index == 2) {
                finalNumStr = [finalNumStr stringByAppendingString:[NSString stringWithFormat:@"%@,", self.subgroupIDArray[[object intValue]]]];
            }
            else if (index == 3) {
                finalNumStr = [finalNumStr stringByAppendingString:[NSString stringWithFormat:@"%@,", self.faulttypeIDArray[[object intValue]]]];
            }
            else {
                finalNumStr = [finalNumStr stringByAppendingString:[NSString stringWithFormat:@"%@,", object]];
            }
            
        }
        if (finalNumStr.length >= 1) {
            finalNumStr = [finalNumStr substringToIndex:finalNumStr.length - 1];
        }
        
        // 赋值
        if (![BXTGlobal isBlankString:finalStr])
        {
            [self.dataArray replaceObjectAtIndex:index withObject:finalStr];
            [self.transArray replaceObjectAtIndex:index withObject:finalNumStr];
            [self.tableView reloadData];
        }
        
        
        // 清除
        [self.mulitSelectArray removeAllObjects];
        [_selectTableView removeFromSuperview];
        _selectTableView = nil;
        [selectBgView removeFromSuperview];
    }];
    sureBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    sureBtn.layer.borderWidth = 0.5;
    [toolView addSubview:sureBtn];
}

- (void)createDatePickerWithIndex:(NSInteger)index
{
    // bgView
    bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    bgView.tag = 101;
    [self.view addSubview:bgView];
    
    
    // headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-50-50, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:headerView];
    
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 30)];
    titleLabel.text = @"开始时间";
    if (index == 1) {
        titleLabel.text = @"结束时间";
    }
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    [headerView addSubview:titleLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [headerView addSubview:line];
    
    // timeLabel
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 165, 10, 150, 30)];
    timeLabel.text = [self weekdayStringFromDate:[NSDate date]];
    timeLabel.textColor = colorWithHexString(@"#3BAFFF");
    timeLabel.font = [UIFont systemFontOfSize:16.f];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:timeLabel];
    
    
    // datePicker
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216-50, SCREEN_WIDTH, 216)];
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    self.datePicker.backgroundColor = colorWithHexString(@"ffffff");
    //    self.datePicker.minimumDate = [NSDate date];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [[self.datePicker rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        // 显示时间
        timeLabel.text = [self weekdayStringFromDate:self.datePicker.date];
    }];
    [bgView addSubview:self.datePicker];
    
    
    // toolView
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    toolView.backgroundColor = colorWithHexString(@"#EEF3F6");
    [bgView addSubview:toolView];
    
    // sure
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 50)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    [[sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.dataArray replaceObjectAtIndex:index withObject:timeLabel.text];
        [self.transArray replaceObjectAtIndex:index withObject:[self transTimeWithTime:timeLabel.text]];
        [self.tableView reloadData];
        
        self.datePicker = nil;
        [bgView removeFromSuperview];
    }];
    sureBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    sureBtn.layer.borderWidth = 0.5;
    [toolView addSubview:sureBtn];
}

// 时间戳转换成 2015年11月27日 星期五 格式
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate
{
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    NSString *weekStr = [weekdays objectAtIndex:theComponents.weekday];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy/MM/dd"];
    NSString *dateStr = [formatter1 stringFromDate:inputDate];
    
    return [NSString stringWithFormat:@"%@ %@", dateStr, weekStr];
}


- (NSString *)transTimeWithTime:(NSString *)time
{
    return [[time substringToIndex:10] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        if (_datePicker)
        {
            [_datePicker removeFromSuperview];
            _datePicker = nil;
        }
        [view removeFromSuperview];
    }
    else if (view.tag == 102)
    {
        if (_selectTableView) {
            [self.mulitSelectArray removeAllObjects];
            [_selectTableView removeFromSuperview];
            _selectTableView = nil;
        }
        [view removeFromSuperview];
    }
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == PropertyGrouping && data.count > 0)
    {
        for (NSDictionary *dataDict in data)
        {
            [self.subgroupArray addObject:dataDict[@"subgroup"]];
            [self.subgroupIDArray addObject:dataDict[@"id"]];
        }
        
        
    }
    else if (type == FaultType && data.count > 0)
    {
        for (NSDictionary *dataDict in data)
        {
            [self.faulttypeArray addObject:dataDict[@"faulttype_type"]];
            [self.faulttypeIDArray addObject:dataDict[@"id"]];
        }
    }
    [self.selectTableView reloadData];
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
