//
//  UIAlertView+BlockT.h
//  MyFramework
//
//  Created by 满孝意 on 15/12/22.
//  Copyright © 2015年 满孝意. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (BlockT) <UIAlertViewDelegate>

// 用Block的方式回调，这时候会默认用self作为Delegate
- (void)showWithBlock:(void(^)(NSInteger buttonIndex)) block;

@end
