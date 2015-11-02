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
    NSMutableArray *shopsArray;
    NSMutableArray *locationShopsArray;
    UISearchBar *headSearchBar;
    UITableView *currentTableView;
    BOOL isPush;
    BOOL is_binding;
    CLLocationManager *locationManager;
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
    [self locationPoint];
    
    shopsArray = [NSMutableArray array];
    locationShopsArray = [NSMutableArray array];
    /**请求分店位置**/
    BXTDataRequest *dep_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [dep_request shopLists:nil];
    
    NSArray *my_shops = [BXTGlobal getUserProperty:U_MYSHOP];
    if (my_shops.count)
    {
        is_binding = YES;
    }
    
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

#pragma mark -
#pragma mark 事件
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

- (void)shopBtnClick:(UIButton *)btn
{
    NSArray *my_shops = [BXTGlobal getUserProperty:U_MYSHOP];
    NSDictionary *companyDic = my_shops[btn.tag];
    BXTHeadquartersInfo *companyInfo = [[BXTHeadquartersInfo alloc] init];
    companyInfo.company_id = [companyDic objectForKey:@"id"];
    companyInfo.name = [companyDic objectForKey:@"shop_name"];
    [BXTGlobal setUserProperty:companyInfo withKey:U_COMPANY];
    NSString *url = [NSString stringWithFormat:@"http://api.91eng.com/?c=Port&m=actionGet_iPhone_v2_Port&shop_id=%@",[companyDic objectForKey:@"id"]];
    [BXTGlobal shareGlobal].baseURL = url;
    /**请求分店位置**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request branchLogin];
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
        if (is_binding)
        {
            NSArray *my_shops = [BXTGlobal getUserProperty:U_MYSHOP];
            NSInteger count = ceil(my_shops.count/3.f);
            return 40.f + 35.f + 40.f * count;
        }
        else
        {
            return 0;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (is_binding && section == 0)
    {
        NSArray *my_shops = [BXTGlobal getUserProperty:U_MYSHOP];
        double number = my_shops.count/3.f;
        NSInteger count = ceil(number);
        CGFloat height = 40.f + 35.f + 40.f * count;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0., 0., SCREEN_WIDTH, height)];
        view.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20.f, SCREEN_WIDTH, height - 40.f)];
        backView.backgroundColor = colorWithHexString(@"ffffff");
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 5, 100.f, 15.f)];
        titleLabel.text = @"已绑定店铺";
        titleLabel.font = [UIFont systemFontOfSize:12.f];
        [backView addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 25.f, SCREEN_WIDTH, 0.7f)];
        lineView.backgroundColor = colorWithHexString(@"e4e4e4");
        [backView addSubview:lineView];
        
        CGFloat width = (SCREEN_WIDTH - 60.f)/3.f;
        
        for (NSInteger index = 0; index < my_shops.count; index++)
        {
            //行号
            NSInteger row = index/3; //行号为框框的序号对列数取商
            //列号
            NSInteger col = index%3; //列号为框框的序号对列数取余
            
            CGFloat appX = 15.f + col * (width + 15.f); // 每个框框靠左边的宽度为 (平均间隔＋框框自己的宽度）
            CGFloat appY =  5.f + 30 + row * (30.f + 10.f); // 每个框框靠上面的高度为 平均间隔＋框框自己的高度
            
            NSDictionary *infoDic = my_shops[index];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btn setFrame:CGRectMake(appX, appY, width, 30.f)];
            [btn setTitle:[infoDic objectForKey:@"shop_name"] forState:UIControlStateNormal];
            [btn setTitleColor:colorWithHexString(@"929697") forState:UIControlStateNormal];
            btn.tag = index;
            btn.layer.cornerRadius = 4.f;
            btn.layer.borderColor = colorWithHexString(@"e6e5e6").CGColor;
            btn.layer.borderWidth = 1.f;
            [btn addTarget:self action:@selector(shopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:btn];
        }
        [view addSubview:backView];
        
        return view;
    }
    else
    {
        return nil;
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
    if (locationShopsArray.count > 0)
    {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (locationShopsArray.count > 0)
    {
        if (section == 2)
        {
            return shopsArray.count;
        }
        else if (section == 1)
        {
            return 1;
        }
        else
        {
            return locationShopsArray.count;
        }
    }
    if (section == 1)
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
    
    if (locationShopsArray.count > 0)
    {
        if (indexPath.section == 0)
        {
            BXTHeadquartersInfo *company = locationShopsArray[indexPath.row];
            cell.nameLabel.text = company.name;
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
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (locationShopsArray.count > 0)
    {
        if (indexPath.section == 0 || indexPath.section == 2)
        {
            BXTHeadquartersInfo *company = shopsArray[indexPath.row];
            BXTBranchViewController *branchVC = [[BXTBranchViewController alloc] initWithHeadquarters:company];
            [self.navigationController pushViewController:branchVC animated:YES];
        }
    }
    else
    {
        if (indexPath.section == 2)
        {
            BXTHeadquartersInfo *company = shopsArray[indexPath.row];
            BXTBranchViewController *branchVC = [[BXTBranchViewController alloc] initWithHeadquarters:company];
            [self.navigationController pushViewController:branchVC animated:YES];
        }
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
    LogRed(@"%@",dic);
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
//    [self hideMBP];
}

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
