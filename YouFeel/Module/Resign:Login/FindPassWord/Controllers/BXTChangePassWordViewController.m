//
//  BXTChangePassWordViewController.m
//  YouFeel
//
//  Created by Jason on 15/10/30.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTChangePassWordViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTResignTableViewCell.h"
#import "BXTProjectAddNewViewController.h"
#import "ANKeyValueTable.h"
#import "BXTPlaceInfo.h"

@interface BXTChangePassWordViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BXTDataResponseDelegate>

@property (weak, nonatomic) IBOutlet UITableView *currentTable;
@property (nonatomic ,copy) NSString *pwStr;
@property (nonatomic ,copy) NSString *pwAgainStr;
@property (nonatomic ,copy) NSString *pw_ID;
@property (nonatomic ,copy) NSString *pw_Key;

@end

@implementation BXTChangePassWordViewController

- (void)dataWithUserID:(NSString *)userID withKey:(NSString *)key
{
    self.pw_ID = userID;
    self.pw_Key = key;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"1111";
    [self navigationSetting:@"修改密码" andRightTitle:nil andRightImage:nil];
    [_currentTable registerNib:[UINib nibWithNibName:@"BXTResignTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    [_currentTable setRowHeight:50.f];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 16.f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (section == 0)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16.f)];
    }
    else
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    }
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 80.f;
    }
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.f)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *nextTapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextTapBtn.frame = CGRectMake(20, 30, SCREEN_WIDTH - 40, 50.f);
        [nextTapBtn setTitle:@"重设登录密码" forState:UIControlStateNormal];
        [nextTapBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [nextTapBtn setBackgroundColor:colorWithHexString(@"3cafff")];
        nextTapBtn.layer.masksToBounds = YES;
        nextTapBtn.layer.cornerRadius = 4.f;
        @weakify(self);
        [[nextTapBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if ([self.pwStr isEqual:self.pwAgainStr])
            {
                [self showLoadingMBP:@"正在更改，请稍候..."];
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request changePassWord:self.pwStr andWithID:self.pw_ID andWithKey:self.pw_Key];
            }
            else
            {
                [self showMBP:@"两次输入不一致！" withBlock:nil];
            }
        }];
        [view addSubview:nextTapBtn];
        return view;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5.f)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTResignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.tf_left.constant = 15.f;
    cell.textField.secureTextEntry = YES;
    @weakify(self);
    if (indexPath.section == 0)
    {
        cell.textField.placeholder = @"设置新密码（长度在6~32字符之间）";
        cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
        [cell.textField.rac_textSignal subscribeNext:^(id x) {
            @strongify(self);
            self.pwStr = x;
        }];
    }
    else
    {
        cell.textField.placeholder = @"再次确认密码";
        cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
        [cell.textField.rac_textSignal subscribeNext:^(id x) {
            @strongify(self);
            self.pwAgainStr = x;
        }];
    }
    
    cell.nameLabel.hidden = YES;
    cell.codeButton.hidden = YES;
    cell.boyBtn.hidden = YES;
    cell.girlBtn.hidden = YES;
    cell.textField.delegate = self;
    
    return cell;
}

#pragma mark -
#pragma mark BXTDataRequestDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    if (type == LoginType && [[dic objectForKey:@"returncode"] isEqualToString:@"0"])
    {
        NSArray *dataArray = [dic objectForKey:@"data"];
        NSDictionary *userInfoDic = [dataArray objectAtIndex:0];
        [BXTAbroadUserInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"userID":@"id"};
        }];
        [BXTResignedShopInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"shopID":@"id"};
        }];
        BXTAbroadUserInfo *abUserInfo = [BXTAbroadUserInfo mj_objectWithKeyValues:userInfoDic];
        
        [BXTGlobal setUserProperty:abUserInfo.name withKey:U_NAME];
        [BXTGlobal setUserProperty:abUserInfo.pic withKey:U_HEADERIMAGE];
        [BXTGlobal setUserProperty:abUserInfo.im_token withKey:U_IMTOKEN];
        [BXTGlobal setUserProperty:abUserInfo.token withKey:U_TOKEN];
        [BXTGlobal setUserProperty:abUserInfo.shop_ids withKey:U_SHOPIDS];
        [BXTGlobal setUserProperty:abUserInfo.userID withKey:U_USERID];
        [BXTGlobal setUserProperty:abUserInfo.my_shop withKey:U_MYSHOP];
        
        if (abUserInfo.my_shop && abUserInfo.my_shop.count > 0)
        {
            BXTResignedShopInfo *shopInfo = abUserInfo.my_shop[0];
            NSString *shopID = shopInfo.shopID;
            NSString *shopName = shopInfo.shop_name;
            BXTHeadquartersInfo *companyInfo = [[BXTHeadquartersInfo alloc] init];
            companyInfo.company_id = shopID;
            companyInfo.name = shopName;
            [BXTGlobal setUserProperty:companyInfo withKey:U_COMPANY];
            NSString *url = [NSString stringWithFormat:@"%@&shop_id=%@&token=%@",KAPIBASEURL, shopID, [BXTGlobal getUserProperty:U_TOKEN]];
            [BXTGlobal shareGlobal].baseURL = url;
            
            dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(concurrentQueue, ^{
                /**请求位置列表**/
                if (![[ANKeyValueTable userDefaultTable] valueWithKey:YPLACESAVE])
                {
                    BXTDataRequest *location_request = [[BXTDataRequest alloc] initWithDelegate:self];
                    [location_request listOFPlaceIsAllPlace:YES];
                }
            });
            dispatch_async(concurrentQueue, ^{
                /**分店登录**/
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request branchLogin];
            });
        }
        else
        {
            BXTProjectAddNewViewController *authenticationVC = [[BXTProjectAddNewViewController alloc] init];
            [self.navigationController pushViewController:authenticationVC animated:YES];
        }
    }
    else if (type == BranchLogin && [[dic objectForKey:@"returncode"] isEqualToString:@"0"])
    {
        NSArray *data = [dic objectForKey:@"data"];
        if (data.count > 0)
        {
            NSDictionary *userInfo = data[0];
            [[BXTGlobal shareGlobal] branchLoginWithDic:userInfo isPushToRootVC:YES];
        }
    }
    else if (type == PlaceLists && [[dic objectForKey:@"returncode"] isEqualToString:@"0"])
    {
        NSArray *data = [dic objectForKey:@"data"];
        [BXTPlaceInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"placeID":@"id"};
        }];
        NSMutableArray *dataSource = [[NSMutableArray alloc] init];
        [dataSource addObjectsFromArray:[BXTPlaceInfo mj_objectArrayWithKeyValuesArray:data]];
        [[ANKeyValueTable userDefaultTable] setValue:dataSource withKey:YPLACESAVE];
    }
    else if (type == PlaceLists && ![[dic objectForKey:@"returncode"] isEqualToString:@"0"])
    {
        BXTDataRequest *location_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [location_request listOFPlaceIsAllPlace:YES];
    }
    else
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            @weakify(self);
            [self showMBP:@"重设密码成功！" withBlock:^(BOOL hidden) {
                @strongify(self);
                [BXTGlobal setUserProperty:self.pwStr withKey:U_PASSWORD];
                
                NSDictionary *userInfoDic;
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"])
                {
                    userInfoDic = @{@"username":[BXTGlobal getUserProperty:U_USERNAME],
                                    @"password":self.pwStr,
                                    @"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"],
                                    @"type":@"1"};
                }
                else
                {
                    userInfoDic = @{@"username":[BXTGlobal getUserProperty:U_USERNAME],
                                    @"password":self.pwStr,
                                    @"cid":@"",
                                    @"type":@"1"};
                }
                
                BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
                [dataRequest loginUser:userInfoDic];
            }];
        }
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
    if (type == PlaceLists)
    {
        BXTDataRequest *location_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [location_request listOFPlaceIsAllPlace:YES];
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
