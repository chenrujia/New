//
//  GJRedDot.m
//  GJRedDotDemo
//
//  Created by wangyutao on 16/5/20.
//  Copyright © 2016年 wangyutao. All rights reserved.
//

#import "GJRedDot.h"

@implementation GJRedDot

+ (void)registWithProfile:(NSArray *)profile {
    NSAssert(profile.count, @"GJRedDot: You can't regist an empty profiles");
    [[GJRedDotManager sharedManager] registWithProfile:profile];
}

+ (void)registWithProfile:(NSArray *)profile
                modelType:(GJRedDotModelType)modelType
           protocolObject:(id<GJRedDotProtocol>)object {
    if ((modelType == GJRedDotModelCustom && !object) ||
        modelType == GJRedDotModelUserDefault) {
        [self registWithProfile:profile];
        return;
    }
    
    
}
@end
