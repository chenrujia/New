//
//  UnReadNoticeView.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTUnReadNoticeView.h"
#import "UIView+Nav.h"

@interface BXTUnReadNoticeView ()

@end

@implementation BXTUnReadNoticeView

#pragma mark -
#pragma mark - 初始化
- (void)initial
{
    [super initial];
    
    [self requestNetResourceWithReadState:NoticeType_UnRead];
}

// 点击返回刷新
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTReadNotice *model = self.dataArray[indexPath.section];
    
    BXTNoticeInformViewController *nivc = [[BXTNoticeInformViewController alloc] init];
    nivc.urlStr = model.view_url;
    nivc.delegateSignal = [RACSubject subject];
    [nivc.delegateSignal subscribeNext:^(id x) {
        [self.tableView.mj_header beginRefreshing];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"beginRefreshing" object:nil];
    }];
    [[self navigation] pushViewController:nivc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
