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

@property (nonatomic, assign) BOOL     isAssign;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic ,strong) NSString *currentOrderID;

@end

@implementation BXTRejectOrderViewController

- (instancetype)initWithOrderID:(NSString *)orderID andIsAssign:(BOOL)assign
{
    self = [super init];
    if (self)
    {
        self.isAssign = assign;
        self.currentOrderID = orderID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:_isAssign ? @"审批说明" : @"拒接原因" andRightTitle:nil andRightImage:nil];
    [self createSubviews];
    self.notes = @"";
}

- (void)createSubviews
{
    UITextView *cause = [[UITextView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT + 20.f, SCREEN_WIDTH, 170.f)];
    cause.font = [UIFont boldSystemFontOfSize:16.];
    cause.textColor = colorWithHexString(@"909497");
    cause.text = _isAssign ? @"请输入您关闭工单的原因（500字以内）" : @"请输入您不接单的原因（500字以内）";
    cause.delegate = self;
    [self.view addSubview:cause];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(20, CGRectGetMaxY(cause.frame) + 40.f, SCREEN_WIDTH - 40, 50.f);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
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
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            if (self.isAssign)
            {
                [request closeOrder:self.currentOrderID withNotes:self.notes];
            }
            else
            {
                [request rejectOrder:self.currentOrderID withNotes:self.notes];
            }
        }
        else
        {
            [self showMBP:self.isAssign ? @"关闭工单原因不能为空" : @"拒接原因不能为空" withBlock:nil];
        }
    }];
    [self.view addSubview:commitBtn];
}

#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:_isAssign ? @"请输入您关闭工单的原因（500字以内）" : @"请输入您不接单的原因（500字以内）"])
    {
        textView.text = @"";
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length < 1)
    {
        textView.text = _isAssign ? @"请输入您关闭工单的原因（500字以内）" : @"请输入您不接单的原因（500字以内）";
    }
    _notes = textView.text;
}

#pragma mark -
#pragma mark BXTDataRequestDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    if ([[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        if (_isAssign)
        {
            [self showMBP:@"已关闭" withBlock:^(BOOL hidden) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
        else
        {
            [self showMBP:@"已拒接" withBlock:^(BOOL hidden) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                --[BXTGlobal shareGlobal].assignNumber;
            }];
        }
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
