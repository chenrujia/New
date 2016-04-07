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
#import "BXTProjectAddNewViewController.h"
#import "BXTHeaderFile.h"
#import "AppDelegate.h"
#import "BXTDataRequest.h"
#import "MBProgressHUD.h"
#import "BXTResignTableViewCell.h"

static NSString *cellIndentify = @"resignCellIndentify";

@interface BXTNickNameViewController ()<MBProgressHUDDelegate,BXTDataResponseDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *currentTableView;
}

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic ,strong) NSString *passWord;
@property (nonatomic, strong) NSString *sex;

@end

@implementation BXTNickNameViewController

- (void)isLoginByWeiXin:(BOOL)loginType
{
    self.isLoginByWX = loginType;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sex = @"1";
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
    currentTableView.rowHeight = 50.f;
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    [self.view addSubview:currentTableView];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 16.f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (section == 0)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16.f)];
    }
    else
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    }
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 100.f;
    }
    return 5.f;
}

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
        @weakify(self);
        [[doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self resignFirstResponder];
            if (![BXTGlobal validateUserName:self.nickName])
            {
                [self showMBP:@"请输入您的真实姓名" withBlock:nil];
                return;
            }
            else if (_isLoginByWX && ![BXTGlobal validatePassword:self.passWord])
            {
                [self showMBP:@"请输入至少6位密码，仅限英文、数字" withBlock:nil];
                return;
            }
            
            [BXTGlobal setUserProperty:@[] withKey:U_MYSHOP];
            [self showLoadingMBP:@"注册中..."];
            [BXTGlobal setUserProperty:self.nickName withKey:U_NAME];
            [BXTGlobal setUserProperty:self.sex withKey:U_SEX];
            
            NSString *userName = [BXTGlobal getUserProperty:U_USERNAME];
            NSString *passWord;
            if (_isLoginByWX)
            {
                passWord = self.passWord;
            }
            else
            {
                passWord = [BXTGlobal getUserProperty:U_PASSWORD];
            }
            NSString *cid = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"] : @"";
            
            NSDictionary *userInfoDic;
            if (_isLoginByWX)
            {
                userInfoDic = @{@"name":self.nickName,
                                @"password":passWord,
                                @"username":userName,
                                @"gender":self.sex,
                                @"mailmatch":@"123",
                                @"roletype":@"1",
                                @"cid":cid,
                                @"type":@"3",
                                @"only_code":[BXTGlobal shareGlobal].openID,
                                @"flat_id":@"1",
                                @"headMedium":[BXTGlobal shareGlobal].wxHeadImage};
            }
            else
            {
                userInfoDic = @{@"name":self.nickName,
                                @"password":passWord,
                                @"username":userName,
                                @"gender":self.sex,
                                @"mailmatch":@"123",
                                @"roletype":@"1",
                                @"cid":cid};
            }
            
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
        @weakify(self);
        [cell.textField.rac_textSignal subscribeNext:^(id x) {
            @strongify(self);
            self.nickName = x;
        }];
    }
    else if (indexPath.section == 2)
    {
        cell.nameLabel.text = @"性   别";
        cell.boyBtn.hidden = NO;
        cell.girlBtn.hidden = NO;
        cell.textField.hidden = YES;
        @weakify(self);
        [[cell.boyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            self.sex = @"1";
            cell.boyBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
            cell.girlBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
        }];
        [[cell.girlBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            self.sex = @"2";
            cell.boyBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
            cell.girlBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
        }];
    }
    else
    {
        cell.nameLabel.text = @"密   码";
        cell.textField.placeholder = @"请输入登录密码，至少6位";
        cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
        cell.codeButton.hidden = YES;
        @weakify(self);
        [cell.textField.rac_textSignal subscribeNext:^(id x) {
            @strongify(self);
            self.passWord = x;
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
    if (type == BranchResign)
    {
        LogBlue(@"dic:%@",dic);
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            NSString *userID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"finish_id"]];
            [BXTGlobal setUserProperty:userID withKey:U_BRANCHUSERID];
            [self showMBP:@"注册成功！" withBlock:^(BOOL hidden) {
                [self showLoadingMBP:@"登录中..."];
                /**分店登录**/
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request branchLogin];
            }];
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
    else
    {
        if ([[dic objectForKey:@"state"] integerValue] == 1)
        {
            NSString *userID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"finish_id"]];
            [BXTGlobal setUserProperty:userID withKey:U_USERID];
            //执行分店注册
            [self showLoadingMBP:@"请稍候..."];
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request branchResign];
        }
        else if ([[dic objectForKey:@"returncode"] integerValue] == 6)
        {
            [self showMBP:@"该手机号已注册，请直接登陆" withBlock:nil];
        }
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
