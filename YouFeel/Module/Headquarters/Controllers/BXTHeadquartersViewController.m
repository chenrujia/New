//
//  BXTHeadquartersViewController.m
//  BXT
//
//  Created by Jason on 15/8/20.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTHeadquartersViewController.h"
#import "BXTHeadquartersTableViewCell.h"
#import "BXTBranchViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTHeadquartersInfo.h"

#define NavBarHeight 120.f

@interface BXTHeadquartersViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,BXTDataResponseDelegate>
{
    NSMutableArray *shopsArray;
    UISearchBar *headSearchBar;
    UITableView *currentTableView;
    BOOL isPush;
}
@end

@implementation BXTHeadquartersViewController

- (instancetype)initWithType:(BOOL)push
{
    self = [super init];
    if (self)
    {
        isPush = push;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    shopsArray = [NSMutableArray array];
    
    /**请求分店位置**/
    BXTDataRequest *dep_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [dep_request shopLists:nil];
    
    [self navigationSetting];
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark -
#pragma mark 初始化视图
- (void)navigationSetting
{
    UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavBarHeight)];
    naviView.image = [[UIImage imageNamed:@"Nav_Bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    naviView.userInteractionEnabled = YES;
    [self.view addSubview:naviView];
    
    UILabel *navi_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 20, SCREEN_WIDTH-128, 44)];
    navi_titleLabel.backgroundColor = [UIColor clearColor];
    navi_titleLabel.font = [UIFont systemFontOfSize:18];
    navi_titleLabel.textColor = [UIColor whiteColor];
    navi_titleLabel.textAlignment = NSTextAlignmentCenter;
    navi_titleLabel.text = [NSString stringWithFormat:@"切换位置"];
    [naviView addSubview:navi_titleLabel];
    
    if (isPush)
    {
        UIButton * navi_leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 44)];
        navi_leftButton.backgroundColor = [UIColor clearColor];
        [navi_leftButton setImage:[UIImage imageNamed:@"Arrow_left"] forState:UIControlStateNormal];
        [navi_leftButton setImage:[UIImage imageNamed:@"Arrow_left_select"] forState:UIControlStateNormal];
        [navi_leftButton addTarget:self action:@selector(navigationLeftButton) forControlEvents:UIControlEventTouchUpInside];
        [naviView addSubview:navi_leftButton];
    }
    
    headSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10.f, NavBarHeight - 44, SCREEN_WIDTH - 20.f, 44.f)];
    headSearchBar.delegate = self;
    headSearchBar.placeholder = @"快速查找";
    headSearchBar.backgroundColor = [UIColor clearColor];
    headSearchBar.barStyle = UIBarStyleDefault;
    [[[[headSearchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
    [headSearchBar setBackgroundColor:[UIColor clearColor]];
    UITextField *searchField=[((UIView *)[headSearchBar.subviews objectAtIndex:0]).subviews lastObject];
    searchField.layer.cornerRadius = 6.0;
    searchField.layer.masksToBounds = YES;
    searchField.layer.borderWidth = 0.5;
    searchField.layer.borderColor = [UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1.0].CGColor;
    [naviView addSubview:headSearchBar];
}

- (void)createTableView
{
    currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavBarHeight) style:UITableViewStyleGrouped];
    [currentTableView registerClass:[BXTHeadquartersTableViewCell class] forCellReuseIdentifier:@"HeadquartersTableViewCell"];
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    [self.view addSubview:currentTableView];
}

#pragma mark -
#pragma mark 事件处理
- (void)barItmeClick:(UIButton *)btn
{
    if (btn.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (btn.tag == 2)
    {
        BXTBranchViewController *branchVC = [[BXTBranchViewController alloc] init];
        [self.navigationController pushViewController:branchVC animated:YES];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    searchBar.showsCancelButton = NO;
}

#pragma mark -
#pragma mark 代理
/**
 *  UITableViewDelegate & UITableViewDatasource
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 30.f;
    }
    else if (section == 1)
    {
        return 6.f;
    }
    else
    {
        return 23.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView * allLoadView = [[UIView alloc] initWithFrame:CGRectMake(0., 0., SCREEN_WIDTH, 25.)];
        UILabel * allLoadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 5., SCREEN_WIDTH, 20.)];
        allLoadLabel.font = [UIFont systemFontOfSize:12.];
        allLoadLabel.text = @"    关闭自动定位后，每次打开应用会默认使用上一次地址";
        [allLoadView addSubview:allLoadLabel];
        return allLoadView;
    }
    else
    {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2)
    {
        return shopsArray.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTHeadquartersTableViewCell * cell = (BXTHeadquartersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HeadquartersTableViewCell"];
    if (indexPath.section == 0)
    {
        cell.nameLabel.text = @"华联天通苑店";
        cell.rightImageView.hidden = NO;
        cell.switchbtn.hidden = YES;
    }
    else if (indexPath.section == 1)
    {
        cell.nameLabel.text = @"自动定位";
        cell.rightImageView.hidden = YES;
        cell.switchbtn.hidden = NO;
    }
    else
    {
        BXTHeadquartersInfo *company = shopsArray[indexPath.row];
        cell.nameLabel.text = company.name;
        cell.rightImageView.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.switchbtn.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2)
    {
        BXTHeadquartersInfo *company = shopsArray[indexPath.row];
        BXTBranchViewController *branchVC = [[BXTBranchViewController alloc] initWithHeadquarters:company];
        [self.navigationController pushViewController:branchVC animated:YES];
    }
}

/**
 *  UISearchBarDelegate
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    for(id cc in [[[searchBar subviews] objectAtIndex:0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

/**
 *  BXTDataResponseDelegate
 */
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    NSArray *array = [dic objectForKey:@"data"];
    for (NSDictionary *dictionary in array)
    {
        DCParserConfiguration *config = [DCParserConfiguration configuration];
        DCObjectMapping *text = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"company_id" onClass:[BXTHeadquartersInfo class]];
        [config addObjectMapping:text];
        
        DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTHeadquartersInfo class] andConfiguration:config];
        BXTHeadquartersInfo *company = [parser parseDictionary:dictionary];
        
        [shopsArray addObject:company];
    }
    [currentTableView reloadData];
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
