//
//  BXTChooseListViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/9.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTChooseListViewController.h"
#import "BXTProjectAddNewCell.h"
#include <math.h>
#import "BXTHeaderForVC.h"
#import "PinYinForObjc.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BXTStoresListsInfo.h"

#define NavBarHeight 120.f

@interface BXTChooseListViewController () <UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,UISearchBarDelegate,BXTDataResponseDelegate>
{
    /** ---- 附近项目 ---- */
    NSMutableArray    *locationShopsArray;
    UITableView       *currentTableView;
    
    NSMutableArray    *searchResults;
    NSString          *searchStr;
}

@property (nonatomic, assign) BOOL           isOpenLocationProject;
@property (nonatomic, strong) UISearchBar    *searchBar;

@property (nonatomic, strong) UITableView    *tableView_Search;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) NSMutableArray *allPersonArray;

@end

@implementation BXTChooseListViewController

- (void)dealloc
{
    LogBlue(@"Header界面释放了！！！！！！");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.isOpenLocationProject = YES;
    locationShopsArray = [NSMutableArray array];
    self.allPersonArray = [[NSMutableArray alloc] init];
    
    
    [self navigationSetting:@"添加新项目" andRightTitle:nil andRightImage:nil];
    
    [self createTableView];
    
    [self showLoadingMBP:@"努力加载中..."];
    /**请求分店位置**/
    BXTDataRequest *dep_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [dep_request listOFStoresWithStoresName:@""];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createTableView
{
    // UISearchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, 55)];
    self.searchBar.delegate = self;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"快速查找";
    [self.view addSubview:self.searchBar];
    
    self.searchBar.backgroundColor = colorWithHexString(NavColorStr);
    self.searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:self.searchBar.bounds.size];
    
    // UITableView
    currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT + 55, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 55) style:UITableViewStyleGrouped];
    [currentTableView registerClass:[BXTProjectAddNewCell class] forCellReuseIdentifier:@"BXTProjectAddNewCell"];
    currentTableView.rowHeight = 50;
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    [self.view addSubview:currentTableView];
    
    // UITableView - tableView_Search
    self.tableView_Search = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 55) style:UITableViewStyleGrouped];
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
    
    [self showTableViewAndHideSearchTableView:YES];
}


- (void)switchAction:(UISwitch *)switchBtn
{
    self.isOpenLocationProject = switchBtn.on;
    [currentTableView reloadData];
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
    
    [self showTableViewAndHideSearchTableView:NO];
    
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
    searchStr = searchText;
    
    NSArray *allPersonArray = self.allPersonArray;
    
    searchResults = [[NSMutableArray alloc]init];
    if (self.searchBar.text.length>0 && ![ChineseInclude isIncludeChineseInString:self.searchBar.text]) {
        
        for (int i=0; i<allPersonArray.count; i++) {
            BXTHeadquartersInfo *model = [BXTHeadquartersInfo modelObjectWithDictionary:allPersonArray[i]];
            
            if ([ChineseInclude isIncludeChineseInString:model.name]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:model.name];
                NSRange titleResult=[tempPinYinStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length > 0) {
                    [searchResults addObject:allPersonArray[i]];
                } else {
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:model.name]; NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length > 0) {
                        [searchResults addObject:allPersonArray[i]];
                    }
                }
            } else {
                NSRange titleResult=[model.name rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    [searchResults addObject:allPersonArray[i]];
                }
            }
        }
    } else if (self.searchBar.text.length > 0 && [ChineseInclude isIncludeChineseInString:self.searchBar.text]) {
        for (NSDictionary *dict in allPersonArray) {
            BXTHeadquartersInfo *model = [BXTHeadquartersInfo modelObjectWithDictionary:dict];
            NSRange titleResult=[model.name rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length > 0) {
                [searchResults addObject:dict];
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
        return 0.1;
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
    if (tableView == self.tableView_Search) {
        if (self.searchArray.count == 0) {
        }
        if ([searchStr isEqualToString:@""]) {
        }
        return self.searchArray.count;
    }
    
    if (self.isOpenLocationProject) {
        // 如果没有项目， 建议打开定位
        if (locationShopsArray.count == 0) {
            return 2;
        }
        return 1 + locationShopsArray.count;
    }
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView_Search) {
        static NSString *cellID = @"cellSearch";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        
        NSDictionary *dict = self.searchArray[indexPath.row];
        BXTHeadquartersInfo *infoModel = [BXTHeadquartersInfo modelObjectWithDictionary:dict];
        cell.textLabel.text = infoModel.name;
        
        return cell;
    }
    
    static NSString *cellID = @"cell";
    BXTProjectAddNewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BXTProjectAddNewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.switchbtn.hidden = YES;
    cell.rightImageView.hidden = YES;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.nameLabel.text = @"附近项目";
            cell.switchbtn.hidden = NO;
            [cell.switchbtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        }
        else
        {
            if (locationShopsArray.count == 0)
            {
                cell.nameLabel.text = @"未能获取您的位置，请开启定位";
                cell.nameLabel.textColor = colorWithHexString(@"#666666");
                cell.nameLabel.frame = CGRectMake(15., 10., SCREEN_WIDTH-30, 30);
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else
            {
                BXTStoresListsInfo *company = locationShopsArray[indexPath.row-1];
                cell.nameLabel.textColor = colorWithHexString(@"#000000");
//                cell.nameLabel.text = company.sto ;
                cell.rightImageView.hidden = NO;
            }
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView_Search)
    {
        NSDictionary *dict = self.searchArray[indexPath.row];
        BXTHeadquartersInfo *infoModel = [BXTHeadquartersInfo modelObjectWithDictionary:dict];
        
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    if (indexPath.section == 0 && indexPath.row != 0) {
        if (locationShopsArray.count == 0) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        else {
            
        }
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark DZNEmptyDataSetDelegate & DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"抱歉，没有找到相关项目";
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
    NSArray *array = [dic objectForKey:@"data"];
    
    if (type == StoresList)
    {
        [locationShopsArray removeAllObjects];
        [self.allPersonArray removeAllObjects];
        [BXTStoresListsInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"storeID":@"id"};
        }];
        [locationShopsArray addObjectsFromArray:[BXTHeadquartersInfo mj_objectArrayWithKeyValuesArray:array]];
        [self.allPersonArray addObjectsFromArray:array];
    }
    
    
    [currentTableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
}

#pragma mark -
#pragma mark - 取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// 列表和搜索列表显示类
- (void)showTableViewAndHideSearchTableView:(BOOL)isRight
{
    if (isRight)
    {
        self.tableView_Search.hidden = YES;
        currentTableView.hidden = NO;
    }
    else
    {
        self.tableView_Search.hidden = NO;
        currentTableView.hidden = YES;
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
