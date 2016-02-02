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

@end
