//
//  BXTCertificationCompleteViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/5/20.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTCertificationCompleteViewController.h"
#import "BXTProjectInformContentCell.h"
#import "BXTProjectInformAuthorCell.h"
#import "BXTProjectInfo.h"
#import "BXTProjectCertificationViewController.h"

@interface BXTCertificationCompleteViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

@property (strong, nonatomic) UITableView *currentTableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) BXTProjectInfo *projectInfo;

@property (assign, nonatomic) BOOL isCompany;

@end

@implementation BXTCertificationCompleteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 认证审批
    [self navigationSetting:@"项目详情" andRightTitle:nil andRightImage:nil];
    self.dataArray = [[NSMutableArray alloc] initWithArray:@[@[@"项目名", @"详情"],
                                                             @[@"常用位置"] ]];
    
    [self createUI];
    
    /** 项目认证详情 **/
    [self showLoadingMBP:@"加载中..."];
    BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    [dataRequest projectAuthenticationDetailWithApplicantID:@"" shopID:companyInfo.company_id outUserID:self.transApplicantID];
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
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        BXTProjectInformContentCell *cell = [BXTProjectInformContentCell cellWithTableView:tableView];
        cell.projectInfo = self.projectInfo;
        
        [self transVertifyState:self.projectInfo.verify_state Cell:cell];
        
        return cell;
    }
    
    
    static NSString *cellID = @"headerViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    cell.textLabel.text = [NSString stringWithFormat:@"项目名：%@", companyInfo.name];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        if (self.isCompany) {
            // 没有专业组
            if ([self.projectInfo.subgroup isEqualToString:@""]) {
                return 130;
            }
            if ([self.projectInfo.extra_subgroup isEqualToString:@""]) {
                return 155;
            }
            return 185;
        }
        return 100;
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
        
        // [self.projectInfo.type integerValue] == 1 ? @"员工" : @"客户";
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
