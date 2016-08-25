//
//  BXTChangePositionViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/8/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTChangePositionViewController.h"

@interface BXTChangePositionViewController ()

@property (strong, nonatomic) UITextField *textField;

@end

@implementation BXTChangePositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"修改姓名" andRightTitle:@"   保存" andRightImage:nil];
    
    [self createUI];
}

- (void)navigationRightButton
{
    [self.view endEditing:YES];
    
    if (self.textField.text.length <= 0 || self.textField.text.length > 15) {
        [MYAlertAction showAlertWithTitle:@"温馨提示" msg:@"请填写真实职位（限定0~15字）" chooseBlock:nil buttonsStatement:@"确定", nil];
        return;
    }
    
    if (self.transPosition) {
        self.transPosition(self.textField.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)createUI
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT+1, SCREEN_WIDTH, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 50)];
    self.textField.placeholder = @"请填写真实职位（限定0~15字）";
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgView addSubview:self.textField];
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
