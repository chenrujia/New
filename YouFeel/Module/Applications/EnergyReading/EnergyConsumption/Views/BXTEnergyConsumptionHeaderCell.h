//
//  BXTEnergyConsumptionHeaderCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/8/12.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTEnergyConsumptionInfo.h"

@interface BXTEnergyConsumptionHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *codeView;
@property (weak, nonatomic) IBOutlet UILabel *rateView;
@property (weak, nonatomic) IBOutlet UILabel *stateView;

@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;

/** ---- 能耗计算 ---- */
@property (nonatomic, strong) BXTEnergyConsumptionInfo *energyConsumptionInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
