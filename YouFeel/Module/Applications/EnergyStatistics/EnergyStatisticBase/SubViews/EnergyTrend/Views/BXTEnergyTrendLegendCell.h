//
//  BXTEnergyTrendLegendCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTEnergyTrendLegendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *roundView1;
@property (weak, nonatomic) IBOutlet UIView *roundView2;

@property (weak, nonatomic) IBOutlet UILabel *temperatureView;
@property (weak, nonatomic) IBOutlet UILabel *humidityView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
