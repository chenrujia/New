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

@interface BXTNickNameViewController ()<MBProgressHUDDelegate,BXTDataResponseDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSString *nickName;
    NSString *sex;
    UITableView *currentTableView;
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
    currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    [currentTableView registerNib:[UINib nibWithNibName:@"BXTResignTableViewCell" bundle:nil] forCellReuseIdentifier:cellIndentify];
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    [self.view addSubview:currentTableView];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
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
        [doneBtn setBackgroundColor:colorWithHexString(@"3cafff")];
        doneBtn.layer.masksToBounds = YES;
        doneBtn.layer.cornerRadius = 4.f;
        [[doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self resignFirstResponder];
            if (![BXTGlobal validateUserName:nickName])
            {
                [self showMBP:@"请输入您的真实姓名" withBlock:nil];
                return;
            }
            
            [BXTGlobal setUserProperty:@[] withKey:U_MYSHOP];
            [self showLoadingMBP:@"注册中..."];
            [BXTGlobal setUserProperty:nickName withKey:U_NAME];
            [BXTGlobal setUserProperty:sex withKey:U_SEX];
            
            NSString *userName = [BXTGlobal getUserProperty:U_USERNAME];
            NSString *passWord = [BXTGlobal getUserProperty:U_PASSWORD];
            NSDictionary *userInfoDic = @{@"name":nickName,
                                          @"password":passWord,
                                          @"username":userName,
                                          @"gender":sex,
                                          @"mailmatch":@"123",
                                          @"roletype":@"1",
                                          @"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"]};
            
            BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
            [dataRequest resignUser:userInfoDic];
        }];
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
    BXTResignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0)
    {
        cell.nameLabel.text = @"手机号";
        cell.textField.text = [BXTGlobal getUserProperty:U_USERNAME];
        cell.textField.userInteractionEnabled = NO;
        cell.boyBtn.hidden = YES;
        cell.girlBtn.hidden = YES;
        cell.textField.hidden = NO;
    }
    else if (indexPath.section == 1)
    {
        cell.nameLabel.text = @"姓   名";
        cell.textField.placeholder = @"请填写您的真实姓名";
        cell.boyBtn.hidden = YES;
        cell.girlBtn.hidden = YES;
        cell.textField.hidden = NO;
        [cell.textField.rac_textSignal subscribeNext:^(id x) {
            nickName = x;
        }];
    }
    else
    {
        cell.nameLabel.text = @"性   别";
        cell.boyBtn.hidden = NO;
        cell.girlBtn.hidden = NO;
        cell.textField.hidden = YES;
        [[cell.boyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            sex = @"1";
            cell.boyBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
            cell.girlBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
        }];
        [[cell.girlBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            sex = @"2";
            cell.boyBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
            cell.girlBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
        }];
    }
    
    cell.codeButton.hidden = YES;

    return cell;
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response
                requeseType:(RequestType)type
{
    [self hideMBP];
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
    else if ([[dic objectForKey:@"returncode"] integerValue] == 6)
    {
        [self showMBP:@"该手机号已注册，请直接登陆" withBlock:nil];
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
