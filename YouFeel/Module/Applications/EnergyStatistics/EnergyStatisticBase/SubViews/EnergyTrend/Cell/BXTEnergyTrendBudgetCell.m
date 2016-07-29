//
//  BXTEnergyTrendBudgetCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyTrendBudgetCell.h"

@implementation BXTEnergyTrendBudgetCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"BXTEnergyTrendBudgetCell";
    BXTEnergyTrendBudgetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEnergyTrendBudgetCell" owner:nil options:nil] lastObject];
    }
    
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.roundView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
