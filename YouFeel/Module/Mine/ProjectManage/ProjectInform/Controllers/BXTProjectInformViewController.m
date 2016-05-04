//
//  BXTProjectInformViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTProjectInformViewController.h"
#import "BXTProjectInformTitleCell.h"
#import "BXTProjectInformContentCell.h"
#import "BXTProjectInformAuthorCell.h"
#import "BXTProjectInfo.h"
#import "BXTProjectCertificationViewController.h"

@interface BXTProjectInformViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

@property (strong, nonatomic) UITableView *currentTableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) BXTProjectInfo *projectInfo;

@property (assign, nonatomic) BOOL isCompany;

@end

@implementation BXTProjectInformViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"项目详情" andRightTitle:nil andRightImage:nil];
    self.dataArray = [[NSMutableArray alloc] initWithArray:@[@[@"项目名", @"详情"],
                                                             @[@"常用位置"],
                                                             @[@"审核人"] ]];
    
    [self createUI];
    
    /** 项目认证详情 **/
    BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
    [dataRequest projectAuthenticationDetailWithApplicantID:@"" shopID:self.transMyProject.shop_id];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // tableView
    self.currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 70) style:UITableViewStyleGrouped];
    self.currentTableView.delegate = self;
    self.currentTableView.dataSource = self;
    [self.view addSubview:self.currentTableView];
    
    // footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerView];
    
    // changeBtn
    CGFloat btnW = (SCREEN_WIDTH - 2 * 15 - 30) / 2;
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(15, 10, btnW, 50);
    [changeBtn setTitle:@"修改信息" forState:UIControlStateNormal];
    changeBtn.backgroundColor = colorWithHexString(@"#5DAEF9");
    changeBtn.layer.cornerRadius = 5;
    @weakify(self);
    [[changeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        // TODO: -----------------  调试  -----------------
        BXTProjectCertificationViewController *pcvc = [[BXTProjectCertificationViewController alloc] init];
        pcvc.transMyProject = self.transMyProject;
        pcvc.transProjectInfo = self.projectInfo;
        pcvc.delegateSignal = [RACSubject subject];
        [pcvc.delegateSignal subscribeNext:^(id x) {
            //            [self getResource];
        }];
        [self.navigationController pushViewController:pcvc animated:YES];
    }];
    [footerView addSubview:changeBtn];
    
    // switchBtn
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.frame = CGRectMake(15 + btnW + 30, 10, btnW, 50);
    [switchBtn setTitle:@"切换至" forState:UIControlStateNormal];
    [switchBtn setTitleColor:colorWithHexString(@"#5DAEF9") forState:UIControlStateNormal];
    switchBtn.layer.borderWidth = 1;
    switchBtn.layer.borderColor = [colorWithHexString(@"#5DAEF9") CGColor];
    switchBtn.layer.cornerRadius = 5;
    [[switchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self refreshAllInformWithShopID:self.transMyProject.shop_id shopAddress:self.transMyProject.name];
        
        /**请求分店位置**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request branchLogin];
    }];
    [footerView addSubview:switchBtn];
    
    // verify_state 状态：0未认证 1申请中 2已认证，没有状态3（不通过），如果审核的时候选择了不通过，则将状态直接设置为0
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    if ([self.transMyProject.verify_state integerValue] != 2) {
        changeBtn.frame = CGRectZero;
        switchBtn.frame = CGRectMake(15, 10, SCREEN_WIDTH - 30, 50);
        
        if ([self.transMyProject.shop_id isEqualToString:companyInfo.company_id]) {
            footerView.frame = CGRectZero;
        }
    }
    else {
        if ([self.transMyProject.shop_id isEqualToString:companyInfo.company_id]) {
            changeBtn.frame = CGRectMake(15, 10, SCREEN_WIDTH - 30, 50);
            switchBtn.frame = CGRectZero;
        }
    }
    
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
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 - self.isCompany)
    {
        BXTProjectInformAuthorCell *cell = [BXTProjectInformAuthorCell cellWithTableView:tableView];
        cell.projectInfo = self.projectInfo;
        [[cell.connectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSLog(@"--------------- 联系Ta");
        }];
        
        return cell;
    }
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        BXTProjectInformContentCell *cell = [BXTProjectInformContentCell cellWithTableView:tableView];
        cell.projectInfo = self.projectInfo;
        
        return cell;
    }
    
    BXTProjectInformTitleCell *cell = [BXTProjectInformTitleCell cellWithTableView:tableView];
    if (indexPath.section == 0)
    {
        cell.titleView.text = @"项目名：";
        cell.descView.text = self.transMyProject.name;
    }
    else if (indexPath.section == 1 && !self.isCompany)
    {
        cell.titleView.text = @"常用位置：";
        cell.descView.text = self.projectInfo.stores_name;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        if (self.isCompany) {
            return 140;
        }
        return 90;
    }
    if (indexPath.section == 2 - self.isCompany)
    {
        return 117;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == AuthenticationDetail && [dic[@"returncode"] integerValue] == 0)
    {
        [BXTProjectInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"projectID": @"id"};
        }];
        self.projectInfo = [BXTProjectInfo mj_objectWithKeyValues:data[0]];
        
        // [self.projectInfo.type integerValue] == 1 ? @"项目管理公司" : @"客户组";
        self.isCompany = [self.projectInfo.type integerValue] == 1;
        if (self.isCompany) {
            [self.dataArray removeObjectAtIndex:1];
        }
        
        
        [self.currentTableView reloadData];
    }
    else if (type == BranchLogin)
    {
        if (data.count > 0)
        {
            NSDictionary *userInfo = data[0];
            
            [[BXTGlobal shareGlobal] branchLoginWithDic:userInfo isPushToRootVC:YES];
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
