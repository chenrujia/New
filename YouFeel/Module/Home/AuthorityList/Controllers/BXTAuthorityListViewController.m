//
//  BXTAuthorityListViewController.m
//  YouFeel
//
//  Created by 满孝意 on 15/12/10.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTAuthorityListViewController.h"
#import "BXTHeaderFile.h"
#import "BXTStatisticsViewController.h"
#import "BXTDataRequest.h"
#import "BXTAuthorityListCell.h"
#import "UIImageView+WebCache.h"

@interface BXTAuthorityListViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BXTAuthorityListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetting:@"项目列表" andRightTitle:nil andRightImage:nil];
    self.dataArray = [[NSMutableArray alloc] init];
    
    self.dataArray = [BXTGlobal getUserProperty:U_MYSHOP];
    
    NSLog(@"\n%@", self.dataArray);
    
    [self createUI];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    [self.view addSubview:self.tableView];
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
    static NSString *cellID = @"cell";
    BXTAuthorityListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTAuthorityListCell" owner:nil options:nil] lastObject];
    }
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    [cell.iconView sd_setImageWithURL:dict[@"shop_logo"] placeholderImage:[UIImage imageNamed:@"New_Ticket_icon"]];
    cell.titleView.text = dict[@"shop_name"];
    cell.addressView.text = [NSString stringWithFormat:@"地址：%@", dict[@"shop_address"]];
    if ([BXTGlobal isBlankString:dict[@"shop_address"]])
    {
        cell.addressView.text = @"";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    BXTHeadquartersInfo *companyInfo = [[BXTHeadquartersInfo alloc] init];
    companyInfo.company_id = dict[@"id"];
    companyInfo.name = dict[@"shop_name"];
    [BXTGlobal setUserProperty:companyInfo withKey:U_COMPANY];
    NSString *url = [NSString stringWithFormat:@"http://api.51bxt.com/?c=Port&m=actionGet_iPhone_v2_Port&shop_id=%@&token=%@", dict[@"id"], [BXTGlobal getUserProperty:U_TOKEN]];
    [BXTGlobal shareGlobal].baseURL = url;

    [self showLoadingMBP:@"权限切换中"];
    /**分店登录**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request branchLogin];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    if (type == BranchLogin && [[dic objectForKey:@"returncode"] isEqualToString:@"0"])
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
        [BXTGlobal showText:@"登录失败，请仔细检查！" view:self.view completionBlock:nil];
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

- (void)didReceiveMemoryWarning
{
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
