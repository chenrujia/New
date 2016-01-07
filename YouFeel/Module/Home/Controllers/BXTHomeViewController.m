//
//  BXTHomeViewController.m
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTHomeViewController.h"
#import "BXTHomeCollectionViewCell.h"
#import "BXTSettingViewController.h"
#import "BXTHeaderFile.h"
#import "BXTGroupInfo.h"
#import "BXTDataRequest.h"
#import "BXTHomeTableViewCell.h"
#import "BXTHeadquartersViewController.h"
#import "BXTAuthorityListViewController.h"
#import "BXTQRCodeViewController.h"
#import "SDCycleScrollView.h"

#define DefualtBackColor colorWithHexString(@"ffffff")
#define SelectBackColor [UIColor grayColor]

@interface BXTHomeViewController ()<BXTDataResponseDelegate, SDCycleScrollViewDelegate>
{
    NSInteger      unreadNumber;
    BOOL           isConfigInfoSuccess;
}

@property (nonatomic, strong) NSMutableArray *usersArray;

@end

@implementation BXTHomeViewController

- (void)dealloc
{
    NSLog(@"执行了。。。。。");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNotifications];
    [self createLogoView];
    [self loginRongCloud];
    
    datasource = [NSMutableArray array];
    NSMutableArray *users = [BXTGlobal getUserProperty:U_USERSARRAY];
    if (users)
    {
        self.usersArray = [NSMutableArray arrayWithArray:users];
    }
    else
    {
        self.usersArray = [NSMutableArray array];
    }
    
    if ([BXTGlobal shareGlobal].isRepair)
    {
        BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
        [dataRequest configInfo];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request messageList];
}

- (void)addNotifications
{
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NewsComing" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        NSNotification *notification = x;
        NSString *str = notification.object;
        if ([str isEqualToString:@"1"])
        {
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request messageList];
        }
        else if ([str isEqualToString:@"2"])
        {
            [self.currentTableView reloadData];
        }
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HaveConnact" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        NSMutableArray *users = [BXTGlobal getUserProperty:U_USERSARRAY];
        if (users)
        {
            self.usersArray = [NSMutableArray arrayWithArray:users];
        }
        else
        {
            self.usersArray = [NSMutableArray array];
        }
    }];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createLogoView
{
    CGFloat deviceRatio = SCREEN_WIDTH/375;
    
    logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 76 + 180*deviceRatio)];
    logoImgView.userInteractionEnabled = YES;
    [self.view addSubview:logoImgView];
    
    //项目列表
    UIButton *branchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    branchBtn.frame = CGRectMake(0, valueForDevice(25.f, 25.f, 20.f, 15.f), 44, 44);
    [branchBtn setBackgroundImage:[UIImage imageNamed:@"list_button"] forState:UIControlStateNormal];
    [[branchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        // 商铺列表
        BXTAuthorityListViewController *alVC = [[BXTAuthorityListViewController alloc] init];
        [self.navigationController pushViewController:alVC animated:YES];
    }];
    [logoImgView addSubview:branchBtn];
    
    //店名
    shop_label = [[UILabel alloc] initWithFrame:CGRectMake(0, valueForDevice(35.f, 35.f, 30.f, 25.f), SCREEN_WIDTH-130, 20.f)];
    shop_label.center = CGPointMake(SCREEN_WIDTH/2.f, shop_label.center.y);
    shop_label.font = [UIFont boldSystemFontOfSize:17.f];
    shop_label.textAlignment = NSTextAlignmentCenter;
    [shop_label setTextColor:colorWithHexString(@"ffffff")];
    [logoImgView addSubview:shop_label];
    
    //设置
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setFrame:CGRectMake(SCREEN_WIDTH - 44.f - 5.f, valueForDevice(25.f, 25.f, 20.f, 15.f), 44.f, 44.f)];
    [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
    settingBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [settingBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    @weakify(self);
    [[settingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTSettingViewController *settingVC = [[BXTSettingViewController alloc] init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }];
    [logoImgView addSubview:settingBtn];
    
    // 扫描
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setFrame:CGRectMake(SCREEN_WIDTH - 44.f - 5.f - 50, valueForDevice(25.f, 25.f, 20.f, 15.f), 44.f, 44.f)];
    [scanBtn setBackgroundImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    [[scanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        //创建参数对象
        LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
        style.photoframeLineW = 6;
        style.photoframeAngleW = 24;
        style.photoframeAngleH = 24;
        style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
        style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
        BXTQRCodeViewController *qrcVC = [[BXTQRCodeViewController alloc] init];
        qrcVC.style = style;
        qrcVC.isQQSimulator = YES;
        qrcVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:qrcVC animated:YES];
    }];
    [logoImgView addSubview:scanBtn];
    
    
    // 广告页
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 180*deviceRatio) imageURLStringsGroup:imagesURLStrings];
    //cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    //cycleScrollView.titlesGroup = titles;
    cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.delegate = self;
    [logoImgView addSubview:cycleScrollView];
    
    
    self.currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImgView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(logoImgView.frame) - KTABBARHEIGHT) style:UITableViewStyleGrouped];
    [_currentTableView registerClass:[BXTHomeTableViewCell class] forCellReuseIdentifier:@"HomeCell"];
    _currentTableView.delegate = self;
    _currentTableView.dataSource = self;
    _currentTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_currentTableView];
}

- (void)loginRongCloud
{
    //登录融云服务器,开始阶段可以先从融云API调试网站获取，之后token需要通过服务器到融云服务器取。
    NSString *token = [BXTGlobal getUserProperty:U_IMTOKEN];
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        NSLog(@"Login successfully with userId: %@.", userId);
    } error:^(RCConnectErrorCode status) {
        NSLog(@"login error status: %ld.", (long)status);
    } tokenIncorrect:^{
        NSLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
    }];
}

#pragma mark -
#pragma mark 事件处理
- (void)repairClick
{
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1f;//section头部高度
    }
    return 10.f;//section头部高度
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (section == 0)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1f)];
    }
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RealValue(60.f);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_titleNameArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([BXTGlobal shareGlobal].isRepair && section == 1)
    {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([BXTGlobal shareGlobal].isRepair && indexPath.section == 1)
    {
        NSArray *images = _imgNameArray[indexPath.section];
        NSArray *titles = _titleNameArray[indexPath.section];
        cell.logoImgView.image = [UIImage imageNamed:images[indexPath.row]];
        cell.titleLabel.text = [titles objectAtIndex:indexPath.row];
    }
    else
    {
        cell.logoImgView.image = [UIImage imageNamed:_imgNameArray[indexPath.section]];
        cell.titleLabel.text = [_titleNameArray objectAtIndex:indexPath.section];
    }
    
    return cell;
}

#pragma mark -
#pragma mark RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    //此处为了演示写了一个用户信息
    if ([[BXTGlobal getUserProperty:U_USERID] isEqual:userId])
    {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = [BXTGlobal getUserProperty:U_USERID];
        user.name = [BXTGlobal getUserProperty:U_NAME];
        user.portraitUri = [BXTGlobal getUserProperty:U_HEADERIMAGE];
        
        return completion(user);
    }
    else
    {
        for (RCUserInfo *userInfo in _usersArray)
        {
            if ([userInfo.userId isEqual:userId])
            {
                return completion(userInfo);
            }
        }
        
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request userInfoForChatListWithID:userId];
        
        return completion(nil);
    }
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    [datasource removeAllObjects];
    NSArray *array = [dic objectForKey:@"data"];
    
    if (type == ConfigInfo)
    {
        isConfigInfoSuccess = YES;
        NSArray *dataArray = [dic objectForKey:@"data"];
        NSDictionary *dataDict = dataArray[0];
        NSMutableArray *arriveArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict1 in dataDict[@"arrive_arr"])
        {
            NSString *time = dict1[@"arrive_time"];
            [arriveArray addObject:time];
        }
        NSMutableArray *hoursArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict2 in dataDict[@"hours_arr"])
        {
            NSString *time = dict2[@"hours_time"];
            [hoursArray addObject:time];
        }
        
        if (arriveArray.count == 0)
        {
            [arriveArray addObjectsFromArray:@[@"10", @"20"]];
        }
        if (hoursArray.count == 0)
        {
            [hoursArray addObjectsFromArray:@[@"1", @"2", @"3", @"4"]];
        }
        
        // 存数组
        [BXTGlobal writeFileWithfileName:@"arriveArray" Array:arriveArray];
        [BXTGlobal writeFileWithfileName:@"hoursArray" Array:hoursArray];
    }
    else if (type == UserInfoForChatList)
    {
        NSDictionary *dictionary = array[0];
        RCUserInfo *userInfo = [[RCUserInfo alloc] init];
        userInfo.userId = [dictionary objectForKey:@"user_id"];
        userInfo.name = [dictionary objectForKey:@"name"];
        userInfo.portraitUri = [dictionary objectForKey:@"pic"];
        [_usersArray addObject:userInfo];
        [BXTGlobal setUserProperty:_usersArray withKey:U_USERSARRAY];
    }
    else
    {
        unreadNumber = [[dic objectForKey:@"unread_number"] integerValue];
        if (array.count)
        {
            [datasource addObjectsFromArray:array];
        }
        [_currentTableView reloadData];
    }
}

- (void)requestError:(NSError *)error
{
    if (!isConfigInfoSuccess)
    {
        NSMutableArray *arriveArray = [[NSMutableArray alloc] initWithObjects:@"10", @"20", nil];
        NSMutableArray *hoursArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", nil];
        // 存数组
        [BXTGlobal writeFileWithfileName:@"arriveArray" Array:arriveArray];
        [BXTGlobal writeFileWithfileName:@"hoursArray" Array:hoursArray];
    }
}

- (BOOL)is_verify
{
    NSString *is_verify = [BXTGlobal getUserProperty:U_IS_VERIFY];
    if ([is_verify integerValue] != 1)
    {
        [BXTGlobal showText:@"您尚未验证，现在去验证" view:self.view completionBlock:^{
            BXTSettingViewController *svc = [[BXTSettingViewController alloc] init];
            [self.navigationController pushViewController:svc animated:YES];
        }];
        return YES;
    }
    return NO;
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
