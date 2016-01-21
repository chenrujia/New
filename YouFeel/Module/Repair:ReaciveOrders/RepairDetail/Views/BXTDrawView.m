//
//  BXTDrawView.m
//  BXT
//
//  Created by Jason on 15/9/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTDrawView.h"
#import "BXTHeaderFile.h"
#import "UIView+ZXQuartz.h"

@implementation BXTDrawView

- (instancetype)initWithFrame:(CGRect)frame withRepairState:(NSInteger)state withIsRespairing:(NSInteger)repairing isShowState:(BOOL)show
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = colorWithHexString(@"ffffff");
        self.isShow = show;
        self.repairState = state;
        self.isRepairing = repairing;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIColor *grayColor = colorWithHexString(@"e2e6e8");
    [grayColor setStroke];
    [grayColor setFill];
//    [self drawLineFrom:CGPointMake(0, 0) to:CGPointMake(rect.size.width, 0) withLineWidth:1.f];
    
    if (_isShow)
    {
        [self drawTextInRect:CGRectMake(15.f, 10, 40.f, 20.f) Contents:@"状态" contentFont:[UIFont systemFontOfSize:16.f] contentColor:colorWithHexString(@"000000")];
    }
    
    [grayColor setStroke];
    [grayColor setFill];
    CGFloat x = 30.f;
    CGFloat y = 45.f;
    //最下面那个灰色长条
    [self drawLineFrom:CGPointMake(x, y) to:CGPointMake(rect.size.width - x, y) withLineWidth:10.f];
    
    UIColor *orangeColor = colorWithHexString(@"febd2d");
    [orangeColor setStroke];
    [orangeColor setFill];
    
    CGFloat space = (SCREEN_WIDTH - x*2.f)/4.f;
    
    switch (_repairState)
    {
        case 1:
            [self drawCircleWithCenter:CGPointMake(x, y) radius:10.f];
            [grayColor setStroke];
            [grayColor setFill];
            [self drawCircleWithCenter:CGPointMake(x + space, y) radius:10.f];
            [self drawCircleWithCenter:CGPointMake(x + space * 2, y) radius:10.f];
            [self drawCircleWithCenter:CGPointMake(x + space * 3, y) radius:10.f];
            [self drawCircleWithCenter:CGPointMake(x + space * 4, y) radius:10.f];
            break;
        case 2:
            if (_isRepairing == 1)
            {
                [self drawCircleWithCenter:CGPointMake(x, y) radius:10.f];
                [self drawLineFrom:CGPointMake(x, y) to:CGPointMake(x + space, y) withLineWidth:10.f];
                [self drawCircleWithCenter:CGPointMake(x + space, y) radius:10.f];
                [grayColor setStroke];
                [grayColor setFill];
                [self drawCircleWithCenter:CGPointMake(x + space * 2, y) radius:10.f];
                [self drawCircleWithCenter:CGPointMake(x + space * 3, y) radius:10.f];
                [self drawCircleWithCenter:CGPointMake(x + space * 4, y) radius:10.f];
            }
            else if (_isRepairing == 2)
            {
                [self drawCircleWithCenter:CGPointMake(x, y) radius:10.f];
                [self drawLineFrom:CGPointMake(x, y) to:CGPointMake(x + space, y) withLineWidth:10.f];
                [self drawCircleWithCenter:CGPointMake(x + space, y) radius:10.f];
                [self drawLineFrom:CGPointMake(x + space, y) to:CGPointMake(x + space * 2, y) withLineWidth:10.f];
                [self drawCircleWithCenter:CGPointMake(x + space * 2, y) radius:10.f];
                [grayColor setStroke];
                [grayColor setFill];
                [self drawCircleWithCenter:CGPointMake(x + space * 3, y) radius:10.f];
                [self drawCircleWithCenter:CGPointMake(x + space * 4, y) radius:10.f];
            }
            break;
        case 3:
            [self drawCircleWithCenter:CGPointMake(x, y) radius:10.f];
            [self drawLineFrom:CGPointMake(x, y) to:CGPointMake(x + space, y) withLineWidth:10.f];
            [self drawCircleWithCenter:CGPointMake(x + space, y) radius:10.f];
            [self drawLineFrom:CGPointMake(x + space, y) to:CGPointMake(x + space * 2, y) withLineWidth:10.f];
            [self drawCircleWithCenter:CGPointMake(x + space * 2, y) radius:10.f];
            [self drawLineFrom:CGPointMake(x + space * 2, y) to:CGPointMake(x + space * 3, y) withLineWidth:10.f];
            [self drawCircleWithCenter:CGPointMake(x + space * 3, y) radius:10.f];
            [grayColor setStroke];
            [grayColor setFill];
            [self drawCircleWithCenter:CGPointMake(x + space * 4, y) radius:10.f];
            break;
        case 5:
            [self drawCircleWithCenter:CGPointMake(x, y) radius:10.f];
            [self drawLineFrom:CGPointMake(x, y) to:CGPointMake(x + space, y) withLineWidth:10.f];
            [self drawCircleWithCenter:CGPointMake(x + space, y) radius:10.f];
            [self drawLineFrom:CGPointMake(x + space, y) to:CGPointMake(x + space * 2, y) withLineWidth:10.f];
            [self drawCircleWithCenter:CGPointMake(x + space * 2, y) radius:10.f];
            [self drawLineFrom:CGPointMake(x + space * 2, y) to:CGPointMake(x + space * 3, y) withLineWidth:10.f];
            [self drawCircleWithCenter:CGPointMake(x + space * 3, y) radius:10.f];
            [self drawLineFrom:CGPointMake(x + space * 3, y) to:CGPointMake(x + space * 4, y) withLineWidth:10.f];
            [self drawCircleWithCenter:CGPointMake(x + space * 4, y) radius:10.f];
            break;
        default:
            break;
    }

    [self drawTextInRect:CGRectMake(6.f, 62, 60.f, 20.f) Contents:@"等待中" contentFont:[UIFont systemFontOfSize:15.f] contentColor:colorWithHexString(@"909497")];
    [self drawTextInRect:CGRectMake(x + space - 23.f, 62, 60.f, 20.f) Contents:@"已接单" contentFont:[UIFont systemFontOfSize:15.f] contentColor:colorWithHexString(@"909497")];
    [self drawTextInRect:CGRectMake(x + space * 2 - 23.f, 62, 60.f, 20.f) Contents:@"维修中" contentFont:[UIFont systemFontOfSize:15.f] contentColor:colorWithHexString(@"909497")];
    [self drawTextInRect:CGRectMake(x + space * 3 - 23.f, 62, 60.f, 20.f) Contents:@"已完成" contentFont:[UIFont systemFontOfSize:15.f] contentColor:colorWithHexString(@"909497")];
    [self drawTextInRect:CGRectMake(x + space * 4 - 23.f, 62, 60.f, 20.f) Contents:@"已评价" contentFont:[UIFont systemFontOfSize:15.f] contentColor:colorWithHexString(@"909497")];
}

@end
