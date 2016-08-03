//
//  BXTEnergyTrendBudgetCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTEnergyTrendInfo.h"

@interface BXTEnergyTrendBudgetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet UILabel *budgeView;

@property (weak, nonatomic) IBOutlet UILabel *differenceNumView;
@property (weak, nonatomic) IBOutlet UILabel *differenceRateView;

@property (nonatomic, strong) BXTEnergyTrendInfo *energyTrendInfo;
@property (nonatomic, strong) BXTEnergyTrendInfo *moneyTrendInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
