//
//  BXTHeadquartersViewController.m
//  BXT
//
//  Created by Jason on 15/8/20.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTProjectAddNewViewController.h"
#import "BXTProjectAddNewCell.h"
#include <math.h>
#import "BXTHeaderForVC.h"
#import "BXTHeadquartersInfo.h"
#import "PinYinForObjc.h"
#import "BXTProjectCertificationViewController.h"
#import "BXTProjectManageViewController.h"
#import "UIScrollView+EmptyDataSet.h"

#define NavBarHeight 120.f

@interface BXTProjectAddNewViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,UISearchBarDelegate,BXTDataResponseDelegate,CLLocationManagerDelegate>
{
    /** ---- 测试项目 ---- */
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
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) NSMutableArray *allPersonArray;

// 点击添加新项目
@property (strong, nonatomic) BXTHeadquartersInfo *headquartersInfo;

@end

@implementation BXTProjectAddNewViewController

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
    
    [self navigationSetting:@"添加项目" andRightTitle:nil andRightImage:nil];
    
    [self createTableView];
    
    
    [self showLoadingMBP:@"加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**请求分店位置**/
        BXTDataRequest *dep_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [dep_request shopLists:nil];
    });
    dispatch_async(concurrentQueue, ^{
        /**获取所有商铺列表**/
        BXTDataRequest *dep_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [dep_request listOFAllShops];
    });
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView_Search) {
        return 1;
    }
    return 2;
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
            cell.nameLabel.text = @"测试项目";
        } else {
            BXTHeadquartersInfo *company = shopsArray[indexPath.row-1];
            cell.nameLabel.text = company.name;
            cell.rightAddView.hidden = NO;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView_Search)
    {
        NSDictionary *dict = self.searchArray[indexPath.row];
        BXTHeadquartersInfo *company = [BXTHeadquartersInfo modelObjectWithDictionary:dict];
        [self transStateOfAuthorityWithInform:company];
        
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
            BXTHeadquartersInfo *company = locationShopsArray[indexPath.row-1];
            [self transStateOfAuthorityWithInform:company];
        }
    }
    else if (indexPath.section == 1 && indexPath.row != 0) {
        BXTHeadquartersInfo *company = shopsArray[indexPath.row-1];
        [self transStateOfAuthorityWithInform:company];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)transStateOfAuthorityWithInform:(BXTHeadquartersInfo *)company
{
    NSArray *shopsIDArray = [BXTGlobal getUserProperty:U_SHOPIDS];
    if ([shopsIDArray containsObject:company.company_id]) {
        [self refreshAllInformWithShopID:company.company_id shopAddress:company.name];
        
        /**请求分店位置**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request branchLogin];
    }
    else {
        self.headquartersInfo = company;
        [self getResourceWithShopID:company.company_id];
    }
}

- (void)getResourceWithShopID:(NSString *)shopID
{
    /**分店添加用户**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request projectAddUserWithShopID:shopID];
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
    
    if (type == BranchLogin)
    {
        if (array.count > 0)
        {
            NSDictionary *userInfo = array[0];
            [[BXTGlobal shareGlobal] branchLoginWithDic:userInfo isPushToRootVC:YES];
        }
    }
    else if (type == LocationShop)
    {
        [locationShopsArray removeAllObjects];
        [BXTHeadquartersInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"company_id":@"id"};
        }];
        [locationShopsArray addObjectsFromArray:[BXTHeadquartersInfo mj_objectArrayWithKeyValuesArray:array]];
        [self.allPersonArray addObjectsFromArray:array];
    }
    else if (type == ListOFAllShops)
    {
        [self.allPersonArray removeAllObjects];
        [self.allPersonArray addObjectsFromArray:array];
    }
    else if (type == BranchResign)
    {
        if ([dic[@"returncode"] integerValue] == 0) {
            [MYAlertAction showAlertWithTitle:@"添加项目成功！" msg:@"现在是否去补齐信息，进行项目认证？" chooseBlock:^(NSInteger buttonIdx) {
                if (buttonIdx == 1) {
                    BXTProjectCertificationViewController *projCfVC = [[BXTProjectCertificationViewController alloc] init];
                    BXTMyProject *myProject = [[BXTMyProject alloc] init];
                    myProject.shop_id = self.headquartersInfo.company_id;
                    myProject.name = self.headquartersInfo.name;
                    myProject.verify_state = @"0";
                    projCfVC.transMyProject = myProject;
                    [self.navigationController pushViewController:projCfVC animated:YES];
                }
                else {
                    NSArray *shopsIDArray = [BXTGlobal getUserProperty:U_SHOPIDS];
                    if (shopsIDArray.count != 0) {
                        BXTProjectManageViewController *pmVC = [[BXTProjectManageViewController alloc] init];
                        [self.navigationController pushViewController:pmVC animated:YES];
                    }
                    else {  // 只有一个项目 - 直接跳到本项目
                        [self refreshAllInformWithShopID:self.headquartersInfo.company_id shopAddress:self.headquartersInfo.name];
                        
                        /**请求分店位置**/
                        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                        [request branchLogin];
                    }
                }
            } buttonsStatement:@"以后再说", @"现在就去", nil];
        }
        else if ([dic[@"returncode"] integerValue] == 6) {
            [MYAlertAction showAlertWithTitle:@"温馨提示" msg:@"项目已添加" chooseBlock:^(NSInteger buttonIdx) {
                
            } buttonsStatement:@"确定", nil];
        }
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

- (void)requestError:(NSError *)error requeseType:(RequestType)type
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
