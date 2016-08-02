//
//  BXTEnergyTrendCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTEnergyTrendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *roundView;

@property (weak, nonatomic) IBOutlet UILabel *consumptionView;
@property (weak, nonatomic) IBOutlet UILabel *unitConsumptionView;

@property (weak, nonatomic) IBOutlet UILabel *circleView;
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UILabel *circleNumView;

@property (weak, nonatomic) IBOutlet UILabel *similarView;
@property (weak, nonatomic) IBOutlet UIImageView *similarImageView;
@property (weak, nonatomic) IBOutlet UILabel *similarNumView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
