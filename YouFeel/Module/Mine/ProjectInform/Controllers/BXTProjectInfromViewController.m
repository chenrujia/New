//
//  BXTProjectInfromViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/9.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTProjectInfromViewController.h"
#import "BXTHeaderFile.h"
#import "BXTSettingTableViewCell.h"
#import "BXTAuditerTableViewCell.h"
#import "BXTDataRequest.h"
#import "AppDelegate.h"
#import "ANKeyValueTable.h"
#import "UINavigationController+YRBackGesture.h"
#import "UIImageView+WebCache.h"
#import "BXTHeadquartersViewController.h"

@interface BXTProjectInfromViewController () <UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate>
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

@implementation BXTProjectInfromViewController

- (void)dealloc
{
    LogBlue(@"设置界面释放了！！！！！！");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"项目信息" andRightTitle:nil andRightImage:nil];
    
    [self initContentViews];
    
    //获取用户信息
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request userInfo];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark -
#pragma mark 初始化视图
- (void)initContentViews
{
    currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
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
    if (section == 0) {
        return 0.1;
    }
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && isHaveChecker)
    {
        return 124.f;
    }
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isHaveChecker)
    {
        return 4;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if ([BXTGlobal shareGlobal].isRepair) {
            return 3;
        }
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && isHaveChecker)
    {
        BXTAuditerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AuditerCell"];
        if (!cell)
        {
            cell = [[BXTAuditerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AuditerCell"];
        }
        
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
        
        return cell;
    }
    
    
    BXTSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
    if (!cell)
    {
        cell = [[BXTSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailLable.textAlignment = NSTextAlignmentLeft;
    }
    
    if (indexPath.section == 0)
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
                cell.titleLabel.text = @"项   目";
                BXTHeadquartersInfo *department = [BXTGlobal getUserProperty:U_COMPANY];
                cell.detailLable.text = department.name;
            }
            else if (indexPath.row == 1)
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
                cell.titleLabel.text = @"项   目";
                BXTHeadquartersInfo *department = [BXTGlobal getUserProperty:U_COMPANY];
                cell.detailLable.text = department.name;
            }
            else if (indexPath.row == 1)
            {
                cell.titleLabel.text = @"部   门";
                BXTDepartmentInfo *department = [BXTGlobal getUserProperty:U_DEPARTMENT];
                cell.detailLable.text = department.department;
            }
        }
    }
    else if (indexPath.section == 1)
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
    }
    
    if ((isHaveChecker && indexPath.section == 3) || (!isHaveChecker && indexPath.section == 2))
    {
        cell.textLabel.text = @"注册新项目";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((isHaveChecker && indexPath.section == 3) || (!isHaveChecker && indexPath.section == 2))
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
