//
//  BXTHomeViewController.m
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTHomeViewController.h"
#import "BXTHomeCollectionViewCell.h"
#import "BXTMessageViewController.h"
#import "BXTHeaderFile.h"
#import "BXTGroupInfo.h"
#import "BXTDataRequest.h"
#import "BXTHomeTableViewCell.h"
#import "BXTQRCodeViewController.h"
#import "SDCycleScrollView.h"
#import "BXTProjectManageViewController.h"
#import "BXTAdsInform.h"
#import "BXTNoticeInformViewController.h"
#import "BXTOrderManagerViewController.h"
#import "BXTOtherAffairViewController.h"
#import "BXTStatisticsViewController.h"
#import "BXTExaminationViewController.h"
#import "BXTReaciveOrdersViewController.h"
#import "BXTMyIntegralViewController.h"
#import "BXTRepairsListViewController.h"
#import "UITabBar+badge.h"

#define DefualtBackColor colorWithHexString(@"ffffff")
#define SelectBackColor [UIColor grayColor]

typedef NS_ENUM(NSInteger, CellType) {
    CellType_DailyOrder = 1,
    CellType_InspectionOrder,
    CellType_RepairOrder,
    CellType_ReportOrder,
    CellType_OtherAffair,
};

@interface BXTHomeViewController ()<BXTDataResponseDelegate, SDCycleScrollViewDelegate>
{
    BOOL              isConfigInfoSuccess;
    UIButton          *messageBtn;
    SDCycleScrollView *cycleScrollView;
}

@property (nonatomic, strong) NSMutableArray *logosArray;
@property (nonatomic, strong) NSMutableArray *usersArray;
@property (nonatomic, strong) NSMutableArray *adsArray;
@property (nonatomic, copy  ) NSString       *projPhone;
@property (nonatomic, strong) UIView         *redView;

@end

@implementation BXTHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNotifications];
    [self createLogoView];
    [self loginRongCloud];
    
    self.projPhone = @"";
    self.adsArray = [[NSMutableArray alloc] init];
    self.logosArray = [[NSMutableArray alloc] init];
    NSMutableArray *users = [BXTGlobal getUserProperty:U_USERSARRAY];
    if (users)
    {
        self.usersArray = [NSMutableArray arrayWithArray:users];
    }
    else
    {
        self.usersArray = [NSMutableArray array];
    }
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /** 广告页 **/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request advertisementPages];
    });
    dispatch_async(concurrentQueue, ^{
        /**请求维保列表**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request shopConfig];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BXTRepairButton" object:nil];
    // 获取通知气泡数据列表
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request remindNumberWithDailyTimestart:[BXTRemindNum sharedManager].timeStart_Daily
                        inspectionTimestart:[BXTRemindNum sharedManager].timeStart_Inspection
                            repairTimestart:[BXTRemindNum sharedManager].timeStart_Repair
                            reportTimestart:[BXTRemindNum sharedManager].timeStart_Report
                            objectTimestart:[BXTRemindNum sharedManager].timeStart_Object
                      announcementTimestart:[BXTRemindNum sharedManager].timeStart_Announcement
                            noticeTimestart:[BXTRemindNum sharedManager].timeStart_Notice];
    
}

- (void)addNotifications
{
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NewsComing" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        NSNotification *notification = x;
        NSString *str = notification.object;
        if ([str isEqualToString:@"2"])
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
    logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    logoImgView.userInteractionEnabled = YES;
    [self.view addSubview:logoImgView];
    
    //项目列表
    UIButton *branchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    branchBtn.frame = CGRectMake(0, 20, 47, 47);
    [branchBtn setBackgroundImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    @weakify(self);
    [[branchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        // 商铺列表
        BXTProjectManageViewController *pivc = [[BXTProjectManageViewController alloc] init];
        pivc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pivc animated:YES];
    }];
    [logoImgView addSubview:branchBtn];
    
    //店名

    
    //消息
    messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setFrame:CGRectMake(SCREEN_WIDTH - 44.f - 5.f, 20, 44.f, 44.f)];
    [messageBtn setBackgroundImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    [[messageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [BXTRemindNum sharedManager].timeStart_Notice = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        SaveValueTUD(@"timeStart_Notice", [BXTRemindNum sharedManager].timeStart_Notice);
        BXTMessageViewController *newsVC = [[BXTMessageViewController alloc] init];
        newsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newsVC animated:YES];
    }];
    [logoImgView addSubview:messageBtn];
    
    // 红点
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20.f, 30, 10, 10)];
    self.redView.backgroundColor = [UIColor redColor];
    self.redView.layer.cornerRadius = 5;
    [logoImgView addSubview:self.redView];
    
    //扫描
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setFrame:CGRectMake(SCREEN_WIDTH - 44.f - 45, 20, 44.f, 44.f)];
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
    
    self.currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImgView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(logoImgView.frame) - KTABBARHEIGHT-5) style:UITableViewStyleGrouped];
    [_currentTableView registerClass:[BXTHomeTableViewCell class] forCellReuseIdentifier:@"HomeCell"];
    _currentTableView.rowHeight = 50;
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

- (void)pushMyOrdersIsRepair:(BOOL)isRepair
{
    // 我的工单
    if (isRepair)
    {
        [BXTRemindNum sharedManager].timeStart_Repair = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        SaveValueTUD(@"timeStart_Repair", [BXTRemindNum sharedManager].timeStart_Repair);
    }
    else
    {
        [BXTRemindNum sharedManager].timeStart_Report = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        SaveValueTUD(@"timeStart_Report", [BXTRemindNum sharedManager].timeStart_Report);
    }
    
    BXTOrderManagerViewController *orderManagerVC = [[BXTOrderManagerViewController alloc] init];
    orderManagerVC.isRepair = isRepair;
    orderManagerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderManagerVC animated:YES];
}

- (void)pushOtherAffair
{
    // 其他事务
    [BXTRemindNum sharedManager].timeStart_Object = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    SaveValueTUD(@"timeStart_Object", [BXTRemindNum sharedManager].timeStart_Object);
    BXTOtherAffairViewController *affairVC = [[BXTOtherAffairViewController alloc] init];
    affairVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:affairVC animated:YES];
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
    [BXTRemindNum sharedManager].timeStart_Inspection = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    SaveValueTUD(@"timeStart_Inspectio", [BXTRemindNum sharedManager].timeStart_Inspection);
    BXTReaciveOrdersViewController *reaciveVC = [[BXTReaciveOrdersViewController alloc] initWithTaskType:2];
    reaciveVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:reaciveVC animated:YES];
}

- (void)pushMyIntegral
{
    // 我的积分
    BXTMyIntegralViewController *myIntegralVC = [[BXTMyIntegralViewController alloc] init];
    myIntegralVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myIntegralVC animated:YES];
}

- (void)projectPhone
{
    NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", self.projPhone];
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
        BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
        CGFloat scale = 123.f/320.f;
        if (![companyInfo.company_id isEqualToString:@"4"])
        {
            return SCREEN_WIDTH * scale;//section头部高度
        }
        return SCREEN_WIDTH * scale + 37;//section头部高度
    }
    return 0.1f;//section头部高度
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        CGFloat scale = 123.f/320.f;
        
        // bgView
        CGFloat bgViewH = SCREEN_WIDTH * scale + 37;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, bgViewH)];
        
        // cycleScrollView
        CGFloat adsViewH = SCREEN_WIDTH * scale;
        if (!cycleScrollView)
        {
            cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adsViewH) delegate:self placeholderImage:[UIImage imageNamed:@"allDefault"]];
        }
        if (cycleScrollView.imageURLStringsGroup.count == 0)
        {
            if (self.logosArray.count != 0)
            {
                cycleScrollView.imageURLStringsGroup = self.logosArray;
            }
            else
            {
                cycleScrollView.placeholderImage = [UIImage imageNamed:@"allDefault"];
            }
        }
        [bgView addSubview:cycleScrollView];
        
        // introduce
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, adsViewH, SCREEN_WIDTH, 37);
        [button setTitle:@"请选择您所在的项目  >>" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            // 商铺列表
            BXTProjectManageViewController *pivc = [[BXTProjectManageViewController alloc] init];
            pivc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pivc animated:YES];
        }];
        
        BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
        if ([companyInfo.company_id isEqualToString:@"4"]) {
            [bgView addSubview:button];
        }
        
        return bgView;
    }
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleNameArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleNameArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.numberLabel.hidden = YES;
    
    cell.logoImgView.image = [UIImage imageNamed:self.imgNameArray[indexPath.section][indexPath.row]];
    cell.titleLabel.text = self.titleNameArray[indexPath.section][indexPath.row];
    
    cell.logoImgView.image = [UIImage imageNamed:_imgNameArray[indexPath.section][indexPath.row]];
    cell.titleLabel.text = _titleNameArray[indexPath.section][indexPath.row];
    
    
    NSString *title = self.titleNameArray[indexPath.section][indexPath.row];
    if ([title isEqualToString:@"日常工单"])
    {
        [self judgeRemindInfo:CellType_DailyOrder tableViewCell:cell];
    }
    else if ([title isEqualToString:@"维保工单"])
    {
        [self judgeRemindInfo:CellType_InspectionOrder tableViewCell:cell];
    }
    else if ([title isEqualToString:@"我的报修工单"])
    {
        [self judgeRemindInfo:CellType_ReportOrder tableViewCell:cell];
    }
    else if ([title isEqualToString:@"我的维修工单"])
    {
        [self judgeRemindInfo:CellType_RepairOrder tableViewCell:cell];
    }
    else if ([title isEqualToString:@"其他事务"])
    {
        [self judgeRemindInfo:CellType_OtherAffair tableViewCell:cell];
    }
    
    return cell;
}

- (void)judgeRemindInfo:(CellType)cellType tableViewCell:(BXTHomeTableViewCell *)cell
{
    if (cellType == CellType_DailyOrder && [[BXTRemindNum sharedManager].dailyNum integerValue] != 0)
    {
        cell.numberLabel.hidden = NO;
        cell.numberLabel.text = [BXTRemindNum sharedManager].dailyNum;
    }
    if (cellType == CellType_InspectionOrder && [[BXTRemindNum sharedManager].inspectionNum integerValue] != 0)
    {
        cell.numberLabel.hidden = NO;
        cell.numberLabel.text = [BXTRemindNum sharedManager].inspectionNum;
    }
    if (cellType == CellType_RepairOrder && [[BXTRemindNum sharedManager].repairNum integerValue] != 0)
    {
        cell.numberLabel.hidden = NO;
        cell.numberLabel.text = [BXTRemindNum sharedManager].repairNum;
    }
    if (cellType == CellType_ReportOrder && [[BXTRemindNum sharedManager].reportNum integerValue] != 0)
    {
        cell.numberLabel.hidden = NO;
        cell.numberLabel.text = [BXTRemindNum sharedManager].reportNum;
    }
    if (cellType == CellType_OtherAffair && [[BXTRemindNum sharedManager].objectNum integerValue] != 0)
    {
        cell.numberLabel.hidden = NO;
        cell.numberLabel.text = [BXTRemindNum sharedManager].objectNum;
    }
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
    NSArray *array = [dic objectForKey:@"data"];
    
    if (type == Ads_Pics)
    {
        NSMutableArray *modelArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in array)
        {
            BXTAdsInform *model = [BXTAdsInform modeWithDict:dict];
            [modelArray addObject:model];
            [self.logosArray addObject:model.pic];
        }
        if (cycleScrollView)
        {
            cycleScrollView.imageURLStringsGroup = self.logosArray;
        }
        self.adsArray = modelArray;
        [_currentTableView reloadData];
    }
    else if (type == UserInfoForChatList)
    {
        if (array.count)
        {
            NSDictionary *dictionary = array[0];
            RCUserInfo *userInfo = [[RCUserInfo alloc] init];
            userInfo.userId = [dictionary objectForKey:@"user_id"];
            userInfo.name = [dictionary objectForKey:@"name"];
            userInfo.portraitUri = [dictionary objectForKey:@"pic"];
            [self.usersArray addObject:userInfo];
            [BXTGlobal setUserProperty:self.usersArray withKey:U_USERSARRAY];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadMailList" object:nil];
        }
    }
    else if (type == Remind_Number && [dic[@"returncode"] integerValue] == 0)
    {
        NSDictionary *numDict = array[0];
        [BXTRemindNum sharedManager].dailyNum = [NSString stringWithFormat:@"%@", numDict[@"daily_num"]];
        [BXTRemindNum sharedManager].inspectionNum = [NSString stringWithFormat:@"%@", numDict[@"inspection_num"]];
        [BXTRemindNum sharedManager].repairNum = [NSString stringWithFormat:@"%@", numDict[@"repair_num"]];
        [BXTRemindNum sharedManager].reportNum = [NSString stringWithFormat:@"%@", numDict[@"report_num"]];
        [BXTRemindNum sharedManager].objectNum = [NSString stringWithFormat:@"%@", numDict[@"object_num"]];
        [BXTRemindNum sharedManager].announcementNum = [NSString stringWithFormat:@"%@", numDict[@"announcement_num"]];
        
        NSString *appShow = [NSString stringWithFormat:@"%@", numDict[@"app_show"]];
        NSString *index_show = [NSString stringWithFormat:@"%@", numDict[@"index_show"]];
        NSString *notice_show = [NSString stringWithFormat:@"%@", numDict[@"notice_show"]];
        [BXTRemindNum sharedManager].app_show = [appShow boolValue];
        [BXTRemindNum sharedManager].index_show = [index_show boolValue];
        [BXTRemindNum sharedManager].notice_show = [notice_show boolValue];
        
        // “应用”是否显示气泡：1是 0否
        if ([BXTRemindNum sharedManager].app_show)
        {
            [self.tabBarController.tabBar showBadgeOnItemIndex:3];
        }
        else
        {
            [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
        }
        // “首页”是否显示气泡：1是 0否
        if ([BXTRemindNum sharedManager].index_show)
        {
            [self.tabBarController.tabBar showBadgeOnItemIndex:0];
        }
        else
        {
            [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
        }
        // “首页”是否显示消息气泡：1是 0否
        if ([BXTRemindNum sharedManager].notice_show)
        {
            self.redView.hidden = NO;
        }
        else
        {
            self.redView.hidden = YES;
        }
        
        [_currentTableView reloadData];
    }
    else if (type == ShopConfig && [dic[@"returncode"] integerValue] == 0)
    {
        NSDictionary *infoDict = array[0];
        if (![BXTGlobal isBlankString:infoDict[@"shop_tel"]])
        {
            [self.imgNameArray addObject:[NSMutableArray arrayWithObjects:@"home_phone",nil]];
            [self.titleNameArray addObject:[NSMutableArray arrayWithObjects:@"项目热线",nil]];
            self.projPhone = infoDict[@"shop_tel"];
            [self.currentTableView reloadData];
        }
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
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
