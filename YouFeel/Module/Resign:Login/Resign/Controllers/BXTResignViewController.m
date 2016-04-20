//
//  BXTResignViewController.m
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTResignViewController.h"
#import "BXTNickNameViewController.h"
#import "UIViewController+DismissKeyboard.h"
#import "BXTHeaderFile.h"
#import "BXTResignTableViewCell.h"
#import "BXTDataRequest.h"
#import "ANKeyValueTable.h"
#import "BXTProjectAddNewViewController.h"

@interface BXTResignViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate>

@property (weak, nonatomic) IBOutlet UITableView *currentTable;
@property (nonatomic ,strong) NSString *userName;
@property (nonatomic ,strong) NSString *passWord;
@property (nonatomic ,strong) NSString *codeNumber;
@property (nonatomic ,strong) NSString *returncode;
@property (nonatomic ,strong) UIButton *codeBtn;

@end

@implementation BXTResignViewController

- (void)isLoginByWeiXin:(BOOL)loginType
{
    self.isLoginByWX = loginType;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //注册前删除任何缓存数据
    [[ANKeyValueTable userDefaultTable] clear];
    [self navigationSetting:@"注册" andRightTitle:nil andRightImage:nil];
    [self setupForDismissKeyboard];
    
    [_currentTable registerNib:[UINib nibWithNibName:@"BXTResignTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    _currentTable.rowHeight = 50.f;
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 16.f;//section头部高度
    }
    return 10.f;//section头部高度
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
    if ((_isLoginByWX && section == 1) || (!_isLoginByWX && section == 2))
    {
        return 80.f;
    }
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ((_isLoginByWX && section == 1) || (!_isLoginByWX && section == 2))
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.f)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *nextTapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextTapBtn.frame = CGRectMake(20, 30, SCREEN_WIDTH - 40, 50.f);
        [nextTapBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [nextTapBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [nextTapBtn setBackgroundColor:colorWithHexString(@"3cafff")];
        nextTapBtn.layer.masksToBounds = YES;
        nextTapBtn.layer.cornerRadius = 4.f;
        @weakify(self);
        [[nextTapBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (![BXTGlobal validateMobile:self.userName])
            {
                [self showMBP:@"手机号格式不对" withBlock:nil];
            }
            else if (![BXTGlobal validateCAPTCHA:self.codeNumber])
            {
                [self showMBP:@"请输入正确4位验证码" withBlock:nil];
            }
            else if (![self.codeNumber isEqualToString:self.returncode])
            {
                [self showMBP:@"验证码不正确" withBlock:nil];
            }
            else if (!_isLoginByWX && ![BXTGlobal validatePassword:self.passWord])
            {
                [self showMBP:@"请输入至少6位密码，仅限英文、数字" withBlock:nil];
            }
            else
            {
                [BXTGlobal setUserProperty:self.userName withKey:U_USERNAME];
                if (_isLoginByWX)
                {
                    [self showLoadingMBP:@"请稍后..."];
                    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                    NSDictionary *dic = @{@"only_code":[BXTGlobal shareGlobal].openID,
                                          @"mobile":self.userName,
                                          @"flat_id":@"1"};
                    [request bindingUser:dic];
                }
                else
                {
                    [BXTGlobal setUserProperty:self.passWord withKey:U_PASSWORD];
                    
                    BXTNickNameViewController *nickNameVC = [[BXTNickNameViewController alloc] init];
                    [nickNameVC isLoginByWeiXin:self.isLoginByWX];
                    [self.navigationController pushViewController:nickNameVC animated:YES];
                }
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
    if (_isLoginByWX)
    {
        return 2;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTResignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0)
    {
        cell.nameLabel.text = @"手机号";
        cell.textField.placeholder = @"请输入有效的手机号码";
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        @weakify(self);
        [[cell.textField.rac_textSignal filter:^BOOL(id value) {
            NSString *str = value;
            return str.length == 11;
        }] subscribeNext:^(id x) {
            @strongify(self);
            self.userName = x;
        }];
        cell.codeButton.hidden = YES;
    }
    else if (indexPath.section == 1)
    {
        cell.nameLabel.text = @"验证码";
        cell.textField.placeholder = @"请输入短信验证码";
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.codeButton.hidden = NO;
        @weakify(self);
        [[cell.codeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if ([BXTGlobal validateMobile:self.userName])
            {
                [self showLoadingMBP:@"正在获取..."];
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request mobileVerCode:self.userName];
                self.codeBtn.userInteractionEnabled = NO;
                [self.codeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
            else
            {
                [self showMBP:@"手机号格式不对" withBlock:nil];
            }
        }];
        self.codeBtn = cell.codeButton;
        [cell.textField.rac_textSignal subscribeNext:^(id x) {
            @strongify(self);
            self.codeNumber = x;
        }];
    }
    else
    {
        cell.nameLabel.text = @"密   码";
        cell.textField.placeholder = @"请输入登录密码，至少6位";
        cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
        cell.codeButton.hidden = YES;
        @weakify(self);
        [cell.textField.rac_textSignal subscribeNext:^(id x) {
            @strongify(self);
            self.passWord = x;
        }];
    }
    
    cell.boyBtn.hidden = YES;
    cell.girlBtn.hidden = YES;
    cell.textField.delegate = self;
    
    return cell;
}

#pragma mark -
#pragma mark BXTDataRequestDelegate
- (void)requestResponseData:(id)response
                requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    LogRed(@"%@",dic);
    if (type == BindingUser && [[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        NSDictionary *userInfoDic = @{@"username":@"",
                                      @"password":@"",
                                      @"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"],
                                      @"type":@"2",
                                      @"flat_id":@"1",
                                      @"only_code":[BXTGlobal shareGlobal].openID};
        BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
        [dataRequest loginUser:userInfoDic];
    }
    else if (type == BindingUser && [[dic objectForKey:@"returncode"] isEqualToString:@"002"])
    {
        BXTNickNameViewController *nickNameVC = [[BXTNickNameViewController alloc] init];
        [nickNameVC isLoginByWeiXin:self.isLoginByWX];
        [self.navigationController pushViewController:nickNameVC animated:YES];
    }
    else if (type == BindingUser && [[dic objectForKey:@"returncode"] isEqualToString:@"004"])
    {
        [self showMBP:@"该手机已经绑定了其他微信号，请更换手机号" withBlock:nil];
    }
    else if (type == BindingUser && [[dic objectForKey:@"returncode"] isEqualToString:@"014"])
    {
        [self showMBP:@"该手机号已绑定其他微信账户" withBlock:nil];
    }
    else if (type == LoginType && [[dic objectForKey:@"returncode"] isEqualToString:@"0"])
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
        
        [BXTGlobal setUserProperty:abUserInfo.username withKey:U_USERNAME];
        [BXTGlobal setUserProperty:abUserInfo.gender withKey:U_SEX];
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
    else if (type == GetVerificationCode && [[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        self.returncode = [NSString stringWithFormat:@"%@", [dic objectForKey:@"verification_code"]];
        [self updateTime];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
}

- (void)updateTime
{
    __block NSInteger count = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_time, dispatch_walltime(NULL, 3), 1.0 * NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(_time, ^{
        @strongify(self);
        count--;
        if (count <= 0)
        {
            dispatch_source_cancel(_time);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.codeBtn.userInteractionEnabled = YES;
                [self.codeBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
                [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeBtn setTitle:[NSString stringWithFormat:@"重新获取 %ld",(long)count] forState:UIControlStateNormal];
            });
        }
    });
    dispatch_resume(_time);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
