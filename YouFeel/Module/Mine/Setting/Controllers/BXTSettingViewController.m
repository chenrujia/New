//
//  BXTSettingViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/9.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTSettingViewController.h"
#import "BXTDataRequest.h"
#import "ANKeyValueTable.h"
#import <RongIMKit/RongIMKit.h>
#import "AppDelegate.h"
#import "UINavigationController+YRBackGesture.h"
#import "BXTChangePassWordViewController.h"
#import "BXTAboutUsViewController.h"
#import "UIImageView+WebCache.h"

@interface BXTSettingViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BXTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"设置" andRightTitle:nil andRightImage:nil];
    
    [self createUI];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    self.dataArray = @[@[@"修改密码"], @[@"清除缓存", @"清除聊天记录"], @[@"关于我们"]];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quitBtn.frame = CGRectMake(20, 40, SCREEN_WIDTH-40, 50);
    [quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    quitBtn.backgroundColor = colorWithHexString(@"#36AFFD");
    quitBtn.layer.cornerRadius = 5;
    @weakify(self);
    [[quitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [MYAlertAction showActionSheetWithTitle:@"您确定退出登录" message:nil chooseBlock:^(NSInteger buttonIdx) {
            if (buttonIdx == 1) {
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request exitLoginWithClientID:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"]];
                [[RCIM sharedRCIM] disconnect];
                [[ANKeyValueTable userDefaultTable] clear];
                [BXTGlobal shareGlobal].isRepair = NO;
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndResign" bundle:nil];
                UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"BXTLoginViewController"];
                UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:loginVC];
                navigation.navigationBar.hidden = YES;
                navigation.enableBackGesture = YES;
                [AppDelegate appdelegete].window.rootViewController = navigation;
            }
        } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitle:@"确定", nil];
    }];
    [footerView addSubview:quitBtn];
}


#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [self showAlertWithTitle:@"验证原密码"message:@"为保障您的数据安全，请填写原密码"];
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            [MYAlertAction showActionSheetWithTitle:@"您确定清除缓存" message:nil chooseBlock:^(NSInteger buttonIdx) {
                if (buttonIdx == 1)
                {
                    // 清除缓存
                    [[SDImageCache sharedImageCache] clearDisk];
                    
                    [BXTGlobal showText:@"清除成功" view:self.view completionBlock:nil];
                }
            } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitle:@"确定", nil];
        }
        else if (indexPath.row == 1)
        {
            [MYAlertAction showActionSheetWithTitle:@"您确定清除聊天记录" message:nil chooseBlock:^(NSInteger buttonIdx) {
                if (buttonIdx == 1)
                {
                    // 清除聊天记录
                    NSArray *conversationArray = @[[NSNumber numberWithInteger:ConversationType_PRIVATE]];
                    [[RCIMClient sharedRCIMClient] clearConversations:conversationArray];
                    
                    [BXTGlobal showText:@"清除成功" view:self.view completionBlock:nil];
                }
            } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitle:@"确定", nil];
        }
        
    }
    else
    {
        BXTAboutUsViewController *auvc = [[BXTAboutUsViewController alloc] init];
        [self.navigationController pushViewController:auvc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - showAlert
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    if (IS_IOS_8)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = [alertController.textFields lastObject];
            [self vertifyPassword:textField.text];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:sureAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    if (buttonIndex == 1)
    {
        [self vertifyPassword:textField.text];
    }
}

- (void)vertifyPassword:(NSString *)textStr
{
    NSLog(@"textStr ---- %@", textStr);
    
    [self showLoadingMBP:@"正在验证中..."];
    
    NSDictionary *userInfoDic;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"])
    {
        userInfoDic = @{@"username":[BXTGlobal getUserProperty:U_USERNAME], @"password":textStr, @"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"]};
    }
    else
    {
        userInfoDic = @{@"username":[BXTGlobal getUserProperty:U_USERNAME], @"password":textStr, @"cid":@""};
    }
    
    BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
    [dataRequest loginUser:userInfoDic];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    
    NSDictionary *dic = response;
    if (type == LoginType && [dic[@"returncode"] intValue] == 0)
    {
        [BXTGlobal showText:@"验证成功" view:self.view completionBlock:^{
            // 重置密码
            NSString *userID = [BXTGlobal getUserProperty:U_USERID];
            NSString *username = [BXTGlobal getUserProperty:U_USERNAME];
            NSString *key = [BXTGlobal md5:[NSString stringWithFormat:@"%@%@", userID, username]];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndResign" bundle:nil];
            BXTChangePassWordViewController *changePassWordVC = (BXTChangePassWordViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTChangePassWordViewController"];
            [changePassWordVC dataWithUserID:userID withKey:key];
            [self.navigationController pushViewController:changePassWordVC animated:YES];
            self.navigationController.navigationBar.hidden = NO;
        }];
    }
    else
    {
        [BXTGlobal showText:@"密码错误，请重试" view:self.view completionBlock:nil];
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
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
