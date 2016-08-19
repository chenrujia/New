//
//  NSMutableDictionary+ErrorLog.m
//  YouFeel
//
//  Created by Jason on 16/8/17.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "NSMutableDictionary+ErrorLog.h"
#import <objc/runtime.h>
#import "BXTPublicSetting.h"

@implementation NSMutableDictionary (ErrorLog)

+(void)load
{
    //交换方法（防错措施）
    Method originAddMethod = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:));
    
    Method newAddMethod = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(el_setObject:forKey:));
    
    method_exchangeImplementations(originAddMethod, newAddMethod);
}

- (void)el_setObject:(id)object forKey:(NSString *)key
{
    if (object != nil)
    {
        [self el_setObject:object forKey:key];
    }
    else
    {
        DLog(@"数组添加nil");
    }
}

@end
