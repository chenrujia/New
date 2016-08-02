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
@property (nonatomic, assign) NSInteger              selectIndex;

- (instancetype)initWithFrame:(CGRect)frame lists:(NSArray *)lists kwhMeasure:(NSInteger)measure kwhNumber:(NSInteger)number;

@end
