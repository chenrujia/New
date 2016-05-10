//
//  BXTChooseItemView.m
//  YouFeel
//
//  Created by Jason on 16/3/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTChooseItemView.h"
#import "BXTPublicSetting.h"
#import "BXTGlobal.h"
#import "BXTItemTableViewCell.h"

static NSInteger const CancelBtnTag = 11;
static NSInteger const DoneBtnTag = 12;

@implementation BXTChooseItemView

- (instancetype)initWithFrame:(CGRect)frame type:(ChooseViewType)cvType array:(NSArray *)array block:(ChooseItemBlock)block
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = colorWithHexString(@"eff3f6");
        self.viewType = cvType;
        self.devicesArray = array;
        self.chooseBlock = block;
        self.markArray = [NSMutableArray array];
        for (NSInteger i = 0; i < [self.devicesArray count]; i++)
        {
            [self.markArray addObject:@"0"];
        }
        
        UIView *titleBV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 56.f)];
        titleBV.backgroundColor = [UIColor whiteColor];
        [self addSubview:titleBV];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2.f, 18, 130, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:17.f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleBV addSubview:self.titleLabel];
        
        UIView *lineOneView = [[UIView alloc] initWithFrame:CGRectMake(0, 55.2f, SCREEN_WIDTH, 0.8f)];
        lineOneView.backgroundColor = colorWithHexString(@"e2e6e8");
        [titleBV addSubview:lineOneView];
        
        if (_viewType == DeviceListType)
        {
            self.titleLabel.text = @"选择设备";
            [self loadTableView];
        }
        else if (_viewType == DatePickerType)
        {
            self.titleLabel.text = @"选择预约时间";
            [self loadDatePicker];
        }
        
        UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - 56.f, SCREEN_WIDTH, 56)];
        toolView.backgroundColor = colorWithHexString(@"ffffff");
        [self addSubview:toolView];
        // sure
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 56)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        @weakify(self);
        [[sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (self.viewType == DeviceListType)
            {
                self.chooseBlock(self.selectDeviceInfo,self.viewType,YES);
            }
            else if (self.viewType == DatePickerType)
            {
                self.chooseBlock(self.selectTimeDic,self.viewType,YES);
            }
        }];
        sureBtn.tag = DoneBtnTag;
        sureBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
        sureBtn.layer.borderWidth = 0.5;
        [toolView addSubview:sureBtn];
        // cancel
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 56)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            self.chooseBlock(nil,self.viewType,NO);
        }];
        cancelBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
        cancelBtn.layer.borderWidth = 0.5;
        cancelBtn.tag = CancelBtnTag;
        [toolView addSubview:cancelBtn];
    }
    return self;
}

- (void)refreshChooseView:(ChooseViewType)cvType array:(NSArray *)array
{
    self.viewType = cvType;
    self.devicesArray = array;
    if (self.viewType == DeviceListType)
    {
        self.titleLabel.text = @"选择设备";
        self.currentDatePicker.hidden = YES;
        self.currentTable.hidden = NO;
        if (self.currentTable)
        {
            [self.currentTable reloadData];
        }
        else
        {
            [self loadTableView];
        }
    }
    else if (self.viewType == DatePickerType)
    {
        self.titleLabel.text = @"选择预约时间";
        self.currentDatePicker.hidden = NO;
        self.currentTable.hidden = YES;
        if (!self.currentDatePicker)
        {
            [self loadDatePicker];
        }
    }
}

- (void)loadTableView
{
    self.currentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 56, SCREEN_WIDTH, 216) style:UITableViewStylePlain];
    [self.currentTable registerNib:[UINib nibWithNibName:@"BXTItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"DeviceListCell"];
    [self.currentTable setRowHeight:50.f];
    self.currentTable.delegate = self;
    self.currentTable.dataSource = self;
    [self addSubview:self.currentTable];
}

- (void)loadDatePicker
{
    self.currentDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 56, SCREEN_WIDTH, 216)];
    self.currentDatePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    self.currentDatePicker.backgroundColor = colorWithHexString(@"ffffff");
    self.currentDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.currentDatePicker.minimumDate = [NSDate date];
    @weakify(self);
    [[self.currentDatePicker rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self);
        NSString *dateStr = [BXTGlobal transTimeWithDate:self.currentDatePicker.date withType:@"yyyy/MM/dd HH:mm"];
        NSString *timeInterval = [NSString stringWithFormat:@"%.0f",self.currentDatePicker.date.timeIntervalSince1970];
        self.selectTimeDic = @{@"time":dateStr,
                               @"timeInterval":timeInterval};
    }];
    [self addSubview:self.currentDatePicker];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.devicesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTItemTableViewCell *cell = (BXTItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DeviceListCell" forIndexPath:indexPath];
    BXTDeviceListInfo *deviceInfo = self.devicesArray[indexPath.row];
    cell.nameLabel.text = deviceInfo.name;
    cell.nameLabel.textColor = [self.markArray[indexPath.row] integerValue] ? colorWithHexString(@"3cafff") : [UIColor blackColor];
    cell.detailLabel.text = deviceInfo.code_number;
    cell.detailLabel.textColor = [self.markArray[indexPath.row] integerValue] ? colorWithHexString(@"3cafff") : colorWithHexString(@"6b6b6b");
    cell.checkImage.hidden = [self.markArray[indexPath.row] integerValue] ? NO : YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectDeviceInfo = self.devicesArray[indexPath.row];
    NSInteger i = 0;
    while (i < self.markArray.count)
    {
        [self.markArray replaceObjectAtIndex:i withObject:@"0"];
        i++;
    }
    [self.markArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    [tableView reloadData];
}

@end
