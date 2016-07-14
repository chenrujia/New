//
//  BXTMainReadNoticeView.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTMainReadNoticeView : UIView

/** ---- 初始化 - 1未读 2已读 ---- */
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)readState;

@end
