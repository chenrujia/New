//
//  MYPieElement.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/25.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "MYPieElement.h"

@implementation MYPieElement

- (id)copyWithZone:(NSZone *)zone
{
    MYPieElement *copyElem = [super copyWithZone:zone];
    copyElem.title = self.title;
    
    return copyElem;
}

@end
