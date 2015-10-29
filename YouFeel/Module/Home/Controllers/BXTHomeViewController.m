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
#import "BXTHeadquartersViewController.h"

#define DefualtBackColor colorWithHexString(@"ffffff")
#define SelectBackColor [UIColor grayColor]

@interface BXTHomeViewController ()

@end

@implementation BXTHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createLogoView];
    [self loginRongCloud];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createLogoView
{
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 235.f)];
    logoImgView.image = [UIImage imageNamed:@"logo_iphone5"];
    logoImgView.userInteractionEnabled = YES;
    [self.view addSubview:logoImgView];
    
    //位置
    logo_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logo_btn setFrame:CGRectMake(0, 30.f, 130.f, 30.f)];
    logo_btn.center = CGPointMake(SCREEN_WIDTH/2.f, logo_btn.center.y);
    logo_btn.titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    [logo_btn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [logo_btn addTarget:self action:@selector(shopClick) forControlEvents:UIControlEventTouchUpInside];
    [logoImgView addSubview:logo_btn];
    
    //设置
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setFrame:CGRectMake(SCREEN_WIDTH - 44.f - 15.f, 25.f, 44.f, 44.f)];
    [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
    settingBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [settingBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
    [logoImgView addSubview:settingBtn];
    
    //店面
    shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shopBtn setFrame:CGRectMake(0, CGRectGetMaxY(logo_btn.frame) + 25.f, 90, 90)];
    [shopBtn setCenter:CGPointMake(SCREEN_WIDTH/2.f, shopBtn.center.y)];
    [shopBtn setImage:[UIImage imageNamed:@"tools"] forState:UIControlStateNormal];
    [shopBtn addTarget:self action:@selector(repairClick) forControlEvents:UIControlEventTouchUpInside];
    [logoImgView addSubview:shopBtn];
    
    //店名
    shop_label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(shopBtn.frame) + 10.f, 130.f, 20.f)];
    shop_label.center = CGPointMake(SCREEN_WIDTH/2.f, shop_label.center.y);
    shop_label.textAlignment = NSTextAlignmentCenter;
    shop_label.textColor = colorWithHexString(@"3cafff");
    shop_label.text = @"一键报修";
    shop_label.font = [UIFont boldSystemFontOfSize:18.f];
    [logoImgView addSubview:shop_label];
    
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
    BXTSettingViewController *settingVC = [[BXTSettingViewController alloc] initWithIsRepair:_isRepair];
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
    if ([@"10" isEqual:userId])
    {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"1";
        user.name = @"测试1";
        user.portraitUri = @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=1756054607,4047938258&fm=96&s=94D712D20AA1875519EB37BE0300C008";
        
        return completion(user);
    }
    else if([@"2" isEqual:userId])
    {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"2";
        user.name = @"测试2";
        user.portraitUri = @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=1756054607,4047938258&fm=96&s=94D712D20AA1875519EB37BE0300C008";
        return completion(user);
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
