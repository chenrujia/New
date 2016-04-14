//
//  BXTMailViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/6.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMailViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTMailRootViewController.h"
#import "UINavigationController+YRBackGesture.h"
#import "BXTProjectManageViewController.h"
#import "BXTMailUserListInfo.h"
#import "ANKeyValueTable.h"

@interface BXTMailViewController () <BXTDataResponseDelegate>

@end

@implementation BXTMailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BXTRepairButtonOther" object:nil];
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@" " object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.conversationListTableView reloadData];
    }];
    
    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [[RCIMClient sharedRCIMClient] getTotalUnreadCount]];
    if ([[RCIMClient sharedRCIMClient] getTotalUnreadCount] == 0)
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        self.navigationController.tabBarItem.badgeValue = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, SCREEN_WIDTH-160, 30)];
    label.font = [UIFont systemFontOfSize:18.0f];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"通讯录";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    
    /** 通讯录列表 **/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request mailListOfUserListWithShopIDs:@"0"];
    

    [[BXTGlobal shareGlobal] enableForIQKeyBoard:NO];
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION)]];
    
    
    UIButton * nav_rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nav_rightButton.frame = CGRectMake(SCREEN_WIDTH - 60, 20, 60, 44);
    nav_rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [nav_rightButton setImage:[UIImage imageNamed:@"mail_address_book"] forState:UIControlStateNormal];
    [nav_rightButton setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    @weakify(self);
    [[nav_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if ([self is_verify]) {
            BXTMailRootViewController *mlvc = [[BXTMailRootViewController alloc] init];
            mlvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mlvc animated:YES];
        }
    }];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:nav_rightButton];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10;
    
    self.navigationItem.rightBarButtonItems = @[spaceItem, rightItem];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    
    if (type == Mail_User_list && data.count > 0)
    {
        [BXTLists mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"userID":@"id"};
        }];
        NSMutableArray *dataSource = [[NSMutableArray alloc] init];
        [dataSource addObjectsFromArray:[BXTMailUserListInfo mj_objectArrayWithKeyValuesArray:data]];
        [[ANKeyValueTable userDefaultTable] setValue:dataSource withKey:YMAILLISTSAVE];
    }
    
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{

}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc] init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)is_verify
{
    NSString *is_verify = [BXTGlobal getUserProperty:U_IS_VERIFY];
    // TODO: -----------------  调试  -----------------
    if ([is_verify integerValue] == 1)
    {
        [BXTGlobal showText:@"您尚未验证，现在去验证" view:self.view completionBlock:^{
            BXTProjectManageViewController *pivc = [[BXTProjectManageViewController alloc] init];
            pivc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pivc animated:YES];
        }];
        return NO;
    }
    return YES;
}

@end
