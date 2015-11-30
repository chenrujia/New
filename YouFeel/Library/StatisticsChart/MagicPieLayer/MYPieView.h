//
//  MYPieView.h
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/25.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieLayer.h"

@interface MYPieView : UIView

typedef void (^blockT)(NSInteger index);
@property(nonatomic, copy) blockT transSelected;
@property (nonatomic, assign) BOOL centerDisplace;

@end

@interface MYPieView (ex)
@property(nonatomic, readonly, retain) PieLayer *layer;
@end
