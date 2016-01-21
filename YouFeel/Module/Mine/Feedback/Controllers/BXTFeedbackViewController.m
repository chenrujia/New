//
//  BXTFeedbackViewController.m
//  YouFeel
//
//  Created by Jason on 15/10/24.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTFeedbackViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTDataRequest.h"

@interface BXTFeedbackViewController ()<UITextViewDelegate,BXTDataResponseDelegate>

@property (nonatomic, strong) NSString *feedbackStr;

@end

@implementation BXTFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.feedbackStr = @"请输入您的反馈意见（500字以内）";
    [self navigationSetting:@"意见反馈" andRightTitle:nil andRightImage:nil];
    [self loadingViews];
}

- (void)loadingViews
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, KNAVIVIEWHEIGHT + 10.f, SCREEN_WIDTH - 20.f, 40.f)];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.textColor = colorWithHexString(@"34afff");
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.text = @"欢迎您提出宝贵的意见和建议，您留下的每个字都将用来改善我们的软件。";
    [self.view addSubview:titleLabel];
    
    UITextView *feedbackTV = [[UITextView alloc] initWithFrame:CGRectMake(10.f, CGRectGetMaxY(titleLabel.frame) + 10.f, SCREEN_WIDTH - 20.f, 170.f)];
    feedbackTV.delegate = self;
    feedbackTV.backgroundColor = [UIColor whiteColor];
    feedbackTV.textColor = colorWithHexString(@"909497");
    feedbackTV.text = @"请输入您的反馈意见（500字以内）";
    feedbackTV.font = [UIFont systemFontOfSize:17.f];
    [self.view addSubview:feedbackTV];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(20, CGRectGetMaxY(feedbackTV.frame) + 40.f, SCREEN_WIDTH - 40, 50.f);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [commitBtn setBackgroundColor:colorWithHexString(@"3cafff")];
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 4.f;
    @weakify(self);
    [[commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if ([self.feedbackStr isEqualToString:@"请输入您的反馈意见（500字以内）"])
        {
            [self showMBP:@"请输入您宝贵的意见" withBlock:nil];
        }
        else
        {
            [self showLoadingMBP:@"提交中..."];
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request feedback:self.feedbackStr];
        }
    }];
    [self.view addSubview:commitBtn];
}

#pragma mark -
#pragma mark 代理
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入您的反馈意见（500字以内）"])
    {
        textView.text = @"";
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length < 1)
    {
        textView.text = @"请输入您的反馈意见（500字以内）";
    }
    self.feedbackStr = textView.text;
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    if ([[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        [self showMBP:@"感谢您宝贵的意见！" withBlock:^(BOOL hidden) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
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
