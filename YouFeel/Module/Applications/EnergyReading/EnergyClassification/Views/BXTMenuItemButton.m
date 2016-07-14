//
//  BXTMenuItemButton.m
//  AllOther
//
//  Created by Jason on 16/6/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMenuItemButton.h"

#define   pi 3.14159265359
#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

@implementation BXTMenuItemButton

- (instancetype)initWithFrame:(CGRect)frame drawType:(DrawContentType)type backgroudColor:(UIColor *)backgroudColor
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.drawType = type;
        self.backColor = backgroudColor;
    }
    return self;
}

- (void)changeDrawColor:(UIColor *)color backgroudColor:(UIColor *)backgroudColor drawType:(DrawContentType)type
{
    self.drawColor = color;
    self.backColor = backgroudColor;
    self.drawType = type;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (self.drawType == DrawLeft)
    {
        [self drawNotChoosedItemOfThreeMiddleLeft:rect];
    }
    else if (self.drawType == DrawMiddle)
    {
        [self drawChoosedItemOfThreeMiddle:rect];
    }
    else if (self.drawType == DrawRight)
    {
        [self drawNotChoosedItemOfThreeMiddleRight:rect];
    }
}

- (void)drawNotChoosedItemOfThreeMiddleLeft:(CGRect)rect
{
    [self.drawColor set];
    UIBezierPath *rectPathOne = [UIBezierPath bezierPathWithRect:rect];
    [rectPathOne fill];
    
    [self.backColor set];
    UIBezierPath *rectPathTwo = [UIBezierPath bezierPathWithRect:CGRectMake(0, CGRectGetHeight(rect) - 10, 10, 10)];
    [rectPathTwo fill];
    
    [self.drawColor set];
    UIBezierPath *circularPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(10, CGRectGetHeight(rect) - 10.f)
                                                                   radius:10
                                                               startAngle:0
                                                                 endAngle:DEGREES_TO_RADIANS(360)
                                                                clockwise:YES];
    [circularPath fill];
}

- (void)drawNotChoosedItemOfThreeMiddleRight:(CGRect)rect
{
    [self.drawColor set];
    UIBezierPath *rectPathOne = [UIBezierPath bezierPathWithRect:rect];
    [rectPathOne fill];
    
    [self.backColor set];
    UIBezierPath *rectPathTwo = [UIBezierPath bezierPath];
    [rectPathTwo moveToPoint:CGPointMake(CGRectGetWidth(rect) - 10, CGRectGetHeight(rect))];
    [rectPathTwo addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) - 10)];
    [rectPathTwo addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [rectPathTwo fill];
    
    [self.drawColor set];
    UIBezierPath *circularPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(rect) - 10, CGRectGetHeight(rect) - 10.f)
                                                                   radius:10
                                                               startAngle:DEGREES_TO_RADIANS(0)
                                                                 endAngle:DEGREES_TO_RADIANS(90)
                                                                clockwise:YES];
    [circularPath fill];
}

//选中中间三个
- (void)drawChoosedItemOfThreeMiddle:(CGRect)rect
{
    [[UIColor whiteColor] set]; //设置线条颜色
    UIBezierPath *circularPathOne = [UIBezierPath bezierPathWithArcCenter:CGPointMake(10, 10)
                                                                   radius:10
                                                               startAngle:0
                                                                 endAngle:DEGREES_TO_RADIANS(360)
                                                                clockwise:YES];
    [circularPathOne fill];
    
    UIBezierPath *rectPathOne = [UIBezierPath bezierPathWithRect:CGRectMake(10, 0, CGRectGetWidth(rect) - 20, 10.f)];
    [rectPathOne fill];
    
    UIBezierPath *circularPathTwo = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(rect) - 10, 10)
                                                                   radius:10
                                                               startAngle:0
                                                                 endAngle:DEGREES_TO_RADIANS(360)
                                                                clockwise:YES];
    [circularPathTwo fill];
    
    UIBezierPath *rectPathTwo = [UIBezierPath bezierPathWithRect:CGRectMake(0, 10, CGRectGetWidth(rect), CGRectGetHeight(rect) - 10.f)];
    [rectPathTwo fill];
}

@end
