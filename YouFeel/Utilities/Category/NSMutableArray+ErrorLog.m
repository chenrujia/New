//
//  NSMutableArray+ErrorLog.m
//  RuntimeDemo
//
//  Created by Jason on 16/8/15.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "NSMutableArray+ErrorLog.h"
#import <objc/runtime.h>
#import "BXTPublicSetting.h"

@implementation NSMutableArray (ErrorLog)

+(void)load
{
    //交换方法（防错措施）
    Method originAddMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:));
    
    Method newAddMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(el_addObject:));
    
    method_exchangeImplementations(originAddMethod, newAddMethod);
}

- (void)el_addObject:(id)object
{
    if (object != nil)
    {
        [self el_addObject:object];
    }
    else
    {
        DLog(@"数组添加nil");
    }
}

@end
