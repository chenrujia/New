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

static NSInteger const CancelBtnTag = 11;
static NSInteger const DoneBtnTag = 12;

@implementation BXTChooseItemView

- (instancetype)initWithFrame:(CGRect)frame type:(ChooseViewType)cvType array:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = colorWithHexString(@"eff3f6");
        self.viewType = cvType;
        
        UIView *titleBV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 56.f)];
        titleBV.backgroundColor = [UIColor whiteColor];
        [self addSubview:titleBV];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2.f, 18, 100, 20)];
        titleLabel.font = [UIFont systemFontOfSize:17.f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"选择设备";
        [titleBV addSubview:titleLabel];
        
        UIView *lineOneView = [[UIView alloc] initWithFrame:CGRectMake(0, 55.2f, SCREEN_WIDTH, 0.8f)];
        lineOneView.backgroundColor = colorWithHexString(@"e2e6e8");
        [titleBV addSubview:lineOneView];
        
        if (_viewType == DeviceListType)
        {
            self.currentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 56, SCREEN_WIDTH, 216) style:UITableViewStylePlain];
            [self.currentTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DeviceListCell"];
            self.currentTable.delegate = self;
            self.currentTable.dataSource = self;
            [self addSubview:self.currentTable];
        }
        else if (_viewType == DatePickerType)
        {
            
        }
        
        UIView *buttonBV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - 56.f, CGRectGetWidth(frame), 56.f)];
        buttonBV.backgroundColor = [UIColor whiteColor];
        [self addSubview:buttonBV];
        
        UIView *lineTwoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.f, SCREEN_WIDTH, 0.5f)];
        lineTwoView.backgroundColor = colorWithHexString(@"e2e6e8");
        [buttonBV addSubview:lineTwoView];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelBtn.tag = CancelBtnTag;
        [cancelBtn setFrame:CGRectMake(0, 6, 120.f, 44.f)];
        [cancelBtn setCenter:CGPointMake(SCREEN_WIDTH/4.f, cancelBtn.center.y)];
        [cancelBtn setTitleColor:colorWithHexString(@"6E6E6E") forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [buttonBV addSubview:cancelBtn];
        
        UIView *lineThreeView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.f - 1.f, 16.f, 2.f, 24.f)];
        lineThreeView.backgroundColor = colorWithHexString(@"ACADB2");
        [buttonBV addSubview:lineThreeView];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        doneBtn.tag = DoneBtnTag;
        [doneBtn setFrame:CGRectMake(0, 6, 120.f, 44.f)];
        [doneBtn setCenter:CGPointMake(SCREEN_WIDTH/4.f*3.f, cancelBtn.center.y)];
        [doneBtn setTitleColor:colorWithHexString(@"3CAFFF") forState:UIControlStateNormal];
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [buttonBV addSubview:doneBtn];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceListCell" forIndexPath:indexPath];
    cell.textLabel.text = @"1";
    
    return cell;
}

@end
