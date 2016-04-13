//
//  BXTCertificationManageViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTCertificationManageViewController.h"
#import "BXTCertificationManageCell.h"
#import "BXTCertificationManageInfoCell.h"
#import "BXTProjectInfo.h"

@interface BXTCertificationManageViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) BXTProjectInfo *projectInfo;

@end

@implementation BXTCertificationManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"认证审批" andRightTitle:nil andRightImage:nil];
    
    [self createUI];
    
    [self showLoadingMBP:@"努力加载中..."];
    /** 项目认证详情 **/
    BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
    [dataRequest projectAuthenticationDetailWithApplicantID:self.transID shopID:@""];
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
    [self.view addSubview:footerView];
    
    
    // disagree
    CGFloat btnW = (SCREEN_WIDTH - 2 * 15 - 30) / 2;
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.frame = CGRectMake(15, 10, btnW, 50);
    [switchBtn setTitle:@"不通过" forState:UIControlStateNormal];
    [switchBtn setTitleColor:colorWithHexString(@"#5DAEF9") forState:UIControlStateNormal];
    switchBtn.layer.borderWidth = 1;
    switchBtn.layer.borderColor = [colorWithHexString(@"#5DAEF9") CGColor];
    switchBtn.layer.cornerRadius = 5;
    @weakify(self);
    [[switchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self showLoadingMBP:@"努力加载中..."];
        /** 项目认证详情 **/
        BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
        [dataRequest projectAuthenticationVerifyWithApplicantID:self.projectInfo.out_userid isVerify:@"0"];
    }];
    [footerView addSubview:switchBtn];
    
    // agree
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(15 + btnW + 30, 10, btnW, 50);
    [changeBtn setTitle:@"通过" forState:UIControlStateNormal];
    changeBtn.backgroundColor = colorWithHexString(@"#5DAEF9");
    changeBtn.layer.cornerRadius = 5;
    [[changeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self showLoadingMBP:@"努力加载中..."];
        /** 项目认证详情 **/
        BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
        [dataRequest projectAuthenticationVerifyWithApplicantID:self.projectInfo.out_userid isVerify:@"1"];
    }];
    [footerView addSubview:changeBtn];
}

#pragma mark -
#pragma mark - tableView代理方法
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
    if (indexPath.section == 0) {
        BXTCertificationManageCell *cell = [BXTCertificationManageCell cellWithTableView:tableView];
        
        cell.projectInfo = self.projectInfo;
        
        return cell;
    }
    
    BXTCertificationManageInfoCell *cell = [BXTCertificationManageInfoCell cellWithTableView:tableView];
    
    cell.projectInfo = self.projectInfo;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 117;
    }
    
    return 140;
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
    
    if (type == AuthenticationDetail && [dic[@"returncode"] integerValue] == 0)
    {
        NSArray *data = [dic objectForKey:@"data"];
        
        [BXTProjectInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"projectID": @"id"};
        }];
        self.projectInfo = [BXTProjectInfo mj_objectWithKeyValues:data[0]];
        
        [self.tableView reloadData];
    }
    else if (type == AuthenticationVerify)
    {
        if ([dic[@"returncode"] integerValue] == 0) {
            [BXTGlobal showText:@"认证审核完成" view:self.view completionBlock:^{
                if (self.delegateSignal) {
                    [self.delegateSignal sendNext:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
        else if ([dic[@"returncode"] integerValue] == 47) {
            [BXTGlobal showText:@"认证审核已被其他人员处理完成" view:self.view completionBlock:^{
                if (self.delegateSignal) {
                    [self.delegateSignal sendNext:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
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
