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
#include <math.h>
#import "BXTDataRequest.h"
#import "BXTHeadquartersViewController.h"

#define DefualtBackColor colorWithHexString(@"ffffff")
#define SelectBackColor [UIColor grayColor]

@interface BXTHomeViewController ()<BXTDataResponseDelegate>
{
    NSInteger      unreadNumber;
    NSMutableArray *usersArray;
    BOOL isConfigInfoSuccess;
}
@end

@implementation BXTHomeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([BXTGlobal shareGlobal].isRepair)
    {
        [self.navigationController.navigationBar setBarTintColor:colorWithHexString(@"09439c")];
    }
    else
    {
        [self.navigationController.navigationBar setBarTintColor:colorWithHexString(@"3cafff")];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsComing:) name:@"NewsComing" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveConnact) name:@"HaveConnact" object:nil];
    [self createLogoView];
    [self loginRongCloud];
    datasource = [NSMutableArray array];
    
    [self haveConnact];
    
    if ([BXTGlobal shareGlobal].isRepair)
    {
        BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
        [dataRequest configInfo];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request messageList];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createLogoView
{
    logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, valueForDevice(235.f, 213.f, 181.5f, 153.5f))];
    logoImgView.userInteractionEnabled = YES;
    [self.view addSubview:logoImgView];
    
    //店名
    shop_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shop_btn setFrame:CGRectMake(0, valueForDevice(35.f, 35.f, 30.f, 25.f), SCREEN_WIDTH-130, 20.f)];
    shop_btn.center = CGPointMake(SCREEN_WIDTH/2.f - 10.f, shop_btn.center.y);
    shop_btn.titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    [shop_btn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [shop_btn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    [shop_btn addTarget:self action:@selector(shopClick) forControlEvents:UIControlEventTouchUpInside];
    [logoImgView addSubview:shop_btn];
    
    //设置
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setFrame:CGRectMake(SCREEN_WIDTH - 44.f - 15.f, valueForDevice(25.f, 25.f, 20.f, 15.f), 44.f, 44.f)];
    [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
    settingBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [settingBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
    [logoImgView addSubview:settingBtn];
    
    //logo
    logo_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logo_Btn setFrame:CGRectMake(0, CGRectGetMaxY(shop_btn.frame) + valueForDevice(25, 20, 12, 10), valueForDevice(90, 90, 80, 65), valueForDevice(90, 90, 80, 65))];
    [logo_Btn setCenter:CGPointMake(SCREEN_WIDTH/2.f, logo_Btn.center.y)];
    [logo_Btn addTarget:self action:@selector(repairClick) forControlEvents:UIControlEventTouchUpInside];
    [logoImgView addSubview:logo_Btn];
    
    //logo下标题
    title_label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logo_Btn.frame) + (IS_IPHONE6 ? 12 : 8), 130.f, 20.f)];
    title_label.center = CGPointMake(SCREEN_WIDTH/2.f, title_label.center.y);
    title_label.textAlignment = NSTextAlignmentCenter;
    title_label.textColor = colorWithHexString(@"ffffff");
    title_label.font = [UIFont boldSystemFontOfSize:17.f];
    [logoImgView addSubview:title_label];
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.minimumInteritemSpacing = 0.f;
    itemsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImgView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetHeight(logoImgView.frame)) collectionViewLayout:flowLayout];
    itemsCollectionView.backgroundColor = colorWithHexString(@"eff3f5");
    [itemsCollectionView registerClass:[BXTHomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    itemsCollectionView.delegate = self;
    itemsCollectionView.dataSource = self;
    [self.view addSubview:itemsCollectionView];
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
- (void)settingClick
{
    BXTSettingViewController *settingVC = [[BXTSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)shopClick
{
    BXTHeadquartersViewController *company = [[BXTHeadquartersViewController alloc] initWithType:YES];
    [self.navigationController pushViewController:company animated:YES];
}

- (void)repairClick
{
    
}

- (void)newsComing:(NSNotification *)notification
{
    NSString *str = notification.object;
    if ([str isEqualToString:@"1"])
    {
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request messageList];
    }
    else if ([str isEqualToString:@"2"])
    {
        [itemsCollectionView reloadData];
    }
}

- (void)haveConnact
{
    NSMutableArray *users = [BXTGlobal getUserProperty:U_USERSARRAY];
    if (users)
    {
        usersArray = [NSMutableArray arrayWithArray:users];
    }
    else
    {
        usersArray = [NSMutableArray array];
    }
}

#pragma mark -
#pragma mark 代理
/**
 *  UICollectionViewDataSource && UICollectionViewDelegate
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BXTHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = colorWithHexString(@"ffffff");
    
    UIImage *image = [UIImage imageNamed:imgNameArray[indexPath.row]];
    cell.namelabel.text = titleNameArray[indexPath.row];
    cell.iconImage = image;
    if (indexPath.row == 6)
    {
        [cell newsRedNumber:unreadNumber];
    }
    else if (indexPath.row == 2)
    {
        [cell newsRedNumber:[[RCIMClient sharedRCIMClient] getTotalUnreadCount]];
    }
    else
    {
        [cell newsRedNumber:0];
    }
    
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger width = floor(SCREEN_WIDTH/3.f);
    
    if (IS_IPHONE6)
    {
        return CGSizeMake(width, collectionView.bounds.size.height/3.f);
    }
    else
    {
        if (indexPath.row%3 == 1)
        {
            return CGSizeMake(width + 2, 129);
        }
        return CGSizeMake(width, 129);
    }
}

/**
 *此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 */
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
        for (RCUserInfo *userInfo in usersArray)
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

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    LogRed(@"%@",dic);
    [datasource removeAllObjects];
    NSArray *array = [dic objectForKey:@"data"];
    
    
    if (type == ConfigInfo)
    {
        isConfigInfoSuccess = YES;
        NSArray *dataArray = [dic objectForKey:@"data"];
        NSDictionary *dataDict = dataArray[0];
        NSMutableArray *arriveArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict1 in dataDict[@"arrive_arr"]) {
            NSString *time = dict1[@"arrive_time"];
            [arriveArray addObject:time];
        }
        NSMutableArray *hoursArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict2 in dataDict[@"hours_arr"]) {
            NSString *time = dict2[@"hours_time"];
            [hoursArray addObject:time];
        }
        
        if (arriveArray.count == 0) {
            [arriveArray addObjectsFromArray:@[@"10", @"20"]];
        }
        if (hoursArray.count == 0) {
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
        [usersArray addObject:userInfo];
        [BXTGlobal setUserProperty:usersArray withKey:U_USERSARRAY];
    }
    else
    {
        unreadNumber = [[dic objectForKey:@"unread_number"] integerValue];
        if (array.count)
        {
            [datasource addObjectsFromArray:array];
        }
        [itemsCollectionView reloadData];
    }
}

- (void)requestError:(NSError *)error
{
    if (!isConfigInfoSuccess) {
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
