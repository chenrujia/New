//
//  BXTEnergyStatisticsView.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTEnergyStatisticsView : UIView

@property (weak, nonatomic) IBOutlet UIButton *surveyBtn;
@property (weak, nonatomic) IBOutlet UIButton *distributionBtn;
@property (weak, nonatomic) IBOutlet UIButton *trendBtn;
@property (weak, nonatomic) IBOutlet UILabel *costStatisticsView;

+ (instancetype)viewForEnergyStatisticsView;

@end
