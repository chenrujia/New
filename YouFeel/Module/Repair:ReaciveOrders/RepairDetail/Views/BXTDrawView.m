//
//  BXTDrawView.m
//  BXT
//
//  Created by Jason on 15/9/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTDrawView.h"
#import "BXTHeaderFile.h"
#import "BXTRepairDetailInfo.h"
#import "UIView+ZXQuartz.h"

@implementation BXTDrawView

- (instancetype)initWithFrame:(CGRect)frame
                 withProgress:(NSArray *)progresses
                  isShowState:(BOOL)show
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = colorWithHexString(@"ffffff");
        self.isShow = show;
        self.progress = progresses;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIColor *grayColor = colorWithHexString(@"e2e6e8");
    [grayColor setStroke];
    [grayColor setFill];
    
    if (_isShow)
    {
        [self drawTextInRect:CGRectMake(15.f, 10, 40.f, 20.f) Contents:@"状态" contentFont:[UIFont systemFontOfSize:16.f] contentColor:colorWithHexString(@"000000")];
    }
    
    [grayColor setStroke];
    [grayColor setFill];
    CGFloat x = 40.f;
    CGFloat y = 45.f;
    //最下面那个灰色长条
    [self drawLineFrom:CGPointMake(x, y) to:CGPointMake(rect.size.width - x, y) withLineWidth:10.f];
    
    UIColor *orangeColor = colorWithHexString(@"febd2d");
    [orangeColor setStroke];
    [orangeColor setFill];
    
    if (_progress.count == 0) return;
    BXTProgressInfo *progressOne = _progress[0];
    BXTProgressInfo *progressTwo = _progress[1];
    BXTProgressInfo *progressThree = _progress[2];
    BXTProgressInfo *progressFour = _progress[3];
    BXTProgressInfo *progressFive = _progress[4];
    CGFloat space = (SCREEN_WIDTH - x*2.f)/4.f;
    
    if (progressOne.state && !progressTwo.state)
    {
        [self drawCircleWithCenter:CGPointMake(x, y) radius:10.f];
        [grayColor setStroke];
        [grayColor setFill];
        [self drawCircleWithCenter:CGPointMake(x + space, y) radius:10.f];
        [self drawCircleWithCenter:CGPointMake(x + space * 2, y) radius:10.f];
        [self drawCircleWithCenter:CGPointMake(x + space * 3, y) radius:10.f];
        [self drawCircleWithCenter:CGPointMake(x + space * 4, y) radius:10.f];
    }
    else if (progressTwo.state && !progressThree.state)
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
    else if (progressThree.state && !progressFour.state)
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
    else if (progressFour.state && !progressFive.state)
    {
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
    }
    else if (progressFive.state)
    {
        [self drawCircleWithCenter:CGPointMake(x, y) radius:10.f];
        [self drawLineFrom:CGPointMake(x, y) to:CGPointMake(x + space, y) withLineWidth:10.f];
        [self drawCircleWithCenter:CGPointMake(x + space, y) radius:10.f];
        [self drawLineFrom:CGPointMake(x + space, y) to:CGPointMake(x + space * 2, y) withLineWidth:10.f];
        [self drawCircleWithCenter:CGPointMake(x + space * 2, y) radius:10.f];
        [self drawLineFrom:CGPointMake(x + space * 2, y) to:CGPointMake(x + space * 3, y) withLineWidth:10.f];
        [self drawCircleWithCenter:CGPointMake(x + space * 3, y) radius:10.f];
        [self drawLineFrom:CGPointMake(x + space * 3, y) to:CGPointMake(x + space * 4, y) withLineWidth:10.f];
        [self drawCircleWithCenter:CGPointMake(x + space * 4, y) radius:10.f];
    }

    [self drawTextInRect:CGRectMake(6.f, 62, 60.f, 20.f) Contents:progressOne.word contentFont:[UIFont systemFontOfSize:15.f] contentColor:colorWithHexString(@"909497")];
    [self drawTextInRect:CGRectMake(x + space - 26.f, 62, 60.f, 20.f) Contents:progressTwo.word contentFont:[UIFont systemFontOfSize:15.f] contentColor:colorWithHexString(@"909497")];
    [self drawTextInRect:CGRectMake(x + space * 2 - 23.f, 62, 60.f, 20.f) Contents:progressThree.word contentFont:[UIFont systemFontOfSize:15.f] contentColor:colorWithHexString(@"909497")];
    [self drawTextInRect:CGRectMake(x + space * 3 - 26.f, 62, 60.f, 20.f) Contents:progressFour.word contentFont:[UIFont systemFontOfSize:15.f] contentColor:colorWithHexString(@"909497")];
    [self drawTextInRect:CGRectMake(x + space * 4 - 26.f, 62, 60.f, 20.f) Contents:progressFive.word contentFont:[UIFont systemFontOfSize:15.f] contentColor:colorWithHexString(@"909497")];
}

@end
