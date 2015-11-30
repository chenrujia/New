//
//  EvaluationHeader.h
//  YouFeel
//
//  Created by 满孝意 on 15/11/27.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AksStraightPieChart.h"

@interface EvaluationHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet AksStraightPieChart *pieChartView;
@property (weak, nonatomic) IBOutlet UILabel *persentView;

@property (weak, nonatomic) IBOutlet UILabel *doneView;
@property (weak, nonatomic) IBOutlet UILabel *praiseView;
@property (weak, nonatomic) IBOutlet UILabel *praiseRateView;

@end
