//
//  BXTMailRootViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMailRootViewController.h"
#import "BXTMailListViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTMailRootInfo.h"
#import "PinYinForObjc.h"
#import "BXTMailListModel.h"

@interface BXTMailRootViewController () <BXTDataResponseDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate>

@property(nonatomic, strong) UISearchBar *searchBar;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView_Search;
@property (nonatomic, strong) NSMutableArray *searchArray;

@end

@implementation BXTMailRootViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"通讯录(商铺)" andRightTitle:nil andRightImage:nil];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self createUI];
    
    [self showLoadingMBP:@"数据加载中..."];
    /** 通讯录列表 **/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request mailListOfAllPerson];
}

#pragma mark -
#pragma mark 设置导航条
- (UIImageView *)navigationSetting:(NSString *)title
                     andRightTitle:(NSString *)right_title
                     andRightImage:(UIImage *)image
{
    self.view.backgroundColor = colorWithHexString(@"eff3f6");
    
    UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KNAVIVIEWHEIGHT)];
    
    naviView.image = [[UIImage imageNamed:@"Nav_Bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    
    naviView.userInteractionEnabled = YES;
    [self.view addSubview:naviView];
    
    UILabel *navi_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 20, SCREEN_WIDTH-128, 44)];
    navi_titleLabel.font = [UIFont systemFontOfSize:17];
    navi_titleLabel.textColor = [UIColor whiteColor];
    navi_titleLabel.textAlignment = NSTextAlignmentCenter;
    navi_titleLabel.text = title;
    [naviView addSubview:navi_titleLabel];
    
    
    UIButton *navi_leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navi_leftButton.frame = CGRectMake(6, 20, 44, 44);
    [navi_leftButton setImage:[UIImage imageNamed:@"arrowBack"] forState:UIControlStateNormal];
    @weakify(self);
    [[navi_leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [naviView addSubview:navi_leftButton];
    
    return naviView;
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // UISearchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 55)];
    //self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    [self.view addSubview:self.searchBar];
    
    // UITableView - tableView_Search
    self.tableView_Search = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.searchBar.frame)) style:UITableViewStyleGrouped];
    self.tableView_Search.dataSource = self;
    self.tableView_Search.delegate = self;
    [self.view addSubview:self.tableView_Search];
    
    // UITableView - tableView_Search - tableHeaderView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.tableView_Search.tableHeaderView = headerView;
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 30)];
    alertLabel.text = @"您可能要找的是：";
    alertLabel.textColor = colorWithHexString(@"#666666");
    alertLabel.font = [UIFont systemFontOfSize:15];
    alertLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:alertLabel];
    
    // UITableView - tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.searchBar.frame) - 50) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self showTableViewAndHideSearchTableView:YES];
}

#pragma mark -
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"should begin");
    
    searchBar.showsCancelButton = YES;
    [self showTableViewAndHideSearchTableView:NO];
    [self.tableView_Search reloadData];
    
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    NSLog(@"did begin");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    NSLog(@"did end");
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [self showTableViewAndHideSearchTableView:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // 获取存值
    NSArray *allPersonArray = [BXTGlobal readFileWithfileName:@"MailUserList"];
    
    NSMutableArray *searchResults = [[NSMutableArray alloc]init];
    if (self.searchBar.text.length>0 && ![ChineseInclude isIncludeChineseInString:self.searchBar.text])
    {
        
        for (int i=0; i<allPersonArray.count; i++)
        {
            BXTMailListModel *model = [BXTMailListModel modelWithDict:allPersonArray[i]];
            
            if ([ChineseInclude isIncludeChineseInString:model.name])
            {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:model.name];
                NSRange titleResult=[tempPinYinStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length > 0)
                {
                    [searchResults addObject:allPersonArray[i]];
                }
                else
                {
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:model.name]; NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length > 0) {
                        [searchResults addObject:allPersonArray[i]];
                    }
                }
            }
            else
            {
                NSRange titleResult=[model.name rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0)
                {
                    [searchResults addObject:allPersonArray[i]];
                }
            }
        }
    }
    else if (self.searchBar.text.length > 0 && [ChineseInclude isIncludeChineseInString:self.searchBar.text])
    {
        for (NSDictionary *dict in allPersonArray)
        {
            BXTMailListModel *model = [BXTMailListModel modelWithDict:dict];
            NSRange titleResult=[model.name rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length > 0)
            {
                [searchResults addObject:dict];
            }
        }
    }
    
    self.searchArray = searchResults;
    
    [self.tableView_Search reloadData];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    BXTMailRootInfo *mail = self.dataArray[indexPath.row];
    cell.textLabel.text = mail.shop_name;
    
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
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTMailListViewController *mlvc = [[BXTMailListViewController alloc] init];
    mlvc.transMailInfo = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:mlvc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    
    if (type == Mail_Get_All && data.count > 0)
    {
        for (NSDictionary *dict in data) {
            BXTMailRootInfo *mail = [BXTMailRootInfo modelWithDict:dict];
            [self.dataArray addObject:mail];
        }
        [self.tableView reloadData];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
}

#pragma mark -
#pragma mark - 方法
- (void)showLoadingMBP:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.delegate = self;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
}

- (void)hideMBP
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

// 列表和搜索列表显示类
- (void)showTableViewAndHideSearchTableView:(BOOL)isRight
{
    if (isRight) {
        self.tableView_Search.hidden = YES;
        self.tableView.hidden = NO;
    }
    else {
        self.tableView_Search.hidden = NO;
        self.tableView.hidden = YES;
    }
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
