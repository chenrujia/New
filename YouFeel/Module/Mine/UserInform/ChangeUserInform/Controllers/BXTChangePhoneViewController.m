//
//  BXTChangePhoneViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/31.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTChangePhoneViewController.h"

@interface BXTChangePhoneViewController () <BXTDataResponseDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phoneView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@end

@implementation BXTChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"修改手机号" andRightTitle:@"   确定" andRightImage:nil];
    
    [self createUI];
}

- (void)navigationRightButton
{
    [self.view endEditing:YES];
    
    if (![BXTGlobal validateMobile:self.phoneTextField.text])
    {
        [self showMBP:@"请输入有效的手机号" withBlock:nil];
        return;
    }
    if ([BXTGlobal isBlankString:self.messageTextField.text])
    {
        [self showMBP:@"请输入正确的验证码" withBlock:nil];
        return;
    }
    
    NSLog(@"%@ ------- %@", self.phoneTextField.text, self.messageTextField.text);
}

- (void)createUI
{
    self.getCodeBtn.layer.borderColor = [colorWithHexString(@"#5DAEF9") CGColor];
    self.getCodeBtn.layer.borderWidth = 1;
    self.getCodeBtn.layer.cornerRadius = 5;
    
    @weakify(self);
    [[self.getCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if ([BXTGlobal validateMobile:self.phoneTextField.text]) {
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request mobileVerCode:self.phoneTextField.text];
            self.getCodeBtn.userInteractionEnabled = NO;
            [self.getCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        else {
            [self showMBP:@"请输入有效的手机号" withBlock:nil];
        }
    }];
}

#pragma mark -
#pragma mark BXTDataRequestDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    if ([[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        [self updateTime];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    
}

- (void)updateTime
{
    __block NSInteger count = 60;
    @weakify(self);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_time, dispatch_walltime(NULL, 3), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_time, ^{
        @strongify(self);
        count--;
        if (count <= 0)
        {
            dispatch_source_cancel(_time);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.getCodeBtn.userInteractionEnabled = YES;
                [self.getCodeBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
                [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重新获取 %ld",(long)count] forState:UIControlStateNormal];
            });
        }
    });
    dispatch_resume(_time);
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
