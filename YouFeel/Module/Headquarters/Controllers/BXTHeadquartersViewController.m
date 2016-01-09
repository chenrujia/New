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
#include <math.h>
#import "BXTHeaderForVC.h"
#import "BXTHeadquartersInfo.h"

#define NavBarHeight 120.f

@interface BXTHeadquartersViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,BXTDataResponseDelegate,CLLocationManagerDelegate>
{
    /** ---- 热门项目 ---- */
    NSMutableArray    *shopsArray;
    /** ---- 附近项目 ---- */
    NSMutableArray    *locationShopsArray;
    UISearchBar       *headSearchBar;
    UITableView       *currentTableView;
    CLLocationManager *locationManager;
    BOOL              isPush;
    BOOL              is_binding;
}

@property (nonatomic, assign) BOOL isOpenLocationProject;

@property(nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView_Search;

@end

@implementation BXTHeadquartersViewController

- (void)dealloc
{
    LogBlue(@"Header界面释放了！！！！！！");
}

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
    //定位
    [self locationPoint];
    
    self.isOpenLocationProject = YES;
    shopsArray = [NSMutableArray array];
    locationShopsArray = [NSMutableArray array];
    
    NSArray *my_shops = [BXTGlobal getUserProperty:U_MYSHOP];
    if (my_shops.count)
    {
        is_binding = YES;
    }
    
    [self navigationSetting:@"添加新项目" andRightTitle:nil andRightImage:nil];
    
    [self createTableView];
    
    [self showLoadingMBP:@"努力加载中..."];
    /**请求分店位置**/
    BXTDataRequest *dep_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [dep_request shopLists:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createTableView
{
    // UISearchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, 55)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    [self.view addSubview:self.searchBar];
    
    // UITableView
    currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT + 55, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 55) style:UITableViewStyleGrouped];
    [currentTableView registerClass:[BXTHeadquartersTableViewCell class] forCellReuseIdentifier:@"HeadquartersTableViewCell"];
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    [self.view addSubview:currentTableView];
    
    // UITableView - tableView_Search
    self.tableView_Search = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 55) style:UITableViewStyleGrouped];
    self.tableView_Search.dataSource = self;
    self.tableView_Search.delegate = self;
    //[self.view addSubview:self.tableView_Search];
}

- (void)locationPoint
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    // 设置定位精度
    // kCLLocationAccuracyNearestTenMeters:精度10米
    // kCLLocationAccuracyHundredMeters:精度100 米
    // kCLLocationAccuracyKilometer:精度1000 米
    // kCLLocationAccuracyThreeKilometers:精度3000米
    // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
    // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if (IS_IOS_8)
    {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        [locationManager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
        [locationManager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
    }
    
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
    locationManager.distanceFilter = kCLDistanceFilterNone; // 如果设为kCLDistanceFilterNone，则每秒更新一次;
    
    // 判断的手机的定位功能是否开启
    // 开启定位:设置 > 隐私 > 位置 > 定位服务
    if ([CLLocationManager locationServicesEnabled])
    {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        [locationManager startUpdatingLocation];
    }
    else
    {
        NSLog(@"请开启定位功能！");
    }
}

- (void)switchAction:(UISwitch *)switchBtn
{
    self.isOpenLocationProject = switchBtn.on;
    [currentTableView reloadData];
    NSLog(@"-------------%d", self.isOpenLocationProject);
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.isOpenLocationProject) {
            return 1 + locationShopsArray.count;
        }
        return 1;
    }
    else {
        return 1 + shopsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    BXTHeadquartersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BXTHeadquartersTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.switchbtn.hidden = YES;
    cell.rightImageView.hidden = YES;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"自动定位";
            cell.switchbtn.hidden = NO;
            [cell.switchbtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        } else {
            BXTHeadquartersInfo *company = locationShopsArray[indexPath.row-1];
            cell.nameLabel.text = company.name;
            cell.rightImageView.hidden = NO;
        }
    }
    else
    {
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"热门项目";
        } else {
            BXTHeadquartersInfo *company = shopsArray[indexPath.row-1];
            cell.nameLabel.text = company.name;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row != 0) {
        BXTHeadquartersInfo *company = locationShopsArray[indexPath.row-1];
        BXTBranchViewController *branchVC = [[BXTBranchViewController alloc] initWithHeadquarters:company];
        branchVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:branchVC animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row != 0) {
        BXTHeadquartersInfo *company = shopsArray[indexPath.row-1];
        BXTBranchViewController *branchVC = [[BXTBranchViewController alloc] initWithHeadquarters:company];
        branchVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:branchVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
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
    else if (type == LocationShop)
    {
        [locationShopsArray removeAllObjects];
        for (NSDictionary *dictionary in array)
        {
            DCParserConfiguration *config = [DCParserConfiguration configuration];
            DCObjectMapping *text = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"company_id" onClass:[BXTHeadquartersInfo class]];
            [config addObjectMapping:text];
            
            DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTHeadquartersInfo class] andConfiguration:config];
            BXTHeadquartersInfo *company = [parser parseDictionary:dictionary];
            
            [locationShopsArray addObject:company];
        }
    }
    else
    {
        [shopsArray removeAllObjects];
        for (NSDictionary *dictionary in array)
        {
            DCParserConfiguration *config = [DCParserConfiguration configuration];
            DCObjectMapping *text = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"company_id" onClass:[BXTHeadquartersInfo class]];
            [config addObjectMapping:text];
            
            DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTHeadquartersInfo class] andConfiguration:config];
            BXTHeadquartersInfo *company = [parser parseDictionary:dictionary];
            
            [shopsArray addObject:company];
        }
    }
    
    [currentTableView reloadData];
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"%@",locations);
    CLLocation *location = locations[0];
    
    NSLog(@"纬度:%f",location.coordinate.latitude);
    NSLog(@"经度:%f",location.coordinate.longitude);
    
    /**附近商店**/
    BXTDataRequest *dep_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [dep_request shopWithLatitude:[NSString stringWithFormat:@"%f",location.coordinate.latitude] andWithLongitude:[NSString stringWithFormat:@"%f",location.coordinate.longitude]];
    
    [manager stopUpdatingLocation];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
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
