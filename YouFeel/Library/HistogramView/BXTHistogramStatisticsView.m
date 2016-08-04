//
//  BXTHistogramStatisticsView.m
//  Histogram
//
//  Created by Jason on 16/7/4.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTHistogramStatisticsView.h"
#import "BXTGlobal.h"

@implementation BXTHistogramStatisticsView

- (instancetype)initWithFrame:(CGRect)frame lists:(NSArray *)datasource kwhMeasure:(NSInteger)measure kwhNumber:(NSInteger)number statisticsType:(StatisticsType)s_type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat sco_width = CGRectGetWidth(self.frame) - 80.f;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(40.f, 30, sco_width, 330.f)];
        scrollView.layer.borderColor = colorWithHexString(@"ADB4BC").CGColor;
        scrollView.layer.borderWidth = 1.f;
        scrollView.contentSize = CGSizeMake(50 * datasource.count, 0);
        scrollView.bounces = NO;
        if (50 * datasource.count > sco_width)
        {
            [scrollView setContentOffset:CGPointMake(50 * datasource.count - sco_width, 0)];
        }
        [self addSubview:scrollView];
        
        //电量
        if (number > 4)
        {
            UILabel *firstkwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 10.f, 35.f, 40.f)];
            firstkwhLabel.lineBreakMode = NSLineBreakByWordWrapping;
            firstkwhLabel.textAlignment = NSTextAlignmentRight;
            firstkwhLabel.numberOfLines = 0;
            firstkwhLabel.textColor = colorWithHexString(@"6D6E6F");
            firstkwhLabel.font = [UIFont systemFontOfSize:11.f];
            NSString *unitStr = @"Kwh";
            if (s_type == BudgetYearType || s_type == BudgetMonthType) {
                unitStr = @"元";
            }
            firstkwhLabel.text = [NSString stringWithFormat:@"  %@\r%ld", unitStr, (long)measure];
            [self addSubview:firstkwhLabel];
            
            UILabel *secondkwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 70.f, 30.f, 20.f)];
            secondkwhLabel.textColor = colorWithHexString(@"6D6E6F");
            secondkwhLabel.font = [UIFont systemFontOfSize:11.f];
            secondkwhLabel.adjustsFontSizeToFitWidth = YES;
            secondkwhLabel.textAlignment = NSTextAlignmentRight;
            secondkwhLabel.text = [NSString stringWithFormat:@"%ld",(long)measure/6*5];
            [self addSubview:secondkwhLabel];
            
            UILabel *thridkwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 120.f, 30.f, 20.f)];
            thridkwhLabel.textColor = colorWithHexString(@"6D6E6F");
            thridkwhLabel.font = [UIFont systemFontOfSize:11.f];
            thridkwhLabel.adjustsFontSizeToFitWidth = YES;
            thridkwhLabel.textAlignment = NSTextAlignmentRight;
            thridkwhLabel.text = [NSString stringWithFormat:@"%ld",(long)measure/6*4];
            [self addSubview:thridkwhLabel];
            
            UILabel *fourthkwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 170.f, 30.f, 20.f)];
            fourthkwhLabel.textColor = colorWithHexString(@"6D6E6F");
            fourthkwhLabel.font = [UIFont systemFontOfSize:11.f];
            fourthkwhLabel.adjustsFontSizeToFitWidth = YES;
            fourthkwhLabel.textAlignment = NSTextAlignmentRight;
            fourthkwhLabel.text = [NSString stringWithFormat:@"%ld",(long)measure/2];
            [self addSubview:fourthkwhLabel];
            
            UILabel *fifthkwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 220.f, 30.f, 20.f)];
            fifthkwhLabel.textColor = colorWithHexString(@"6D6E6F");
            fifthkwhLabel.font = [UIFont systemFontOfSize:11.f];
            fifthkwhLabel.adjustsFontSizeToFitWidth = YES;
            fifthkwhLabel.textAlignment = NSTextAlignmentRight;
            fifthkwhLabel.text = [NSString stringWithFormat:@"%ld",(long)measure/3];
            [self addSubview:fifthkwhLabel];
            
            UILabel *sixthkwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 270.f, 30.f, 20.f)];
            sixthkwhLabel.textColor = colorWithHexString(@"6D6E6F");
            sixthkwhLabel.font = [UIFont systemFontOfSize:11.f];
            sixthkwhLabel.adjustsFontSizeToFitWidth = YES;
            sixthkwhLabel.textAlignment = NSTextAlignmentRight;
            sixthkwhLabel.text = [NSString stringWithFormat:@"%ld",(long)measure/6];
            [self addSubview:sixthkwhLabel];
            
            UILabel *seventhkwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 320.f, 30.f, 20.f)];
            seventhkwhLabel.textColor = colorWithHexString(@"6D6E6F");
            seventhkwhLabel.font = [UIFont systemFontOfSize:11.f];
            seventhkwhLabel.adjustsFontSizeToFitWidth = YES;
            seventhkwhLabel.textAlignment = NSTextAlignmentRight;
            seventhkwhLabel.text = @"0";
            [self addSubview:seventhkwhLabel];
            
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
            NSString *content = @"-50°\r100%";
            NSRange range = [content rangeOfString:@"100%"];
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:content];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"50A1F9") range:range];
            thridTemLabel.attributedText = attributeStr;
            [self addSubview:thridTemLabel];
            
            //湿度
            UILabel *firstHumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scrollView.frame) + 5.f, 170.f, 40.f, 20.f)];
            firstHumLabel.textColor = colorWithHexString(@"50A1F9");
            firstHumLabel.font = [UIFont systemFontOfSize:11.f];
            firstHumLabel.textAlignment = NSTextAlignmentLeft;
            firstHumLabel.text = @"50%";
            [self addSubview:firstHumLabel];
            
            UILabel *secondHumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scrollView.frame) + 5.f, 210.f, 40.f, 40.f)];
            secondHumLabel.lineBreakMode = NSLineBreakByWordWrapping;
            secondHumLabel.numberOfLines = 0;
            secondHumLabel.textColor = colorWithHexString(@"50A1F9");
            secondHumLabel.font = [UIFont systemFontOfSize:11.f];
            secondHumLabel.textAlignment = NSTextAlignmentLeft;
            NSString *humContent = @"0%\r10级";
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
        }
        else
        {
            UILabel *firstkwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 10.f, 35.f, 40.f)];
            firstkwhLabel.lineBreakMode = NSLineBreakByWordWrapping;
            firstkwhLabel.textAlignment = NSTextAlignmentCenter;
            firstkwhLabel.numberOfLines = 0;
            firstkwhLabel.textColor = colorWithHexString(@"6D6E6F");
            firstkwhLabel.font = [UIFont systemFontOfSize:11.f];
            NSString *unitStr = @"Kwh";
            if (s_type == BudgetYearType || s_type == BudgetMonthType) {
                unitStr = @"元";
            }
            firstkwhLabel.text = [NSString stringWithFormat:@"  %@\r%ld", unitStr, (long)measure];
            [self addSubview:firstkwhLabel];
            
            UILabel *secondkwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 95.f, 35.f, 20.f)];
            secondkwhLabel.textColor = colorWithHexString(@"6D6E6F");
            secondkwhLabel.font = [UIFont systemFontOfSize:11.f];
            secondkwhLabel.adjustsFontSizeToFitWidth = YES;
            secondkwhLabel.textAlignment = NSTextAlignmentRight;
            secondkwhLabel.text = [NSString stringWithFormat:@"%ld",(long)measure/4*3];
            [self addSubview:secondkwhLabel];
            
            UILabel *thridkwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 170.f, 35.f, 20.f)];
            thridkwhLabel.textColor = colorWithHexString(@"6D6E6F");
            thridkwhLabel.font = [UIFont systemFontOfSize:11.f];
            thridkwhLabel.adjustsFontSizeToFitWidth = YES;
            thridkwhLabel.textAlignment = NSTextAlignmentRight;
            thridkwhLabel.text = [NSString stringWithFormat:@"%ld",(long)measure/2];
            [self addSubview:thridkwhLabel];
            
            UILabel *fourthkwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 245.f, 35.f, 20.f)];
            fourthkwhLabel.textColor = colorWithHexString(@"6D6E6F");
            fourthkwhLabel.font = [UIFont systemFontOfSize:11.f];
            fourthkwhLabel.adjustsFontSizeToFitWidth = YES;
            fourthkwhLabel.textAlignment = NSTextAlignmentRight;
            fourthkwhLabel.text = [NSString stringWithFormat:@"%ld",(long)measure/4];
            [self addSubview:fourthkwhLabel];
            
            UILabel *fifthkwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 320.f, 35.f, 20.f)];
            fifthkwhLabel.textColor = colorWithHexString(@"6D6E6F");
            fifthkwhLabel.font = [UIFont systemFontOfSize:11.f];
            fifthkwhLabel.adjustsFontSizeToFitWidth = YES;
            fifthkwhLabel.textAlignment = NSTextAlignmentRight;
            fifthkwhLabel.text = @"0";
            [self addSubview:fifthkwhLabel];
            
            //温度
            UILabel *firstTemLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scrollView.frame) + 5.f, 20.f, 30.f, 20.f)];
            firstTemLabel.textColor = colorWithHexString(@"FDD400");
            firstTemLabel.font = [UIFont systemFontOfSize:11.f];
            firstTemLabel.text = @"50°";
            [self addSubview:firstTemLabel];
            
            UILabel *secondTemLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scrollView.frame) + 5.f, 95.f, 25.f, 20.f)];
            secondTemLabel.textColor = colorWithHexString(@"FDD400");
            secondTemLabel.font = [UIFont systemFontOfSize:11.f];
            secondTemLabel.textAlignment = NSTextAlignmentLeft;
            secondTemLabel.text = @"0°";
            [self addSubview:secondTemLabel];
            
            UILabel *thridTemLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scrollView.frame) + 5.f, 160.f, 40.f, 40.f)];
            thridTemLabel.lineBreakMode = NSLineBreakByWordWrapping;
            thridTemLabel.numberOfLines = 0;
            thridTemLabel.textColor = colorWithHexString(@"FDD400");
            thridTemLabel.font = [UIFont systemFontOfSize:9.f];
            thridTemLabel.textAlignment = NSTextAlignmentLeft;
            NSString *content = @"-50°\r100%";
            NSRange range = [content rangeOfString:@"100%"];
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:content];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"50A1F9") range:range];
            thridTemLabel.attributedText = attributeStr;
            [self addSubview:thridTemLabel];
            
            //湿度
            UILabel *firstHumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scrollView.frame) + 5.f, 245.f, 40.f, 20.f)];
            firstHumLabel.textColor = colorWithHexString(@"50A1F9");
            firstHumLabel.font = [UIFont systemFontOfSize:11.f];
            firstHumLabel.textAlignment = NSTextAlignmentLeft;
            firstHumLabel.text = @"50%";
            [self addSubview:firstHumLabel];
            
            UILabel *secondHumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scrollView.frame) + 5.f, 320.f, 40.f, 20.f)];
            secondHumLabel.textColor = colorWithHexString(@"50A1F9");
            secondHumLabel.font = [UIFont systemFontOfSize:11.f];
            secondHumLabel.textAlignment = NSTextAlignmentLeft;
            NSString *humContent = @"0%";
            NSRange humRange = [humContent rangeOfString:@"10级"];
            NSMutableAttributedString *humAttributeStr = [[NSMutableAttributedString alloc] initWithString:humContent];
            [humAttributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"ef6868") range:humRange];
            secondHumLabel.attributedText = humAttributeStr;
            [self addSubview:secondHumLabel];
        }
        
        self.footerView = [BXTHistogramFooterView viewForHistogramFooterView];
        self.footerView.frame = CGRectMake(0, 370, self.frame.size.width, 100);
        [self addSubview:self.footerView];
        
        
        BXTHistogramView *histogramView = [[BXTHistogramView alloc] initWithFrame:CGRectMake(0, 0, 1500, 330.f) lists:datasource kwhMeasure:measure kwhNumber:number statisticsType:s_type block:^(CGFloat temperature, CGFloat humidity, CGFloat windPower, NSArray *energy,NSInteger index) {
            if (s_type == MonthType)
            {
                self.footerView.checkDetailBtn.hidden = NO;
            }
            if (s_type == MonthType || s_type == DayType)
            {
                self.footerView.consumptionView.text = [NSString stringWithFormat:@"总能耗：%@", energy[0]];
                self.footerView.peakNumView.text = [NSString stringWithFormat:@"尖峰量：%@", energy[1]];
                self.footerView.apexNumView.text = [NSString stringWithFormat:@"峰段量：%@", energy[2]];
                self.footerView.levelNumView.text = [NSString stringWithFormat:@"平段量：%@", energy[3]];
                self.footerView.valleyNumView.text = [NSString stringWithFormat:@"谷段量：%@", energy[4]];
            }
            self.selectIndex = index;
            
            if (s_type == BudgetYearType || s_type == EnergyYearType || s_type == BudgetMonthType || s_type == EnergyMonthType) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BXTHistogramViewSelectIndex" object:nil userInfo:@{@"index": @(index), @"s_type": @(s_type)}];
            }
        }];
        [scrollView addSubview:histogramView];
        
    }
    return self;
}

@end
