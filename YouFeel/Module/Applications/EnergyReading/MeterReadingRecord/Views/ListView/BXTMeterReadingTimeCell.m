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

- (void)setInfo:(BXTMeterReadingRecordListInfo *)info
{
    _info = info;
}

- (void)setLists:(BXTRecordListsInfo *)lists
{
    _lists = lists;
    
    self.peakValueView.text = [NSString stringWithFormat:@"%@ %@", lists.peak_segment_num, self.info.unit];
    self.peakNumView.text = [NSString stringWithFormat:@"%@ %@", lists.peak_segment_amount, self.info.unit];
    
    self.apexValueView.text = [NSString stringWithFormat:@"%@ %@", lists.peak_period_num, self.info.unit];
    self.apexNumView.text = [NSString stringWithFormat:@"%@ %@", lists.peak_period_amount, self.info.unit];
    
    self.levelValueView.text = [NSString stringWithFormat:@"%@ %@", lists.flat_section_num, self.info.unit];
    self.levelNumView.text = [NSString stringWithFormat:@"%@ %@", lists.flat_section_amount, self.info.unit];
    
    self.valleyValueView.text = [NSString stringWithFormat:@"%@ %@", lists.valley_section_num, self.info.unit];
    self.valleyNumView.text = [NSString stringWithFormat:@"%@ %@", lists.valley_section_amount, self.info.unit];
    
    self.temperatureView.text = [NSString stringWithFormat:@"%.0f℃", [lists.temperature floatValue]];
    self.humidityView.text = [NSString stringWithFormat:@"%@%%", lists.humidity];
    self.windForceView.text = [NSString stringWithFormat:@"%@级", lists.wind_force];
    
    
    if ([self.info.prepayment isEqualToString:@"1"]) {
        if ([lists.remaining_energy integerValue] != 0 && [lists.remaining_money integerValue] != 0) {
            self.lineView.hidden = NO;
            self.surplusSumTitleLabel.hidden = NO;
            self.surplusSumLabel.hidden = NO;
            self.surplusMoneyTitleLabel.hidden = NO;
            self.surplusMoneyLabel.hidden = NO;
            self.surplusSumLabel.text = [NSString stringWithFormat:@"%@ %@", lists.remaining_energy, self.info.unit];
            self.surplusMoneyLabel.text = [NSString stringWithFormat:@"%@ 元", lists.remaining_money];
        }
        else if ([lists.remaining_energy integerValue] != 0) {
            self.lineView.hidden = NO;
            self.surplusSumTitleLabel.hidden = NO;
            self.surplusSumLabel.hidden = NO;
            self.surplusSumTitleLabel.text = @"总余量：";
            self.surplusSumLabel.text = [NSString stringWithFormat:@"%@ %@", lists.remaining_energy, self.info.unit];
        }
        else if ([lists.remaining_money integerValue] != 0) {
            self.lineView.hidden = NO;
            self.surplusSumTitleLabel.hidden = NO;
            self.surplusSumLabel.hidden = NO;
            self.surplusSumTitleLabel.text = @"总余额：";
            self.surplusSumLabel.text = [NSString stringWithFormat:@"%@ 元", lists.remaining_money];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.lineView.hidden = YES;
    self.surplusSumTitleLabel.hidden = YES;
    self.surplusSumLabel.hidden = YES;
    self.surplusMoneyTitleLabel.hidden = YES;
    self.surplusMoneyLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
