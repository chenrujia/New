//
//  BarChatItemView.m
//  BarChatItemDemo
//
//  Created by 满孝意 on 15/11/25.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "BarChatItemView.h"

#define view_width  30
#define Max_Height  250

#define BAR_SPACES_DEFAULT 10
#define VERTICALE_DATA_SPACES 10

@implementation BarChatItemView

@synthesize dateArray;
@synthesize ItemArray;
@synthesize dataArray;

#pragma mark -
#pragma mark - init
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        self.backgroundColor =[UIColor clearColor];
        
        // UIScrollView
        contentSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, frame.origin.y+VERTICALE_DATA_SPACES/2, frame.size.width, frame.size.height-frame.origin.y-view_width)];
        //contentSV.backgroundColor = [UIColor redColor];
        contentSV.showsVerticalScrollIndicator = NO;
        [self addSubview:contentSV];
        
        // UIScrollView - contentView
        contentView = [[UIView alloc] init];
        [contentSV addSubview:contentView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self filter];
    
    ItemShowViewArray = [[NSMutableArray alloc]init];
    
    contentView.frame = CGRectMake(0, 0, self.frame.size.width, (VERTICALE_DATA_SPACES+view_width)*[ItemArray count]+VERTICALE_DATA_SPACES);
    NSLog(@"AllHeihht - %lu \nItemArray.count - %lu",(unsigned long)(VERTICALE_DATA_SPACES+view_width)*[ItemArray count],(unsigned long)[ItemArray count]);
    [contentSV setContentSize:CGSizeMake(contentSV.frame.size.width, contentView.frame.size.height)];
    
    [self initDate];
}

#pragma mark -
#pragma mark - 添加数据
- (void)filter {
    NSMutableArray *array1 = [dataArray objectAtIndex:0];
    NSMutableArray *array2 = [dataArray objectAtIndex:1];
    int count1 = (int)[array1 count];
    int count2 = (int)[array2 count];
    if (count1 == count2) {
        dateArray = [dataArray objectAtIndex:0];
        ItemArray = [dataArray objectAtIndex:1];
        
    } else if (count1 < count2) {
        NSMutableArray *tmp1 = [[NSMutableArray alloc]init];
        for (int i = 0; i< count1; i++) {
            [tmp1 addObject:[array2 objectAtIndex:i]];
        }
        dateArray = [dataArray objectAtIndex:0];
        ItemArray = [NSArray arrayWithArray:tmp1];
        
    } else {
        NSMutableArray *tmp1 = [NSMutableArray arrayWithArray:[dataArray objectAtIndex:1]];
        for (int i = count2; i< count1; i++) {
            [tmp1 addObject:@"0"];
        }
        dateArray = [dataArray objectAtIndex:0];
        ItemArray = [NSArray arrayWithArray:tmp1];
    }
}

#pragma mark -
#pragma mark - 时间轴
- (void)initDate {
    NSUInteger count = [dateArray count];
    NSUInteger row_Inter = VERTICALE_DATA_SPACES;
    int maxIndex = [self getMaxIndex:ItemArray];
    for (int i = 0 ; i< count; i++) {
        NSUInteger y = (i+1)*row_Inter+i*view_width;
        
        int maxEv = [[ItemArray objectAtIndex:maxIndex] intValue];
        if ([[ItemArray objectAtIndex:maxIndex] intValue] == 0) {
            maxEv = 1;
        }
        CGFloat height= [[ItemArray objectAtIndex:i] intValue]*Max_Height/maxEv;
        
        //底色
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(40, y, height, view_width)];
        view.backgroundColor = [UIColor colorWithRed:50/255.0 green:143/255.0 blue:222/255.0 alpha:1];
        view.layer.shadowColor= [UIColor blackColor].CGColor;
        view.layer.shadowOpacity = 0.2;
        view.layer.shadowOffset =CGSizeMake(0.0, 1.0);
        view.tag = i+1;
        [contentView addSubview:view];
        [ItemShowViewArray addObject:view];
        
        //点击区域
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(40, y, BAR_SPACES_DEFAULT+Max_Height, view_width);
        btn.tag = i+1;
        [btn addTarget:self action:@selector(showValue:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
        
        //添加值左侧标签
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, y, view_width, view_width)];
        contentLabel.font = [UIFont systemFontOfSize:10.0f];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.text = [dateArray objectAtIndex:i];
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.backgroundColor = [UIColor clearColor];
        //contentLabel.transform = CGAffineTransformRotate(contentLabel.transform,M_PI/2);
        [contentView addSubview:contentLabel];
        
        // 添加右侧值标签
        CGPoint center = view.center;
        valueLabel = [[UILabel alloc]init];
        valueLabel.font = [UIFont systemFontOfSize:10.0f];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.text = [NSString stringWithFormat:@"%d%%",[[ItemArray objectAtIndex:i] intValue]];
        if ([[ItemArray objectAtIndex:i] intValue] == 0) {
            valueLabel.hidden = YES;
        }
        valueLabel.bounds = CGRectMake(0, 0, view_width*2, view_width*2);
        valueLabel.center = CGPointMake(center.x+view.frame.size.width/2+view_width, center.y);
        valueLabel.textColor = [UIColor darkGrayColor];
        valueLabel.backgroundColor = [UIColor clearColor];
        //valueLabel.transform = CGAffineTransformRotate(valueLabel.transform,M_PI/2);
        [contentView addSubview:valueLabel];
    }
    
    //画线
    int x = 35; int y = self.frame.origin.y+VERTICALE_DATA_SPACES/2;
    int toX = 35; //int toY = self.frame.origin.y+(row_Inter+view_width)*count;
    //画水平线
    [self addLine:x tox:toX y:y toY:self.frame.size.height-VERTICALE_DATA_SPACES/2];
    //画 垂直线
    [self addLine:35 tox:40+Max_Height y:self.frame.origin.y+VERTICALE_DATA_SPACES/2 toY:self.frame.origin.y+VERTICALE_DATA_SPACES/2];
    
    //添加最值
    UILabel *maxLabel = [[UILabel alloc]init];
    maxLabel.bounds = CGRectMake(0, 0, view_width, view_width);
    maxLabel.center = CGPointMake(35+Max_Height+view_width, self.frame.origin.y+view_width/2-VERTICALE_DATA_SPACES/2);
    maxLabel.font = [UIFont systemFontOfSize:10.0f];
    maxLabel.textAlignment = NSTextAlignmentCenter;
    maxLabel.text = [ItemArray objectAtIndex:maxIndex];
    maxLabel.textColor = [UIColor darkGrayColor];
    maxLabel.backgroundColor = [UIColor clearColor];
    //maxLabel.transform = CGAffineTransformRotate(maxLabel.transform,M_PI/2);
    [self addSubview:maxLabel];
}

- (int)getMaxIndex:(NSArray *)array {
    int MaxValue = [[array objectAtIndex:0] intValue];
    int length = (int)array.count;
    int maxIndex = 0;
    for (int i=1; i< length; i++) {
        if ([[array objectAtIndex:i] intValue] > MaxValue) {
            MaxValue =[[array objectAtIndex:i] intValue];
            maxIndex = i;
        }
    }
    return maxIndex;
}

- (void)addLine:(int)x tox:(int)toX y:(int)y toY:(int)toY {
    CAShapeLayer *lineShape = nil;
    CGMutablePathRef linePath = nil;
    linePath = CGPathCreateMutable();
    lineShape = [CAShapeLayer layer];
    lineShape.lineWidth = 0.5f;
    lineShape.lineCap = kCALineCapRound;;
    lineShape.strokeColor = [UIColor darkGrayColor].CGColor;
    
    CGPathMoveToPoint(linePath, NULL, x, y);
    CGPathAddLineToPoint(linePath, NULL, toX, toY);
    lineShape.path = linePath;
    CGPathRelease(linePath);
    [self.layer addSublayer:lineShape];
}

#pragma mark -
#pragma mark -  按钮点击事件
- (void)showValue:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if (self.transSelected2) {
        self.transSelected2(btn.tag-1);
    }
    
    UIView *view = [ItemShowViewArray objectAtIndex:btn.tag-1];
    if (lastTapView) {
        lastTapView.backgroundColor = [UIColor colorWithRed:50/255.0 green:143/255.0 blue:222/255.0 alpha:1];
        if (lastTapView != view) {
            view.backgroundColor = [UIColor colorWithRed:118/255.0 green:207/255.0 blue:244/255.0 alpha:1];;
            lastTapView = view;
            selected = YES;
        } else {
            if (selected) {
                selected = NO;
            } else {
                selected = YES;
                view.backgroundColor = [UIColor colorWithRed:118/255.0 green:207/255.0 blue:244/255.0 alpha:1];
            }
        }
    } else {
        view.backgroundColor = [UIColor colorWithRed:118/255.0 green:207/255.0 blue:244/255.0 alpha:1];;
        lastTapView = view;
        selected = YES;
    }
}

@end
