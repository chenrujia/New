//
//  UnReadNoticeView.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTUnReadNoticeView.h"

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

@end