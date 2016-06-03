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
#import "BXTHeaderForVC.h"
#import "BXTMailRootInfo.h"
#import "ANKeyValueTable.h"
#import "BXTMailListViewController.h"
#import "BXTRemindNum.h"
#import "UITabBar+badge.h"

@interface BXTMailViewController () <BXTDataResponseDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation BXTMailViewController

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
 
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:NO];
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION)]];
   
    UIButton * nav_rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nav_rightButton.frame = CGRectMake(0, 20, 44, 44);
    [nav_rightButton setImage:[UIImage imageNamed:@"mail_address_book"] forState:UIControlStateNormal];
    [nav_rightButton setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    @weakify(self);
    [[nav_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.dataArray.count == 1)
        {
            BXTMailListViewController *mlvc = [[BXTMailListViewController alloc] init];
            mlvc.hidesBottomBarWhenPushed = YES;
            mlvc.transMailInfo = self.dataArray[0];
            [self.navigationController pushViewController:mlvc animated:YES];
        }
        else
        {
            BXTMailRootViewController *mlvc = [[BXTMailRootViewController alloc] init];
            mlvc.hidesBottomBarWhenPushed = YES;
            mlvc.dataArray = self.dataArray;
            [self.navigationController pushViewController:mlvc animated:YES];
        }
    }];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:nav_rightButton];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10;
    self.navigationItem.rightBarButtonItems = @[spaceItem, rightItem];
    self.dataArray = [[NSMutableArray alloc] init];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReloadMailList" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.conversationListTableView reloadData];
    }];
    
    [BXTGlobal showLoadingMBP:@"数据加载中..."];
    /** 通讯录列表 **/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request mailListOfAllPerson];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    
    if ([BXTRemindNum sharedManager].app_show) {
        [self.tabBarController.tabBar showBadgeOnItemIndex:3];
    }
    else {
        [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BXTRepairButtonOther" object:nil];
    
    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [[RCIMClient sharedRCIMClient] getTotalUnreadCount]];
    if ([[RCIMClient sharedRCIMClient] getTotalUnreadCount] == 0)
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        self.navigationController.tabBarItem.badgeValue = nil;
    }
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    
    if (type == Mail_Get_All && data.count > 0)
    {
        NSMutableArray *shopIDsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in data)
        {
            BXTMailRootInfo *mail = [BXTMailRootInfo modelWithDict:dict];
            [self.dataArray addObject:mail];
            [shopIDsArray addObject:mail.shop_id];
        }

        NSString *idStr = [shopIDsArray componentsJoinedByString:@","];
        if (![ValueFUD(@"user_lists_shop_ids") isEqualToString:idStr])
        {
            /** 通讯录列表 **/
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request mailListOfUserListWithShopIDs:idStr];
        }
        SaveValueTUD(@"user_lists_shop_ids", idStr);
    }
    else if (type == Mail_User_list && data.count > 0)
    {
        [[ANKeyValueTable userDefaultTable] setValue:data withKey:YMAILLISTSAVE];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
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

@end
