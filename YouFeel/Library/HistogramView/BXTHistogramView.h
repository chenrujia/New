//
//  BXTHistogramView.h
//  Histogram
//
//  Created by Jason on 16/6/30.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTGlobal.h"

typedef NS_ENUM(NSInteger, BrokenLineType) {
    TemperatureType = 1,
    HumidityType = 2,
    WindPowerType = 3,
    MoneyBudgetType = 4
};

typedef NS_ENUM(NSInteger, StatisticsType) {
    MonthType = 1,
    DayType = 2,
    BudgetYearType = 3,
    EnergyYearType = 4,
    BudgetMonthType = 5,
    EnergyMonthType = 6,
};

typedef void (^ChoosedDatesourece)(CGFloat temperature,CGFloat humidity,CGFloat windPower,NSArray *energy,NSInteger index);

@interface BXTHistogramView : UIView
{
    BOOL      isFirst;
    NSInteger selectIndex;
}

@property (nonatomic, copy  ) ChoosedDatesourece datasourceBlock;
@property (nonatomic, strong) NSArray            *datasource;
@property (nonatomic, strong) NSArray            *temperatureArray;
@property (nonatomic, strong) NSArray            *humidityArray;
@property (nonatomic, strong) NSArray            *windPowerArray;
@property (nonatomic, strong) NSArray            *moneyArray;
@property (nonatomic, strong) NSArray            *energyArray;
@property (nonatomic, strong) NSArray            *totalEnergyArray;
@property (nonatomic, assign) NSInteger          kwhMeasure;
@property (nonatomic, assign) NSInteger          kwhNumber;
@property (nonatomic, assign) StatisticsType     statisticsType;

- (instancetype)initWithFrame:(CGRect)frame lists:(NSArray *)datasource kwhMeasure:(NSInteger)measure kwhNumber:(NSInteger)number statisticsType:(StatisticsType)s_type block:(ChoosedDatesourece)block;

@end
