//
//  BXTMailListViewController.m
//  YouFeel
//
//  Created by Jason on 15/12/24.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTMailListViewController.h"
#import "BXTHeaderForVC.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "BXTMailListCell.h"
#import "BXTSearchData.h"
#import "BXTPersonInfromViewController.h"

typedef NS_ENUM(NSInteger, ImageViewType) {
    ImageViewType_Root,
    ImageViewType_Normal,
    ImageViewType_Selected
};

@interface BXTMailListViewController () <UISearchBarDelegate, BXTDataResponseDelegate, SKSTableViewDelegate>
{
    UIImageView *arrow;
    CGFloat groupBtnX;
}

@property(nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView_Search;
@property(nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIScrollView *subScrollView;
@property (nonatomic, strong)  SKSTableView *tableView;

@property(nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) NSMutableArray *subDataArray;
@property(nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation BXTMailListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetting:@"通讯录" andRightTitle:nil andRightImage:nil];
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.titleArray = [[NSMutableArray alloc] init];
    self.subDataArray = [[NSMutableArray alloc] init];
    self.searchArray = [[NSMutableArray alloc] init];
    groupBtnX = 0;
    
    [self showLoadingMBP:@"数据加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /** 通讯录列表 **/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request mailListOfAllPerson];
    });
    dispatch_async(concurrentQueue, ^{
        /** 通讯录搜索列表 **/
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request mailListOfUserList];
        });
    });
    
    [self createUI];
}

#pragma mark -
#pragma mark - 创建UI
- (void)createUI
{
    // UISearchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 55)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    [self.view addSubview:self.searchBar];
    
    // UITableView - tableView_Search
    self.tableView_Search = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.searchBar.frame)-50) style:UITableViewStyleGrouped];
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
    
    // headerView - bgView
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_HEIGHT, 50)];
    self.bgView.backgroundColor = colorWithHexString(@"#ffb648");
    self.bgView.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    self.bgView.layer.borderWidth = 0.5;
    [self.view addSubview:self.bgView];
    
    
    // 顶部视图
    UIButton *rootBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 105, 50)];
    [rootBtn setTitle:@"组织机构" forState:UIControlStateNormal];
    rootBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    rootBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    rootBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [rootBtn setTitleColor:colorWithHexString(@"#ffffff") forState:UIControlStateNormal];
    [[rootBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        for (UIView *view in self.subScrollView.subviews) {
            [view removeFromSuperview];
            self.subScrollView.contentSize = CGSizeMake(0, 50);
            groupBtnX = 0;
            [self ergodicArray:self.dataArray];
        }
        [self reloadTableView];
    }];
    [self.bgView addSubview:rootBtn];
    
    
    // headerView - UIScrollView
    self.subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(89, 0, SCREEN_WIDTH-90, 50)];
    self.subScrollView.backgroundColor = colorWithHexString(@"#ffb648");
    self.subScrollView.showsHorizontalScrollIndicator = NO;
    [self.bgView addSubview:self.subScrollView];
    
    
    // UITableView - tableView
    self.tableView = [[SKSTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bgView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.bgView.frame) - 50) style:UITableViewStyleGrouped];
    self.tableView.SKSTableViewDelegate = self;
    [self.view addSubview:self.tableView];
    
    [self showTableViewAndHideSearchTableView:YES];
}

#pragma mark -
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //[self.searchArray removeAllObjects];
    //    [self.tableView_search reloadData];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSArray *allPersonArray = [BXTGlobal readFileWithfileName:@"MailUserList"];
    
    // TODO: -----------------  目前只判断第一字母 待优化  -----------------
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in allPersonArray) {
        BXTSearchData *model = [BXTSearchData modelObjectWithDictionary:dict];
        NSLog(@"------- %@", model.nameShort);
        if ([[model.nameShort substringToIndex:1] isEqualToString:[self getNamePinYin:searchBar.text].lowercaseString]) {
            [searchArray addObject:dict];
        }
    }
    
    self.searchArray = searchArray;
    
    NSLog(@"------- %@", self.searchArray);
    
    [self.tableView_Search reloadData];
    
    [self.view endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView_Search) {
        return self.searchArray.count;
    }
    return self.titleArray.count;
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.subDataArray[indexPath.row] count] - 1;
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView_Search) {
        static NSString *cellID = @"cellSearch";
        BXTMailListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTMailListCell" owner:nil options:nil] lastObject];
        }
        
        NSDictionary *dict = self.searchArray[indexPath.row];
        BXTSearchData *model = [BXTSearchData modelObjectWithDictionary:dict];
        cell.nameView.text = model.name;
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"SKSTableViewCell";
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    BXTMailListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTMailListCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameView.text = self.subDataArray[indexPath.row][indexPath.subRow];
    
    return cell;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView_Search) {
        return 60.f;
    }
    return 50.0f;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView_Search) {
        BXTPersonInfromViewController *pivc = [[BXTPersonInfromViewController alloc] init];
        pivc.userID = @"1";
        [self.navigationController pushViewController:pivc animated:YES];
        
        [self showTableViewAndHideSearchTableView:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    NSArray *array = self.subDataArray[indexPath.row];
    
    if (array.count == 1) {
        [self.titleArray removeAllObjects];
        [self.subDataArray removeAllObjects];
        [self.titleArray addObject:@"2级分组"];
        [self.titleArray addObject:@"iOS分组"];
        [self.titleArray addObject:@"Android分组"];
        [self.subDataArray addObject:@[@"", @"测试1",@"测试2"]];
        [self.subDataArray addObject:@[@"", @"满意"]];
        [self.subDataArray addObject:@[@"", @"圣骑", @"大海"]];
        
        [self reloadTableView];
        UIButton *button = [self createShowButtonTitle:@"子部门已"];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *subBtn) {
            for (UIView *subView in self.subScrollView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    if (subBtn.frame.origin.x < subView.frame.origin.x) {
                        [subView removeFromSuperview];
                        [subBtn setBackgroundImage:[UIImage imageNamed:@"mail_rectangle_selected"] forState:UIControlStateNormal];
                        self.subScrollView.contentSize = CGSizeMake(subBtn.frame.origin.x + subBtn.frame.size.width, 50);
                        groupBtnX = subBtn.frame.origin.x;
                    }
                }
            }
        }];
    }
    
    NSLog(@"Section: %ld, Row:%ld, Subrow:%ld", (long)indexPath.section, (long)indexPath.row, (long)indexPath.subRow);
}

- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BXTPersonInfromViewController *pivc = [[BXTPersonInfromViewController alloc] init];
    pivc.userID = @"1";
    pivc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pivc animated:YES];
    
    NSLog(@"Section: %ld, Row:%ld, Subrow:%ld", (long)indexPath.section, (long)indexPath.row, (long)indexPath.subRow);
}

#pragma mark - Actions
- (void)undoData
{
    [self reloadTableView];
    
    [self setDataManipulationButton:UIBarButtonSystemItemRefresh];
}

- (void)reloadTableView
{
    [self.tableView refreshDataWithScrollingToIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [self setDataManipulationButton:UIBarButtonSystemItemUndo];
}

#pragma mark - Helpers
- (void)setDataManipulationButton:(UIBarButtonSystemItem)item
{
    switch (item) {
        case UIBarButtonSystemItemUndo:
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoData)];
            break;
        default:
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
            break;
    }
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == Mail_Get_All && data.count > 0)
    {
        [self hideMBP];
        self.dataArray = data;
        [self ergodicArray:data];
    }
    else if (type == Mail_User_list)
    {
        [BXTGlobal writeFileWithfileName:@"MailUserList" Array:dic[@"data"]];
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

- (void)ergodicArray:(NSArray *)subArray
{
    [self.titleArray removeAllObjects];
    [self.subDataArray removeAllObjects];
    for (NSDictionary *dict in subArray)
    {
        [self.titleArray addObject:dict[@"name"]];
        
        NSArray *user_listArray = dict[@"user_list"];
        NSMutableArray *subPersonArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
        for (NSDictionary *subDict in user_listArray) {
            [subPersonArray addObject:subDict[@"name"]];
        }
        [self.subDataArray addObject:subPersonArray];
    }
    
    [self reloadTableView];
    
    
    NSLog(@"%@", self.titleArray);
    NSLog(@"%@", self.subDataArray);
}

#pragma mark -
#pragma mark - 自定义方法
- (UIButton *)createShowButtonTitle:(NSString *)title
{
    UIButton *groupBtn = [[UIButton alloc] initWithFrame:CGRectMake(groupBtnX, 0, 120, 50)];
    [groupBtn setTitle:title forState:UIControlStateNormal];
    groupBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [groupBtn setTitleColor:colorWithHexString(@"#ffffff") forState:UIControlStateNormal];
    [groupBtn setBackgroundImage:[UIImage imageNamed:@"mail_rectangle_selected"] forState:UIControlStateNormal];
    [self.subScrollView addSubview:groupBtn];
    
    for (UIView *subView in self.subScrollView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [(UIButton *)subView setBackgroundImage:[UIImage imageNamed:@"mail_rectangle_normal"] forState:UIControlStateNormal];
        }
    }
    
    UIButton *lastButton = self.subScrollView.subviews.lastObject;
    [lastButton setBackgroundImage:[UIImage imageNamed:@"mail_rectangle_selected"] forState:UIControlStateNormal];
    self.subScrollView.contentSize = CGSizeMake(lastButton.frame.origin.x + lastButton.frame.size.width, 50);
    groupBtnX = lastButton.frame.origin.x + 90;
    
    return groupBtn;
}

// 列表和搜索列表显示类
- (void)showTableViewAndHideSearchTableView:(BOOL)isRight
{
    if (isRight) {
        self.tableView_Search.hidden = YES;
        self.tableView.hidden = NO;
        self.bgView.hidden = NO;
    } else {
        self.tableView_Search.hidden = NO;
        self.tableView.hidden = YES;
        self.bgView.hidden = YES;
    }
}

// 获取真实名字的第一个字的首字母
- (NSString *)getNamePinYin:(NSString *)searchName
{
    NSString *S = [self phonetic:searchName];
    return [self phonetic:[S uppercaseString]];
}

- (NSString *)phonetic:(NSString *)sourceString
{
    if (sourceString.length <= 0) return @"";
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSString  *current = [source substringToIndex:1];
    return current;
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
