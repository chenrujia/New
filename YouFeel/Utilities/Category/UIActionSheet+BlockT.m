//
//  UIActionSheet+BlockT.m
//  MyFramework
//
//  Created by 满孝意 on 15/12/22.
//  Copyright © 2015年 满孝意. All rights reserved.
//

#import "UIActionSheet+BlockT.h"
#import <objc/runtime.h>

@implementation UIActionSheet (BlockT)

static char key;

- (void)showInView:(UIView *)view block:(void(^)(NSInteger idx))block {
    if (block) {
        objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, &key, block, OBJC_ASSOCIATION_COPY);
        self.delegate = self;
    }
    [self showInView:view];
}


// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    void(^block)(NSInteger idx);
    block = objc_getAssociatedObject(self, &key);
    if (block) {
        block(buttonIndex);
    }
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    
}

@end
