//
//  BXTChangeNameViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/31.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTChangeNameViewController.h"

@interface BXTChangeNameViewController () <BXTDataResponseDelegate>

@property (strong, nonatomic) UITextField *textField;

@end

@implementation BXTChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"修改姓名" andRightTitle:@"   保存" andRightImage:nil];
    
    [self createUI];
}

- (void)navigationRightButton
{
    [self.view endEditing:YES];
    
    if (![BXTGlobal validateUserName:self.textField.text]) {
        [MYAlertAction showAlertWithTitle:@"温馨提示" msg:@"请填写真实姓名" chooseBlock:nil buttonsStatement:@"确定", nil];
        return;
    }
    
    /** 修改用户信息 **/
    BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
    [dataRequest modifyUserInformWithName:self.textField.text
                                   gender:@""
                                   mobile:@""];
}

- (void)createUI
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT+1, SCREEN_WIDTH, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 50)];
    self.textField.placeholder = @"请填写真实姓名";
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgView addSubview:self.textField];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    
    NSDictionary *dic = response;
    
    if (type == ModifyUserInform && [dic[@"returncode"] integerValue] == 0)
    {
        [BXTGlobal showText:@"修改成功" view:self.view completionBlock:^{
            [BXTGlobal setUserProperty:self.textField.text withKey:U_NAME];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeNameSuccess" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
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
