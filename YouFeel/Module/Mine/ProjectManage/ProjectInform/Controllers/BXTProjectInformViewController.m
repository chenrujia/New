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

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;

@property (strong, nonatomic) BXTProjectInfo *projectInfo;

@end

@implementation BXTProjectInformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"项目详情" andRightTitle:nil andRightImage:nil];
    
    self.dataArray = @[@[@"项目名", @"详情"],
                       @[@"常用位置"],
                       @[@"审核人"] ];
    
    [self createUI];
    
    
    /** 修改用户信息 **/
    BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
    [dataRequest projectAuthenticationDetailWithShopID:self.transMyProject.projectID];
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
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [footerView addSubview:switchBtn];
    
    
    // verify_state 状态：0未认证 1申请中 2已认证，没有状态3（不通过），如果审核的时候选择了不通过，则将状态直接设置为0
    if ([self.transMyProject.verify_state integerValue] != 2) {
        changeBtn.frame = CGRectMake(0, 0, 0, 0);
        switchBtn.frame = CGRectMake(15, 10, SCREEN_WIDTH - 30, 50);
    }
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
    if (indexPath.section == 2) {
        BXTProjectInformAuthorCell *cell = [BXTProjectInformAuthorCell cellWithTableView:tableView];
        
        cell.projectInfo = self.projectInfo;
        
        [[cell.connectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSLog(@"--------------- 联系Ta");
        }];
        
        return cell;
    }
    
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        BXTProjectInformContentCell *cell = [BXTProjectInformContentCell cellWithTableView:tableView];
        
        cell.projectInfo = self.projectInfo;
        
        return cell;
    }
    
    
    BXTProjectInformTitleCell *cell = [BXTProjectInformTitleCell cellWithTableView:tableView];
    
    if (indexPath.section == 0) {
        cell.titleView.text = @"项目名：";
        cell.descView.text = self.transMyProject.name;
    }
    else if (indexPath.section == 1) {
        cell.titleView.text = @"常用位置：";
        cell.descView.text = self.projectInfo.stores_name;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 140;
    }
    if (indexPath.section == 2) {
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
        
        [self.tableView reloadData];
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
