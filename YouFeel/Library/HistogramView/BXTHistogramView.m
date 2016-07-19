//
//  BXTHistogramView.m
//  Histogram
//
//  Created by Jason on 16/6/30.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTHistogramView.h"
#import "NSDate+Escort.h"
#import <math.h>

#define StatisticsHeight(rect) rect.size.height - 30.f

@implementation BXTHistogramView

- (instancetype)initWithFrame:(CGRect)frame temperaturePoints:(NSArray *)temPoints humidityPoints:(NSArray *)humPoints windPowerPoints:(NSArray *)windPoints totalEnergyPoints:(NSArray *)energyPoints block:(ChoosedDatesourece)block
{
    self = [super initWithFrame:frame];
    if (self)
    {
        isFirst = YES;
        self.datasourceBlock = block;
        self.temperatureArray = temPoints;
        self.humidityArray = humPoints;
        self.windPowerArray = windPoints;
        self.totalEnergyArray = energyPoints;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //背景色
    CGContextAddRect(ctx, rect);
    [colorWithHexString(@"EDEEEF") set];
    CGContextFillPath(ctx);
    
    NSDate *todayDate = [NSDate date];
    NSString *today = [self transTimeWithDate:todayDate withType:@"MM/dd"];
    
    CGFloat scale = (StatisticsHeight(rect))/1000.f;
    
    //矩形柱
    for (NSInteger i = 0; i < self.totalEnergyArray.count; i++)
    {
        NSArray *totalArray = self.totalEnergyArray[i];
        //高峰
        CGFloat peak = [totalArray[0] floatValue];
        peak = StatisticsHeight(rect) - peak * scale;

        CGContextAddRect(ctx, CGRectMake(10 + 50 * i, peak, 40, StatisticsHeight(rect) - peak));
        [colorWithHexString(@"FAB082") set];
        CGContextFillPath(ctx);
        
        //平
        CGFloat flat = [totalArray[1] floatValue];
        flat = StatisticsHeight(rect) - flat * scale;
        
        CGContextAddRect(ctx, CGRectMake(10 + 50 * i, flat, 40, StatisticsHeight(rect) - flat));
        [colorWithHexString(@"78DA9F") set];
        CGContextFillPath(ctx);
        
        //低谷
        CGFloat trough = [totalArray[2] floatValue];
        trough = StatisticsHeight(rect) - trough * scale;
        
        CGContextAddRect(ctx, CGRectMake(10 + 50 * i, trough, 40, StatisticsHeight(rect) - trough));
        [colorWithHexString(@"6EC6F5") set];
        CGContextFillPath(ctx);
        
        //时间
        if (i == self.totalEnergyArray.count - 1)
        {
            [self drawDate:today index:i rect:rect];
        }
        else
        {
            NSDate *agoDate = [NSDate dateWithDaysBeforeNow:self.totalEnergyArray.count - 1 - i];
            NSString *ago = [self transTimeWithDate:agoDate withType:@"MM/dd"];
            [self drawDate:ago index:i rect:rect];
        }
        isFirst = NO;
    }
    
    //标线
    for (NSInteger i = 0; i < 5; i++)
    {
        CGFloat value = ((StatisticsHeight(rect))/6.f);
        CGContextMoveToPoint(ctx, 0, value * (i + 1)); // 起点
        CGContextAddLineToPoint(ctx, CGRectGetWidth(rect), value * (i + 1)); //终点
        [[UIColor whiteColor] set]; // 两种设置颜色的方式都可以
        CGContextSetLineWidth(ctx, 1.0f); // 线的宽度
        CGContextSetLineCap(ctx, kCGLineCapRound); // 起点和终点圆角
        CGContextSetLineJoin(ctx, kCGLineJoinRound); // 转角圆角
        CGContextStrokePath(ctx); // 渲染（直线只能绘制空心的，不能调用CGContextFillPath(ctx);）
    }
    
    
    /********************************温度折线图*******************************/
    [self drawBrokenLine:ctx points:self.temperatureArray color:colorWithHexString(@"FED502") type:TemperatureType rect:rect];
    
    /********************************湿度折线图*******************************/
    [self drawBrokenLine:ctx points:self.humidityArray color:colorWithHexString(@"539EF4") type:HumidityType rect:rect];
    
    /********************************风力折线图*******************************/
    [self drawBrokenLine:ctx points:self.windPowerArray color:colorWithHexString(@"EC6868") type:WindPowerType rect:rect];
}

//日期
- (void)drawDate:(NSString *)date index:(NSInteger)index rect:(CGRect)rect
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (!isFirst && index == selectIndex)
    {
        dict[NSForegroundColorAttributeName] = [UIColor whiteColor]; // 文字颜色
    }
    else
    {
        dict[NSForegroundColorAttributeName] = colorWithHexString(@"909699"); // 文字颜色
    }
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:14]; // 字体
    [date drawInRect:CGRectMake(10 + 50 * index, StatisticsHeight(rect) + 5.f, 40, 20) withAttributes:dict];
}

- (void)drawBrokenLine:(CGContextRef)ctx points:(NSArray *)points color:(UIColor *)color type:(BrokenLineType)type rect:(CGRect)rect
{
    //折线
    for (NSInteger i = 0; i < points.count; i++)
    {
        CGFloat point = [points[i] floatValue];
        if (type == TemperatureType)
        {
            point = (StatisticsHeight(rect))/6.f - point;
        }
        else if (type == HumidityType)
        {
            point = (StatisticsHeight(rect))/6.f*4.f - point;
        }
        else if (type == WindPowerType)
        {
            point = StatisticsHeight(rect) - point * 10.f;
        }
        
        if (i == 0)
        {
            CGContextMoveToPoint(ctx, 10 + 50 * i + 20.f, point); // 起点
        }
        else
        {
            CGContextAddLineToPoint(ctx, 10 + 50 * i + 20.f, point); //终点
        }
    }
    [[[UIColor whiteColor] colorWithAlphaComponent:0.5f] set]; // 两种设置颜色的方式都可以
    CGContextSetLineWidth(ctx, 1.0f); // 线的宽度
    CGContextSetLineCap(ctx, kCGLineCapRound); // 起点和终点圆角
    CGContextSetLineJoin(ctx, kCGLineJoinRound); // 转角圆角
    CGContextStrokePath(ctx); // 渲染（直线只能绘制空心的，不能调用CGContextFillPath(ctx);）
    
    //圆点
    for (NSInteger i = 0; i < points.count; i++)
    {
        CGFloat point = [points[i] floatValue];
        if (type == TemperatureType)
        {
            point = (StatisticsHeight(rect))/6.f - point;
        }
        else if (type == HumidityType)
        {
            point = (StatisticsHeight(rect))/6.f*4.f - point;
        }
        else if (type == WindPowerType)
        {
            point = StatisticsHeight(rect) - point * 10.f;
        }
        
        [color set];
        CGContextAddArc(ctx, 10 + 50 * i + 20.f, point, 5, 0, 2*M_PI, 0); //添加一个圆
        CGContextDrawPath(ctx, kCGPathFill);//绘制填充
    }
}

- (NSString *)transTimeWithDate:(NSDate *)date withType:(NSString *)timeType
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:timeType];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat number = floorf(point.x/50.f);
    CGFloat remainder = point.x/50.f;
    if (remainder - number > 0.2f)
    {
        selectIndex = (NSInteger)number;
        [self setNeedsDisplay];
        
        CGFloat tem = [self.temperatureArray[selectIndex] floatValue];
        CGFloat hum = [self.humidityArray[selectIndex] floatValue];
        CGFloat win = [self.windPowerArray[selectIndex] floatValue];
        NSArray *energyArray = self.totalEnergyArray[selectIndex];
        self.datasourceBlock(tem,hum,win,energyArray);
    }
}

@end