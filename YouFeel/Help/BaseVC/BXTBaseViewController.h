//
//  BXTBaseViewController.h
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTBaseViewController : UIViewController

- (UIImageView *)navigationSetting:(NSString *)title andRightTitle:(NSString *)right_title andRightImage:(UIImage *)image;
- (void)navigationLeftButton;
- (void)navigationRightButton;
- (void)showMBP:(NSString *)text;
- (void)showLoadingMBP:(NSString *)text;
- (void)hideMBP;

@end
