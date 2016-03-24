//
//  BXTMTWriteReportCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMTWriteReportCell.h"

@implementation BXTMTWriteReportCell

+ (instancetype)cellWithTableViewCell:(UITableView *)tableView
{
    static NSString *cellID = @"WriteReportCell";
    BXTMTWriteReportCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTMTWriteReportCell" owner:nil options:nil] lastObject];
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
