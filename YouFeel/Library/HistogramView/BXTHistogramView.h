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

typedef void (^ChoosedDatesourece)(CGFloat temperature,CGFloat humidity,CGFloat windPower,NSArray *energy);

@interface BXTHistogramView : UIView
{
    BOOL      isFirst;
    NSInteger selectIndex;
}

@property (nonatomic, copy  ) ChoosedDatesourece datasourceBlock;
@property (nonatomic, strong) NSArray            *temperatureArray;
@property (nonatomic, strong) NSArray            *humidityArray;
@property (nonatomic, strong) NSArray            *windPowerArray;
@property (nonatomic, strong) NSArray            *totalEnergyArray;

- (instancetype)initWithFrame:(CGRect)frame temperaturePoints:(NSArray *)temPoints humidityPoints:(NSArray *)humPoints windPowerPoints:(NSArray *)windPoints totalEnergyPoints:(NSArray *)energyPoints block:(ChoosedDatesourece)block;

@end
