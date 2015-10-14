//
//  BXTLoginViewController.m
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTLoginViewController.h"
#import "BXTHeaderFile.h"
#import "BXTRepairHomeViewController.h"
#import "BXTShopsHomeViewController.h"
#import "BXTHeadquartersViewController.h"
#import "UIViewController+DismissKeyboard.h"
#import "BXTDataRequest.h"
#import "BXTResignViewController.h"
#import "AppDelegate.h"

#define UserNameTag 11
#define PassWordTag 12

@interface BXTLoginViewController ()<UITextFieldDelegate,BXTDataResponseDelegate>
{
    UITextField *userNameTF;
    UITextField *passWordTF;
}
@end

@implementation BXTLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backGround];
    [self initContentViews];
    [self setupForDismissKeyboard];
}

#pragma mark -
#pragma mark 初始化视图
- (void)backGround
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"Background-iphone5"];
    [self.view addSubview:imageView];
}

- (void)initContentViews
{
    UIView *textfiledBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 207.f, SCREEN_WIDTH, 118.f)];
    textfiledBackView.backgroundColor = colorWithHexString(@"d2e6ff");
    [self.view addSubview:textfiledBackView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15.f, 0, SCREEN_WIDTH - 30.f, 1.f)];
    lineView.center = CGPointMake(lineView.center.x, textfiledBackView.bounds.size.height/2.f);
    lineView.backgroundColor = colorWithHexString(@"294550");
    [textfiledBackView addSubview:lineView];
    
    UILabel *login_label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0, 60.f, 20.f)];
    login_label.center = CGPointMake(login_label.center.x, textfiledBackView.bounds.size.height/4.f);
    login_label.textColor = colorWithHexString(@"000000");
    login_label.font = [UIFont boldSystemFontOfSize:16.f];
    login_label.text = @"登录名";
    [textfiledBackView addSubview:login_label];
    
    userNameTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(login_label.frame) + 15.f, 0.f, SCREEN_WIDTH - 30.f - 60.f, 44.f)];
    userNameTF.center = CGPointMake(userNameTF.center.x, textfiledBackView.bounds.size.height/4.f);
    userNameTF.keyboardType = UIKeyboardTypeNumberPad;
    userNameTF.placeholder = @"输入手机号";
    userNameTF.text = [BXTGlobal getUserProperty:U_USERNAME];
    [userNameTF setValue:colorWithHexString(@"4e74a5") forKeyPath:@"_placeholderLabel.textColor"];
    userNameTF.delegate = self;
    userNameTF.tag = UserNameTag;
    [textfiledBackView addSubview:userNameTF];
    
    UILabel *passWord_label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0, 60.f, 20.f)];
    passWord_label.center = CGPointMake(login_label.center.x, (textfiledBackView.bounds.size.height/4.f)*3.f);
    passWord_label.textColor = colorWithHexString(@"000000");
    passWord_label.font = [UIFont boldSystemFontOfSize:16.f];
    passWord_label.text = @"密码";
    [textfiledBackView addSubview:passWord_label];

    passWordTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passWord_label.frame) + 15.f, CGRectGetMaxY(userNameTF.frame) + 15.f, SCREEN_WIDTH - 30.f - 60.f, 44.f)];
    passWordTF.center = CGPointMake(passWordTF.center.x, (textfiledBackView.bounds.size.height/4.f)*3.f);
    passWordTF.keyboardType = UIKeyboardTypeASCIICapable;
    passWordTF.placeholder = @"输入密码";
    passWordTF.text = [BXTGlobal getUserProperty:U_PASSWORD];
    [passWordTF setValue:colorWithHexString(@"4e74a5") forKeyPath:@"_placeholderLabel.textColor"];
    passWordTF.delegate = self;
    passWordTF.tag = PassWordTag;
    [textfiledBackView addSubview:passWordTF];

    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginBtn.frame = CGRectMake(CGRectGetMinX(textfiledBackView.frame) + 20.f, CGRectGetMaxY(textfiledBackView.frame) + 36.f, CGRectGetWidth(textfiledBackView.frame) - 40.f, 44.f);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:colorWithHexString(@"fdbd2c")];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 6.f;
    [loginBtn addTarget:self action:@selector(loginHightLight:) forControlEvents:UIControlEventTouchDown];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn addTarget:self action:@selector(loginOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:loginBtn];
    
    UIButton *resignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resignBtn setFrame:CGRectMake(CGRectGetMinX(loginBtn.frame), CGRectGetMaxY(loginBtn.frame), 50, 40.f)];
    [resignBtn setTitle:@"注册" forState:UIControlStateNormal];
    [resignBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
    [resignBtn addTarget:self action:@selector(resignUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resignBtn];

    UIButton *findPassWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [findPassWordBtn setFrame:CGRectMake(CGRectGetMaxX(loginBtn.frame) - 90, CGRectGetMaxY(loginBtn.frame), 90, 40.f)];
    [findPassWordBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [findPassWordBtn setTitleColor:colorWithHexString(@"4e74a5") forState:UIControlStateNormal];
    [findPassWordBtn addTarget:self action:@selector(findPassWord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findPassWordBtn];
}

#pragma mark -
#pragma mark 事件处理
- (void)resignUser
{
    BXTResignViewController *resignVC = [[BXTResignViewController alloc] init];
    [self.navigationController pushViewController:resignVC animated:YES];
}

- (void)loginHightLight:(UIButton *)btn
{
    [btn setBackgroundColor:colorWithHexString(@"b59844")];
}

- (void)login:(UIButton *)btn
{
    [userNameTF resignFirstResponder];
    [passWordTF resignFirstResponder];
    [btn setBackgroundColor:colorWithHexString(@"fdbd2c")];
    if ([BXTGlobal validateMobile:userNameTF.text])
    {
        [self showLoadingMBP:@"正在登录..."];

        [BXTGlobal setUserProperty:userNameTF.text withKey:U_USERNAME];
        [BXTGlobal setUserProperty:passWordTF.text withKey:U_PASSWORD];
        
        NSDictionary *userInfoDic = @{@"password":passWordTF.text,@"username":userNameTF.text};
        
        BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
        [dataRequest loginUser:userInfoDic];
    }
    else
    {
        [self showMBP:@"手机号格式不对"];
    }
}

- (void)loginOutside:(UIButton *)btn
{
    [btn setBackgroundColor:colorWithHexString(@"fdbd2c")];
}

- (void)findPassWord
{
    
}

#pragma mark -
#pragma mark 代理
/**
 *  UITextFiledDelegate
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == UserNameTag)
    {
        NSString * resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (resultString.length > 11)
        {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/**
 *  BXTDataResponseDelegate
 */
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSLog(@"%@", response);
    NSDictionary *dic = response;
    if (type == LoginType && [[dic objectForKey:@"returncode"] isEqualToString:@"0"])
    {
        NSArray *dataArray = [dic objectForKey:@"data"];
        NSDictionary *userInfoDic = [dataArray objectAtIndex:0];
        
        [BXTGlobal setUserProperty:[userInfoDic objectForKey:@"gender"] withKey:U_SEX];
        [BXTGlobal setUserProperty:[userInfoDic objectForKey:@"name"] withKey:U_NAME];
        [BXTGlobal setUserProperty:[userInfoDic objectForKey:@"pic"] withKey:U_HEADERIMAGE];

        NSArray *shopids = [userInfoDic objectForKey:@"shop_ids"];
        [BXTGlobal setUserProperty:shopids withKey:U_SHOPIDS];
        
        NSString *userID = [NSString stringWithFormat:@"%@",[userInfoDic objectForKey:@"id"]];
        [BXTGlobal setUserProperty:userID withKey:U_USERID];
        
        /**分店登录**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request branchLogin];
    }
    else if (type == BranchLogin && [[dic objectForKey:@"returncode"] isEqualToString:@"0"])
    {
        NSArray *data = [dic objectForKey:@"data"];
        if (data.count > 0)
        {
            NSDictionary *userInfo = data[0];
            
            NSArray *bindingAds = [userInfo objectForKey:@"binding_ads"];
            [BXTGlobal setUserProperty:bindingAds withKey:U_BINDINGADS];
            
            BXTDepartmentInfo *departmentInfo = [[BXTDepartmentInfo alloc] init];
            departmentInfo.dep_id = [userInfo objectForKey:@"department"];
            departmentInfo.department = [userInfo objectForKey:@"department_name"];
            [BXTGlobal setUserProperty:departmentInfo withKey:U_DEPARTMENT];
            
            BXTGroupingInfo *groupInfo = [[BXTGroupingInfo alloc] init];
            groupInfo.group_id = [userInfo objectForKey:@"subgroup"];
            groupInfo.subgroup = [userInfo objectForKey:@"subgroup_name"];
            [BXTGlobal setUserProperty:groupInfo withKey:U_GROUPINGINFO];
            
            NSString *userID = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
            [BXTGlobal setUserProperty:userID withKey:U_BRANCHUSERID];
            
            BXTPostionInfo *roleInfo = [[BXTPostionInfo alloc] init];
            roleInfo.role_id = [userInfo objectForKey:@"role_id"];
            roleInfo.role = [userInfo objectForKey:@"role"];
            [BXTGlobal setUserProperty:roleInfo withKey:U_POSITION];
            
            BXTShopInfo *shopInfo = [[BXTShopInfo alloc] init];
            shopInfo.stores_id = [userInfo objectForKey:@"stores_id"];
            shopInfo.stores_name = [userInfo objectForKey:@"stores"];
            [BXTGlobal setUserProperty:shopInfo withKey:U_SHOP];
            
            [BXTGlobal setUserProperty:[userInfo objectForKey:@"username"] withKey:U_USERNAME];
            [BXTGlobal setUserProperty:[userInfo objectForKey:@"role_con"] withKey:U_ROLEARRAY];
            [BXTGlobal setUserProperty:[userInfo objectForKey:@"mobile"] withKey:U_MOBILE];
            
            UINavigationController *nav;
            if ([[userInfo objectForKey:@"is_repair"] integerValue] == 1)
            {
                BXTShopsHomeViewController *homeVC = [[BXTShopsHomeViewController alloc] initWithIsRepair:NO];
                nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
            }
            else if ([[userInfo objectForKey:@"is_repair"] integerValue] == 2)
            {
                BXTRepairHomeViewController *homeVC = [[BXTRepairHomeViewController alloc] initWithIsRepair:YES];
                nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
            }
            nav.navigationBar.hidden = YES;
            [AppDelegate appdelegete].window.rootViewController = nav;
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
