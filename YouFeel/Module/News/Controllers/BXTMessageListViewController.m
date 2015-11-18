//
//  BXTMessageListViewController.m
//  YouFeel
//
//  Created by Jason on 15/10/22.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTMessageListViewController.h"
#import "BXTMessageListTableViewCell.h"
#import "BXTHeaderForVC.h"
#import "BXTNewsViewController.h"

@interface BXTMessageListViewController ()<UITableViewDataSource,UITableViewDelegate, BXTDataResponseDelegate>
{
    UITableView *currentTable;
    NSArray *imageArray;
    NSArray *newsType;
}

@property (nonatomic ,strong) NSMutableArray *datasource;
@property (nonatomic, assign) BOOL isPopVC;

@end

@implementation BXTMessageListViewController

- (instancetype)initWithDataSourch:(NSMutableArray *)data
{
    self = [super init];
    if (self)
    {
        self.datasource = data;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"消息" andRightTitle:nil andRightImage:nil];
    [self createTableView];
    
    imageArray = @[@"MessageIcon",@"TicketIcon",@"NotificationIcon",@"WarningIcon"];
    newsType = @[@"系统消息",@"工单消息",@"通知",@"预警"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 入栈传值，出栈更新
    if (self.isPopVC) {
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request messageList];
    }
    self.isPopVC = YES;
}

#pragma mark -
#pragma mark 创建视图
- (void)createTableView
{
    currentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    currentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    currentTable.backgroundColor = colorWithHexString(@"eff3f6");
    [currentTable registerClass:[BXTMessageListTableViewCell class] forCellReuseIdentifier:@"Cell"];
    currentTable.delegate = self;
    currentTable.dataSource = self;
    [self.view addSubview:currentTable];
}

#pragma mark -
#pragma mark 代理
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.5f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5f)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 4.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_datasource.count)
    {
        NSDictionary *dic = _datasource[indexPath.section];
        [cell newsRedNumber:[[dic objectForKey:@"unread_num"] integerValue]];
        cell.titleLabel.text = [dic objectForKey:@"type_name"];
        cell.detailLabel.text = [dic objectForKey:@"last_title"];
    }
    else
    {
        cell.titleLabel.text =  newsType[indexPath.section];
    }
    cell.iconView.image = [UIImage imageNamed:imageArray[indexPath.section]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            
            break;
        case 1:
        {
            BXTNewsViewController *newsVC = [[BXTNewsViewController alloc] init];
            [self.navigationController pushViewController:newsVC animated:YES];
        }
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        default:
            break;
    }
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    NSArray *array = [dic objectForKey:@"data"];
    if (array.count)
    {
        [self.datasource removeAllObjects];
        [self.datasource addObjectsFromArray:array];
    }
    [currentTable reloadData];
}

- (void)requestError:(NSError *)error
{
    
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
