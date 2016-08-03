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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark -
#pragma mark - other
- (UIImage *)judgeImage:(NSInteger)sign
{
    NSString *imageStr = @"energyStatistics_Minus";
    if (sign == 1) {
        imageStr = @"energyStatistics_rise";
    }
    else if (sign == -1) {
        imageStr = @"energyStatistics_decline";
    }
    return [UIImage imageNamed:imageStr];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.energyBtn.layer.cornerRadius = 15;
    self.energyBtn.backgroundColor = colorWithHexString(@"#5DAFF9");
    [self.energyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.formatBtn.layer.cornerRadius = 15;
    self.formatBtn.layer.borderColor = [colorWithHexString(@"#5DAFF9") CGColor];
    self.formatBtn.layer.borderWidth = 2;
    
    self.buildingBtn.layer.cornerRadius = 15;
    self.buildingBtn.layer.borderColor = [colorWithHexString(@"#5DAFF9") CGColor];
    self.buildingBtn.layer.borderWidth = 2;
    self.buildingBtn.enabled = NO;
    
    self.areaBtn.layer.cornerRadius = 15;
    self.areaBtn.layer.borderColor = [colorWithHexString(@"#5DAFF9") CGColor];
    self.areaBtn.layer.borderWidth = 2;
    self.areaBtn.enabled = NO;
    
    self.systemBtn.layer.cornerRadius = 15;
    self.systemBtn.layer.borderColor = [colorWithHexString(@"#5DAFF9") CGColor];
    self.systemBtn.layer.borderWidth = 2;
    self.systemBtn.enabled = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
