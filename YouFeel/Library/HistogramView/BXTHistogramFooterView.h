//
//  BXTHistogramFooterView.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/5.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTGlobal.h"

@interface BXTHistogramFooterView : UIView

/** ---- 总能耗 ---- */
@property (weak, nonatomic) IBOutlet UILabel *consumptionView;
/** ---- 峰段 ---- */
@property (weak, nonatomic) IBOutlet UILabel *apexNumView;
/** ---- 平段 ---- */
@property (weak, nonatomic) IBOutlet UILabel *levelNumView;
/** ---- 谷段 ---- */
@property (weak, nonatomic) IBOutlet UILabel *valleyNumView;
/** ---- 尖峰 ---- */
@property (weak, nonatomic) IBOutlet UILabel *peakNumView;

@property (weak, nonatomic) IBOutlet UIButton *checkDetailBtn;

@property (weak, nonatomic) IBOutlet UIView *roundView0;
@property (weak, nonatomic) IBOutlet UIView *roundView1;
@property (weak, nonatomic) IBOutlet UIView *roundView2;
@property (weak, nonatomic) IBOutlet UIView *roundView3;
@property (weak, nonatomic) IBOutlet UIView *roundView4;
@property (weak, nonatomic) IBOutlet UIView *roundView5;

+ (instancetype)viewForHistogramFooterView;

@end
