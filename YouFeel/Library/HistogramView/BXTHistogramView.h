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
    WindPowerType = 3
};

typedef void (^ChoosedDatesourece)(CGFloat temperature,CGFloat humidity,CGFloat windPower,NSArray *energy,NSInteger index);

@interface BXTHistogramView : UIView
{
    BOOL      isFirst;
    NSInteger selectIndex;
}

@property (nonatomic, copy  ) ChoosedDatesourece datasourceBlock;
@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) NSArray            *temperatureArray;
@property (nonatomic, strong) NSArray            *humidityArray;
@property (nonatomic, strong) NSArray            *windPowerArray;
@property (nonatomic, strong) NSArray            *totalEnergyArray;
@property (nonatomic, assign) NSInteger          kwhMeasure;
@property (nonatomic, assign) NSInteger          kwhNumber;

- (instancetype)initWithFrame:(CGRect)frame lists:(NSArray *)datasource kwhMeasure:(NSInteger)measure kwhNumber:(NSInteger)number block:(ChoosedDatesourece)block;

@end
