//
//  StatisticsMianViewController.h
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/25.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYPieView.h"
#import "MYPieElement.h"
#import "BarChatItemView.h"
#import "AksStraightPieChart.h"
#import "PNChart.h"
#import "BXTGlobal.h"
#import "BXTHeaderFile.h"
#import "BXTDataRequest.h"
#import "SPBarChart.h"
#import "SPBarChartData.h"
#import "SPChartDelegate.h"

@interface StatisticsMianViewController : UIViewController  {
    UIView *pickerbgView;
    UIDatePicker *datePicker;
    NSDate *selectedDate;
}

/**
 *  所有子界面控件加载到rootScrollView上即可
 */
@property (nonatomic, strong) UIScrollView *rootScrollView;
@property(nonatomic, strong) UISegmentedControl *rootSegmentedCtr;
@property (nonatomic, strong) UIButton *rootCenterButton;

/**
 *  时间戳转换成 2015-11-27 格式
 */
- (NSString *)transTimeWithDate:(NSDate *)date;
/**
 *  时间戳转换成 2015年11月27日 星期五 格式
 */
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

- (void)showLoadingMBP:(NSString *)text;

- (void)hideMBP;

@end
