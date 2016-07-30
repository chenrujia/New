//
//  BXTEnergySurveyViewChartCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/30.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYPieView.h"
#import "MYPieElement.h"
#import "BXTEnergySurveyInfo.h"

@interface BXTEnergySurveyViewChartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MYPieView *pieView;

@property (weak, nonatomic) IBOutlet UILabel *moneyView;

@property (weak, nonatomic) IBOutlet UILabel *circleView;
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UILabel *circleNumView;

@property (weak, nonatomic) IBOutlet UILabel *similarView;
@property (weak, nonatomic) IBOutlet UIImageView *similarImageView;
@property (weak, nonatomic) IBOutlet UILabel *similarNumView;

/** ---- 总数据 ---- */
@property (nonatomic, strong) BXTEySyTotalInfo *totalInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
