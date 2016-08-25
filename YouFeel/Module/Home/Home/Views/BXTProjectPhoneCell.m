//
//  BXTProjectPhoneCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/8/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTProjectPhoneCell.h"

@implementation BXTProjectPhoneCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTProjectPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTProjectPhoneCell" owner:nil options:nil] lastObject];
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
