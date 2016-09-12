//
//  UIView+ObtainVC.m
//  YouFeel
//
//  Created by Jason on 16/9/7.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "UIView+ObtainVC.h"

@implementation UIView (ObtainVC)

- (UIViewController *)viewController
{
    UIViewController *viewController = nil;
    UIResponder *next = self.nextResponder;
    while (next)
    {
        if ([next isKindOfClass:[UIViewController class]])
        {
            viewController = (UIViewController *)next;
            break;
        }
        next = next.nextResponder;
    }
    return viewController;
}

@end
