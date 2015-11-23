//
//  BXTDrawView.h
//  BXT
//
//  Created by Jason on 15/9/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTDrawView : UIView

@property (nonatomic ,assign) NSInteger repairState;
@property (nonatomic ,assign) NSInteger isRepairing;

- (instancetype)initWithFrame:(CGRect)frame withRepairState:(NSInteger)state withIsRespairing:(NSInteger)repairing;

@end
