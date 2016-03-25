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

@interface BXTMTReportsViewController () <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,BXTDataResponseDelegate>
{
    UIView *bgView;
}

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

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
    
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"维修结果", @"维修位置", @"故障类型", @"", @"", @"结束时间", nil];
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"请选择", @"请选择", @"请选择", @"", @"", @"请选择", nil];
    
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
    }];
    [footerView addSubview:doneBtn];
}

- (void)sureBtnClick
{
    
}

- (void)createSelectedView
{
    bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    bgView.tag = 101;
    [self.view addSubview:bgView];
    
    
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;//section头部高度
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return 140;
    }
    if (indexPath.section == 4)
    {
        return 130;
    }
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3)
    {
        BXTMTWriteReportCell *cell = [BXTMTWriteReportCell cellWithTableViewCell:tableView];
        
        cell.textView.text = @"请填写维修记录";
        cell.textView.delegate = self;
        
        return cell;
    }
    else if (indexPath.section == 4)
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
    if (indexPath.section == 0) {
        [self createSelectedView];
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
//        if (_datePicker)
//        {
//            [_datePicker removeFromSuperview];
//            _datePicker = nil;
//        }
        [view removeFromSuperview];
    }
    else if (view.tag == 102)
    {
//        if (_selectTableView) {
//            [self.mulitSelectArray removeAllObjects];
//            [_selectTableView removeFromSuperview];
//            _selectTableView = nil;
//        }
        [view removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
