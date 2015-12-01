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
#import "BarTimeAxisView.h"
#import "BarTimeAxisData.h"
#import "AksStraightPieChart.h"
#import "PNChart.h"
#import "BXTGlobal.h"
#import "BXTHeaderFile.h"
#import "BXTDataRequest.h"

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

/**
 *  时间戳转换成 2015-11-27 格式
 */
- (NSString *)transTimeWithDate:(NSDate *)date;

- (void)showLoadingMBP:(NSString *)text;

- (void)hideMBP;

@end
