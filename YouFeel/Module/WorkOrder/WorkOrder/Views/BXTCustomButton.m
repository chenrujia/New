//
//  BXTCustomButton.m
//  AttributeViewDemo
//
//  Created by Jason on 16/3/25.
//  Copyright © 2016年 tangjp. All rights reserved.
//

#import "BXTCustomButton.h"

@implementation BXTCustomButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 8;
    CGFloat titleY = 0;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 17.f;
    CGFloat imageH = 17.f;
    
    return CGRectMake(5, 6, imageW, imageH);
}

@end
