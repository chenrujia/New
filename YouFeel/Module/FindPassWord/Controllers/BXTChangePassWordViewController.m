//
//  BXTChangePassWordViewController.m
//  YouFeel
//
//  Created by Jason on 15/10/30.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTChangePassWordViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTResignTableViewCell.h"
#import "BXTHeadquartersViewController.h"

#define Password 11
#define PasswordAgain 12

@interface BXTChangePassWordViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BXTDataResponseDelegate>
{
    NSString *pwStr;
    NSString *pwAgainStr;
    NSString *pw_ID;
    NSString *pw_Key;
}
@end

@implementation BXTChangePassWordViewController

- (instancetype)initWithID:(NSString *)fp_ID andWithKey:(NSString *)key
{
    self = [super init];
    if (self)
    {
        pw_ID = fp_ID;
        pw_Key = key;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"重置密码" andRightTitle:nil andRightImage:nil];
    [self initContentViews];
}

#pragma mark -
#pragma mark 初始化视图
- (void)initContentViews
{
    UITableView *currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    [currentTableView registerClass:[BXTResignTableViewCell class] forCellReuseIdentifier:@"Cell"];
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    [self.view addSubview:currentTableView];
}

#pragma mark -
#pragma mark 事件处理
- (void)nextTapClick
{
    if ([pwStr isEqual:pwAgainStr])
    {
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request changePassWord:pwStr andWithID:pw_ID andWithKey:pw_Key];
    }
    else
    {
        [self showMBP:@"两次输入不一致！" withBlock:nil];
    }
}

#pragma mark -
#pragma mark 代理
/**
 *  UITextFiledDelegate
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == Password)
    {
        pwStr = resultString;
        if (resultString.length > 11)
        {
            return NO;
        }
    }
    else if (textField.tag == PasswordAgain)
    {
        pwAgainStr = resultString;
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
    if (section == 1)
    {
        return 80.f;
    }
    return 5.f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.f)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *nextTapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextTapBtn.frame = CGRectMake(20, 30, SCREEN_WIDTH - 40, 50.f);
        [nextTapBtn setTitle:@"重设登录密码" forState:UIControlStateNormal];
        [nextTapBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [nextTapBtn setBackgroundColor:colorWithHexString(@"3cafff")];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTResignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.nameLabel.hidden = YES;
    cell.codeButton.hidden = YES;
    cell.textField.frame = CGRectMake(15.f, 3, SCREEN_WIDTH - 30.f, 44.f);
    cell.textField.secureTextEntry = YES;
    if (indexPath.section == 0)
    {
        cell.textField.placeholder = @"设置新密码（长度在6~32字符之间）";
        cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
        cell.textField.tag = Password;
    }
    else
    {
        cell.textField.placeholder = @"再次确认密码";
        cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
        cell.textField.tag = PasswordAgain;
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
    LogRed(@"dic....%@",dic);
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
            NSString *url = [NSString stringWithFormat:@"http://api.51bxt.com/?c=Port&m=actionGet_iPhone_v2_Port&shop_id=%@",shopID];
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
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [self showMBP:@"重设密码成功！" withBlock:^(BOOL hidden) {
                [BXTGlobal setUserProperty:pwStr withKey:U_PASSWORD];
                NSDictionary *userInfoDic = @{@"username":[BXTGlobal getUserProperty:U_USERNAME],@"password":pwStr,@"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"]};
                BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
                [dataRequest loginUser:userInfoDic];
            }];
        }
    }
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
