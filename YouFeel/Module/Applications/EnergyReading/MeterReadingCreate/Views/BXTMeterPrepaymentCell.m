//
//  BXTMeterPrepaymentCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/8/31.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMeterPrepaymentCell.h"

@implementation BXTMeterPrepaymentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"BXTMeterPrepaymentCell";
    BXTMeterPrepaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTMeterPrepaymentCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
