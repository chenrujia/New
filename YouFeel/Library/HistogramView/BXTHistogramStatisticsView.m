//
//  BXTHistogramStatisticsView.m
//  Histogram
//
//  Created by Jason on 16/7/4.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTHistogramStatisticsView.h"
#import "BXTGlobal.h"
#import "BXTHistogramView.h"

@implementation BXTHistogramStatisticsView

- (instancetype)initWithFrame:(CGRect)frame temperatureArray:(NSArray *)temArray humidityArray:(NSArray *)humArray windPowerArray:(NSArray *)windArray totalEnergyArray:(NSArray *)energyArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.temperatureArray = temArray;
        self.humidityArray = humArray;
        self.windPowerArray = windArray;
        self.totalEnergyArray = energyArray;
        
        //电量
        UILabel *firstkwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 10.f, 30.f, 40.f)];
        firstkwhLabel.lineBreakMode = NSLineBreakByWordWrapping;
        firstkwhLabel.numberOfLines = 0;
        firstkwhLabel.textColor = colorWithHexString(@"6D6E6F");
        firstkwhLabel.font = [UIFont systemFontOfSize:11.f];
        firstkwhLabel.text = @"  kwh\r1000";
        [self addSubview:firstkwhLabel];
        
        UILabel *secondkwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 120.f, 25.f, 20.f)];
        secondkwhLabel.textColor = colorWithHexString(@"6D6E6F");
        secondkwhLabel.font = [UIFont systemFontOfSize:11.f];
        secondkwhLabel.textAlignment = NSTextAlignmentRight;
        secondkwhLabel.text = @"600";
        [self addSubview:secondkwhLabel];
        
        UILabel *thridkwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 220.f, 25.f, 20.f)];
        thridkwhLabel.textColor = colorWithHexString(@"6D6E6F");
        thridkwhLabel.font = [UIFont systemFontOfSize:11.f];
        thridkwhLabel.textAlignment = NSTextAlignmentRight;
        thridkwhLabel.text = @"300";
        [self addSubview:thridkwhLabel];
        
        UILabel *fourthkwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 320.f, 25.f, 20.f)];
        fourthkwhLabel.textColor = colorWithHexString(@"6D6E6F");
        fourthkwhLabel.font = [UIFont systemFontOfSize:11.f];
        fourthkwhLabel.textAlignment = NSTextAlignmentRight;
        fourthkwhLabel.text = @"0";
        [self addSubview:fourthkwhLabel];
        
        CGFloat sco_width = CGRectGetWidth(self.frame) - 80.f;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(40.f, 30, sco_width, 330.f)];
        scrollView.layer.borderColor = colorWithHexString(@"ADB4BC").CGColor;
        scrollView.layer.borderWidth = 1.f;
        scrollView.contentSize = CGSizeMake(1500, 0);
        scrollView.bounces = NO;
        [scrollView setContentOffset:CGPointMake(1500 - sco_width, 0)];
        [self addSubview:scrollView];
        
        //温度
        UILabel *firstTemLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scrollView.frame) + 5.f, 20.f, 30.f, 20.f)];
        firstTemLabel.textColor = colorWithHexString(@"FDD400");
        firstTemLabel.font = [UIFont systemFontOfSize:11.f];
        firstTemLabel.text = @"50°";
        [self addSubview:firstTemLabel];
        
        UILabel *secondTemLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scrollView.frame) + 5.f, 70.f, 25.f, 20.f)];
        secondTemLabel.textColor = colorWithHexString(@"FDD400");
        secondTemLabel.font = [UIFont systemFontOfSize:11.f];
        secondTemLabel.textAlignment = NSTextAlignmentLeft;
        secondTemLabel.text = @"0°";
        [self addSubview:secondTemLabel];
        
        UILabel *thridTemLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scrollView.frame) + 5.f, 110.f, 40.f, 40.f)];
        thridTemLabel.lineBreakMode = NSLineBreakByWordWrapping;
        thridTemLabel.numberOfLines = 0;
        thridTemLabel.textColor = colorWithHexString(@"FDD400");
        thridTemLabel.font = [UIFont systemFontOfSize:9.f];
        thridTemLabel.textAlignment = NSTextAlignmentLeft;
        NSString *content = @"-50°\r100%rh";
        NSRange range = [content rangeOfString:@"100%rh"];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:content];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"50A1F9") range:range];
        thridTemLabel.attributedText = attributeStr;
        [self addSubview:thridTemLabel];
        
        //湿度
        UILabel *firstHumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scrollView.frame) + 5.f, 170.f, 40.f, 20.f)];
        firstHumLabel.textColor = colorWithHexString(@"50A1F9");
        firstHumLabel.font = [UIFont systemFontOfSize:11.f];
        firstHumLabel.textAlignment = NSTextAlignmentLeft;
        firstHumLabel.text = @"50%rh";
        [self addSubview:firstHumLabel];
        
        UILabel *secondHumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scrollView.frame) + 5.f, 210.f, 40.f, 40.f)];
        secondHumLabel.lineBreakMode = NSLineBreakByWordWrapping;
        secondHumLabel.numberOfLines = 0;
        secondHumLabel.textColor = colorWithHexString(@"50A1F9");
        secondHumLabel.font = [UIFont systemFontOfSize:11.f];
        secondHumLabel.textAlignment = NSTextAlignmentLeft;
        NSString *humContent = @"0%rh\r10级";
        NSRange humRange = [humContent rangeOfString:@"10级"];
        NSMutableAttributedString *humAttributeStr = [[NSMutableAttributedString alloc] initWithString:humContent];
        [humAttributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"ef6868") range:humRange];
        secondHumLabel.attributedText = humAttributeStr;
        [self addSubview:secondHumLabel];
        
        //风力
        UILabel *firstWinLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scrollView.frame) + 5.f, 270.f, 40.f, 20.f)];
        firstWinLabel.textColor = colorWithHexString(@"ef6868");
        firstWinLabel.font = [UIFont systemFontOfSize:11.f];
        firstWinLabel.textAlignment = NSTextAlignmentLeft;
        firstWinLabel.text = @"5级";
        [self addSubview:firstWinLabel];
        
        UILabel *secondWinLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scrollView.frame) + 5.f, 320.f, 40.f, 20.f)];
        secondWinLabel.textColor = colorWithHexString(@"ef6868");
        secondWinLabel.font = [UIFont systemFontOfSize:11.f];
        secondWinLabel.textAlignment = NSTextAlignmentLeft;
        secondWinLabel.text = @"0级";
        [self addSubview:secondWinLabel];
        
        
        // BXTHistogramFooterView
        self.footerView = [BXTHistogramFooterView viewForHistogramFooterView];
        self.footerView.frame = CGRectMake(0, 370, self.frame.size.width, 100);
        [self addSubview:self.footerView];
        
        
        BXTHistogramView *histogramView = [[BXTHistogramView alloc] initWithFrame:CGRectMake(0, 0, 1500, 330.f) temperaturePoints:self.temperatureArray humidityPoints:self.humidityArray windPowerPoints:self.windPowerArray totalEnergyPoints:self.totalEnergyArray block:^(CGFloat temperature, CGFloat humidity, CGFloat windPower, NSArray *energy) {
            NSLog(@"%f,%f,%f,%@",temperature,humidity,windPower,energy);
        }];
        [scrollView addSubview:histogramView];

    }
    return self;
}

@end
