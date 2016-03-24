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
#import "PinYinForObjc.h"
#import "BXTAuthenticationViewController.h"

#define NavBarHeight 120.f

@interface BXTHeadquartersViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,BXTDataResponseDelegate,CLLocationManagerDelegate>
{
    /** ---- 热门项目 ---- */
    NSMutableArray    *shopsArray;
    /** ---- 附近项目 ---- */
    CLLocationManager *locationManager;
    NSMutableArray    *locationShopsArray;
    UISearchBar       *headSearchBar;
    UITableView       *currentTableView;
    BOOL              isPush;
    BOOL              is_binding;
    NSMutableArray    *searchResults;
    NSString          *searchStr;
}

@property (nonatomic, assign) BOOL           isOpenLocationProject;
@property (nonatomic, strong) UISearchBar    *searchBar;
@property (nonatomic, strong) UITableView    *tableView_Search;
@property (nonatomic, strong) UILabel        *remindLabel;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) NSMutableArray *allPersonArray;

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
    self.allPersonArray = [[NSMutableArray alloc] init];
    
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
    [currentTableView registerClass:[BXTHeadquartersTableViewCell class] forCellReuseIdentifier:@"HeadquartersTableViewCell"];
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    [self.view addSubview:currentTableView];
    
    // UITableView - tableView_Search
    self.tableView_Search = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 55) style:UITableViewStyleGrouped];
    self.tableView_Search.dataSource = self;
    self.tableView_Search.delegate = self;
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
    
    self.remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, SCREEN_WIDTH-40, 40)];
    self.remindLabel.text = @"抱歉，没有找到相关项目";
    self.remindLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.remindLabel];
    self.remindLabel.hidden = YES;
    
    [self showTableViewAndHideSearchTableView:YES];
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
    self.remindLabel.hidden = YES;
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
    if (tableView == self.tableView_Search) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.remindLabel.hidden = YES;
    
    if (tableView == self.tableView_Search) {
        if (self.searchArray.count == 0) {
            self.remindLabel.hidden = NO;
        }
        if ([searchStr isEqualToString:@""]) {
            self.remindLabel.hidden = YES;
        }
        return self.searchArray.count;
    }
    
    if (section == 0) {
        if (self.isOpenLocationProject) {
            // 如果没有项目， 建议打开定位
            if (locationShopsArray.count == 0) {
                return 2;
            }
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
    BXTHeadquartersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BXTHeadquartersTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
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
                BXTHeadquartersInfo *company = locationShopsArray[indexPath.row-1];
                cell.nameLabel.textColor = colorWithHexString(@"#000000");
                cell.nameLabel.text = company.name;
                cell.rightImageView.hidden = NO;
            }
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
    if (tableView == self.tableView_Search)
    {
        NSDictionary *dict = self.searchArray[indexPath.row];
        BXTHeadquartersInfo *infoModel = [BXTHeadquartersInfo modelObjectWithDictionary:dict];
        
        
        NSArray *shopsIDArray = [BXTGlobal getUserProperty:U_SHOPIDS];
        if ([shopsIDArray containsObject:infoModel.company_id])
        {
            [self refreshAllInformWithShopID:infoModel.company_id shopAddress:infoModel.name];
            
            /**请求分店位置**/
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request branchLogin];
        }
        else
        {
            BXTAuthenticationViewController *authenticationVC = [[BXTAuthenticationViewController alloc] init];
            authenticationVC.shopID = infoModel.company_id;
            authenticationVC.shopAddress = infoModel.name;
            [self.navigationController pushViewController:authenticationVC animated:YES];
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    if (indexPath.section == 0 && indexPath.row != 0)
    {
        if (locationShopsArray.count == 0)
        {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
        } else {
            BXTHeadquartersInfo *company = locationShopsArray[indexPath.row-1];
            
            NSArray *shopsIDArray = [BXTGlobal getUserProperty:U_SHOPIDS];
            if ([shopsIDArray containsObject:company.company_id])
            {
                [self refreshAllInformWithShopID:company.company_id shopAddress:company.name];
                
                /**请求分店位置**/
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request branchLogin];
            }
            else
            {
                BXTAuthenticationViewController *authenticationVC = [[BXTAuthenticationViewController alloc] init];
                authenticationVC.shopID = company.company_id;
                authenticationVC.shopAddress = company.name;
                [self.navigationController pushViewController:authenticationVC animated:YES];
            }
            
        }
    }
    else if (indexPath.section == 1 && indexPath.row != 0) {
        BXTHeadquartersInfo *company = shopsArray[indexPath.row-1];
        BXTBranchViewController *branchVC = [[BXTBranchViewController alloc] initWithHeadquarters:company];
        branchVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:branchVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshAllInformWithShopID:(NSString *)shopID shopAddress:(NSString *)shopAddress {
    BXTHeadquartersInfo *companyInfo = [[BXTHeadquartersInfo alloc] init];
    companyInfo.company_id = shopID;
    companyInfo.name = shopAddress;
    [BXTGlobal setUserProperty:companyInfo withKey:U_COMPANY];
    
    
    NSString *url = [NSString stringWithFormat:@"http://api.51bxt.com/?c=Port&m=actionGet_iPhone_v2_Port&shop_id=%@&token=%@", shopID, [BXTGlobal getUserProperty:U_TOKEN]];
    [BXTGlobal shareGlobal].baseURL = url;
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
        [self.allPersonArray removeAllObjects];
        [BXTHeadquartersInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"company_id":@"id"};
        }];
        [locationShopsArray addObjectsFromArray:[BXTHeadquartersInfo mj_objectArrayWithKeyValuesArray:array]];
        [self.allPersonArray addObjectsFromArray:array];
    }
    else
    {
        [shopsArray removeAllObjects];
        [BXTHeadquartersInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"company_id":@"id"};
        }];
        [shopsArray addObjectsFromArray:[BXTHeadquartersInfo mj_objectArrayWithKeyValuesArray:array]];
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

//取消searchbar背景色
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
