//
//  BXTMyIntegralFirstCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMyIntegralFirstCell.h"

@implementation BXTMyIntegralFirstCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTMyIntegralFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTMyIntegralFirstCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    
    [self.sameMonthBtn setImage:[UIImage imageNamed:@"down_arrow_gray"] forState:UIControlStateNormal];
    [self.sameMonthBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.sameMonthBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, -100)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
