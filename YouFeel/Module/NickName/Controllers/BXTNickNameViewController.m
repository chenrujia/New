//
//  BXTNickNameViewController.m
//  BXT
//
//  Created by Jason on 15/8/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTNickNameViewController.h"
#import "UIViewController+DismissKeyboard.h"
#import "BXTHomeViewController.h"
#import "BXTHeadquartersViewController.h"
#import "BXTHeaderFile.h"
#import "AppDelegate.h"
#import "BXTDataRequest.h"
#import "MBProgressHUD.h"
#import "BXTResignTableViewCell.h"

static NSString *cellIndentify = @"resignCellIndentify";

#define NickNameTag 11
#define SexTag 12

@interface BXTNickNameViewController ()<UITextFieldDelegate,MBProgressHUDDelegate,BXTDataResponseDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSString *nickName;
    NSString *sex;
}
@end

@implementation BXTNickNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    sex = @"1";
    [self navigationSetting:@"完善个人资料" andRightTitle:nil andRightImage:nil];
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
- (void)doneClick
{
    [self showLoadingMBP:@"注册中..."];
    [BXTGlobal setUserProperty:nickName withKey:U_NAME];
    [BXTGlobal setUserProperty:sex withKey:U_SEX];
    
    NSString *userName = [BXTGlobal getUserProperty:U_USERNAME];
    NSString *passWord = [BXTGlobal getUserProperty:U_PASSWORD];
    
    NSDictionary *userInfoDic = @{@"name":nickName,@"password":passWord,@"username":userName,@"gender":sex,@"mailmatch":@"123",@"roletype":@"1",@"cid":[BXTGlobal getUserProperty:U_CLIENTID]};
    
    BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
    [dataRequest resignUser:userInfoDic];
}

- (void)sexClick:(UIButton *)btn
{
    BXTResignTableViewCell *cell = (BXTResignTableViewCell *)btn.superview;
    if (btn.tag == 11)
    {
        sex = @"1";
        cell.boyBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
        cell.girlBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
    }
    else if (btn.tag == 12)
    {
        sex = @"2";
        cell.boyBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
        cell.girlBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    }
}

#pragma mark -
#pragma mark 代理
/**
 * UITextFiledDelegate
 */
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == NickNameTag)
    {
        nickName = textField.text;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/**
 * UITableViewDelegate & UITableViewDatasource
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
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(20, 50, SCREEN_WIDTH - 40, 50.f);
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [doneBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [doneBtn setBackgroundColor:colorWithHexString(@"aac3e1")];
        doneBtn.layer.masksToBounds = YES;
        doneBtn.layer.cornerRadius = 6.f;
        [doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:doneBtn];
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
        cell.textField.text = [BXTGlobal getUserProperty:U_USERNAME];
        cell.textField.userInteractionEnabled = NO;
        cell.boyBtn.hidden = YES;
        cell.girlBtn.hidden = YES;
    }
    else if (indexPath.section == 1)
    {
        cell.nameLabel.text = @"姓   名";
        cell.textField.placeholder = @"请填写您的真实姓名";
        cell.textField.tag = NickNameTag;
        cell.boyBtn.hidden = YES;
        cell.girlBtn.hidden = YES;
    }
    else
    {
        cell.nameLabel.text = @"性   别";
        cell.textField.hidden = YES;
        cell.textField.tag = SexTag;
        [cell.boyBtn addTarget:self action:@selector(sexClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.girlBtn addTarget:self action:@selector(sexClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.textField.delegate = self;
    cell.codeButton.hidden = YES;

    return cell;
}

/**
 * BXTDataResponseDelegate
 */
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    LogRed(@"%@", response);
    NSDictionary *dic = response;
    if ([[dic objectForKey:@"state"] integerValue] == 1)
    {
        NSString *userID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"finish_id"]];
        [BXTGlobal setUserProperty:userID withKey:U_USERID];
        
        BXTHeadquartersViewController *headVC = [[BXTHeadquartersViewController alloc] initWithType:NO];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:headVC];
        nav.navigationBar.hidden = YES;
        [AppDelegate appdelegete].window.rootViewController = nav;
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
