//
//  UIAlertView+BlockT.m
//  MyFramework
//
//  Created by 满孝意 on 15/12/22.
//  Copyright © 2015年 满孝意. All rights reserved.
//

#import "UIAlertView+BlockT.h"
#import <objc/runtime.h>

@implementation UIAlertView (BlockT)

static char key;

- (void)showWithBlock:(void(^)(NSInteger buttonIndex))block {
    if (block) {
        objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, &key, block, OBJC_ASSOCIATION_COPY);
        self.delegate = self;
    }
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    void(^block)(NSInteger buttonIndex);
    block = objc_getAssociatedObject(self, &key);
    
    if (block) {
        block(buttonIndex);
    }
}

@end
