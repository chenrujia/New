//
//  BXTHistogramStatisticsView.h
//  Histogram
//
//  Created by Jason on 16/7/4.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTHistogramFooterView.h"

@interface BXTHistogramStatisticsView : UIView

@property (nonatomic, strong) BXTHistogramFooterView *footerView;

@property (nonatomic, strong) NSArray            *temperatureArray;
@property (nonatomic, strong) NSArray            *humidityArray;
@property (nonatomic, strong) NSArray            *windPowerArray;
@property (nonatomic, strong) NSArray            *totalEnergyArray;

- (instancetype)initWithFrame:(CGRect)frame temperatureArray:(NSArray *)temArray humidityArray:(NSArray *)humArray windPowerArray:(NSArray *)windArray totalEnergyArray:(NSArray *)energyArray;

@end
