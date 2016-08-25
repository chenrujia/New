//
//  BXTEquipmentListViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/22.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEquipmentListViewController.h"
#import "BXTEPFilterViewController.h"
#import "DOPDropDownMenu.h"
#import "BXTEquipmentListCell.m"
#import <MJRefresh.h>
#import "BXTEPList.h"
#import "BXTEquipmentViewController.h"
#import "BXTGlobal.h"

@interface BXTEquipmentListViewController () <DOPDropDownMenuDelegate, DOPDropDownMenuDataSource, UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *alphaView;
@property (nonatomic, strong) DOPDropDownMenu *menu;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *typeArray;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, copy) NSString *order;
@property (nonatomic, copy) NSString *placeID;

/** ---- 向上返回按钮 ---- */
@property (nonatomic, strong) UIButton *upBtn;

@end

@implementation BXTEquipmentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"设备列表" andRightTitle:@"   筛选" andRightImage:nil];
    
    self.typeArray = [[NSArray alloc] initWithObjects:@"设备编号逆序", @"设备编号正序", nil];
    self.dataArray = [[NSMutableArray alloc] init];
    self.currentPage = 1;
    if (!self.date) {
        self.date = @"";
    }
    if (!self.state) {
        self.state = @"";
    }
    self.order = @"";
    if (!self.typeID) {
        self.typeID = @"";
    }
    self.placeID = @"";
    
    [self createUI];
}

- (void)navigationRightButton
{
    BXTEPFilterViewController *filterVC = [[BXTEPFilterViewController alloc] init];
    filterVC.delegateSignal = [RACSubject subject];
    @weakify(self);
    [filterVC.delegateSignal subscribeNext:^(NSArray *transArray) {
        @strongify(self);
        
        NSLog(@"transArray -= ---------- %@", transArray);
        self.date = transArray[0];
        self.placeID = transArray[1];
        self.typeID = transArray[2];
        self.state = transArray[3];
        
        self.currentPage = 1;
        [self getResource];
    }];
    [self.navigationController pushViewController:filterVC animated:YES];
}

- (void)getResource
{
    [BXTGlobal showLoadingMBP:@"数据加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request statisticsEPListWithTime:self.date
                                State:self.state
                                Order:self.order
                               TypeID:self.typeID
                               AreaID:@""
                              PlaceID:self.placeID
                             StoresID:@""
                           SearchName:@""
                             Pagesize:@"5"
                                 Page:[NSString stringWithFormat:@"%ld", (long)self.currentPage]];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // UISearchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, 55)];
    self.searchBar.delegate = self;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入设备编号或名称";
    [self.view addSubview:self.searchBar];
    
    
    // 添加下拉菜单
    self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, CGRectGetMaxY(self.searchBar.frame)) andHeight:44];
    self.menu.delegate = self;
    self.menu.dataSource = self;
    [self.view addSubview:self.menu];
    [self.menu selectDefalutIndexPath];
    
    
    // UITableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.menu.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.menu.frame)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf getResource];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf getResource];
    }];
    
    
    // alphaView
    self.alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.searchBar.frame))];
    self.alphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.alphaView.hidden = YES;
    [self.view addSubview:self.alphaView];
    
    
    // upBtn
    self.upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.upBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT, 50, 50);
    [self.upBtn setImage:[UIImage imageNamed:@"up_icon"] forState:UIControlStateNormal];
    @weakify(self);
    [[self.upBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
    [self.view addSubview:self.upBtn];
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
    
    self.alphaView.hidden = NO;
    
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
    self.alphaView.hidden = YES;
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.alphaView.hidden = YES;
    [self.view endEditing:YES];
    NSLog(@"SearchButtonClicked");
    [BXTGlobal showText:searchBar.text view:self.view completionBlock:nil];
}

#pragma mark -
#pragma mark DOPDropDownMenuDataSource && DOPDropDownMenuDelegate
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    return self.typeArray.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return self.typeArray[indexPath.row];
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    self.currentPage = 1;
    switch (indexPath.row) {
        case 0: self.order = @"2"; break;
        case 1: self.order = @"1"; break;
        default: break;
    }
    [self getResource];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTEquipmentListCell *cell = [BXTEquipmentListCell cellWithTableView:tableView];
    
    cell.epList = self.dataArray[indexPath.section];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    self.cellHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTEPList *list = self.dataArray[indexPath.section];
    
    BXTEquipmentViewController *epVC = [[BXTEquipmentViewController alloc] initWithDeviceID:list.EPID orderID:nil];
    [self.navigationController pushViewController:epVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.upBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 60, 38, 38);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //Table Top
    CGPoint localPoint = self.tableView.contentOffset;
    
    if(localPoint.y <= 0){
        [UIView animateWithDuration:0.5 animations:^{
            self.upBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT, 38, 38);
        }];
        return;
    }
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (self.currentPage == 1)
    {
        [self.dataArray removeAllObjects];
    }
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == Statistics_EPList && data.count > 0)
    {
        for (NSDictionary *dataDict in data)
        {
            BXTEPList *listModel = [BXTEPList modelWithDict:dataDict];
            [self.dataArray addObject:listModel];
        }
        
        if (!IS_IOS_8)
        {
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.tableView reloadData];
            });
        }
    }
    [self.tableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.alphaView.hidden = YES;
    [self.view endEditing:YES];
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
