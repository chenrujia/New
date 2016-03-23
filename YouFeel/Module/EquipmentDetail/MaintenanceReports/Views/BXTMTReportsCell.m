//
//  BXTMTReportsCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/23.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMTReportsCell.h"

@implementation BXTMTReportsCell

+ (instancetype)cellWithTableViewCell:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTMTReportsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTMTReportsCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
