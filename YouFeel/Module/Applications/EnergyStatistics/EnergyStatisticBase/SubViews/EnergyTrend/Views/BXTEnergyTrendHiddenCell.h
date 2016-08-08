//
//  BXTEnergyTrendHiddenCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/8/4.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTEnergyTrendInfo.h"

@interface BXTEnergyTrendHiddenCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *roundView;

@property (weak, nonatomic) IBOutlet UILabel *consumptionView;

@property (weak, nonatomic) IBOutlet UILabel *circleView;
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UILabel *circleNumView;

@property (weak, nonatomic) IBOutlet UILabel *similarView;
@property (weak, nonatomic) IBOutlet UIImageView *similarImageView;
@property (weak, nonatomic) IBOutlet UILabel *similarNumView;

@property (weak, nonatomic) IBOutlet UILabel *trueNumView;
@property (weak, nonatomic) IBOutlet UILabel *statisticErrorView;

@property (nonatomic, strong) BXTEnergyTrendInfo *energyTrendInfo;
@property (nonatomic, strong) BXTEnergyTrendInfo *moneyTrendInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
