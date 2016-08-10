//
//  BXTEnergyReadingQuickViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyReadingQuickViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BXTEnergyMeterListInfo.h"
#import "BXTEnergyRecordTableViewCell.h"
#import "DOPDropDownMenu.h"
#import "BXTEnergyReadingSearchViewController.h"
#import <MJRefresh.h>
#import "BXTMeterReadingRecordViewController.h"

@interface BXTEnergyReadingQuickViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, BXTDataResponseDelegate, DOPDropDownMenuDelegate, DOPDropDownMenuDataSource>

@property (nonatomic, strong) DOPDropDownMenu *menu;

@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, strong) NSMutableArray *modeArray;

@property (nonatomic, copy) NSString *typeStr;
@property (nonatomic, copy) NSString *checkTypeStr;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, copy) NSString *introInfo;

/** ---- 是否全选 ---- */
@property (nonatomic ,assign)BOOL isAllSelected;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *selectAllBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (strong, nonatomic) NSMutableArray *selectedArray;

@end

@implementation BXTEnergyReadingQuickViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"快捷抄表" andRightTitle:@"    编辑" andRightImage:nil];
    self.dataArray = [[NSMutableArray alloc] init];
    self.selectedArray = [[NSMutableArray alloc] init];
    self.typeStr = @"";
    self.checkTypeStr = @"";
    [self createUI];
    
    self.currentPage = 1;
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf getResource];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf getResource];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:REFRESHTABLEVIEWOFLIST object:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.currentPage = 1;
        [weakSelf getResource];
    }];
}

- (void)navigationRightButton
{
    [self changeSelectedState:self.tableView.isEditing];
}

- (void)changeSelectedState:(BOOL)selectedState
{
    if (selectedState)
    {
        [self navigationSetting:@"快捷抄表" andRightTitle:@"    编辑" andRightImage:nil];
        [self.tableView setEditing:NO animated:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.menu.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.menu.frame));
            self.footerView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT + 25);
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [self navigationSetting:@"快捷抄表" andRightTitle:@"    取消" andRightImage:nil];
        [self.tableView setEditing:YES animated:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.menu.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.menu.frame) - 50);
            self.footerView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 25);
        } completion:^(BOOL finished) {
            self.isAllSelected = NO;
        }];
    }
}

#pragma mark -
#pragma mark - getResource
- (void)getResource
{
    [self showLoadingMBP:@"加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request energyMeterFavoriteListsWithType:self.typeStr checkType:self.checkTypeStr page:self.currentPage searchName:@""];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createUI
{
    // UISearchBar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, 55)];
    searchBar.placeholder = @"搜索";
    [self.view addSubview:searchBar];
    // searchBtn
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:searchBar.frame];
    @weakify(self);
    [[searchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTEnergyReadingSearchViewController *erqsvc = [[BXTEnergyReadingSearchViewController alloc] initWithSearchPushType:SearchPushTypeOFQuick];
        [self.navigationController pushViewController:erqsvc animated:YES];
    }];
    [self.view addSubview:searchBtn];
    
    // 添加下拉菜单
    self.typeArray = [[NSMutableArray alloc] initWithObjects:@"计量表类型", @"电能表", @"水表", @"燃气表", @"热能表", nil];
    self.modeArray = [[NSMutableArray alloc] initWithObjects:@"抄表方式", @"手动抄表", @"自动抄表", nil];
    self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, CGRectGetMaxY(searchBar.frame)) andHeight:44];
    self.menu.delegate = self;
    self.menu.dataSource = self;
    [self.view addSubview:self.menu];
    
    // UITableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.menu.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.menu.frame)) style:UITableViewStyleGrouped];
    self.tableView.rowHeight = 106.f;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.view addSubview: self.tableView];
    
    // self.footerView
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
    self.footerView.backgroundColor = colorWithHexString(@"#F6F7F9");
    self.footerView.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    self.footerView.layer.borderWidth = 0.5;
    [self.view addSubview:self.footerView];
    
    self.selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectAllBtn.frame = CGRectMake(0, 5, 80, 40);
    [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectAllBtn setTitleColor:colorWithHexString(@"#5BABF5") forState:UIControlStateNormal];
    [self.footerView addSubview:self.selectAllBtn];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.frame = CGRectMake(SCREEN_WIDTH - 80, 5, 80, 40);
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:colorWithHexString(@"#5BABF5") forState:UIControlStateNormal];
    [self.footerView addSubview:self.deleteBtn];
    
    [[self.selectAllBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.isAllSelected = !self.isAllSelected;
        for (int i = 0; i<self.dataArray.count; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            if (self.isAllSelected)
            {   // 全选
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
            else
            {    //反选
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
    }];
    
    [[self.deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [MYAlertAction showAlertWithTitle:@"确定删除所选抄表" msg:nil chooseBlock:^(NSInteger buttonIdx) {
            if (buttonIdx == 0)
            {
                NSMutableArray *deleteArrarys = [NSMutableArray array];
                for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows)
                {
                    [deleteArrarys addObject:self.dataArray[indexPath.row]];
                }
                NSMutableArray *idsArray = [[NSMutableArray alloc] init];
                for (BXTEnergyMeterListInfo *messageInfo in deleteArrarys)
                {
                    [idsArray addObject:messageInfo.energyMeterID];
                }
                NSString *idsStr = [idsArray componentsJoinedByString:@","];
                // TODO: -----------------  调试  -----------------
                [self showLoadingMBP:@"删除中..."];
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request energyMeterFavoriteAddWithAboutID:@"" delIDs:idsStr];
            }
        } buttonsStatement:@"确定", @"取消", nil];
    }];
}

#pragma mark -
#pragma mark DOPDropDownMenuDataSource & DOPDropDownMenuDelegate
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 2;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0)
    {
        return self.typeArray.count;
    }
    
    return self.modeArray.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0)
    {
        return self.typeArray[indexPath.row];
    }
    
    return self.modeArray[indexPath.row];
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0)
    {
        self.typeStr = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    }
    else if (indexPath.column == 1)
    {
        self.checkTypeStr = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    }
    
    [self getResource];
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
        
        [self showLoadingMBP:@"数据加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request energyMeterFavoriteAddWithAboutID:cell.listInfo.energyMeterID delIDs:@""];
    }];
    
    return cell;
}

- (void)saveViewControllerBgColor:(NSString *)type
{
    NSString *colorStr = @"";
    switch ([type integerValue])
    {
        case 1:colorStr = @"f45b5b"; break;
        case 2:colorStr = @"1683e2"; break;
        case 3:colorStr = @"f5c809"; break;
        case 4:colorStr = @"f1983e"; break;
        default: break;
    }
    SaveValueTUD(EnergyReadingColorStr, colorStr);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing)
    {
        return;
    }
    
    BXTEnergyMeterListInfo *listInfo = self.dataArray[indexPath.row];
    // 存储页面颜色
    [self saveViewControllerBgColor:listInfo.type];
    
    BXTMeterReadingRecordViewController *mrrvc = [[BXTMeterReadingRecordViewController alloc] init];
    mrrvc.transID = listInfo.energyMeterID;
    mrrvc.delegateSignal = [RACSubject subject];
    @weakify(self);
    [mrrvc.delegateSignal subscribeNext:^(id x) {
        @strongify(self);
        self.currentPage = 1;
        [self.tableView.mj_header beginRefreshing];
    }];
    [self.navigationController pushViewController:mrrvc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.dataArray removeObject:self.dataArray[indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark -
#pragma mark DZNEmptyDataSetDelegate & DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无快捷抄表";
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor blackColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    
    if (type == MeterFavoriteLists)
    {
        if (self.currentPage == 1 && self.dataArray.count != 0) {
            [self.dataArray removeAllObjects];
        }
        if (data.count)
        {
            [BXTEnergyMeterListInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"energyMeterID":@"id"};
            }];
            [self.dataArray addObjectsFromArray:[BXTEnergyMeterListInfo mj_objectArrayWithKeyValuesArray:data]];
        }
        [self.tableView reloadData];
    }
    else if (type == MeterFavoriteAdd && [dic[@"returncode"] integerValue] == 0)
    {
        __weak __typeof(self) weakSelf = self;
        [BXTGlobal showText:self.introInfo view:self.view completionBlock:^{
            [weakSelf getResource];
        }];
    }
    else if (type == MeterFavoriteDel && [dic[@"returncode"] integerValue] == 0)
    {
        __weak __typeof(self) weakSelf = self;
        [BXTGlobal showText:@"删除抄表成功" view:self.view completionBlock:^{
            [weakSelf getResource];
            [self changeSelectedState:YES];
        }];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
