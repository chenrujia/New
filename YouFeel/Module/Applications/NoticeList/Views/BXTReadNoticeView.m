//
//  ReadNoticeView.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTReadNoticeView.h"

@interface BXTReadNoticeView () <BXTDataResponseDelegate>

@end

@implementation BXTReadNoticeView

#pragma mark -
#pragma mark - 初始化
- (void)initial
{
    [super initial];
    
    [self requestNetResourceWithReadState:NoticeType_Read];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTReadNotice *model = self.dataArray[indexPath.section];
    
    BXTNoticeInformViewController *nivc = [[BXTNoticeInformViewController alloc] init];
    nivc.urlStr = model.view_url;
    nivc.delegateSignal = [RACSubject subject];
    [nivc.delegateSignal subscribeNext:^(id x) {
        [self.tableView.mj_header beginRefreshing];
    }];
    [[self getNavigation] pushViewController:nivc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
