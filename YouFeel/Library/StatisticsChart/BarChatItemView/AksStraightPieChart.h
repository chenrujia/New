//
//  AksStraightPieChart.h
//  Betify
//
//  Created by Alok on 19/06/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AksStraightPieChart : UIView {
    NSMutableArray *dataToRepresent;
}

/**
 *  是否是竖直的
 */
@property (nonatomic, assign) BOOL isVertical;

- (void)addDataToRepresent:(int)value WithColor:(UIColor *)color;
- (void)clearChart;

@end
