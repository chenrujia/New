//
//  BXTEnergyReadingSearchViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/16.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyReadingSearchViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTHeadquartersInfo.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BXTEnergyMeterListInfo.h"
#import "BXTEnergyRecordTableViewCell.h"
#import "BXTMeterReadingRecordViewController.h"
#import <MJRefresh.h>

@interface BXTEnergyReadingSearchViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UISearchBarDelegate, BXTDataResponseDelegate>

@property (nonatomic, strong) UISearchBar    *searchBar;
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger      transPushType;

@property (nonatomic, copy  ) NSString        *introInfo;
@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation BXTEnergyReadingSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"搜索计量表" andRightTitle:nil andRightImage:nil];
    self.dataArray = [[NSMutableArray alloc] init];
    [self createUI];
}

- (instancetype)initWithSearchPushType:(SearchPushType)pushType
{
    self = [super init];
    if (self)
    {
        self.transPushType = pushType;
    }
    return self;
}

#pragma mark -
#pragma mark - getResource
- (void)getResourceWithPushType:(SearchPushType)pushType SearchName:(NSString *)searchName
{
    [BXTGlobal showLoadingMBP:@"搜索中..."];
    if (pushType == SearchPushTypeOFQuick)
    {
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request energyMeterFavoriteListsWithType:@"" checkType:@"" page:self.currentPage searchName:searchName];
    }
    else
    {
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request energyMeterListsWithType:[NSString stringWithFormat:@"%ld", (long)pushType]
                                checkType:@""
                                priceType:@""
                                  placeID:@""
                          measurementPath:@""
                               searchName:searchName
                                     page:self.currentPage];
        
    }
}

#pragma mark -
#pragma mark 初始化视图
- (void)createUI
{
    // UISearchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, 55)];
    self.searchBar.delegate = self;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    [self.view addSubview:self.searchBar];
    
    // UITableView - tableView_Search
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT + 55, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 55) style:UITableViewStyleGrouped];
    self.tableView.rowHeight = 106.f;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self.view addSubview:self.tableView];
    
    // UITableView - tableView_Search - tableHeaderView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.tableView.tableHeaderView = headerView;
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 30)];
    alertLabel.text = @"搜索结果：";
    alertLabel.textColor = colorWithHexString(@"#666666");
    alertLabel.font = [UIFont systemFontOfSize:15];
    alertLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:alertLabel];
}

#pragma mark -
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"should begin");
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews])
    {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]])
        {
            UIButton * cancel =(UIButton *)view;
            [cancel  setTintColor:[UIColor whiteColor]];
        }
    }
    
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
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
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([BXTGlobal isBlankString:searchBar.text])
    {
        if (self.dataArray.count != 0)
        {
            [self.dataArray removeAllObjects];
        }
        [self.tableView reloadData];
        
        return;
    }
    
    self.searchText = searchBar.text;
    
    self.currentPage = 1;
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf getResourceWithPushType:self.transPushType SearchName:searchBar.text];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf getResourceWithPushType:self.transPushType SearchName:searchBar.text];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

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
    BXTEnergyRecordTableViewCell *cell = [BXTEnergyRecordTableViewCell cellWithTableView:tableView];
    cell.listInfo = self.dataArray[indexPath.row];
    @weakify(self);
    [[cell.starView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        // 收藏按钮设置
        self.introInfo = [cell.listInfo.is_collect integerValue] == 1 ? @"取消收藏成功" : @"收藏成功";
        
        [BXTGlobal showLoadingMBP:@"数据加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request energyMeterFavoriteAddWithAboutID:cell.listInfo.energyMeterID delIDs:@""];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BXTMeterReadingRecordViewController *mrrvc = [[BXTMeterReadingRecordViewController alloc] init];
    BXTEnergyMeterListInfo *listInfo = self.dataArray[indexPath.row];
    mrrvc.transID = listInfo.energyMeterID;
    [self.navigationController pushViewController:mrrvc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)refreshAllInformWithShopID:(NSString *)shopID shopAddress:(NSString *)shopAddress
{
    BXTHeadquartersInfo *companyInfo = [[BXTHeadquartersInfo alloc] init];
    companyInfo.company_id = shopID;
    companyInfo.name = shopAddress;
    [BXTGlobal setUserProperty:companyInfo withKey:U_COMPANY];
    
    NSString *url = [NSString stringWithFormat:@"%@&shop_id=%@&token=%@",KAPIBASEURL, shopID, [BXTGlobal getUserProperty:U_TOKEN]];
    [BXTGlobal shareGlobal].baseURL = url;
}

#pragma mark -
#pragma mark DZNEmptyDataSetDelegate & DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"抱歉，没有找到相关抄表";
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor blackColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    
    if (type == MeterFavoriteLists || type == EnergyMeterLists)
    {
        if (self.currentPage == 1 && self.dataArray.count != 0)
        {
            [self.dataArray removeAllObjects];
        }
        
        [BXTEnergyMeterListInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"energyMeterID":@"id"};
        }];
        [self.dataArray addObjectsFromArray:[BXTEnergyMeterListInfo mj_objectArrayWithKeyValuesArray:data]];
    }
    else if (type == MeterFavoriteAdd && [dic[@"returncode"] integerValue] == 0)
    {
        @weakify(self);
        [BXTGlobal showText:self.introInfo completionBlock:^{
            @strongify(self);
            if (self.delegateSignal) {
                [self.delegateSignal sendNext:nil];
            }
            self.currentPage = 1;
            [self.tableView.mj_header beginRefreshing];
        }];
    }
    
    [self.tableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
