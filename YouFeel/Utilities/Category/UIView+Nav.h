//
//  UIView+Nav.h
//  BXT
//
//  Created by Jason on 15/9/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Nav)

- (UINavigationController *)navigation;

- (void)showLoadingMBP:(NSString *)text;

- (void)hideMBP;

@end
