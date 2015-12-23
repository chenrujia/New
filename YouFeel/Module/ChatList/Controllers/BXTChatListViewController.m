//
//  BXTChatListViewController.m
//  YouFeel
//
//  Created by Jason on 15/10/28.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTChatListViewController.h"
#import "BXTHeaderForVC.h"
#import "UINavigationController+YRBackGesture.h"

@interface BXTChatListViewController ()

@end

@implementation BXTChatListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:NO];
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION)]];
    
    self.title = @"会话";
    UIButton *navi_leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navi_leftButton.frame = CGRectMake(0, 20, 44, 44);
    [navi_leftButton setImage:[UIImage imageNamed:@"arrowBack"] forState:UIControlStateNormal];
    @weakify(self);
    [[navi_leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [[BXTGlobal shareGlobal] enableForIQKeyBoard:YES];
        self.navigationController.navigationBar.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:navi_leftButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftItem, nil];
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc] init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    // 删除位置功能
    //[conversationVC.pluginBoardView removeItemAtIndex:2];
    [self.navigationController pushViewController:conversationVC animated:YES];
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
