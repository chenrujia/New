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

#define YLineWidth 6.f

@implementation BXTDrawView

- (instancetype)initWithFrame:(CGRect)frame
                 withProgress:(NSArray *)progresses
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.progress = progresses;
        self.fontSize = IS_IPHONE6 ? 15.f : 14.f;
        self.colorsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIColor *grayColor = colorWithHexString(@"e2e6e8");
    [grayColor setStroke];
    [grayColor setFill];
    CGFloat x = 40.f;
    CGFloat y = 20.f;
    //最下面那个灰色长条
    [self drawLineFrom:CGPointMake(x, y) to:CGPointMake(rect.size.width - x, y) withLineWidth:YLineWidth];
    
    UIColor *greenColor = colorWithHexString(@"45b2fe");
    [greenColor setStroke];
    [greenColor setFill];
    
    if (self.progress.count == 0) return;
    BXTProgressInfo *progressOne = _progress[0];
    BXTProgressInfo *progressTwo = _progress[1];
    BXTProgressInfo *progressThree = _progress[2];
    BXTProgressInfo *progressFour = _progress[3];
    BXTProgressInfo *progressFive = _progress[4];
    CGFloat space = (SCREEN_WIDTH - x*2.f)/4.f;
    
    [self.colorsArray removeAllObjects];
    if (progressOne.state && !progressTwo.state)
    {
        [[UIColor whiteColor] setFill];
        [self drawCircleWithCenter:CGPointMake(x, y) radius:13.f];
        [greenColor setFill];
        [self drawCircleWithCenter:CGPointMake(x, y) radius:10.f];
        [grayColor setStroke];
        [grayColor setFill];
        [self drawCircleWithCenter:CGPointMake(x + space, y) radius:10.f];
        [self drawCircleWithCenter:CGPointMake(x + space * 2, y) radius:10.f];
        [self drawCircleWithCenter:CGPointMake(x + space * 3, y) radius:10.f];
        [self drawCircleWithCenter:CGPointMake(x + space * 4, y) radius:10.f];
        
        [self.colorsArray addObjectsFromArray:@[colorWithHexString(@"4a4a4a"),
                                                colorWithHexString(@"9b9b9b"),
                                                colorWithHexString(@"9b9b9b"),
                                                colorWithHexString(@"9b9b9b"),
                                                colorWithHexString(@"9b9b9b")]];
    }
    else if (progressTwo.state && !progressThree.state)
    {
        [self drawCircleWithCenter:CGPointMake(x, y) radius:10.f];
        [self drawLineFrom:CGPointMake(x, y) to:CGPointMake(x + space, y) withLineWidth:YLineWidth];
        [[UIColor whiteColor] setFill];
        [self drawCircleWithCenter:CGPointMake(x + space, y) radius:13.f];
        [greenColor setFill];
        [self drawCircleWithCenter:CGPointMake(x + space, y) radius:10.f];
        [grayColor setStroke];
        [grayColor setFill];
        [self drawCircleWithCenter:CGPointMake(x + space * 2, y) radius:10.f];
        [self drawCircleWithCenter:CGPointMake(x + space * 3, y) radius:10.f];
        [self drawCircleWithCenter:CGPointMake(x + space * 4, y) radius:10.f];
        
        [self.colorsArray addObjectsFromArray:@[colorWithHexString(@"9b9b9b"),
                                                colorWithHexString(@"4a4a4a"),
                                                colorWithHexString(@"9b9b9b"),
                                                colorWithHexString(@"9b9b9b"),
                                                colorWithHexString(@"9b9b9b")]];
    }
    else if (progressThree.state && !progressFour.state)
    {
        [self drawCircleWithCenter:CGPointMake(x, y) radius:10.f];
        [self drawLineFrom:CGPointMake(x, y) to:CGPointMake(x + space, y) withLineWidth:YLineWidth];
        [self drawCircleWithCenter:CGPointMake(x + space, y) radius:10.f];
        [self drawLineFrom:CGPointMake(x + space, y) to:CGPointMake(x + space * 2, y) withLineWidth:YLineWidth];
        [[UIColor whiteColor] setFill];
        [self drawCircleWithCenter:CGPointMake(x + space * 2, y) radius:13.f];
        [greenColor setFill];
        [self drawCircleWithCenter:CGPointMake(x + space * 2, y) radius:10.f];
        [grayColor setStroke];
        [grayColor setFill];
        [self drawCircleWithCenter:CGPointMake(x + space * 3, y) radius:10.f];
        [self drawCircleWithCenter:CGPointMake(x + space * 4, y) radius:10.f];
        
        [self.colorsArray addObjectsFromArray:@[colorWithHexString(@"9b9b9b"),
                                                colorWithHexString(@"9b9b9b"),
                                                colorWithHexString(@"4a4a4a"),
                                                colorWithHexString(@"9b9b9b"),
                                                colorWithHexString(@"9b9b9b")]];
    }
    else if (progressFour.state && !progressFive.state)
    {
        [self drawCircleWithCenter:CGPointMake(x, y) radius:10.f];
        [self drawLineFrom:CGPointMake(x, y) to:CGPointMake(x + space, y) withLineWidth:YLineWidth];
        [self drawCircleWithCenter:CGPointMake(x + space, y) radius:10.f];
        [self drawLineFrom:CGPointMake(x + space, y) to:CGPointMake(x + space * 2, y) withLineWidth:YLineWidth];
        [self drawCircleWithCenter:CGPointMake(x + space * 2, y) radius:10.f];
        [self drawLineFrom:CGPointMake(x + space * 2, y) to:CGPointMake(x + space * 3, y) withLineWidth:YLineWidth];
        [[UIColor whiteColor] setFill];
        [self drawCircleWithCenter:CGPointMake(x + space * 3, y) radius:13.f];
        [greenColor setFill];
        [self drawCircleWithCenter:CGPointMake(x + space * 3, y) radius:10.f];
        [grayColor setStroke];
        [grayColor setFill];
        [self drawCircleWithCenter:CGPointMake(x + space * 4, y) radius:10.f];
        
        [self.colorsArray addObjectsFromArray:@[colorWithHexString(@"9b9b9b"),
                                                colorWithHexString(@"9b9b9b"),
                                                colorWithHexString(@"9b9b9b"),
                                                colorWithHexString(@"4a4a4a"),
                                                colorWithHexString(@"9b9b9b")]];
    }
    else if (progressFive.state)
    {
        [self drawCircleWithCenter:CGPointMake(x, y) radius:10.f];
        [self drawLineFrom:CGPointMake(x, y) to:CGPointMake(x + space, y) withLineWidth:YLineWidth];
        [self drawCircleWithCenter:CGPointMake(x + space, y) radius:10.f];
        [self drawLineFrom:CGPointMake(x + space, y) to:CGPointMake(x + space * 2, y) withLineWidth:YLineWidth];
        [self drawCircleWithCenter:CGPointMake(x + space * 2, y) radius:10.f];
        [self drawLineFrom:CGPointMake(x + space * 2, y) to:CGPointMake(x + space * 3, y) withLineWidth:YLineWidth];
        [self drawCircleWithCenter:CGPointMake(x + space * 3, y) radius:10.f];
        [self drawLineFrom:CGPointMake(x + space * 3, y) to:CGPointMake(x + space * 4, y) withLineWidth:YLineWidth];
        [[UIColor whiteColor] setFill];
        [self drawCircleWithCenter:CGPointMake(x + space * 4, y) radius:13.f];
        [greenColor setFill];
        [self drawCircleWithCenter:CGPointMake(x + space * 4, y) radius:10.f];
        
        [self.colorsArray addObjectsFromArray:@[colorWithHexString(@"9b9b9b"),
                                                colorWithHexString(@"9b9b9b"),
                                                colorWithHexString(@"9b9b9b"),
                                                colorWithHexString(@"9b9b9b"),
                                                colorWithHexString(@"4a4a4a")]];
    }

    CGSize oneSize = MB_MULTILINE_TEXTSIZE(progressOne.word, [UIFont systemFontOfSize:self.fontSize], CGSizeMake(1000, 100), NSLineBreakByWordWrapping);
    [self drawTextInRect:CGRectMake(x - oneSize.width/2.f, y + 20.f, oneSize.width, oneSize.height) Contents:progressOne.word contentFont:[UIFont systemFontOfSize:self.fontSize] contentColor:self.colorsArray[0]];
    
    CGSize twoSize = MB_MULTILINE_TEXTSIZE(progressTwo.word, [UIFont systemFontOfSize:self.fontSize], CGSizeMake(1000, 100), NSLineBreakByWordWrapping);
    [self drawTextInRect:CGRectMake(x + space - twoSize.width/2.f, y + 20.f, twoSize.width, twoSize.height) Contents:progressTwo.word contentFont:[UIFont systemFontOfSize:self.fontSize] contentColor:self.colorsArray[1]];
    
    CGSize threeSize = MB_MULTILINE_TEXTSIZE(progressThree.word, [UIFont systemFontOfSize:self.fontSize], CGSizeMake(1000, 100), NSLineBreakByWordWrapping);
    [self drawTextInRect:CGRectMake(x + space * 2 - threeSize.width/2.f, y + 20.f, threeSize.width, threeSize.height) Contents:progressThree.word contentFont:[UIFont systemFontOfSize:self.fontSize] contentColor:self.colorsArray[2]];
    
    CGSize fourSize = MB_MULTILINE_TEXTSIZE(progressFour.word, [UIFont systemFontOfSize:self.fontSize], CGSizeMake(1000, 100), NSLineBreakByWordWrapping);
    [self drawTextInRect:CGRectMake(x + space * 3 - fourSize.width/2.f, y + 20.f, fourSize.width, fourSize.height) Contents:progressFour.word contentFont:[UIFont systemFontOfSize:self.fontSize] contentColor:self.colorsArray[3]];
    
    CGSize fiveSize = MB_MULTILINE_TEXTSIZE(progressFive.word, [UIFont systemFontOfSize:self.fontSize], CGSizeMake(1000, 100), NSLineBreakByWordWrapping);
    [self drawTextInRect:CGRectMake(x + space * 4 - fiveSize.width/2.f, y + 20.f, fiveSize.width, fiveSize.height) Contents:progressFive.word contentFont:[UIFont systemFontOfSize:self.fontSize] contentColor:self.colorsArray[4]];
}

@end
