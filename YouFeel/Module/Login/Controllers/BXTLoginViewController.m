//
//  BXTLoginViewController.m
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTLoginViewController.h"
#import "BXTHeaderFile.h"
#import "BXTHeadquartersViewController.h"
#import "UIViewController+DismissKeyboard.h"
#import "BXTDataRequest.h"
#import "BXTResignViewController.h"
#import "BXTHeadquartersInfo.h"
#import "BXTFindPassWordViewController.h"

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
    self.view.backgroundColor = colorWithHexString(@"ffffff");
    [self backGround];
    [self initContentViews];
    [self setupForDismissKeyboard];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -
#pragma mark 初始化视图
- (void)backGround
{
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80.f, 182.5, 63.3)];
    logoImgView.center = CGPointMake(SCREEN_WIDTH/2.f, logoImgView.center.y);
    logoImgView.image = [UIImage imageNamed:@"logo"];
    
    [self.view addSubview:logoImgView];
}

- (void)initContentViews
{
    CGFloat y = IS_IPHONE4 ? 175.f : 207.f;
    UIView *textfiledBackView = [[UIView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 118.f)];
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
    passWordTF.secureTextEntry = YES;
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
    [loginBtn setBackgroundColor:colorWithHexString(@"3cafff")];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 6.f;
    [loginBtn addTarget:self action:@selector(loginHightLight:) forControlEvents:UIControlEventTouchDown];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn addTarget:self action:@selector(loginOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:loginBtn];

    UIButton *findPassWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [findPassWordBtn setFrame:CGRectMake(CGRectGetMaxX(loginBtn.frame) - 90, CGRectGetMaxY(loginBtn.frame), 90, 40.f)];
    [findPassWordBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [findPassWordBtn setTitleColor:colorWithHexString(@"4e74a5") forState:UIControlStateNormal];
    [findPassWordBtn addTarget:self action:@selector(findPassWord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findPassWordBtn];
    
    UIButton *resignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resignBtn setFrame:CGRectMake(0, SCREEN_HEIGHT - (IS_IPHONE6P ? 50.2f : 33.5f) - (IS_IPHONE6P ? 30 : 20), (IS_IPHONE6P ? 175.f : 116.5f), (IS_IPHONE6P ? 50.2f : 33.5f))];
    [resignBtn setCenter:CGPointMake(SCREEN_WIDTH/2.f, resignBtn.center.y)];
    [resignBtn setImage:[UIImage imageNamed:@"Registered"] forState:UIControlStateNormal];
    [resignBtn addTarget:self action:@selector(resignUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resignBtn];
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
    [btn setBackgroundColor:colorWithHexString(@"4d81e5")];
}

- (void)login:(UIButton *)btn
{
    [userNameTF resignFirstResponder];
    [passWordTF resignFirstResponder];
    [btn setBackgroundColor:colorWithHexString(@"3cafff")];
    
    if ([BXTGlobal validateMobile:userNameTF.text])
    {
        [self showLoadingMBP:@"正在登录..."];

        [BXTGlobal setUserProperty:userNameTF.text withKey:U_USERNAME];
        [BXTGlobal setUserProperty:passWordTF.text withKey:U_PASSWORD];
        
        NSDictionary *userInfoDic = @{@"password":passWordTF.text,@"username":userNameTF.text,@"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"]};
        
        BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
        [dataRequest loginUser:userInfoDic];
    }
    else
    {
        [self showMBP:@"手机号格式不对" withBlock:nil];
    }
}

- (void)loginOutside:(UIButton *)btn
{
    [btn setBackgroundColor:colorWithHexString(@"3cafff")];
}

- (void)findPassWord
{
    BXTFindPassWordViewController *findVC = [[BXTFindPassWordViewController alloc] init];
    [self.navigationController pushViewController:findVC animated:YES];
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
        [BXTGlobal setUserProperty:[userInfoDic objectForKey:@"im_token"] withKey:U_IMTOKEN];
        
        NSArray *shopids = [userInfoDic objectForKey:@"shop_ids"];
        [BXTGlobal setUserProperty:shopids withKey:U_SHOPIDS];
        
        NSString *userID = [NSString stringWithFormat:@"%@",[userInfoDic objectForKey:@"id"]];
        [BXTGlobal setUserProperty:userID withKey:U_USERID];
        
        NSArray *my_shop = [userInfoDic objectForKey:@"my_shop"];
        [BXTGlobal setUserProperty:my_shop withKey:U_MYSHOP];
   
        if (my_shop && my_shop.count > 0)
        {
            NSDictionary *shopsDic = my_shop[0];
            NSString *shopID = [shopsDic objectForKey:@"id"];
            NSString *shopName = [shopsDic objectForKey:@"shop_name"];
            BXTHeadquartersInfo *companyInfo = [[BXTHeadquartersInfo alloc] init];
            companyInfo.company_id = shopID;
            companyInfo.name = shopName;
            [BXTGlobal setUserProperty:companyInfo withKey:U_COMPANY];
            NSString *url = [NSString stringWithFormat:@"http://api.hellouf.com/?c=Port&m=actionGet_iPhone_v2_Port&shop_id=%@",shopID];
            [BXTGlobal shareGlobal].baseURL = url;
            
            BXTDataRequest *pic_request = [[BXTDataRequest alloc] initWithDelegate:self];
            [pic_request updateHeadPic:[userInfoDic objectForKey:@"pic"]];
            
            /**分店登录**/
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request branchLogin];
        }
        else
        {
            BXTHeadquartersViewController *authenticationVC = [[BXTHeadquartersViewController alloc] init];
            [self.navigationController pushViewController:authenticationVC animated:YES];
        }
    }
    else if (type == BranchLogin && [[dic objectForKey:@"returncode"] isEqualToString:@"0"])
    {
        NSArray *data = [dic objectForKey:@"data"];
        if (data.count > 0)
        {
            NSDictionary *userInfo = data[0];
            [[BXTGlobal shareGlobal] reLoginWithDic:userInfo];
        }
    }
    else if (type == UpdateHeadPic)
    {
        NSLog(@"Update success");
    }
    else
    {
        [self hideMBP];
        BXTHeadquartersViewController *headVC = [[BXTHeadquartersViewController alloc] initWithType:YES];
        [self.navigationController pushViewController:headVC animated:YES];
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
