//
//  BXTHistogramView.m
//  Histogram
//
//  Created by Jason on 16/6/30.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTHistogramView.h"
#import <math.h>
#import "BXTMeterReadingRecordMonthListInfo.h"
#import "BXTMeterReadingRecordDayListInfo.h"

#define StatisticsHeight(rect) rect.size.height - 30.f

@implementation BXTHistogramView

- (instancetype)initWithFrame:(CGRect)frame lists:(NSArray *)datasource kwhMeasure:(NSInteger)measure kwhNumber:(NSInteger)number statisticsType:(StatisticsType)s_type block:(ChoosedDatesourece)block
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.kwhNumber = number;
        self.statisticsType = s_type;
        isFirst = YES;
        self.datasource = datasource;
        self.datasourceBlock = block;
        NSMutableArray *temArray = [NSMutableArray array];
        NSMutableArray *humArray = [NSMutableArray array];
        NSMutableArray *energyArray = [NSMutableArray array];
        if (self.statisticsType == DayType)
        {
            NSMutableArray *windArray = [NSMutableArray array];
            for (NSInteger i = 0; i < datasource.count; i++)
            {
                BXTRecordDayListsInfo *recordInfo = datasource[i];
                [temArray addObject:@(recordInfo.data.temperature)];
                [humArray addObject:@(recordInfo.data.humidity)];
                [windArray addObject:@(recordInfo.data.wind_force)];
                [energyArray addObject:@[@(recordInfo.data.use_amount),@(recordInfo.data.peak_segment_amount),@(recordInfo.data.peak_period_amount),@(recordInfo.data.flat_section_amount),@(recordInfo.data.valley_section_amount)]];
            }
            self.windPowerArray = windArray;
        }
        else if (self.statisticsType == MonthType)
        {
            for (NSInteger i = 0; i < datasource.count; i++)
            {
                BXTRecordMonthListsInfo *recordInfo = datasource[i];
                [temArray addObject:@(recordInfo.data.temperature)];
                [humArray addObject:@(recordInfo.data.humidity)];
                [energyArray addObject:@[@(recordInfo.data.use_amount),@(recordInfo.data.peak_segment_amount),@(recordInfo.data.peak_period_amount),@(recordInfo.data.flat_section_amount),@(recordInfo.data.valley_section_amount)]];
            }
        }
        else if (self.statisticsType == BudgetType)
        {
            
        }
        
        self.temperatureArray = temArray;
        self.humidityArray = humArray;
        self.totalEnergyArray = energyArray;
        self.kwhMeasure = measure;
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

    CGFloat scale = (StatisticsHeight(rect))/self.kwhMeasure;
    
    //矩形柱
    for (NSInteger i = 0; i < self.totalEnergyArray.count; i++)
    {
        NSArray *totalArray = self.totalEnergyArray[i];
        
        //总能耗
        CGFloat total = [totalArray[0] floatValue];
        total = StatisticsHeight(rect) - total * scale;
        
        CGContextAddRect(ctx, CGRectMake(10 + 50 * i, total, 40, StatisticsHeight(rect) - total));
        [colorWithHexString(@"AE63CB") set];
        CGContextFillPath(ctx);
        
        //尖峰
        CGFloat peak = [totalArray[1] floatValue] + [totalArray[2] floatValue] + [totalArray[3] floatValue] + [totalArray[4] floatValue];
        peak = StatisticsHeight(rect) - peak * scale;

        CGContextAddRect(ctx, CGRectMake(10 + 50 * i, peak, 40, StatisticsHeight(rect) - peak));
        [colorWithHexString(@"F3639B") set];
        CGContextFillPath(ctx);
        
        //峰段
        CGFloat part = [totalArray[2] floatValue] + [totalArray[3] floatValue] + [totalArray[4] floatValue];
        part = StatisticsHeight(rect) - part * scale;
        
        CGContextAddRect(ctx, CGRectMake(10 + 50 * i, part, 40, StatisticsHeight(rect) - part));
        [colorWithHexString(@"FAB082") set];
        CGContextFillPath(ctx);
        
        //平段
        CGFloat flat = [totalArray[3] floatValue] + [totalArray[4] floatValue];
        flat = StatisticsHeight(rect) - flat * scale;
        
        CGContextAddRect(ctx, CGRectMake(10 + 50 * i, flat, 40, StatisticsHeight(rect) - flat));
        [colorWithHexString(@"78DA9F") set];
        CGContextFillPath(ctx);
        
        //谷段
        CGFloat trough = [totalArray[4] floatValue];
        trough = StatisticsHeight(rect) - trough * scale;
        
        CGContextAddRect(ctx, CGRectMake(10 + 50 * i, trough, 40, StatisticsHeight(rect) - trough));
        [colorWithHexString(@"6EC6F5") set];
        CGContextFillPath(ctx);
        
        //时间
        if (self.kwhNumber > 4)
        {
            BXTRecordDayListsInfo *recordInfo = self.datasource[i];
            [self drawDate:[NSString stringWithFormat:@"%ld号",(long)recordInfo.day] index:i rect:rect];
        }
        else
        {
            BXTRecordMonthListsInfo *recordInfo = self.datasource[i];
            [self drawDate:[NSString stringWithFormat:@"%ld月",(long)recordInfo.month] index:i rect:rect];
        }
        
        isFirst = NO;
    }
    
    //标线
    for (NSInteger i = 0; i < self.kwhNumber - 1; i++)
    {
        CGFloat value = ((StatisticsHeight(rect))/self.kwhNumber);
        CGContextMoveToPoint(ctx, 0, value * (i + 1)); // 起点
        CGContextAddLineToPoint(ctx, CGRectGetWidth(rect), value * (i + 1)); //终点
        [[[UIColor whiteColor] colorWithAlphaComponent:0.95f] set]; // 两种设置颜色的方式都可以
        CGContextSetLineWidth(ctx, 0.5f); // 线的宽度
        CGContextSetLineCap(ctx, kCGLineCapRound); // 起点和终点圆角
        CGContextSetLineJoin(ctx, kCGLineJoinRound); // 转角圆角
        CGContextStrokePath(ctx); // 渲染（直线只能绘制空心的，不能调用CGContextFillPath(ctx);）
    }
    
    /********************************温度折线图*******************************/
    [self drawBrokenLine:ctx points:self.temperatureArray color:colorWithHexString(@"FED502") type:TemperatureType rect:rect];
    
    /********************************湿度折线图*******************************/
    [self drawBrokenLine:ctx points:self.humidityArray color:colorWithHexString(@"539EF4") type:HumidityType rect:rect];
    
    /********************************风力折线图*******************************/
    if (self.windPowerArray)
    {
        [self drawBrokenLine:ctx points:self.windPowerArray color:colorWithHexString(@"EC6868") type:WindPowerType rect:rect];
    }
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
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:13]; // 字体
    [date drawInRect:CGRectMake(20 + 50 * index, StatisticsHeight(rect) + 5.f, 40, 20) withAttributes:dict];
}

- (void)drawBrokenLine:(CGContextRef)ctx points:(NSArray *)points color:(UIColor *)color type:(BrokenLineType)type rect:(CGRect)rect
{
    //折线
    for (NSInteger i = 0; i < points.count; i++)
    {
        CGFloat point = [points[i] floatValue];
        if (type == TemperatureType)
        {
            point = (StatisticsHeight(rect))/self.kwhNumber - point * ((StatisticsHeight(rect))/self.kwhNumber/50.f);
        }
        else if (type == HumidityType)
        {
            point = (StatisticsHeight(rect))/self.kwhNumber*4.f - point * ((StatisticsHeight(rect))/self.kwhNumber/50.f);
        }
        else if (type == WindPowerType)
        {
            point = StatisticsHeight(rect) - point * ((StatisticsHeight(rect))/self.kwhNumber/50.f) * 10.f;
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
    [[UIColor whiteColor] set]; // 两种设置颜色的方式都可以
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
            point = (StatisticsHeight(rect))/self.kwhNumber - point * ((StatisticsHeight(rect))/self.kwhNumber/50.f);
        }
        else if (type == HumidityType)
        {
            point = (StatisticsHeight(rect))/self.kwhNumber*4.f - point * ((StatisticsHeight(rect))/self.kwhNumber/50.f);
        }
        else if (type == WindPowerType)
        {
            point = StatisticsHeight(rect) - point * ((StatisticsHeight(rect))/self.kwhNumber/50.f) * 10.f;
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
        CGFloat win = 0.f;
        if (self.windPowerArray)
        {
            win = [self.windPowerArray[selectIndex] floatValue];
        }
        NSArray *energyArray = self.totalEnergyArray[selectIndex];
        self.datasourceBlock(tem,hum,win,energyArray);
    }
}

@end
