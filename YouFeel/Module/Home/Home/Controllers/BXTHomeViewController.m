//
//  BXTHomeViewController.m
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTHomeViewController.h"
#import "BXTHomeCollectionViewCell.h"
#import "BXTMessageListViewController.h"
#import "BXTHeaderFile.h"
#import "BXTGroupInfo.h"
#import "BXTDataRequest.h"
#import "BXTHomeTableViewCell.h"
#import "BXTHeadquartersViewController.h"
#import "BXTAuthorityListViewController.h"
#import "BXTQRCodeViewController.h"
#import "SDCycleScrollView.h"
#import "BXTSettingViewController.h"
#import "BXTAdsInform.h"
#import "BXTNoticeInformViewController.h"
#import "BXTOrderManagerViewController.h"
#import "BXTEvaluationListViewController.h"
#import "BXTManagerOMViewController.h"
#import "BXTStatisticsViewController.h"
#import "BXTExaminationViewController.h"
#import "BXTReaciveOrdersViewController.h"
#import "BXTAchievementsViewController.h"

#define DefualtBackColor colorWithHexString(@"ffffff")
#define SelectBackColor [UIColor grayColor]

@interface BXTHomeViewController ()<BXTDataResponseDelegate, SDCycleScrollViewDelegate>
{
    NSInteger         unreadNumber;
    BOOL              isConfigInfoSuccess;
    UIButton          *messageBtn;
    SDCycleScrollView *cycleScrollView;
}

@property (nonatomic, strong) NSMutableArray *usersArray;
@property (nonatomic, strong) NSMutableArray *adsArray;

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
    self.adsArray = [[NSMutableArray alloc] init];
    NSMutableArray *users = [BXTGlobal getUserProperty:U_USERSARRAY];
    if (users)
    {
        self.usersArray = [NSMutableArray arrayWithArray:users];
    }
    else
    {
        self.usersArray = [NSMutableArray array];
    }
    
    [self showLoadingMBP:@"数据加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /** 获取配置参数 **/
        if ([BXTGlobal shareGlobal].isRepair)
        {
            BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
            [dataRequest configInfo];
        }
    });
    dispatch_async(concurrentQueue, ^{
        /** 广告页 **/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request advertisementPages];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /** 消息列表 **/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request messageList];
    });
    dispatch_async(concurrentQueue, ^{
        dispatch_async(concurrentQueue, ^{
            /** 提醒数字 **/
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request remindNumberWithDailyTimeStart:[BXTRemindNum sharedManager].timeStart_Daily InspectioTimeStart:[BXTRemindNum sharedManager].timeStart_Inspectio];
        });
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BXTRepairButton" object:nil];
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

#pragma mark -
#pragma mark 初始化视图
- (void)createLogoView
{
    CGFloat deviceRatio = SCREEN_WIDTH/375;
    logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64 + 180*deviceRatio)];
    logoImgView.userInteractionEnabled = YES;
    [self.view addSubview:logoImgView];
    
    //项目列表
    UIButton *branchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    branchBtn.frame = CGRectMake(5, valueForDevice(25.f, 25.f, 20.f, 15.f), 44, 44);
    [branchBtn setBackgroundImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    @weakify(self);
    [[branchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        // 商铺列表
        BXTAuthorityListViewController *alVC = [[BXTAuthorityListViewController alloc] init];
        alVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:alVC animated:YES];
    }];
    [logoImgView addSubview:branchBtn];
    
    //店名
    shop_label = [[UILabel alloc] initWithFrame:CGRectMake(0, valueForDevice(35.f, 35.f, 30.f, 25.f), SCREEN_WIDTH-130, 20.f)];
    shop_label.center = CGPointMake(SCREEN_WIDTH/2.f, shop_label.center.y);
    shop_label.font = [UIFont systemFontOfSize:18.f];
    shop_label.textAlignment = NSTextAlignmentCenter;
    [shop_label setTextColor:colorWithHexString(@"ffffff")];
    [logoImgView addSubview:shop_label];
    
    //消息
    messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setFrame:CGRectMake(SCREEN_WIDTH - 44.f - 5.f, valueForDevice(25.f, 25.f, 20.f, 15.f), 44.f, 44.f)];
    [messageBtn setBackgroundImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    [[messageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTMessageListViewController *messageVC = [[BXTMessageListViewController alloc] initWithDataSourch:datasource];
        messageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messageVC animated:YES];
    }];
    [logoImgView addSubview:messageBtn];
    
    //扫描
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setFrame:CGRectMake(SCREEN_WIDTH - 44.f - 50, valueForDevice(25.f, 25.f, 20.f, 15.f), 44.f, 44.f)];
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
    
    //广告页
    cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 180*deviceRatio + 6) delegate:self placeholderImage:[UIImage imageNamed:@"allDefault"]];
    [logoImgView addSubview:cycleScrollView];
    
    self.currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImgView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(logoImgView.frame) - KTABBARHEIGHT-5) style:UITableViewStyleGrouped];
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

- (void)pushMyOrders
{
    // 我的工单
    BXTOrderManagerViewController *orderManagerVC = [[BXTOrderManagerViewController alloc] init];
    orderManagerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderManagerVC animated:YES];
}

- (void)pushEvaluationList
{
    // 评价
    BXTEvaluationListViewController *evaluationListVC = [[BXTEvaluationListViewController alloc] init];
    evaluationListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:evaluationListVC animated:YES];
}

- (void)pushSpecialOrders
{
    // 特殊工单
    BXTManagerOMViewController *serviceVC = [[BXTManagerOMViewController alloc] init];
    serviceVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:serviceVC animated:YES];
}

- (void)pushStatistics
{
    // 业务统计
    BXTStatisticsViewController *statisticsVC = [[BXTStatisticsViewController alloc] init];
    statisticsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:statisticsVC animated:YES];
}

- (void)pushExamination
{
    // 审批
    BXTExaminationViewController *examinationVC = [[BXTExaminationViewController alloc] init];
    examinationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:examinationVC animated:YES];
}

- (void)pushNormalOrders
{
    //正常工单
    [BXTRemindNum sharedManager].timeStart_Daily = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    SaveValueTUD(@"timeStart_Daily", [BXTRemindNum sharedManager].timeStart_Daily);
    BXTReaciveOrdersViewController *reaciveVC = [[BXTReaciveOrdersViewController alloc] initWithTaskType:1];
    reaciveVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:reaciveVC animated:YES];
}

- (void)pushMaintenceOrders
{
    //维保工单
    [BXTRemindNum sharedManager].timeStart_Inspectio = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    BXTReaciveOrdersViewController *reaciveVC = [[BXTReaciveOrdersViewController alloc] initWithTaskType:2];
    SaveValueTUD(@"timeStart_Inspectio", [BXTRemindNum sharedManager].timeStart_Inspectio);
    reaciveVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:reaciveVC animated:YES];
}

- (void)pushAchievements
{
    // 我的绩效
    BXTAchievementsViewController *achievementVC = [[BXTAchievementsViewController alloc] init];
    achievementVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:achievementVC animated:YES];
}

- (void)projectPhone
{
    NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", ValueFUD(@"shop_tel")];
    UIWebView *callWeb = [[UIWebView alloc] init];
    [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
    [self.view addSubview:callWeb];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BXTAdsInform *model = self.adsArray[index];
    BXTNoticeInformViewController *nivc = [[BXTNoticeInformViewController alloc] init];
    nivc.urlStr = model.more;
    nivc.pushType = PushType_Ads;
    nivc.titleStr = model.title;
    nivc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nivc animated:YES];
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1f;//section头部高度
    }
    return 8.f;//section头部高度
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
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
    cell.numberLabel.hidden = YES;
    
    if ([BXTGlobal shareGlobal].isRepair && indexPath.section == 1)
    {
        NSArray *images = _imgNameArray[indexPath.section];
        NSArray *titles = _titleNameArray[indexPath.section];
        cell.logoImgView.image = [UIImage imageNamed:images[indexPath.row]];
        cell.titleLabel.text = [titles objectAtIndex:indexPath.row];
        
        if (indexPath.row == 0 && [[BXTRemindNum sharedManager].dailyNum integerValue] != 0) {
            cell.numberLabel.hidden = NO;
            cell.numberLabel.text = [BXTRemindNum sharedManager].dailyNum;
        }
        if (indexPath.row == 1 && [[BXTRemindNum sharedManager].inspectioNum integerValue] != 0) {
            cell.numberLabel.hidden = NO;
            cell.numberLabel.text = [BXTRemindNum sharedManager].inspectioNum;
        }
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
    [self hideMBP];
    
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
        
        SaveValueTUD(@"shop_tel", dataDict[@"shop_tel"]);
    }
    else if (type == Ads_Pics)
    {
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        NSMutableArray *modelArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in array) {
            BXTAdsInform *model = [BXTAdsInform modeWithDict:dict];
            [modelArray addObject:model];
            [imageArray addObject:model.pic];
        }
        cycleScrollView.imageURLStringsGroup = imageArray;
        self.adsArray = modelArray;
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
    else if (type == Remind_Number)
    {
        NSDictionary *numDict = array[0];
        [BXTRemindNum sharedManager].dailyNum = [NSString stringWithFormat:@"%@", numDict[@"daily_number"]];
        [BXTRemindNum sharedManager].inspectioNum = [NSString stringWithFormat:@"%@", numDict[@"inspectio_number"]];
        [BXTRemindNum sharedManager].appNum = [NSString stringWithFormat:@"%@", numDict[@"app_sum_number"]];
        [BXTRemindNum sharedManager].announcementNum = [NSString stringWithFormat:@"%@", numDict[@"announcement_number"]];
        
        if ( [[BXTRemindNum sharedManager].appNum integerValue] != 0) {
            UIViewController *tController = [self.tabBarController.viewControllers objectAtIndex:2];
            tController.tabBarItem.badgeValue = [BXTRemindNum sharedManager].appNum;
        }
        
        [_currentTableView reloadData];
    }
    else
    {
        unreadNumber = [[dic objectForKey:@"unread_number"] integerValue];
        if (unreadNumber > 0) {
            [messageBtn setBackgroundImage:[UIImage imageNamed:@"news_unread"] forState:UIControlStateNormal];
        } else {
            [messageBtn setBackgroundImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
        }
        
        if (array.count)
        {
            [datasource addObjectsFromArray:array];
        }
        [_currentTableView reloadData];
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
    if (!isConfigInfoSuccess)
    {
        NSMutableArray *arriveArray = [[NSMutableArray alloc] initWithObjects:@"10", @"20", nil];
        NSMutableArray *hoursArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", nil];
        // 存数组
        [BXTGlobal writeFileWithfileName:@"arriveArray" Array:arriveArray];
        [BXTGlobal writeFileWithfileName:@"hoursArray" Array:hoursArray];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
