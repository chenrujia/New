//
//  BXTMTReportsViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/23.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMTReportsViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTMTReportsCell.h"
#import "BXTMTAddImageCell.h"
#import "BXTMTWriteReportCell.h"
#import "UIImage+SubImage.h"
#import "BXTSearchPlaceViewController.h"

@interface BXTMTReportsViewController () <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,BXTDataResponseDelegate>
{
    UIView *bgView;
}

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *selectTableView;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *mulitSelectArray;

@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSMutableArray *resultIDArray;
@property (nonatomic, strong) NSMutableArray *badCauseArray;
@property (nonatomic, strong) NSMutableArray *badCauseIDArray;
// 选择的Row
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) BOOL isShowCause;

@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation BXTMTReportsViewController

- (void)dealloc
{
    LogBlue(@"新建报修释放了。。。");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //侦听删除事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteImage:) name:@"DeleteTheImage" object:nil];
    
    
    [BXTGlobal shareGlobal].maxPics = 4;
    self.indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
    
    
    self.mulitSelectArray = [[NSMutableArray alloc] init];
    self.resultArray = [[NSMutableArray alloc] initWithObjects:@"未修好", @"已修好", nil];
    self.resultIDArray = [[NSMutableArray alloc] init];
    self.badCauseArray = [[NSMutableArray alloc] initWithObjects:@"待件维修", @"客户取消", @"无法维修", @"第三方维修", nil];
    self.badCauseIDArray = [[NSMutableArray alloc] init];
    self.selectedRow = -1;
    
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"维修结果", @"维修位置", @"故障类型", @"", @"", @"结束时间", nil];
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"请选择", @"请选择", @"请选择", @"请选择", @"", @"请选择", nil];
    
    [self navigationSetting:@"维修报告" andRightTitle:nil andRightImage:nil];
    
    [self createUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)deleteImage:(NSNotification *)notification
{
    NSNumber *number = notification.object;
    [self handleData:[number integerValue]];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createUI
{
    CGFloat bgViewH = 60;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - bgViewH)];
    self.currentTableView = [[UITableView alloc] initWithFrame:backView.bounds style:UITableViewStyleGrouped];
    self.currentTableView.delegate = self;
    self.currentTableView.dataSource = self;
    [backView addSubview:self.currentTableView];
    [self.view addSubview:backView];
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - bgViewH, SCREEN_WIDTH, bgViewH)];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerView];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake((SCREEN_WIDTH-200)/2, 10, 200, bgViewH-20);
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [doneBtn setBackgroundColor:colorWithHexString(@"3cafff")];
    doneBtn.layer.masksToBounds = YES;
    doneBtn.layer.cornerRadius = 4.f;
    @weakify(self);
    [[doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self sureBtnClick];
        
        NSLog(@"---------------\n %@", self.dataArray);
    }];
    [footerView addSubview:doneBtn];
}

- (void)sureBtnClick
{
    
}

- (void)createTableViewWithIndex:(NSInteger)index AndTitle:(NSString *)titleStr
{
    if (index == 0) {
        self.selectArray = self.resultArray;
    }
    else if (index == 1) {
        self.selectArray = self.badCauseArray;
    }
    
    bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    bgView.tag = 102;
    [self.view addSubview:bgView];
    
    bgView.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        bgView.alpha = 1;
    }];
    
    
    CGFloat tableViewH = self.selectArray.count * 50 + 60;
    
    // headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-tableViewH-50, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:headerView];
    
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, SCREEN_WIDTH-100, 30)];
    titleLabel.text = titleStr;
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [headerView addSubview:line];
    
    // selectTableView
    self.selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - tableViewH, SCREEN_WIDTH, tableViewH) style:UITableViewStylePlain];
    self.selectTableView.delegate = self;
    self.selectTableView.dataSource = self;
    self.selectTableView.scrollEnabled = NO;
    [bgView addSubview:self.selectTableView];
    
    
    // toolView
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    toolView.backgroundColor = colorWithHexString(@"#EEF3F6");
    self.selectTableView.tableFooterView = toolView;
    
    // cancel
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH/2-0.5, 50)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        [UIView animateWithDuration:0.25 animations:^{
            bgView.alpha = 0.0;
        } completion:^(BOOL finished) {
            // 清除
            [self.mulitSelectArray removeAllObjects];
            [_selectTableView removeFromSuperview];
            _selectTableView = nil;
            [bgView removeFromSuperview];
        }];
        
    }];
    [toolView addSubview:cancelBtn];
    
    // line
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-0.5, 10, 1, 50)];
    line2.backgroundColor = colorWithHexString(@"#d9d9d9");
    [toolView addSubview:line2];
    
    // sure
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+0.5, 10, SCREEN_WIDTH/2-0.5, 50)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:colorWithHexString(@"#77BBF8") forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor whiteColor];
    [[sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        if (index == 0) {
            self.isShowCause = self.selectedRow == 0 ? YES : NO;
            if (self.selectedRow == 0) {
                if ( ![self.titleArray[1] isEqualToString:@"未修好原因"]) {
                    [self.titleArray insertObject:@"未修好原因" atIndex:1];
                    [self.dataArray insertObject:@"请选择" atIndex:1];
                }
            } else {
                if ([self.titleArray[1] isEqualToString:@"未修好原因"]) {
                    [self.titleArray removeObjectAtIndex:1];
                    [self.dataArray removeObjectAtIndex:1];
                }
            }
            
            [self.dataArray replaceObjectAtIndex:0 withObject:self.resultArray[self.selectedRow]];
        }
        else if (index == 1) {
            [self.dataArray replaceObjectAtIndex:1 withObject:self.badCauseArray[self.selectedRow]];
        }
        NSLog(@"---------------------- %ld", (long)self.selectedRow);
        
        [self.currentTableView reloadData];
        
        [UIView animateWithDuration:0.25 animations:^{
            bgView.alpha = 0.0;
        } completion:^(BOOL finished) {
            // 清除
            [self.mulitSelectArray removeAllObjects];
            [_selectTableView removeFromSuperview];
            _selectTableView = nil;
            [bgView removeFromSuperview];
        }];
    }];
    [toolView addSubview:sureBtn];
}

- (void)createDatePicker
{
    // bgView
    bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    bgView.tag = 101;
    [self.view addSubview:bgView];
    
    bgView.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        bgView.alpha = 1;
    }];
    
    // headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-50-50, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:headerView];
    
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, SCREEN_WIDTH-100, 30)];
    titleLabel.text = @"选择预约时间";
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [headerView addSubview:line];
    
    
    // datePicker
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216-50, SCREEN_WIDTH, 216)];
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    self.datePicker.backgroundColor = colorWithHexString(@"ffffff");
    //    self.datePicker.minimumDate = [NSDate date];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [[self.datePicker rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        // 显示时间
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *timeStr = [formatter stringFromDate:self.datePicker.date];
        NSLog(@"timeStr-------%@", timeStr);
        [self.dataArray replaceObjectAtIndex:5+self.isShowCause withObject:timeStr];
        [self.currentTableView reloadData];
        
    }];
    [bgView addSubview:self.datePicker];
    
    
    // toolView
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    toolView.backgroundColor = colorWithHexString(@"#EEF3F6");
    [bgView addSubview:toolView];
    
    // cancel
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH/2-0.5, 50)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        [UIView animateWithDuration:0.25 animations:^{
            bgView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.datePicker = nil;
            [bgView removeFromSuperview];
        }];
        
    }];
    [toolView addSubview:cancelBtn];
    
    // line
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-0.5, 10, 1, 50)];
    line2.backgroundColor = colorWithHexString(@"#d9d9d9");
    [toolView addSubview:line2];
    
    // sure
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+0.5, 10, SCREEN_WIDTH/2-0.5, 50)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:colorWithHexString(@"#77BBF8") forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor whiteColor];
    [[sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        [UIView animateWithDuration:0.25 animations:^{
            bgView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.datePicker = nil;
            [bgView removeFromSuperview];
        }];
        
    }];
    [toolView addSubview:sureBtn];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 + self.isShowCause) {
        return 140;
    }
    if (indexPath.section == 4 + self.isShowCause)
    {
        return 130;
    }
    return 50.f;
}

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
    
    
    if (indexPath.section == 3 + self.isShowCause)
    {
        BXTMTWriteReportCell *cell = [BXTMTWriteReportCell cellWithTableViewCell:tableView];
        
        cell.textView.text = @"请填写维修记录";
        cell.textView.delegate = self;
        
        return cell;
    }
    else if (indexPath.section == 4 + self.isShowCause)
    {
        BXTMTAddImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemarkCell"];
        if (!cell)
        {
            cell = [[BXTMTAddImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RemarkCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLabel.text = @"维修后照片";
        
        @weakify(self);
        UITapGestureRecognizer *tapGROne = [[UITapGestureRecognizer alloc] init];
        [[tapGROne rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self loadMWPhotoBrowser:cell.imgViewOne.tag];
        }];
        [cell.imgViewOne addGestureRecognizer:tapGROne];
        UITapGestureRecognizer *tapGRTwo = [[UITapGestureRecognizer alloc] init];
        [[tapGRTwo rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self loadMWPhotoBrowser:cell.imgViewTwo.tag];
        }];
        [cell.imgViewTwo addGestureRecognizer:tapGRTwo];
        UITapGestureRecognizer *tapGRThree = [[UITapGestureRecognizer alloc] init];
        [[tapGRThree rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self loadMWPhotoBrowser:cell.imgViewThree.tag];
        }];
        [cell.imgViewThree addGestureRecognizer:tapGRThree];
        
        [cell.addBtn addTarget:self action:@selector(addImages) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    
    BXTMTReportsCell *cell = [BXTMTReportsCell cellWithTableViewCell:tableView];
    
    cell.titleView.text = self.titleArray[indexPath.section];
    cell.detailView.text = self.dataArray[indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectTableView) {
        NSString *selectRow  = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        // 选择row 传值
        self.selectedRow = indexPath.row;
        
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
        
        [tableView reloadData];
        return;
    }
    
    
    if (self.isShowCause && indexPath.section == 1) {
        [self createTableViewWithIndex:indexPath.section AndTitle:@"未修好原因"];
    }
    
    
    if (indexPath.section == 0) {
        [self createTableViewWithIndex:indexPath.section AndTitle:@"选择维修结果"];
    }
    else if (indexPath.section == 1 + self.isShowCause) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
        BXTSearchPlaceViewController *searchVC = (BXTSearchPlaceViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTSearchPlaceViewController"];
        @weakify(self);
        [searchVC userChoosePlaceInfo:^(BXTPlace *placeInfo) {
            @strongify(self);
            
            MJExtensionLog(@"placeInfo:%@", placeInfo.place);
            [self.dataArray replaceObjectAtIndex:indexPath.section withObject:placeInfo.place];
            [self.currentTableView reloadData];
        }];
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    else if (indexPath.section == 5 + self.isShowCause) {
        [self createDatePicker];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请填写维修记录"])
    {
        textView.text = @"";
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.dataArray replaceObjectAtIndex:3+self.isShowCause withObject:textView.text];
    
    if (textView.text.length < 1)
    {
        textView.text = @"请填写维修记录";
    }
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        [UIView animateWithDuration:0.25 animations:^{
            bgView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (_datePicker)
            {
                [_datePicker removeFromSuperview];
                _datePicker = nil;
            }
            [view removeFromSuperview];
        }];
        
    }
    else if (view.tag == 102)
    {
        [UIView animateWithDuration:0.25 animations:^{
            bgView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (_selectTableView) {
                [self.mulitSelectArray removeAllObjects];
                [_selectTableView removeFromSuperview];
                _selectTableView = nil;
            }
            [view removeFromSuperview];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
