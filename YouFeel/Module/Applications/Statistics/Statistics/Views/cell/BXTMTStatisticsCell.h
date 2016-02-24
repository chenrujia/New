//
//  BXTMTStatisticsCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/2/23.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AksStraightPieChart.h"

@interface BXTMTStatisticsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *detailView;
@property (weak, nonatomic) IBOutlet AksStraightPieChart *pieChartView;

@end
