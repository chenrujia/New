//
//  BXTEPFilterViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/23.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMTFilterViewController.h"
#import "BXTEPFilterCell.h"
#import "BXTRepairStateInfo.h"


@interface BXTMTFilterViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *transArray;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *selectBgView;

@property (nonatomic, strong) UITableView *selectTableView;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *mulitSelectArray;
@property (nonatomic, assign) int selectRow;
@property (nonatomic, assign) NSInteger showSelectedRow;

// 存值参数
@property (nonatomic, strong) NSMutableArray *subgroupArray;
@property (nonatomic, strong) NSMutableArray *subgroupIDArray;
@property (nonatomic, strong) NSMutableArray *faulttypeArray;
@property (nonatomic, strong) NSMutableArray *faulttypeIDArray;
@property (nonatomic, strong) NSArray *repairStateArray;
@property (nonatomic, strong) NSArray *repairStateIDArray;

@end

@implementation BXTMTFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetting:@"筛选" andRightTitle:nil andRightImage:nil];
    
    NSArray *startTimeArray = [BXTGlobal yearStartAndEnd];
    NSArray *endTimeArray = [BXTGlobal dayStartAndEnd];
    
    self.titleArray = @[@"开始时间", @"结束时间", @"专业分组", @"维保分类", @"维保状态"];
    self.dataArray = [[NSMutableArray alloc] initWithObjects:startTimeArray[0], endTimeArray[0], @"请选择", @"请选择", @"请选择", nil];
    self.transArray = [[NSMutableArray alloc] initWithObjects:startTimeArray[0], endTimeArray[0], @"", @"", @"", nil];
    
    self.subgroupArray = [[NSMutableArray alloc] init];
    self.subgroupIDArray = [[NSMutableArray alloc] init];
    self.faulttypeArray = [[NSMutableArray alloc] init];
    self.faulttypeIDArray = [[NSMutableArray alloc] init];
    self.repairStateArray = @[@"全部", @"进行中", @"已完成"];
    self.repairStateIDArray = @[@"0", @"1", @"2"];
    
    //设置初始值，不要默认选中第0行
    self.selectRow = -1;
    self.mulitSelectArray = [[NSMutableArray alloc] init];
    
    [BXTGlobal showLoadingMBP:@"数据加载中..."];
    
    /**专业分组**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    [request listOFSubgroupShopID:companyInfo.company_id];
    
    [self createUI];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT- KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    self.tableView.rowHeight = 50;
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
        
        [BXTGlobal showText:@"填写完成" view:self.view completionBlock:^{
            if (self.delegateSignal) {
                [self.delegateSignal sendNext:self.transArray];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    }];
    
    [footerView addSubview:doneBtn];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.selectTableView)
    {
        return 1;
    }
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.selectTableView)
    {
        return self.selectArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectTableView)
    {
        static NSString *cellID = @"cellSelect";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        
        //字符串
        NSString *selectRow = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        
        //数组中包含当前行号，设置对号
        if ([self.mulitSelectArray containsObject:selectRow])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
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
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.1;
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
    self.showSelectedRow = index;
    if (index == 2) {
        self.selectArray = self.subgroupArray;
    }
    else if (index == 3) {
        self.selectArray = self.faulttypeArray;
    }
    else if (index == 4) {
        self.selectArray = (NSMutableArray *)self.repairStateArray;
    }
    
    self.selectBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.selectBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    self.selectBgView.tag = 102;
    [self.view addSubview:self.selectBgView];
    
    
    // selectTableView
    CGFloat tableViewH = self.selectArray.count * 50 + 10;
    if (self.selectArray.count >= 6) {
        tableViewH = 6 * 50 + 10;
    }
    self.selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - tableViewH-50, SCREEN_WIDTH, tableViewH) style:UITableViewStylePlain];
    self.selectTableView.delegate = self;
    self.selectTableView.dataSource = self;
    [self.view addSubview:self.selectTableView];
    
    
    // toolView
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    toolView.backgroundColor = colorWithHexString(@"#EEF3F6");
    [self.selectBgView addSubview:toolView];
    
    // sure
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
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
            else if (index == 4) {
                finalNumStr = [finalNumStr stringByAppendingString:[NSString stringWithFormat:@"%@,", self.repairStateIDArray[[object intValue]]]];
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
        [self.selectBgView removeFromSuperview];
    }];
    sureBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    sureBtn.layer.borderWidth = 0.5;
    [toolView addSubview:sureBtn];
}

- (void)createDatePickerWithIndex:(NSInteger)index
{
    // bgView
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    self.bgView.tag = 101;
    [self.view addSubview:self.bgView];
    
    
    // headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-50-50, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:headerView];
    
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
    [self.bgView addSubview:self.datePicker];
    
    
    // toolView
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    toolView.backgroundColor = colorWithHexString(@"#EEF3F6");
    [self.bgView addSubview:toolView];
    
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
        [self.bgView removeFromSuperview];
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
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter1 stringFromDate:inputDate];
    
    NSLog(@"%@ - %@", theComponents, weekdays);
    //return [NSString stringWithFormat:@"%@ %@", dateStr, weekStr];
    return dateStr;
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
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == SubgroupLists && data.count > 0)
    {
        for (NSDictionary *dataDict in data)
        {
            [self.subgroupArray addObject:dataDict[@"subgroup"]];
            [self.subgroupIDArray addObject:dataDict[@"id"]];
        }
        
        /**系统分组**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request faultTypeListWithRTaskType:@"2" more:nil];
        
    }
    else if (type == FaultType && data.count > 0)
    {
        [BXTGlobal hideMBP];
        
        for (NSDictionary *dataDict in data)
        {
            [self.faulttypeArray addObject:dataDict[@"faulttype"]];
            [self.faulttypeIDArray addObject:dataDict[@"id"]];
        }
    }
    
    [self.selectTableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    
    [self showMBP:@"请求数据失败，请返回重试" withBlock:^(BOOL hidden) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
