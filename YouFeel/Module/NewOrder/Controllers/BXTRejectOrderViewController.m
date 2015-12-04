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
{
    NSString    *notes;
}

@property (nonatomic ,strong) NSString *currentOrderID;

@end

@implementation BXTRejectOrderViewController

- (instancetype)initWithOrderID:(NSString *)orderID
{
    self = [super init];
    if (self)
    {
        self.currentOrderID = orderID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"拒接原因" andRightTitle:nil andRightImage:nil];
    [self createSubviews];
    notes = @"";
}

- (void)createSubviews
{
    UITextView *cause = [[UITextView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT + 20.f, SCREEN_WIDTH, 170.f)];
    cause.font = [UIFont boldSystemFontOfSize:16.];
    cause.textColor = colorWithHexString(@"909497");
    cause.text = @"请输入您不接单的原因（500字以内）";
    cause.delegate = self;
    [self.view addSubview:cause];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(20, CGRectGetMaxY(cause.frame) + 40.f, SCREEN_WIDTH - 40, 50.f);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [commitBtn setBackgroundColor:colorWithHexString(@"3cafff")];
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 6.f;
    [commitBtn addTarget:self action:@selector(commitEvaluation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
}

- (void)commitEvaluation
{
    if (notes.length)
    {
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request rejectOrder:_currentOrderID withNotes:notes];
    }
    else
    {
        [self showMBP:@"拒接原因不能为空" withBlock:nil];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入您不接单的原因（500字以内）"])
    {
        textView.text = @"";
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length < 1)
    {
        textView.text = @"请输入您不接单的原因（500字以内）";
    }
    notes = textView.text;
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    if ([[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        
        [self showMBP:@"已拒接" withBlock:^(BOOL hidden) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            --[BXTGlobal shareGlobal].assignNumber;
        }];
    }
}

- (void)requestError:(NSError *)error
{
    
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
