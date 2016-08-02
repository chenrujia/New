//
//  BXTHistogramStatisticsView.h
//  Histogram
//
//  Created by Jason on 16/7/4.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTHistogramFooterView.h"
#import "BXTHistogramView.h"

@interface BXTHistogramStatisticsView : UIView

@property (nonatomic, strong) BXTHistogramFooterView *footerView;
@property (nonatomic, assign) NSInteger              selectIndex;

- (instancetype)initWithFrame:(CGRect)frame lists:(NSArray *)datasource kwhMeasure:(NSInteger)measure kwhNumber:(NSInteger)number statisticsType:(StatisticsType)s_type;

@end
