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

#define NavBarHeight 120.f

@interface BXTChooseListViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UISearchBarDelegate, BXTDataResponseDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
// switch是否打开
@property (nonatomic, assign) BOOL isSwitchOn;

@property (nonatomic, strong) UITableView *tableView_Search;
@property (nonatomic, strong) NSMutableArray *searchArray;
// 存储所有可搜索数据
@property (nonatomic, strong) NSMutableArray *allDataArray;

@end

@implementation BXTChooseListViewController

- (void)dealloc
{
    LogBlue(@"Header界面释放了！！！！！！");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO: -----------------  调试  -----------------
    if (self.typeOfPush == PushType_Department) {
        [self navigationSetting:@"所属" andRightTitle:nil andRightImage:nil];
    }
    else if (self.typeOfPush == PushType_Location) {
        [self navigationSetting:@"常用位置" andRightTitle:nil andRightImage:nil];
    }
    
    self.isSwitchOn = YES;
    self.dataArray = [NSMutableArray array];
    self.allDataArray = [[NSMutableArray alloc] init];
    
    [self createUI];
    
    [BXTGlobal showLoadingMBP:@"加载中..."];
    /**请求分店位置**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
  
    // TODO: -----------------  调试  -----------------
    if (self.typeOfPush == PushType_Department) {
        [request listOFStoresWithStoresName:@""];
    }
    else if (self.typeOfPush == PushType_Location) {
        [request listOFStoresPlaceWithStoresID:self.transID];
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
    self.searchBar.placeholder = @"快速查找";
    [self.view addSubview:self.searchBar];
    
    self.searchBar.backgroundColor = colorWithHexString(NavColorStr);
    self.searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:self.searchBar.bounds.size];
    
    
    // UITableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT + 55, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 55) style:UITableViewStyleGrouped];
    [self.tableView registerClass:[BXTProjectAddNewCell class] forCellReuseIdentifier:@"BXTProjectAddNewCell"];
    self.tableView.rowHeight = 50;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
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

#pragma mark -
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"should begin");
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton *cancel =(UIButton *)view;
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
    NSArray *allPersonArray = self.allDataArray;
    
    NSMutableArray *searchResults = [[NSMutableArray alloc]init];
    if (self.searchBar.text.length>0 && ![ChineseInclude isIncludeChineseInString:self.searchBar.text]) {
        
        for (int i=0; i<allPersonArray.count; i++) {
            
            // TODO: -----------------  调试  -----------------
            NSString *searchNameText;
            if (self.typeOfPush == PushType_Department) {
                BXTStoresListsInfo *model = allPersonArray[i];
                searchNameText = model.stores_name;
            }
            else if (self.typeOfPush == PushType_Location) {
                BXTPlaceListInfo *model = allPersonArray[i];
                searchNameText = model.place_name;
            }
            
            
            if ([ChineseInclude isIncludeChineseInString:searchNameText]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:searchNameText];
                NSRange titleResult=[tempPinYinStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length > 0) {
                    [searchResults addObject:allPersonArray[i]];
                } else {
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:searchNameText]; NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length > 0) {
                        [searchResults addObject:allPersonArray[i]];
                    }
                }
            } else {
                NSRange titleResult=[searchNameText rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    [searchResults addObject:allPersonArray[i]];
                }
            }
        }
    } else if (self.searchBar.text.length > 0 && [ChineseInclude isIncludeChineseInString:self.searchBar.text]) {
        
        // TODO: -----------------  调试  -----------------
        if (self.typeOfPush == PushType_Department) {
            for (BXTStoresListsInfo *model in allPersonArray) {
                NSRange titleResult=[model.stores_name rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    [searchResults addObject:model];
                }
            }
        }
        else if (self.typeOfPush == PushType_Location) {
            for (BXTPlaceListInfo *model in allPersonArray) {
                NSRange titleResult=[model.place_name rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    [searchResults addObject:model];
                }
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
        return self.searchArray.count;
    }
    
    if (self.isSwitchOn) {
        // 如果没有项目， 建议打开定位
        if (self.dataArray.count == 0) {
            return 2;
        }
        return 1 + self.dataArray.count;
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
        
        // TODO: -----------------  调试  -----------------
        if (self.typeOfPush == PushType_Department) {
            BXTStoresListsInfo *infoModel = self.searchArray[indexPath.row];
            cell.textLabel.text = infoModel.stores_name;
        }
        else if (self.typeOfPush == PushType_Location) {
            BXTPlaceListInfo *infoModel = self.searchArray[indexPath.row];
            cell.textLabel.text = infoModel.place_name;
        }
        
        
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
    cell.rightAddView.hidden = YES;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.nameLabel.text = @"手动选择部门";
            cell.switchbtn.hidden = NO;
            @weakify(self);
            [[cell.switchbtn rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *switchBtn) {
                @strongify(self);
                self.isSwitchOn = switchBtn.on;
                [self.tableView reloadData];
            }];
        }
        else
        {
            if (self.dataArray.count == 0)
            {
                cell.nameLabel.text = @"暂无部门";
                cell.nameLabel.textColor = colorWithHexString(@"#666666");
                cell.nameLabel.frame = CGRectMake(15., 10., SCREEN_WIDTH-30, 30);
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else
            {
                // TODO: -----------------  调试  -----------------
                if (self.typeOfPush == PushType_Department) {
                    BXTStoresListsInfo *company = self.dataArray[indexPath.row-1];
                    cell.nameLabel.text = company.stores_name ;
                }
                else if (self.typeOfPush == PushType_Location) {
                    BXTPlaceListInfo *company = self.dataArray[indexPath.row-1];
                    cell.nameLabel.text = company.place_name;
                }
                
                cell.nameLabel.textColor = colorWithHexString(@"#000000");
                cell.rightImageView.hidden = NO;
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // TODO: -----------------  调试  -----------------
    if (indexPath.section + indexPath.row != 0) {
        if (self.typeOfPush == PushType_Department) {
            BXTStoresListsInfo *storeInfo;
            if (tableView == self.tableView_Search) {
                storeInfo = self.searchArray[indexPath.row];
            } else {
                if (indexPath.row != 0 && self.dataArray.count != 0) {
                    storeInfo = self.dataArray[indexPath.row-1];
                }
            }
            if (self.delegateSignal) {
                [self.delegateSignal sendNext:storeInfo];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else if (self.typeOfPush == PushType_Location) {
            BXTPlaceListInfo *storeInfo;
            if (tableView == self.tableView_Search) {
                storeInfo = self.searchArray[indexPath.row];
            } else {
                if (indexPath.row != 0 && self.dataArray.count != 0) {
                    storeInfo = self.dataArray[indexPath.row-1];
                }
            }
            if (self.delegateSignal) {
                [self.delegateSignal sendNext:storeInfo];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    
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
    [BXTGlobal hideMBP];
    NSDictionary *dic = response;
    NSArray *array = [dic objectForKey:@"data"];
    
    if (type == StoresList && array.count != 0)
    {
        [self.dataArray removeAllObjects];
        [self.allDataArray removeAllObjects];
        
        [BXTStoresListsInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"storeID":@"id"};
        }];
        [self.dataArray addObjectsFromArray:[BXTStoresListsInfo mj_objectArrayWithKeyValuesArray:array]];
        [self.allDataArray addObjectsFromArray:[BXTStoresListsInfo mj_objectArrayWithKeyValuesArray:array]];
    }
    else if (type == ListOFStoresPlace && array.count != 0)
    {
        [self.dataArray removeAllObjects];
        [self.allDataArray removeAllObjects];
        
        [BXTPlaceListInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"placeID":@"id"};
        }];
        [self.dataArray addObjectsFromArray:[BXTPlaceListInfo mj_objectArrayWithKeyValuesArray:array]];
        [self.allDataArray addObjectsFromArray:[BXTPlaceListInfo mj_objectArrayWithKeyValuesArray:array]];
    }
    
    [self.tableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
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
