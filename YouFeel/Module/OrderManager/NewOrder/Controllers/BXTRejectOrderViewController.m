//
//  BXTRejectOrderViewController.m
//  YouFeel
//
//  Created by Jason on 15/12/3.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTRejectOrderViewController.h"
#import "BXTHeaderForVC.h"

@interface BXTRejectOrderViewController ()<UITextViewDelegate,BXTDataResponseDelegate>

@property (nonatomic, strong) NSString *notes;
@property (nonatomic ,strong) NSString *currentOrderID;

@end

@implementation BXTRejectOrderViewController

- (instancetype)initWithOrderID:(NSString *)orderID viewControllerType:(ViewControllType)type
{
    self = [super init];
    if (self)
    {
        self.vcType = type;
        self.currentOrderID = orderID;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.affairID)
    {
        self.affairID = @"";
    }
    
    if (_vcType == ExamineVCType)
    {
       [self navigationSetting:@"审批说明" andRightTitle:nil andRightImage:nil];
    }
    else if (_vcType == AssignVCType)
    {
        [self navigationSetting:@"拒接原因" andRightTitle:nil andRightImage:nil];
    }
    else if (_vcType == RejectType)
    {
        [self navigationSetting:@"驳回维修结果" andRightTitle:nil andRightImage:nil];
    }
    
    [self createSubviews];
    self.notes = @"";
}

- (void)createSubviews
{
    UITextView *cause = [[UITextView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT + 20.f, SCREEN_WIDTH, 170.f)];
    cause.font = [UIFont systemFontOfSize:16.];
    cause.textColor = colorWithHexString(@"909497");
    if (_vcType == ExamineVCType)
    {
        cause.text = @"请输入您关闭工单的原因（500字以内）";
    }
    else if (_vcType == AssignVCType)
    {
        cause.text = @"请输入您不接单的原因（500字以内）";
    }
    else if (_vcType == RejectType)
    {
        cause.text = @"请输入您驳回的原因（500字以内）";
    }
    
    cause.delegate = self;
    [self.view addSubview:cause];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(20, CGRectGetMaxY(cause.frame) + 40.f, SCREEN_WIDTH - 40, 50.f);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [commitBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [commitBtn setBackgroundColor:colorWithHexString(@"3cafff")];
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 4.f;
    @weakify(self);
    [[commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
        
        if (self.notes.length)
        {
            [self showLoadingMBP:@"请稍候..."];
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            if (self.vcType == ExamineVCType)
            {
                [request closeOrder:self.currentOrderID withNotes:self.notes];
            }
            else if (self.vcType == AssignVCType)
            {
                [request rejectOrder:self.currentOrderID withNotes:self.notes];
            }
            else if (self.vcType == RejectType)
            {
                [request isFixed:self.currentOrderID confirmState:@"2" confirmNotes:self.notes affairsID:self.affairID];
            }
        }
        else
        {
            if (self.vcType == ExamineVCType)
            {
                [self showMBP:@"关闭工单原因不能为空" withBlock:nil];
            }
            else if (self.vcType == AssignVCType)
            {
                [self showMBP:@"拒接原因不能为空"  withBlock:nil];
            }
            else if (self.vcType == RejectType)
            {
                [self showMBP:@"驳回原因不能为空" withBlock:nil];
            }
        }
    }];
    [self.view addSubview:commitBtn];
}

#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.vcType == ExamineVCType)
    {
        if ([textView.text isEqualToString:@"请输入您关闭工单的原因（500字以内）"])
        {
            textView.text = @"";
        }
    }
    else if (self.vcType == AssignVCType)
    {
        if ([textView.text isEqualToString:@"请输入您不接单的原因（500字以内）"])
        {
            textView.text = @"";
        }
    }
    else if (self.vcType == RejectType)
    {
        if ([textView.text isEqualToString:@"请输入您驳回的原因（500字以内）"])
        {
            textView.text = @"";
        }
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.vcType == ExamineVCType)
    {
        if (textView.text.length < 1)
        {
            textView.text = @"请输入您关闭工单的原因（500字以内）";
        }
    }
    else if (self.vcType == AssignVCType)
    {
        if (textView.text.length < 1)
        {
            textView.text = @"请输入您不接单的原因（500字以内）";
        }
    }
    else if (self.vcType == RejectType)
    {
        if (textView.text.length < 1)
        {
            textView.text = @"请输入您驳回的原因（500字以内）";
        }
    }
    
    _notes = textView.text;
}

#pragma mark -
#pragma mark BXTDataRequestDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    if ([[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        if (self.vcType == ExamineVCType)
        {
            [self showMBP:@"已关闭" withBlock:^(BOOL hidden) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
        else if (self.vcType == AssignVCType)
        {
            [self showMBP:@"已拒接" withBlock:^(BOOL hidden) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                --[BXTGlobal shareGlobal].assignNumber;
                [[BXTGlobal shareGlobal].assignOrderIDs removeObject:self.currentOrderID];
            }];
        }
        else if (self.vcType == RejectType)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestDetail" object:nil];
            [self showMBP:@"已驳回" withBlock:^(BOOL hidden) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
