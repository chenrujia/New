//
//  BXTChatListViewController.m
//  YouFeel
//
//  Created by Jason on 15/10/28.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTChatListViewController.h"
#import "BXTHeaderForVC.h"

@interface BXTChatListViewController ()

@end

@implementation BXTChatListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:NO];
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION)]];
    
    self.title = @"会话";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"  返回" style:UIBarButtonItemStylePlain target:self action:@selector(navigationLeftButton)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)navigationLeftButton
{
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:YES];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc] init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.userName = model.conversationTitle;
    conversationVC.title = model.conversationTitle;
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
