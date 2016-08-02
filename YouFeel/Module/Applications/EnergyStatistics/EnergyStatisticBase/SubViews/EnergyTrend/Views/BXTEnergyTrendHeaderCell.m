//
//  BXTEnergyTrendHeaderCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/8/2.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyTrendHeaderCell.h"

@implementation BXTEnergyTrendHeaderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"BXTEnergyTrendHeaderCell";
    BXTEnergyTrendHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEnergyTrendHeaderCell" owner:nil options:nil] lastObject];
    }
    
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
