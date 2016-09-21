//
//  BXTProjectInformViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTProjectInformViewController.h"
#import "BXTProjectInformContentCell.h"
#import "BXTProjectInformAuthorCell.h"
#import "BXTProjectCertificationViewController.h"
#import "BXTAuthenticateUserListInfo.h"
#import "ANKeyValueTable.h"
#import "BXTMailListCell.h"
#import <RongIMKit/RongIMKit.h>
#import "MYAlertAction.h"
#import "BXTPersonInfromViewController.h"

@interface BXTProjectInformViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *isShowArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
/** ---- 管理员数组 ---- */
@property (nonatomic, strong) NSMutableArray *authorArray;

@property (strong, nonatomic) BXTPersonInform *projectInfo;

/** ---- 是员工类型 ---- */
@property (assign, nonatomic) BOOL isCompany;

@end

@implementation BXTProjectInformViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 项目管理进
    [self navigationSetting:@"项目详情" andRightTitle:nil andRightImage:nil];
    
    self.isShowArray = [[NSMutableArray alloc] initWithObjects:@"1", nil];
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"项目名", nil];
    self.authorArray = [[NSMutableArray alloc] init];
    
    [BXTGlobal showLoadingMBP:@"加载中..."];
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /** 项目认证详情 **/
        BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
        [dataRequest mailListOfOnePersonWithID:@"" outUserID:self.transMyProject.user_id shopID:self.transMyProject.shop_id];
    });
    dispatch_async(concurrentQueue, ^{
        /**店铺信息**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request shopConfig];
    });
    
    [self createUI];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 70) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = [UIColor whiteColor];
    if (!self.hiddenChangeBtn) {
        [self.view addSubview:footerView];
    }
    
    // switchBtn
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.frame = CGRectMake(15, 10, SCREEN_WIDTH - 30, 50);
    switchBtn.backgroundColor = colorWithHexString(@"#5DAEF9");
    [switchBtn setTitle:@"切换至" forState:UIControlStateNormal];
    [switchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    switchBtn.layer.cornerRadius = 5;
    @weakify(self);
    [[switchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self refreshAllInformWithShopID:self.transMyProject.shop_id shopAddress:self.transMyProject.name];
        
        /**请求分店位置**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request branchLogin];
    }];
    [footerView addSubview:switchBtn];
}

- (void)refreshAllInformWithShopID:(NSString *)shopID shopAddress:(NSString *)shopAddress {
    BXTHeadquartersInfo *companyInfo = [[BXTHeadquartersInfo alloc] init];
    companyInfo.company_id = shopID;
    companyInfo.name = shopAddress;
    [BXTGlobal setUserProperty:companyInfo withKey:U_COMPANY];
    
    NSString *url = [NSString stringWithFormat:@"%@&shop_id=%@&token=%@",KAPIBASEURL, shopID, [BXTGlobal getUserProperty:U_TOKEN]];
    [BXTGlobal shareGlobal].baseURL = url;
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isShowArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.isShowArray[section] isEqualToString:@"1"])
    {
        return  1;
    }
    return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        BXTProjectInformContentCell *cell = [BXTProjectInformContentCell cellWithTableView:tableView];
        cell.projectInfo = self.projectInfo;
        
        [self transVertifyState:self.transMyProject.verify_state Cell:cell];
        
        return cell;
    }
    
    
    BXTMailListCell *cell = [BXTMailListCell cellWithTableView:tableView];
    
    cell.mailListModel = self.authorArray[indexPath.row];
    
    @weakify(self);
    [[cell.messageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self connectTaWithOutID0:cell.mailListModel];
    }];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 200, 21)];
        title.text = [NSString stringWithFormat:@"%@：%@", self.dataArray[section], self.transMyProject.name];
        title.textColor = colorWithHexString(@"#666666");
        title.textAlignment = NSTextAlignmentLeft;
        title.font = [UIFont systemFontOfSize:15];
        [view addSubview:title];
        
        return view;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = section;
    btn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    btn.layer.borderWidth = 0.5;
    @weakify(self);
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        // 改变组的显示状态
        if ([self.isShowArray[btn.tag] isEqualToString:@"1"])
        {
            [self.isShowArray replaceObjectAtIndex:btn.tag withObject:@"0"];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [self.isShowArray replaceObjectAtIndex:btn.tag withObject:@"1"];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 200, 21)];
    title.text = self.dataArray[section];
    title.textColor = colorWithHexString(@"#666666");
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:15];
    [btn addSubview:title];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 18.5, 15, 8)];
    arrow.image = [UIImage imageNamed:@"down_arrow_gray"];
    if ([self.isShowArray[section] isEqualToString:@"1"])
    {
        arrow.image = [UIImage imageNamed:@"up_arrow_gray"];
    }
    [btn addSubview:arrow];
    
    return btn;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        BXTMailListModel *mailListModel = self.authorArray[indexPath.row];
        
        BXTPersonInfromViewController *pivc = [[BXTPersonInfromViewController alloc] init];
        pivc.userID = mailListModel.userID;
        pivc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pivc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        // 员工类型
        if (self.isCompany) {
            // 没有专业组
            if ([self.projectInfo.subgroup_name isEqualToString:@""]) {
                return 130;
            }
            if ([self.projectInfo.have_subgroup_name isEqualToString:@""]) {
                return 155;
            }
            return 185;
        }
        return 100;
    }
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == UserInfo && data.count > 0)
    {
        [BXTPersonInform mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"personID":@"id"};
        }];
        self.projectInfo  = [BXTPersonInform mj_objectWithKeyValues:data[0]];
        
        // [self.projectInfo.type integerValue] == 1 ? @"员工" : @"客户";
        self.isCompany = self.projectInfo.type == 1;
    }
    else if (type == BranchLogin)
    {
        if (data.count > 0)
        {
            NSDictionary *userInfo = data[0];
            
            [[BXTGlobal shareGlobal] branchLoginWithDic:userInfo isPushToRootVC:YES];
        }
    }
    else  if (type == ShopConfig && [dic[@"returncode"] integerValue] == 0)
    {
        // 管理员
        [BXTMailListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"userID":@"id"};
        }];
        [self.authorArray addObjectsFromArray:[BXTMailListModel mj_objectArrayWithKeyValuesArray:dic[@"authenticate_user_arr"]]];
        
        if (self.authorArray.count != 0) {
            [self.isShowArray addObject:@"0"];
            [self.dataArray addObject:@"联系项目管理员"];
        }
    }
    
    [self.tableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

- (void)transVertifyState:(NSString *)state Cell:(BXTProjectInformContentCell *)cell
{
    // verify_state 状态：0未认证 1申请中 2已认证，没有状态3（不通过），如果审核的时候选择了不通过，则将状态直接设置为0
    switch ([state integerValue]) {
        case 0: {
            cell.stateView.text = @"未认证";
            cell.stateView.textColor = colorWithHexString(@"#696869");
        } break;
        case 1: {
            cell.stateView.text = @"申请中";
            cell.stateView.textColor = colorWithHexString(@"#D2564D");
        } break;
        case 2: {
            cell.stateView.text = @"已认证";
            cell.stateView.textColor = colorWithHexString(@"#5BB0F7");
        } break;
        default: break;
    }
}

- (void)connectTaWithOutID0:(BXTMailListModel *)model
{
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = model.out_userid;
    
    NSString *my_userID = [BXTGlobal getUserProperty:U_USERID];
    if ([userInfo.userId isEqualToString:my_userID]) {
        [MYAlertAction showAlertWithTitle:@"温馨提示" msg:@"不能与自己通话" chooseBlock:^(NSInteger buttonIdx) {
            
        } buttonsStatement:@"确定", nil];
        return;
    }
    
    userInfo.name = model.name;
    userInfo.portraitUri = model.head_pic;
    
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
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = userInfo.userId;
    conversationVC.title = userInfo.name;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
