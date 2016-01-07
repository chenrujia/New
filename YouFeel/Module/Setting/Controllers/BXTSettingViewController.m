//
//  BXTSettingViewController.m
//  BXT
//
//  Created by Jason on 15/8/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTSettingViewController.h"
#import "BXTHeaderFile.h"
#import "BXTSettingTableViewCell.h"
#import "BXTAuditerTableViewCell.h"
#import "AppDelegate.h"
#import "BXTPostionInfo.h"
#import "BXTDataRequest.h"
#import "UIImageView+WebCache.h"
#import "UINavigationController+YRBackGesture.h"
#import "BXTHeadquartersInfo.h"
#import "ANKeyValueTable.h"
#import "BXTHeadquartersViewController.h"
#import "BXTChangePassWordViewController.h"

static NSString *settingCellIndentify = @"settingCellIndentify";

@interface BXTSettingViewController ()<UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate>
{
    UITableView    *currentTableView;
    NSString       *verify_state;
    NSString       *checks_user;
    NSString       *checks_user_department;
    NSString       *department_id;
    BOOL           isHaveChecker;
    NSDictionary   *checkUserDic;
}

@property (nonatomic, strong) NSString *checks_phone;

@end

@implementation BXTSettingViewController

- (void)dealloc
{
    LogBlue(@"设置界面释放了！！！！！！");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [BXTGlobal shareGlobal].maxPics = 1;
    self.isSettingVC = YES;
    self.selectPhotos = [NSMutableArray array];
    [self navigationSetting:@"设置" andRightTitle:nil andRightImage:nil];
    [self initContentViews];
    //获取用户信息
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request userInfo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:YES];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -
#pragma mark 初始化视图
- (void)initContentViews
{
    currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - KTABBARHEIGHT) style:UITableViewStyleGrouped];
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    currentTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:currentTableView];
}

- (void)contactTa
{
    self.navigationController.navigationBar.hidden = NO;

    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = [checkUserDic objectForKey:@"checks_user_out_userid"];
    
    NSString *my_userID = [BXTGlobal getUserProperty:U_USERID];
    if ([userInfo.userId isEqualToString:my_userID]) return;
    
    userInfo.name = [checkUserDic objectForKey:@"checks_user"];
    userInfo.portraitUri = [checkUserDic objectForKey:@"checks_user_pic"];
    
    NSMutableArray *usersArray = [BXTGlobal getUserProperty:U_USERSARRAY];
    if (usersArray)
    {
        NSArray *arrResult = [usersArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.userId = %@",userInfo.userId]];
        if (arrResult.count)
        {
            RCUserInfo *temp_userInfo = arrResult[0];
            NSInteger index = [usersArray indexOfObject:temp_userInfo];
            [usersArray replaceObjectAtIndex:index withObject:temp_userInfo];
        }
        else
        {
            [usersArray addObject:userInfo];
        }
    }
    else
    {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:userInfo];
        [BXTGlobal setUserProperty:array withKey:U_USERSARRAY];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HaveConnact" object:nil];
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:NO];
    
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE;
    conversationVC.targetId = userInfo.userId;
    conversationVC.title = userInfo.name;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 16.f;//section头部高度
    }
    return 10.f;//section头部高度
}

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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4)
    {
        if (!isHaveChecker)
        {
            return 100.f;
        }
        return 40.f;
    }
    else if (section == 5 && isHaveChecker)
    {
        return 100.f;
    }
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 4)
    {
        if (!isHaveChecker)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100.f)];
            view.backgroundColor = [UIColor clearColor];
            
            UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 20.f)];
            titleLable.font = [UIFont systemFontOfSize:11.f];
            titleLable.textColor = colorWithHexString(@"909497");
            titleLable.textAlignment = NSTextAlignmentCenter;
            titleLable.text = @"注意：修改以上身份信息均需要再次提交审核，方可修改成功。";
            [view addSubview:titleLable];
            
            UIButton *quitOut = [UIButton buttonWithType:UIButtonTypeCustom];
            quitOut.frame = CGRectMake(20, 40, SCREEN_WIDTH - 40, 50.f);
            [quitOut setTitle:@"退出登录" forState:UIControlStateNormal];
            [quitOut setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
            [quitOut setBackgroundColor:colorWithHexString(@"3cafff")];
            quitOut.layer.masksToBounds = YES;
            quitOut.layer.cornerRadius = 6.f;
            @weakify(self);
            [[quitOut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request exit_loginWithClientID:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"]];
                [[RCIM sharedRCIM] disconnect];
                [[ANKeyValueTable userDefaultTable] clear];
                [BXTGlobal shareGlobal].isRepair = NO;
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndResign" bundle:nil];
                UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"BXTLoginViewController"];
                UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:loginVC];
                navigation.navigationBar.hidden = YES;
                navigation.enableBackGesture = YES;
                [AppDelegate appdelegete].window.rootViewController = navigation;
            }];
            [view addSubview:quitOut];
            
            return view;
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.f)];
        view.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 20.f)];
        titleLable.font = [UIFont systemFontOfSize:11.f];
        titleLable.textColor = colorWithHexString(@"909497");
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.text = @"注意：修改以上身份信息均需要再次提交审核，方可修改成功。";
        [view addSubview:titleLable];
        
        return view;
    }
    else if (section == 5 && isHaveChecker)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100.f)];
        view.backgroundColor = [UIColor clearColor];
        
        UIButton *quitOut = [UIButton buttonWithType:UIButtonTypeCustom];
        quitOut.frame = CGRectMake(20, 25, SCREEN_WIDTH - 40, 50.f);
        [quitOut setTitle:@"退出登录" forState:UIControlStateNormal];
        [quitOut setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [quitOut setBackgroundColor:colorWithHexString(@"3cafff")];
        quitOut.layer.masksToBounds = YES;
        quitOut.layer.cornerRadius = 6.f;
        @weakify(self);
        [[quitOut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request exit_loginWithClientID:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"]];
            [[RCIM sharedRCIM] disconnect];
            [[ANKeyValueTable userDefaultTable] clear];
            [BXTGlobal shareGlobal].isRepair = NO;
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndResign" bundle:nil];
            UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"BXTLoginViewController"];
            UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:loginVC];
            navigation.navigationBar.hidden = YES;
            navigation.enableBackGesture = YES;
            [AppDelegate appdelegete].window.rootViewController = navigation;
        }];
        [view addSubview:quitOut];
        
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
    if (indexPath.section == 0)
    {
        return 100.f;
    }
    else if (indexPath.section == 5 && isHaveChecker)
    {
        return 124.f;
    }
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isHaveChecker)
    {
        return 6;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 3;
    }
    else if (section == 2)
    {
        if ([BXTGlobal shareGlobal].isRepair)
        {
            return 2;
        }
        if ([department_id integerValue] == 2) {
            return 3;
        }
        return 2;
    }
    else if (section == 3)
    {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5 && isHaveChecker)
    {
        BXTAuditerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AuditerCell"];
        if (!cell)
        {
            cell = [[BXTAuditerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AuditerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.auditNameLabel.text = checks_user;
            cell.positionLabel.text = checks_user_department;
            [cell.contactBtn addTarget:self action:@selector(contactTa) forControlEvents:UIControlEventTouchUpInside];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.checks_phone];
            NSRange strRange = {0, [str length]};
            [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
            [cell.phoneBtn setAttributedTitle:str forState:UIControlStateNormal];
            [cell.phoneBtn sizeToFit];
            @weakify(self);
            [[cell.phoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", self.checks_phone];
                UIWebView *callWeb = [[UIWebView alloc] init];
                [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
                [self.view addSubview:callWeb];
            }];
        }
        
        return cell;
    }
    else
    {
        BXTSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
        if (!cell)
        {
            cell = [[BXTSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailLable.textAlignment = NSTextAlignmentLeft;
        }
        
        if (indexPath.section == 0)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailLable.hidden = YES;
            cell.checkImgView.hidden = YES;
            CGRect titleRect = cell.titleLabel.frame;
            titleRect.origin.y = 40.f;
            [cell.titleLabel setFrame:titleRect];
            cell.titleLabel.text = @"头像";
            cell.headImageView.hidden = NO;
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[BXTGlobal getUserProperty:U_HEADERIMAGE]] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
        else if (indexPath.section == 1)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailLable.hidden = NO;
            cell.checkImgView.hidden = NO;
            cell.detailLable.frame = CGRectMake(100.f, 15.f, SCREEN_WIDTH - 100.f, 20);
            if (indexPath.row == 0)
            {
                cell.titleLabel.text = @"手机号";
                cell.detailLable.text = [BXTGlobal getUserProperty:U_USERNAME];
            }
            else if (indexPath.row == 1)
            {
                cell.titleLabel.text = @"姓   名";
                cell.detailLable.text = [BXTGlobal getUserProperty:U_NAME];
            }
            else
            {
                cell.titleLabel.text = @"性   别";
                if ([[BXTGlobal getUserProperty:U_SEX] isEqualToString:@"1"])
                {
                    cell.detailLable.text = @"男";
                }
                else
                {
                    cell.detailLable.text = @"女";
                }
            }
        }
        else if (indexPath.section == 2)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailLable.hidden = NO;
            cell.titleLabel.frame = CGRectMake(15.f, 15.f, 60.f, 20);
            cell.detailLable.frame = CGRectMake(100.f, 15.f, SCREEN_WIDTH - 100.f - 100.f, 20);
            [cell.auditStatusLabel setFrame:CGRectMake(CGRectGetMaxX(cell.detailLable.frame) + 20.f, 15.f, 80.f, 20.f)];
            cell.auditStatusLabel.text = verify_state;
            if ([BXTGlobal shareGlobal].isRepair)
            {
                if (indexPath.row == 0)
                {
                    cell.titleLabel.text = @"部   门";
                    BXTDepartmentInfo *department = [BXTGlobal getUserProperty:U_DEPARTMENT];
                    cell.detailLable.text = department.department;
                }
                else
                {
                    cell.titleLabel.text = @"分   组";
                    BXTGroupingInfo *group = [BXTGlobal getUserProperty:U_GROUPINGINFO];
                    cell.detailLable.text = group.subgroup;
                }
            }
            else
            {
                if (indexPath.row == 0)
                {
                    cell.titleLabel.text = @"位   置";
                    BXTHeadquartersInfo *company = [BXTGlobal getUserProperty:U_COMPANY];
                    cell.detailLable.text = company.name;
                }
                else if (indexPath.row == 1)
                {
                    cell.titleLabel.text = @"部   门";
                    BXTDepartmentInfo *department = [BXTGlobal getUserProperty:U_DEPARTMENT];
                    cell.detailLable.text = department.department;
                }
                else
                {
                    cell.titleLabel.text = @"地   点";
                    BXTShopInfo *shopInfo = [BXTGlobal getUserProperty:U_SHOP];
                    cell.detailLable.text = shopInfo.stores_name;
                }
            }
        }
        else if (indexPath.section == 3)
        {
            if (indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.detailLable.hidden = NO;
                cell.titleLabel.frame = CGRectMake(15.f, 15.f, 60.f, 20);
                cell.detailLable.frame = CGRectMake(100.f, 15.f, SCREEN_WIDTH - 100.f - 100.f, 20);
                [cell.auditStatusLabel setFrame:CGRectMake(CGRectGetMaxX(cell.detailLable.frame) + 20.f, 15.f, 80.f, 20.f)];
                cell.auditStatusLabel.text = verify_state;
                BXTPostionInfo *positionInfo = [BXTGlobal getUserProperty:U_POSITION];
                cell.titleLabel.text = @"职   位";
                cell.detailLable.text = positionInfo.role;
            }
            else if (indexPath.row) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.titleLabel.frame = CGRectMake(15.f, 15.f, 120.f, 20);
                cell.titleLabel.text = @"重置密码";
            }
            
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.titleLabel.frame = CGRectMake(15.f, 15.f, 120.f, 20);
            cell.titleLabel.text = @"注册新项目";
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [self addImages];
    }
    else if (indexPath.section == 3 && indexPath.row == 1)
    {
        // 重置密码
        NSString *userID = [BXTGlobal getUserProperty:U_USERID];
        NSString *username = [BXTGlobal getUserProperty:U_USERNAME];
        NSString *key = [BXTGlobal md5:[NSString stringWithFormat:@"%@%@", userID, username]];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndResign" bundle:nil];
        BXTChangePassWordViewController *changePassWordVC = (BXTChangePassWordViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTChangePassWordViewController"];
        [changePassWordVC dataWithUserID:userID withKey:key];
        [self.navigationController pushViewController:changePassWordVC animated:YES];
        self.navigationController.navigationBar.hidden = NO;
    }
    else if (indexPath.section == 4)
    {
        BXTHeadquartersViewController *company = [[BXTHeadquartersViewController alloc] initWithType:YES];
        [self.navigationController pushViewController:company animated:YES];
    }
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    if (type == UploadHeadImage && [[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        [BXTGlobal setUserProperty:[dic objectForKey:@"pic"] withKey:U_HEADERIMAGE];
    }
    else if (type == UserInfo && [[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        NSArray *array = [dic objectForKey:@"data"];
        if (array.count > 0)
        {
            NSDictionary *dictionay = array[0];
            department_id = [dictionay objectForKey:@"department_id"];
            verify_state = [dictionay objectForKey:@"verify_state"];
            checkUserDic = [dictionay objectForKey:@"stores_checks"];
            checks_user = [checkUserDic objectForKey:@"checks_user"];
            self.checks_phone = [checkUserDic objectForKey:@"checks_user_mobile"];
            NSString *is_verify = [NSString stringWithFormat:@"%@", [dictionay objectForKey:@"is_verify"]];
            [BXTGlobal setUserProperty:is_verify withKey:U_IS_VERIFY];
            if (checks_user.length)
            {
                isHaveChecker = YES;
            }
            else
            {
                isHaveChecker = NO;
            }
            checks_user_department = [checkUserDic objectForKey:@"checks_user_department"];
        }
    }
    
    [currentTableView reloadData];
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
