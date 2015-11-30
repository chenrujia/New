//
//  EvaluationFooter.h
//  YouFeel
//
//  Created by 满孝意 on 15/11/27.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNBarChart.h"

@interface EvaluationFooter : UIView

@property (weak, nonatomic) IBOutlet PNBarChart *barChart;

@property (weak, nonatomic) IBOutlet UILabel *groupView;
@property (weak, nonatomic) IBOutlet UILabel *doneView;
@property (weak, nonatomic) IBOutlet UILabel *praiseView;
@property (weak, nonatomic) IBOutlet UILabel *praiseRateView;

@end
