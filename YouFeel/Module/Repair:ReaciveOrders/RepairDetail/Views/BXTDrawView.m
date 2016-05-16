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
        self.backgroundColor = [UIColor whiteColor];
        self.isShow = show;
        self.progress = progresses;
        self.fontSize = IS_IPHONE6 ? 16.f : 15.f;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIColor *grayColor = colorWithHexString(@"e2e6e8");
    [grayColor setStroke];
    [grayColor setFill];
    
    if (self.isShow)
    {
        [self drawTextInRect:CGRectMake(15.f, 10, 40.f, 20.f) Contents:@"状态" contentFont:[UIFont systemFontOfSize:16.f] contentColor:colorWithHexString(@"000000")];
    }
    
    [grayColor setStroke];
    [grayColor setFill];
    CGFloat x = 30.f;
    CGFloat y = 20.f;
    //最下面那个灰色长条
    [self drawLineFrom:CGPointMake(x, y) to:CGPointMake(rect.size.width - x, y) withLineWidth:10.f];
    
    UIColor *orangeColor = colorWithHexString(@"3cafff");
    [orangeColor setStroke];
    [orangeColor setFill];
    
    if (self.progress.count == 0) return;
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
        
        [self drawTextInRect:CGRectMake(x - 4, y - 8, 12, 12) Contents:@"1" contentFont:[UIFont systemFontOfSize:12.f] contentColor:[UIColor whiteColor]];
        [self drawTextInRect:CGRectMake(x + space - 4, y - 8, 12, 12) Contents:@"2" contentFont:[UIFont systemFontOfSize:12.f] contentColor:colorWithHexString(@"AFB3BC")];
        [self drawTextInRect:CGRectMake(x + space * 2 - 4, y - 8, 12, 12) Contents:@"3" contentFont:[UIFont systemFontOfSize:12.f] contentColor:colorWithHexString(@"AFB3BC")];
        [self drawTextInRect:CGRectMake(x + space * 3 - 4, y - 8, 12, 12) Contents:@"4" contentFont:[UIFont systemFontOfSize:12.f] contentColor:colorWithHexString(@"AFB3BC")];
        [self drawTextInRect:CGRectMake(x + space * 4 - 4, y - 8, 12, 12) Contents:@"5" contentFont:[UIFont systemFontOfSize:12.f] contentColor:colorWithHexString(@"AFB3BC")];
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
        
        [self drawTextInRect:CGRectMake(x - 4, y - 8, 12, 12) Contents:@"1" contentFont:[UIFont systemFontOfSize:12.f] contentColor:[UIColor whiteColor]];
        [self drawTextInRect:CGRectMake(x + space - 4, y - 8, 12, 12) Contents:@"2" contentFont:[UIFont systemFontOfSize:12.f] contentColor:[UIColor whiteColor]];
        [self drawTextInRect:CGRectMake(x + space * 2 - 4, y - 8, 12, 12) Contents:@"3" contentFont:[UIFont systemFontOfSize:12.f] contentColor:colorWithHexString(@"AFB3BC")];
        [self drawTextInRect:CGRectMake(x + space * 3 - 4, y - 8, 12, 12) Contents:@"4" contentFont:[UIFont systemFontOfSize:12.f] contentColor:colorWithHexString(@"AFB3BC")];
        [self drawTextInRect:CGRectMake(x + space * 4 - 4, y - 8, 12, 12) Contents:@"5" contentFont:[UIFont systemFontOfSize:12.f] contentColor:colorWithHexString(@"AFB3BC")];
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
        
        [self drawTextInRect:CGRectMake(x - 4, y - 8, 12, 12) Contents:@"1" contentFont:[UIFont systemFontOfSize:12.f] contentColor:[UIColor whiteColor]];
        [self drawTextInRect:CGRectMake(x + space - 4, y - 8, 12, 12) Contents:@"2" contentFont:[UIFont systemFontOfSize:12.f] contentColor:[UIColor whiteColor]];
        [self drawTextInRect:CGRectMake(x + space * 2 - 4, y - 8, 12, 12) Contents:@"3" contentFont:[UIFont systemFontOfSize:12.f] contentColor:[UIColor whiteColor]];
        [self drawTextInRect:CGRectMake(x + space * 3 - 4, y - 8, 12, 12) Contents:@"4" contentFont:[UIFont systemFontOfSize:12.f] contentColor:colorWithHexString(@"AFB3BC")];
        [self drawTextInRect:CGRectMake(x + space * 4 - 4, y - 8, 12, 12) Contents:@"5" contentFont:[UIFont systemFontOfSize:12.f] contentColor:colorWithHexString(@"AFB3BC")];
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
        
        [self drawTextInRect:CGRectMake(x - 4, y - 8, 12, 12) Contents:@"1" contentFont:[UIFont systemFontOfSize:12.f] contentColor:[UIColor whiteColor]];
        [self drawTextInRect:CGRectMake(x + space - 4, y - 8, 12, 12) Contents:@"2" contentFont:[UIFont systemFontOfSize:12.f] contentColor:[UIColor whiteColor]];
        [self drawTextInRect:CGRectMake(x + space * 2 - 4, y - 8, 12, 12) Contents:@"3" contentFont:[UIFont systemFontOfSize:12.f] contentColor:[UIColor whiteColor]];
        [self drawTextInRect:CGRectMake(x + space * 3 - 4, y - 8, 12, 12) Contents:@"4" contentFont:[UIFont systemFontOfSize:12.f] contentColor:[UIColor whiteColor]];
        [self drawTextInRect:CGRectMake(x + space * 4 - 4, y - 8, 12, 12) Contents:@"5" contentFont:[UIFont systemFontOfSize:12.f] contentColor:colorWithHexString(@"AFB3BC")];
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
        
        [self drawTextInRect:CGRectMake(x - 4, y - 8, 12, 12) Contents:@"1" contentFont:[UIFont systemFontOfSize:12.f] contentColor:[UIColor whiteColor]];
        [self drawTextInRect:CGRectMake(x + space - 4, y - 8, 12, 12) Contents:@"2" contentFont:[UIFont systemFontOfSize:12.f] contentColor:[UIColor whiteColor]];
        [self drawTextInRect:CGRectMake(x + space * 2 - 4, y - 8, 12, 12) Contents:@"3" contentFont:[UIFont systemFontOfSize:12.f] contentColor:[UIColor whiteColor]];
        [self drawTextInRect:CGRectMake(x + space * 3 - 4, y - 8, 12, 12) Contents:@"4" contentFont:[UIFont systemFontOfSize:12.f] contentColor:[UIColor whiteColor]];
        [self drawTextInRect:CGRectMake(x + space * 4 - 4, y - 8, 12, 12) Contents:@"5" contentFont:[UIFont systemFontOfSize:12.f] contentColor:[UIColor whiteColor]];
    }

    CGSize oneSize = MB_MULTILINE_TEXTSIZE(progressOne.word, [UIFont systemFontOfSize:15.f], CGSizeMake(1000, 100), NSLineBreakByWordWrapping);
    [self drawTextInRect:CGRectMake(x - oneSize.width/2.f, y + 20.f, oneSize.width, oneSize.height) Contents:progressOne.word contentFont:[UIFont systemFontOfSize:self.fontSize] contentColor:colorWithHexString(@"909497")];
    
    CGSize twoSize = MB_MULTILINE_TEXTSIZE(progressTwo.word, [UIFont systemFontOfSize:15.f], CGSizeMake(1000, 100), NSLineBreakByWordWrapping);
    [self drawTextInRect:CGRectMake(x + space - twoSize.width/2.f, y + 20.f, twoSize.width, twoSize.height) Contents:progressTwo.word contentFont:[UIFont systemFontOfSize:self.fontSize] contentColor:colorWithHexString(@"909497")];
    
    CGSize threeSize = MB_MULTILINE_TEXTSIZE(progressThree.word, [UIFont systemFontOfSize:15.f], CGSizeMake(1000, 100), NSLineBreakByWordWrapping);
    [self drawTextInRect:CGRectMake(x + space * 2 - threeSize.width/2.f, y + 20.f, threeSize.width, threeSize.height) Contents:progressThree.word contentFont:[UIFont systemFontOfSize:self.fontSize] contentColor:colorWithHexString(@"909497")];
    
    CGSize fourSize = MB_MULTILINE_TEXTSIZE(progressFour.word, [UIFont systemFontOfSize:15.f], CGSizeMake(1000, 100), NSLineBreakByWordWrapping);
    [self drawTextInRect:CGRectMake(x + space * 3 - fourSize.width/2.f, y + 20.f, fourSize.width, fourSize.height) Contents:progressFour.word contentFont:[UIFont systemFontOfSize:self.fontSize] contentColor:colorWithHexString(@"909497")];
    
    CGSize fiveSize = MB_MULTILINE_TEXTSIZE(progressFive.word, [UIFont systemFontOfSize:15.f], CGSizeMake(1000, 100), NSLineBreakByWordWrapping);
    [self drawTextInRect:CGRectMake(x + space * 4 - fiveSize.width/2.f, y + 20.f, fiveSize.width, fiveSize.height) Contents:progressFive.word contentFont:[UIFont systemFontOfSize:self.fontSize] contentColor:colorWithHexString(@"909497")];
}

@end
