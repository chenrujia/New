//
//  BXTEnergyReadingSearchViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/16.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyReadingSearchViewController.h"
#include <math.h>
#import "BXTHeaderForVC.h"
#import "BXTHeadquartersInfo.h"
#import "PinYinForObjc.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BXTEnergyMeterListInfo.h"
#import "BXTEnergyRecordTableViewCell.h"

@interface BXTEnergyReadingSearchViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UISearchBarDelegate, BXTDataResponseDelegate>
{
    NSString *searchStr;
    NSMutableArray *searchResults;
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView_Search;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *searchArray;

@end

@implementation BXTEnergyReadingSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationSetting:@"快捷抄表" andRightTitle:nil andRightImage:nil];
    
    [self createUI];
    
    [self getResource];
}
#pragma mark -
#pragma mark - getResource
- (void)getResource
{
//    [self showLoadingMBP:@"加载中..."];
//    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
//    [request energyMeterFavoriteListsWithType:@"" checkType:@"" page:1];
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
    self.tableView_Search = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT + 55, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 55) style:UITableViewStyleGrouped];
    self.tableView_Search.rowHeight = 106.f;
    self.tableView_Search.dataSource = self;
    self.tableView_Search.delegate = self;
    self.tableView_Search.emptyDataSetDelegate = self;
    self.tableView_Search.emptyDataSetSource = self;
    [self.view addSubview:self.tableView_Search];
    
    
    // UITableView - tableView_Search - tableHeaderView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.tableView_Search.tableHeaderView = headerView;
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
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel  setTintColor:[UIColor whiteColor]];
        }
    }
    
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
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchStr = searchText;
    
    NSArray *allPersonArray = self.dataArray;
    
    searchResults = [[NSMutableArray alloc]init];
    if (self.searchBar.text.length>0 && ![ChineseInclude isIncludeChineseInString:self.searchBar.text]) {
        
        for (int i=0; i<allPersonArray.count; i++) {
            BXTEnergyMeterListInfo *model = allPersonArray[i];
            
            if ([ChineseInclude isIncludeChineseInString:model.code_number]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:model.code_number];
                NSRange titleResult=[tempPinYinStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length > 0) {
                    [searchResults addObject:allPersonArray[i]];
                } else {
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:model.code_number]; NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length > 0) {
                        [searchResults addObject:allPersonArray[i]];
                    }
                }
            } else {
                NSRange titleResult=[model.code_number rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    [searchResults addObject:allPersonArray[i]];
                }
            }
        }
    } else if (self.searchBar.text.length > 0 && [ChineseInclude isIncludeChineseInString:self.searchBar.text]) {
        for (BXTEnergyMeterListInfo *model in allPersonArray) {
            NSRange titleResult=[model.code_number rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length > 0) {
                [searchResults addObject:model];
            }
        }
    }
    
    self.searchArray = searchResults;
    
    [self.tableView_Search reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
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
    if (self.searchArray.count == 0) {
    }
    if ([searchStr isEqualToString:@""]) {
    }
    return self.searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BXTEnergyRecordTableViewCell *cell = [BXTEnergyRecordTableViewCell cellWithTableView:tableView];
    
    cell.listInfo = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.tableView_Search)
    {
        BXTEnergyMeterListInfo *model = self.searchArray[indexPath.row];
        NSLog(@"--------%@", model.code_number);
        
        
        return;
    }
    
    
}

- (void)refreshAllInformWithShopID:(NSString *)shopID shopAddress:(NSString *)shopAddress {
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
    [self hideMBP];
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    
    if (type == MeterFavoriteLists)
    {
        [BXTEnergyMeterListInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"energyMeterID":@"id"};
        }];
        [self.dataArray addObjectsFromArray:[BXTEnergyMeterListInfo mj_objectArrayWithKeyValuesArray:data]];
    }
    
    [self.tableView_Search reloadData];
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