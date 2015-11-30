//
//  BarTimeAxisView.h
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/26.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarTimeAxisView : UIView

@property float spaceBetweenBars;
@property float barWidth;
@property (strong) UIColor * linesColor;
@property (strong) UIColor * numbersColor;
@property (strong) UIColor * numbersTextColor;
@property (strong) UIColor * dateColor;
@property (strong) UIColor * barColor;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) NSArray * colorArray;
@property (strong) UIColor * textColor;
@property (strong) UIColor * dottedLineColor;
@property (strong) UIColor * barOuterLine;
@property int numberOfVerticalElements;
@property (strong) NSString * datesBarText;
@property (strong) NSString * tasksBarText;
@property (strong) NSString * fontName;
@property CGFloat dateFontSize;
@property CGFloat titlesFontSize;

@end
