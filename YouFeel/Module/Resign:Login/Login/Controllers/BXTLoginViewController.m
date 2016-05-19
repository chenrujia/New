//
//  BXTLoginViewController.m
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTLoginViewController.h"
#import "BXTHeaderFile.h"
#import "UIViewController+DismissKeyboard.h"
#import "BXTDataRequest.h"
#import "BXTHeadquartersInfo.h"
#import "AppDelegate.h"
#import "BXTPlaceInfo.h"
#import "ANKeyValueTable.h"
#import "BXTResignViewController.h"
#import "BXTProjectAddNewViewController.h"
#import <Crashlytics/Crashlytics.h>

#define UserNameTag 11
#define PassWordTag 12

@interface BXTLoginViewController ()<BXTDataResponseDelegate>

@property (weak, nonatomic) IBOutlet UITextField        *nameTF;
@property (weak, nonatomic) IBOutlet UITextField        *passwordTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logo_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *back_top;
@property (nonatomic ,strong) NSString *userName;
@property (nonatomic ,strong) NSString *passWord;

- (IBAction)loginAction:(id)sender;
- (IBAction)loginByWeiXin:(id)sender;

@end

@implementation BXTLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = colorWithHexString(@"ffffff");
    if (IS_IPHONE4)
    {
        self.logo_top.constant = 60.f;
        self.back_top.constant = 175.f;
    }
    if (![WXApi isWXAppInstalled])
    {
        self.wxLogin.hidden = YES;
    }
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"GotoResignVC" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndResign" bundle:nil];
        BXTResignViewController *resignVC = (BXTResignViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTResignViewController"];
        [resignVC isLoginByWeiXin:YES];
        [self.navigationController pushViewController:resignVC animated:YES];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"LoginAgin" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self loginIn];
    }];
    
    [self.nameTF setValue:colorWithHexString(@"#96d3ff") forKeyPath:@"_placeholderLabel.textColor"];
    if ([BXTGlobal getUserProperty:U_USERNAME])
    {
        self.nameTF.text = [BXTGlobal getUserProperty:U_USERNAME];
    }
    [[self.nameTF.rac_textSignal filter:^BOOL(id value) {
        NSString *str = value;
        return str.length == 11;
    }] subscribeNext:^(id x) {
        @strongify(self);
        self.userName = x;
    }];
    
    [self.passwordTF setValue:colorWithHexString(@"#96d3ff") forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTF.rac_textSignal subscribeNext:^(id x) {
        @strongify(self);
        self.passWord = x;
    }];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, 50, 100, 30);
    [button setTitle:@"Crash" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(crashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)crashButtonTapped:(id)sender
{
    [[Crashlytics sharedInstance] crash];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (IS_IPHONE6P)
    {
        
    }
    else if (IS_IPHONE6)
    {
        self.wx_bottom.constant = 40.f;
        [self.wxLogin layoutIfNeeded];
    }
    else if (IS_IPHONE5)
    {
        self.wx_bottom.constant = 20.f;
        [self.wxLogin layoutIfNeeded];
    }
    else if (IS_IPHONE4)
    {
        self.logo_y.constant = 30.f;
        [self.logoView layoutIfNeeded];
        self.login_back_y.constant = 130.f;
        [self.loginBackView layoutIfNeeded];
        self.wx_bottom.constant = 20.f;
        [self.wxLogin layoutIfNeeded];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [BXTGlobal shareGlobal].isLogin = NO;
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)loginAction:(id)sender
{
    [self.view endEditing:YES];
    [self resignFirstResponder];
    [self loginIn];
}

- (void)loginIn
{
    if ([BXTGlobal validateMobile:self.userName])
    {
        [self showLoadingMBP:@"正在登录..."];
        
        [BXTGlobal setUserProperty:self.userName withKey:U_USERNAME];
        [BXTGlobal setUserProperty:self.passWord withKey:U_PASSWORD];
        
        NSDictionary *userInfoDic;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"])
        {
            userInfoDic = @{@"username":self.userName,
                            @"password":self.passWord,
                            @"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"],
                            @"type":@"1"};
        }
        else
        {
            userInfoDic = @{@"username":self.userName,
                            @"password":self.passWord,
                            @"cid":@"",
                            @"type":@"1"};
        }
        
        BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
        [dataRequest loginUser:userInfoDic];
    }
    else
    {
        [self showMBP:@"手机号格式不对" withBlock:nil];
    }
}

- (IBAction)loginByWeiXin:(id)sender
{
    if ([WXApi isWXAppInstalled])
    {
        //授权登录
        SendAuthReq *req =[[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo"; // 此处不能随意改
        req.state = @"123"; // 这个貌似没影响
        [WXApi sendReq:req];
    }
    else
    {
        [MYAlertAction showAlertWithTitle:@"您未安装微信" msg:@"请使用其他方式登录" chooseBlock:^(NSInteger buttonIdx) {
            
        } buttonsStatement:@"确定", nil];
    }
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response
                requeseType:(RequestType)type
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
            if (![[ANKeyValueTable userDefaultTable] valueWithKey:YSAVEDSHOPID] || ![[[ANKeyValueTable userDefaultTable] valueWithKey:YSAVEDSHOPID] isEqualToString:shopID])
            {
                /**位置列表**/
                BXTDataRequest *location_request = [[BXTDataRequest alloc] initWithDelegate:self];
                [location_request listOFPlaceIsAllPlace];
            }
            else
            {
                NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
                NSInteger now = nowTime;
                NSInteger ago = [[[ANKeyValueTable userDefaultTable] valueWithKey:YSAVEDTIME] integerValue];
                //超过7天
                if (now - ago > 604800)
                {
                    /**位置列表**/
                    BXTDataRequest *location_request = [[BXTDataRequest alloc] initWithDelegate:self];
                    [location_request listOFPlaceIsAllPlace];
                }
            }
            [[ANKeyValueTable userDefaultTable] setValue:shopID withKey:YSAVEDSHOPID];
            
            /**分店登录**/
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request branchLogin];
        }
        else
        {
            BXTProjectAddNewViewController *authenticationVC = [[BXTProjectAddNewViewController alloc] init];
            [self.navigationController pushViewController:authenticationVC animated:YES];
        }
    }
    else if (type == BranchLogin)
    {
        if ([[dic objectForKey:@"returncode"] isEqualToString:@"0"])
        {
            NSArray *data = [dic objectForKey:@"data"];
            if (data.count > 0)
            {
                NSDictionary *userInfo = data[0];
                [[BXTGlobal shareGlobal] branchLoginWithDic:userInfo isPushToRootVC:YES];
            }
        }
        else
        {
            [BXTGlobal showText:@"登录失败，请仔细检查！" view:self.view completionBlock:nil];
        }
    }
    else if (type == BranchLogin && [[dic objectForKey:@"returncode"] isEqualToString:@"002"])
    {
        BXTProjectAddNewViewController *headVC = [[BXTProjectAddNewViewController alloc] initWithType:YES];
        [self.navigationController pushViewController:headVC animated:YES];
    }
    else if (type == LoginType && [[dic objectForKey:@"returncode"] isEqualToString:@"044"])
    {
        [MYAlertAction showAlertWithTitle:@"温馨提示" msg:@"授权到期，请联系软件相关人员！" chooseBlock:^(NSInteger buttonIdx) {
            if (buttonIdx == 1) {
                NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:4008937878"];
                UIWebView *callWeb = [[UIWebView alloc] init];
                [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
                [self.view addSubview:callWeb];
            }
        } buttonsStatement:@"取消", @"联系客服", nil];
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
        [[ANKeyValueTable userDefaultTable] synchronize:YES];
        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
        NSInteger now = nowTime;
        [[ANKeyValueTable userDefaultTable] setValue:[NSNumber numberWithInteger:now] withKey:YSAVEDTIME];
    }
    else if (type == PlaceLists && ![[dic objectForKey:@"returncode"] isEqualToString:@"0"])
    {
        BXTDataRequest *location_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [location_request listOFPlaceIsAllPlace];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
    if (type == PlaceLists)
    {
        BXTDataRequest *location_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [location_request listOFPlaceIsAllPlace];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
