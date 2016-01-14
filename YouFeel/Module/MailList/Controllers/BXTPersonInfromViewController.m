//
//  BXTPersonInfromViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/4.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTPersonInfromViewController.h"
#import "BXTHeaderForVC.h"
#import "UIImageView+WebCache.h"
#import "BXTPersonInform.h"
#import <RongIMKit/RongIMKit.h>

@interface BXTPersonInfromViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>
{
    UIImageView *logoImgView;
    UIImageView *iconView;
    UILabel *nameLabel;
    UILabel *positionLabel;
    UIButton *messageBtn;
    UIButton *phoneBtn;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *headerTitleArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BXTPersonInfromViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.headerTitleArray = @[@"企业信息", @"项目信息", @"个人信息"];
    
    
    [self showLoadingMBP:@"数据加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request mailListOfOnePersonWithID:self.userID];
    
    [self createHeaderView];
    
    [self createFooterView];
}

#pragma mark -
#pragma mark - 初始化视图
- (void)createHeaderView
{
    // 背景色
    logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, valueForDevice(235.f, 213.f, 181.5f, 153.5f) + 30)];
    logoImgView.userInteractionEnabled = YES;
    logoImgView.image = [UIImage imageNamed:@"Nav_Bar"];
    if ([BXTGlobal shareGlobal].isRepair)
    {
        logoImgView.image = [UIImage imageNamed:@"Nav_Bars"];
    }
    [self.view addSubview:logoImgView];
    
    // 返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, valueForDevice(25.f, 25.f, 20.f, 15.f), 44, 44);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrowBack"] forState:UIControlStateNormal];
    @weakify(self);
    [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [logoImgView addSubview:backBtn];
    
    // title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, valueForDevice(35.f, 35.f, 30.f, 25.f), SCREEN_WIDTH-130, 20.f)];
    titleLabel.center = CGPointMake(SCREEN_WIDTH/2.f, titleLabel.center.y);
    titleLabel.text = @"个人信息";
    titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setTextColor:colorWithHexString(@"ffffff")];
    [logoImgView addSubview:titleLabel];
    
    // 头像
    iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + valueForDevice(25, 20, 12, 10), valueForDevice(90, 90, 80, 65), valueForDevice(90, 90, 80, 65))];
    iconView.center = CGPointMake(SCREEN_WIDTH/2.f, iconView.center.y);
    iconView.layer.cornerRadius = valueForDevice(90, 90, 80, 65)/2;
    iconView.layer.masksToBounds = YES;
    [logoImgView addSubview:iconView];
    
    // 姓名
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconView.frame) + (IS_IPHONE6 ? 12 : 8), 130.f, 20.f)];
    nameLabel.center = CGPointMake(SCREEN_WIDTH/2.f, nameLabel.center.y);
    nameLabel.text = @"王晓晓";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = colorWithHexString(@"ffffff");
    nameLabel.font = [UIFont boldSystemFontOfSize:17.f];
    [logoImgView addSubview:nameLabel];
    
    // 职位
    positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame) + (IS_IPHONE6 ? 12 : 8), 180.f, 20.f)];
    positionLabel.center = CGPointMake(SCREEN_WIDTH/2.f, positionLabel.center.y);
    positionLabel.text = @"XXXXXX部门经理";
    positionLabel.textAlignment = NSTextAlignmentCenter;
    positionLabel.textColor = colorWithHexString(@"ffffff");
    positionLabel.font = [UIFont systemFontOfSize:16.f];
    [logoImgView addSubview:positionLabel];
}

- (void)createFooterView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImgView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(logoImgView.frame) - 50) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // 发消息
    messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    messageBtn.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH/2-0.5, 49.5);
    messageBtn.backgroundColor = [UIColor whiteColor];
    messageBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    messageBtn.layer.borderWidth = 0.5;
    [messageBtn setImage:[UIImage imageNamed:@"speech_bubble"] forState:UIControlStateNormal];
    [self.view addSubview:messageBtn];
    
    // 打电话
    phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBtn.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-50, SCREEN_WIDTH/2-0.5, 49.5);
    phoneBtn.backgroundColor = [UIColor whiteColor];
    phoneBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    phoneBtn.layer.borderWidth = 0.5;
    [phoneBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [self.view addSubview:phoneBtn];
}


#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.dataArray[section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.headerTitleArray[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (data.count > 0)
    {
        NSDictionary *infoDict = data[0];
        BXTPersonInform *informModel = [BXTPersonInform modelObjectWithDictionary:infoDict];
        
        NSDictionary *stores_checks = infoDict[@"stores_checks"];
        
        // 完善信息
        [iconView sd_setImageWithURL:[NSURL URLWithString:informModel.head_pic] placeholderImage:[UIImage imageNamed:@"login_normal"]];
        nameLabel.text = informModel.name;
        positionLabel.text = informModel.department;
        
        @weakify(self);
        [[messageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self connectTaWithOutID:informModel];
        }];
        
        [[phoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", informModel.mobile];
            UIWebView *callWeb = [[UIWebView alloc] init];
            [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
            [self.view addSubview:callWeb];
        }];
        
        NSArray *section0 = @[@"发生了房间啊速度来发掘噢啦打发"];
        NSArray *section1 = @[@"ddd", @"gggg"];
        NSArray *section2 = @[stores_checks[@"checks_user"], stores_checks[@"checks_user_mobile"], stores_checks[@"checks_user_department"], stores_checks[@"checks_user_department"], stores_checks[@"checks_user_department"]];
        [self.dataArray addObjectsFromArray:@[section0, section1, section2]];
        
        [self.tableView reloadData];
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

- (void)connectTaWithOutID:(BXTPersonInform *)model
{
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = model.out_userid;
    
    //    NSString *my_userID = [BXTGlobal getUserProperty:U_USERID];
    //    if ([userInfo.userId isEqualToString:my_userID]) return;
    
    userInfo.name = model.name;
    userInfo.portraitUri = model.head;
    
    NSMutableArray *usersArray = [BXTGlobal getUserProperty:U_USERSARRAY];
    if (usersArray)
    {
        NSArray *arrResult = [usersArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.userId = %@",userInfo.userId]];
        if (arrResult.count)
        {
            RCUserInfo *temp_userInfo = arrResult[0];
            NSInteger index = [usersArray indexOfObject:temp_userInfo];
            [usersArray replaceObjectAtIndex:index withObject:temp_userInfo];
        }
        else
        {
            [usersArray addObject:userInfo];
        }
    }
    else
    {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:userInfo];
        [BXTGlobal setUserProperty:array withKey:U_USERSARRAY];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HaveConnact" object:nil];
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:NO];
    
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE;
    conversationVC.targetId = userInfo.userId;
    conversationVC.title = userInfo.name;
    // 删除位置功能
    //[conversationVC.pluginBoardView removeItemAtIndex:2];
    [self.navigationController pushViewController:conversationVC animated:YES];
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
