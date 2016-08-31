//
//  BXTMeterReadingTimeCell.m
//  HHHHHH
//
//  Created by 满孝意 on 16/7/4.
//  Copyright © 2016年 满孝意. All rights reserved.
//

#import "BXTMeterReadingTimeCell.h"

@implementation BXTMeterReadingTimeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTMeterReadingTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTMeterReadingTimeCell" owner:nil options:nil] lastObject];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (void)setLists:(BXTRecordListsInfo *)lists
{
    _lists = lists;
    
    self.peakValueView.text = [NSString stringWithFormat:@"%@ %@", lists.peak_segment_num, self.unit];
    self.peakNumView.text = [NSString stringWithFormat:@"%@ %@", lists.peak_segment_amount, self.unit];
    
    self.apexValueView.text = [NSString stringWithFormat:@"%@ %@", lists.peak_period_num, self.unit];
    self.apexNumView.text = [NSString stringWithFormat:@"%@ %@", lists.peak_period_amount, self.unit];
    
    self.levelValueView.text = [NSString stringWithFormat:@"%@ %@", lists.flat_section_num, self.unit];
    self.levelNumView.text = [NSString stringWithFormat:@"%@ %@", lists.flat_section_amount, self.unit];
    
    self.valleyValueView.text = [NSString stringWithFormat:@"%@ %@", lists.valley_section_num, self.unit];
    self.valleyNumView.text = [NSString stringWithFormat:@"%@ %@", lists.valley_section_amount, self.unit];
    
    self.surplusSumLabel.text = [NSString stringWithFormat:@"%@ %@", lists.remaining_energy, self.unit];
    self.surplusMoneyLabel.text = [NSString stringWithFormat:@"%@ 元", lists.remaining_money];
    
    self.temperatureView.text = [NSString stringWithFormat:@"%.0f℃", [lists.temperature floatValue]];
    self.humidityView.text = [NSString stringWithFormat:@"%@%%", lists.humidity];
    self.windForceView.text = [NSString stringWithFormat:@"%@级", lists.wind_force];
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
