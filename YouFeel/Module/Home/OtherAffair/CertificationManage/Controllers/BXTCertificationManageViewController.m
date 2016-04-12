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

@interface BXTCertificationManageViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation BXTCertificationManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"认证审批" andRightTitle:nil andRightImage:nil];
    
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
        BXTCertificationManageCell *cell = [BXTCertificationManageCell cellWithTableView:tableView];
        
        
        return cell;
    }
    
    BXTCertificationManageInfoCell *cell = [BXTCertificationManageInfoCell cellWithTableView:tableView];
    
    
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
//    NSArray *data = [dic objectForKey:@"data"];
//    
//    if (type == AuthenticationDetail && [dic[@"returncode"] integerValue] == 0)
//    {
//        [BXTProjectInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//            return @{@"projectID": @"id"};
//        }];
//        self.projectInfo = [BXTProjectInfo mj_objectWithKeyValues:data[0]];
//        
//        [self.tableView reloadData];
//    }
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
