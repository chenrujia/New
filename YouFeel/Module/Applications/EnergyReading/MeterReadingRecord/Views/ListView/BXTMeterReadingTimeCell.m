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
    
    self.peakValueView.text = lists.peak_segment_num;
    self.peakNumView.text = lists.peak_segment_amount;
    
    self.apexValueView.text = lists.peak_period_num;
    self.apexNumView.text = lists.peak_period_amount;
    
    self.levelValueView.text = lists.flat_section_num;
    self.levelNumView.text = lists.flat_section_amount;
    
    self.valleyValueView.text = lists.valley_section_num;
    self.valleyNumView.text = lists.valley_section_amount;
    
    self.temperatureView.text = [NSString stringWithFormat:@"%2.ld℃", [lists.temperature integerValue]];
    self.humidityView.text = [NSString stringWithFormat:@"%@%%rh", lists.humidity];
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
