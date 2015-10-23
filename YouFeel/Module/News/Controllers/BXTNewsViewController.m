//
//  BXTNewsViewController.m
//  YouFeel
//
//  Created by Jason on 15/10/19.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTNewsViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTNewsTableViewCell.h"

@interface BXTNewsViewController ()<UITableViewDelegate,UITableViewDataSource,BXTDataResponseDelegate>
{
    UITableView *currentTable;
    NSMutableArray *datasource;
}

@end

@implementation BXTNewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"消息" andRightTitle:nil andRightImage:nil];
    [self createTableView];
    
    datasource = [NSMutableArray array];
    
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request newsList];
}

#pragma mark - 
#pragma mark 创建视图
- (void)createTableView
{
    currentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    currentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    currentTable.backgroundColor = colorWithHexString(@"eff3f6");
    [currentTable registerClass:[BXTNewsTableViewCell class] forCellReuseIdentifier:@"Cell"];
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
        return 0;
    }
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [datasource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *dic = datasource[indexPath.section];
    cell.titleLabel.text = [dic objectForKey:@"notice_title"];
    cell.detailLabel.text = [dic objectForKey:@"notice_body"];
    cell.timeLabel.text = [BXTGlobal transformationTime:@"yyyy-MM-dd HH:mm:ss" withTime:[dic objectForKey:@"send_time"]];
    if ([[dic objectForKey:@"handle_state"] integerValue] == 2)
    {
        cell.evaButton.hidden = YES;
    }
    else
    {
        cell.evaButton.hidden = NO;
    }
    
    return cell;
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = (NSDictionary *)response;
    LogRed(@"%@",dic);
    NSArray *array = [dic objectForKey:@"data"];
    if (array.count > 0)
    {
        [datasource addObjectsFromArray:array];
        [currentTable reloadData];
    }
}

- (void)requestError:(NSError *)error
{
    
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
