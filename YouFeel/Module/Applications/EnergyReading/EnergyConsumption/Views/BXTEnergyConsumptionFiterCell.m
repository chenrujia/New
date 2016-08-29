//
//  BXTEnergyConsumptionFiterCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/6/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyConsumptionFiterCell.h"
#import "BXTGlobal.h"

@implementation BXTEnergyConsumptionFiterCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"Fitercell";
    BXTEnergyConsumptionFiterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEnergyConsumptionFiterCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)setConsumpInfo:(BXTEnergyConsumptionInfo *)consumpInfo
{
    _consumpInfo = consumpInfo;
    
    self.sumValueView.text = [NSString stringWithFormat:@"%@ %@", [BXTGlobal transNum:30.21999], self.consumpInfo.unit];
    self.peakValueView.text = [NSString stringWithFormat:@"%@ %@", [BXTGlobal transNum:consumpInfo.calc.peak_segment_num], self.consumpInfo.unit];
    self.apexValueView.text = [NSString stringWithFormat:@"%@ %@", [BXTGlobal transNum:consumpInfo.calc.peak_period_num], self.consumpInfo.unit];
    self.levelValueView.text = [NSString stringWithFormat:@"%@ %@", [BXTGlobal transNum:consumpInfo.calc.flat_section_num], self.consumpInfo.unit];
    self.valleyValueView.text = [NSString stringWithFormat:@"%@ %@", [BXTGlobal transNum:consumpInfo.calc.valley_section_num], self.consumpInfo.unit];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius = 10;
    
    self.startTimeBtn.layer.borderColor = [colorWithHexString(@"#5DAFF9") CGColor];
    self.startTimeBtn.layer.borderWidth = 1;
    self.startTimeBtn.layer.cornerRadius = 5;
    
    self.endTimeBtn.layer.borderColor = [colorWithHexString(@"#5DAFF9") CGColor];
    self.endTimeBtn.layer.borderWidth = 1;
    self.endTimeBtn.layer.cornerRadius = 5;
    
    self.filterBtn.layer.cornerRadius = 5;
    
    self.resetBtn.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
