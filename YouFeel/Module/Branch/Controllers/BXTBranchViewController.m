//
//  BXTBranchViewController.m
//  BXT
//
//  Created by Jason on 15/8/20.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBranchViewController.h"
#import "BXTAuthenticationViewController.h"
#import "BXTShopsTableViewCell.h"
#import "BXTHeaderForVC.h"

@interface BXTBranchViewController ()<UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate>
{
    NSMutableArray *markArray;
    NSMutableArray *shopsArray;
    BXTHeadquartersInfo *headquarters;
    UITableView *currentTableView;
}
@end

@implementation BXTBranchViewController

- (instancetype)initWithHeadquarters:(BXTHeadquartersInfo *)company
{
    self = [super init];
    if (self)
    {
        [self navigationSetting:company.name andRightTitle:@"确定" andRightImage:nil];
        shopsArray = [NSMutableArray array];
        markArray = [NSMutableArray array];
        [self createTableView];
        
        /**请求分店位置**/
        BXTDataRequest *dep_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [dep_request shopLists:company.company_id];
    }
    return self;
}

#pragma mark -
#pragma mark 初始化视图
- (void)createTableView
{
    currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStylePlain];
    [currentTableView registerClass:[BXTShopsTableViewCell class] forCellReuseIdentifier:@"shopsCell"];
    currentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    currentTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:currentTableView];
}

#pragma mark -
#pragma mark 事件处理
- (void)navigationRightButton
{
    [BXTGlobal setUserProperty:headquarters withKey:U_COMPANY];
    NSString *url = [NSString stringWithFormat:@"http://api.hellouf.com/?c=Port&m=actionGet_iPhone_v2_Port&shop_id=%@",headquarters.company_id];
    [BXTGlobal shareGlobal].baseURL = url;
    
    NSArray *shopsIDArray = [BXTGlobal getUserProperty:U_SHOPIDS];
    if ([shopsIDArray containsObject:headquarters.company_id])
    {
        /**请求分店位置**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request branchLogin];
    }
    else
    {
        BXTAuthenticationViewController *authenticationVC = [[BXTAuthenticationViewController alloc] init];
        [self.navigationController pushViewController:authenticationVC animated:YES];
    }
}

#pragma mark -
#pragma mark 代理
/**
 *  UITableViewDelegate & UITableViewDatasource
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return shopsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTShopsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"shopsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    BXTHeadquartersInfo *company = shopsArray[indexPath.row];
    if ([markArray[indexPath.row] integerValue])
    {
        cell.checkImgView.hidden = NO;
    }
    else
    {
        cell.checkImgView.hidden = YES;
    }
    cell.titleLabel.text = company.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTHeadquartersInfo *company = shopsArray[indexPath.row];
    headquarters = company;
    [markArray removeAllObjects];
    for (NSInteger i = 0; i < shopsArray.count; i++)
    {
        [markArray addObject:@"0"];
    }
    [markArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    [tableView reloadData];
}

/**
 *  BXTDataResponseDelegate
 */
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    NSArray *array = [dic objectForKey:@"data"];
    if (type == BranchLogin)
    {
        if (array.count > 0)
        {
            NSDictionary *userInfo = array[0];
            [[BXTGlobal shareGlobal] reLoginWithDic:userInfo];
        }
    }
    else
    {
        for (NSDictionary *dictionary in array)
        {
            DCParserConfiguration *config = [DCParserConfiguration configuration];
            DCObjectMapping *text = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"company_id" onClass:[BXTHeadquartersInfo class]];
            [config addObjectMapping:text];
            
            DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTHeadquartersInfo class] andConfiguration:config];
            BXTHeadquartersInfo *company = [parser parseDictionary:dictionary];
            
            [shopsArray addObject:company];
        }
        
        for (NSInteger i = 0; i < shopsArray.count; i++)
        {
            [markArray addObject:@"0"];
        }
        
        [currentTableView reloadData];
    }
}

- (void)requestError:(NSError *)error
{
    //    [self hideMBP];
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
