//
//  BXTProjectManageViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTProjectManageViewController.h"
#import "BXTProjectManageCell.h"
#import "BXTHeadquartersViewController.h"
#import "BXTProjectInformViewController.h"
#import "BXTProjectCertificationViewController.h"
#import "BXTMyProject.h"

@interface BXTProjectManageViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation BXTProjectManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"项目管理" andRightTitle:@"项目认证" andRightImage:nil];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self createUI];
    
    [self showLoadingMBP:@"请稍等..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request listOFUserShopLists];
}

- (void)navigationRightButton
{
    BXTProjectCertificationViewController *pcvc = [[BXTProjectCertificationViewController alloc] init];
    [self.navigationController pushViewController:pcvc animated:YES];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, 30)];
    label.text = @"我的项目:";
    label.textColor = colorWithHexString(@"#666666");
    label.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:label];
    
    // footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerView];
    
    UIButton *addItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addItemBtn.frame = CGRectMake((SCREEN_WIDTH - 180) / 2, 10, 180, 50);
    [addItemBtn setTitle:@"添加项目" forState:UIControlStateNormal];
    addItemBtn.backgroundColor = colorWithHexString(@"#5DAEF9");
    addItemBtn.layer.cornerRadius = 5;
    @weakify(self);
    [[addItemBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTHeadquartersViewController *headqtVC = [[BXTHeadquartersViewController alloc] init];
        [self.navigationController pushViewController:headqtVC animated:YES];
    }];
    [footerView addSubview:addItemBtn];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTProjectManageCell *cell = [BXTProjectManageCell cellWithTableView:tableView];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTProjectInformViewController *pivc = [[BXTProjectInformViewController alloc] init];
    [self.navigationController pushViewController:pivc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    
    if (type == UserShopLists && [dic[@"returncode"] integerValue] == 0)
    {
        [BXTMyProject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"projectID": @"id"};
        }];
        [self.dataArray addObjectsFromArray:[BXTMyProject mj_objectArrayWithKeyValuesArray:data]];
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
