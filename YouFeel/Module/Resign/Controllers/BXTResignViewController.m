//
//  BXTResignViewController.m
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTResignViewController.h"
#import "BXTNickNameViewController.h"
#import "UIViewController+DismissKeyboard.h"
#import "BXTHeaderFile.h"
#import "BXTResignTableViewCell.h"
#import "BXTDataRequest.h"

static NSString *cellIndentify = @"cellIndentify";

#define UserNameTag 11
#define CodeTag 12
#define PassWordTag 13

@interface BXTResignViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate>
{
    NSString *userName;
    NSString *codeNumber;
    NSString *passWord;
    UIButton *codeBtn;
}
@end

@implementation BXTResignViewController

- (void)dealloc
{
    NSLog(@".....");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"注册" andRightTitle:nil andRightImage:nil];
    [self initContentViews];
    [self setupForDismissKeyboard];
    
}

#pragma mark -
#pragma mark 初始化视图
- (void)initContentViews
{
    UITableView *currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    [currentTableView registerClass:[BXTResignTableViewCell class] forCellReuseIdentifier:cellIndentify];
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    [self.view addSubview:currentTableView];
}

#pragma mark -
#pragma mark 事件处理
- (void)nextTapClick
{
    if ([BXTGlobal validateMobile:userName])
    {
        [BXTGlobal setUserProperty:userName withKey:U_USERNAME];
        [BXTGlobal setUserProperty:passWord withKey:U_PASSWORD];
        
        BXTNickNameViewController *nickNameVC = [[BXTNickNameViewController alloc] init];
        [self.navigationController pushViewController:nickNameVC animated:YES];
    }
    else
    {
        [self showMBP:@"手机号格式不对"];
    }
    
}

- (void)backBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)getVerCode
{
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request mobileVerCode:userName];
}

#pragma mark -
#pragma mark 代理
/**
 *  UITextFiledDelegate
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == UserNameTag)
    {
        userName = resultString;
        if (resultString.length > 11)
        {
            return NO;
        }
    }
    else if (textField.tag == CodeTag)
    {
        codeNumber = resultString;
    }
    else if (textField.tag == PassWordTag)
    {
        passWord = resultString;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/**
 *  UITableViewDelegate & UITableViewDatasource
 */
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 16.f;//section头部高度
    }
    return 10.f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (section == 0)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16.f)];
    }
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 100.f;
    }
    return 5.f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100.f)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *nextTapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextTapBtn.frame = CGRectMake(20, 50, SCREEN_WIDTH - 40, 50.f);
        [nextTapBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [nextTapBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [nextTapBtn setBackgroundColor:colorWithHexString(@"aac3e1")];
        nextTapBtn.layer.masksToBounds = YES;
        nextTapBtn.layer.cornerRadius = 6.f;
        [nextTapBtn addTarget:self action:@selector(nextTapClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:nextTapBtn];
        return view;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5.f)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTResignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 0)
    {
        cell.nameLabel.text = @"手机号";
        cell.textField.placeholder = @"请输入有效的手机号码";
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.tag = UserNameTag;
        cell.codeButton.hidden = YES;
    }
    else if (indexPath.section == 1)
    {
        cell.nameLabel.text = @"验证码";
        cell.textField.placeholder = @"请输入短信验证码";
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.codeButton.hidden = NO;
        [cell.codeButton addTarget:self action:@selector(getVerCode) forControlEvents:UIControlEventTouchUpInside];
        codeBtn = cell.codeButton;
        cell.textField.tag = CodeTag;
    }
    else
    {
        cell.nameLabel.text = @"密   码";
        cell.textField.placeholder = @"请输入登录密码，至少6位";
        cell.codeButton.hidden = YES;
        cell.textField.tag = PassWordTag;
    }
    
    cell.boyBtn.hidden = YES;
    cell.girlBtn.hidden = YES;
    cell.textField.delegate = self;
    
    return cell;
}

/**
 *  BXTDataRequestDelegate
 */
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    if ([[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        codeBtn.userInteractionEnabled = NO;
        [codeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self updateTime];
    }
}

- (void)updateTime
{
    __block NSInteger count = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_time, dispatch_walltime(NULL, 3), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_time, ^{
        count--;
        if (count <= 0)
        {
            dispatch_source_cancel(_time);
            dispatch_async(dispatch_get_main_queue(), ^{
                codeBtn.userInteractionEnabled = YES;
                [codeBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
                [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [codeBtn setTitle:[NSString stringWithFormat:@"重新获取 %ld",(long)count] forState:UIControlStateNormal];
            });
        }
    });
    dispatch_resume(_time);
}

- (void)requestError:(NSError *)error
{
    
}

- (void)didReceiveMemoryWarning
{
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
