//
//  BXTLoginViewController.m
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTLoginViewController.h"
#import "BXTHeaderFile.h"
#import "BXTHeadquartersViewController.h"
#import "UIViewController+DismissKeyboard.h"
#import "BXTDataRequest.h"
#import "BXTHeadquartersInfo.h"

#define UserNameTag 11
#define PassWordTag 12

@interface BXTLoginViewController ()<BXTDataResponseDelegate>

@property (weak, nonatomic) IBOutlet UITextField        *nameTF;
@property (weak, nonatomic) IBOutlet UITextField        *passwordTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resign_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logo_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *back_top;
@property (nonatomic ,strong) NSString *userName;
@property (nonatomic ,strong) NSString *passWord;

- (IBAction)loginAction:(id)sender;

@end

@implementation BXTLoginViewController

- (void)dealloc
{
    LogBlue(@"登录界面释放了！！！！！！");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = colorWithHexString(@"ffffff");
    
    //!!!: 适配，适配，还得适配，醉了。。。
    if (IS_IPHONE4)
    {
        _logo_top.constant = 60.f;
        _back_top.constant = 175.f;
        _resign_bottom.constant = 20;
    }
    
    [_nameTF setValue:colorWithHexString(@"#96d3ff") forKeyPath:@"_placeholderLabel.textColor"];
    @weakify(self);
    [[_nameTF.rac_textSignal filter:^BOOL(id value) {
        NSString *str = value;
        return str.length == 11;
    }] subscribeNext:^(id x) {
        @strongify(self);
        self.userName = x;
    }];
    
    [_passwordTF setValue:colorWithHexString(@"#96d3ff") forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordTF.rac_textSignal subscribeNext:^(id x) {
        @strongify(self);
        self.passWord = x;
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)loginAction:(id)sender
{
    [self resignFirstResponder];
    
    if ([BXTGlobal validateMobile:self.userName])
    {
        [self showLoadingMBP:@"正在登录..."];
        
        [BXTGlobal setUserProperty:self.userName withKey:U_USERNAME];
        [BXTGlobal setUserProperty:self.passWord withKey:U_PASSWORD];
        
        NSDictionary *userInfoDic = @{@"username":self.userName,@"password":self.passWord,@"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"]};
        
        BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
        [dataRequest loginUser:userInfoDic];
    }
    else
    {
        [self showMBP:@"手机号格式不对" withBlock:nil];
    }
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response
                requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    if (type == LoginType && [[dic objectForKey:@"returncode"] isEqualToString:@"0"])
    {
        NSArray *dataArray = [dic objectForKey:@"data"];
        NSDictionary *userInfoDic = [dataArray objectAtIndex:0];
        
        [BXTGlobal setUserProperty:[userInfoDic objectForKey:@"gender"] withKey:U_SEX];
        [BXTGlobal setUserProperty:[userInfoDic objectForKey:@"name"] withKey:U_NAME];
        [BXTGlobal setUserProperty:[userInfoDic objectForKey:@"pic"] withKey:U_HEADERIMAGE];
        [BXTGlobal setUserProperty:[userInfoDic objectForKey:@"im_token"] withKey:U_IMTOKEN];
        [BXTGlobal setUserProperty:[userInfoDic objectForKey:@"token"] withKey:U_TOKEN];
        
        NSArray *shopids = [userInfoDic objectForKey:@"shop_ids"];
        [BXTGlobal setUserProperty:shopids withKey:U_SHOPIDS];
        
        NSString *userID = [NSString stringWithFormat:@"%@",[userInfoDic objectForKey:@"id"]];
        [BXTGlobal setUserProperty:userID withKey:U_USERID];
        
        NSArray *my_shop = [userInfoDic objectForKey:@"my_shop"];
        [BXTGlobal setUserProperty:my_shop withKey:U_MYSHOP];
        
        if (my_shop && my_shop.count > 0)
        {
            NSDictionary *shopsDic = my_shop[0];
            NSString *shopID = [shopsDic objectForKey:@"id"];
            NSString *shopName = [shopsDic objectForKey:@"shop_name"];
            BXTHeadquartersInfo *companyInfo = [[BXTHeadquartersInfo alloc] init];
            companyInfo.company_id = shopID;
            companyInfo.name = shopName;
            [BXTGlobal setUserProperty:companyInfo withKey:U_COMPANY];
            NSString *url = [NSString stringWithFormat:@"http://api.51bxt.com/?c=Port&m=actionGet_iPhone_v2_Port&shop_id=%@&token=%@", shopID, [BXTGlobal getUserProperty:U_TOKEN]];
            [BXTGlobal shareGlobal].baseURL = url;
            
            BXTDataRequest *pic_request = [[BXTDataRequest alloc] initWithDelegate:self];
            [pic_request updateHeadPic:[userInfoDic objectForKey:@"pic"]];
            
            /**分店登录**/
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request branchLogin];
        }
        else
        {
            BXTHeadquartersViewController *authenticationVC = [[BXTHeadquartersViewController alloc] init];
            [self.navigationController pushViewController:authenticationVC animated:YES];
        }
    }
    else if (type == BranchLogin && [[dic objectForKey:@"returncode"] isEqualToString:@"0"])
    {
        NSArray *data = [dic objectForKey:@"data"];
        if (data.count > 0)
        {
            NSDictionary *userInfo = data[0];
            [[BXTGlobal shareGlobal] reLoginWithDic:userInfo];
        }
    }
    else if (type == BranchLogin && [[dic objectForKey:@"returncode"] isEqualToString:@"002"])
    {
        [self hideMBP];
        BXTHeadquartersViewController *headVC = [[BXTHeadquartersViewController alloc] initWithType:YES];
        [self.navigationController pushViewController:headVC animated:YES];
    }
    else if (type == UpdateHeadPic)
    {
        NSLog(@"Update success");
    }
    else
    {
        [self hideMBP];
        [self showMBP:@"登录失败，请仔细检查！" withBlock:nil];
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
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
