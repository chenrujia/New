//
//  BXTEnergyDistributionViewChartCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/30.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyDistributionViewChartCell.h"

@interface BXTEnergyDistributionViewChartCell ()

@end

@implementation BXTEnergyDistributionViewChartCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"BXTEnergyDistributionViewChartCell";
    BXTEnergyDistributionViewChartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEnergyDistributionViewChartCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setEnergyListInfo:(BXTEYDTTotalInfo *)energyListInfo
{
    _energyListInfo = energyListInfo;
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %ld %@", (long)energyListInfo.mom_energy_consumption, self.unit];
    self.circleImageView.image = [self judgeImage:energyListInfo.mom_energy_consumption_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", energyListInfo.mom_energy_consumption_per];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %.ld %@", (long)energyListInfo.an_energy_consumption, self.unit];
    self.similarImageView.image = [self judgeImage:energyListInfo.an_energy_consumption_sign];
    self.similarNumView.text = [NSString stringWithFormat:@"%@", energyListInfo.an_energy_consumption_per];
}

- (void)setMoneyListInfo:(BXTEYDTTotalInfo *)moneyListInfo
{
    _moneyListInfo = moneyListInfo;
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %ld 元", (long)moneyListInfo.mom_money];
    self.circleImageView.image = [self judgeImage:moneyListInfo.mom_money_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", moneyListInfo.mom_money_per];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %.ld 元", (long)moneyListInfo.an_money];
    self.similarImageView.image = [self judgeImage:moneyListInfo.an_money_sign];
    self.similarNumView.text = [NSString stringWithFormat:@"%@", moneyListInfo.an_money_per];
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
    self.energyBtn.layer.borderColor = [colorWithHexString(@"#5DAFF9") CGColor];
    self.energyBtn.layer.borderWidth = 2;
    
    self.formatBtn.layer.cornerRadius = 15;
    self.formatBtn.layer.borderColor = [colorWithHexString(@"#5DAFF9") CGColor];
    self.formatBtn.layer.borderWidth = 2;
    
    self.buildingBtn.layer.cornerRadius = 15;
    self.buildingBtn.layer.borderColor = [colorWithHexString(@"#5DAFF9") CGColor];
    self.buildingBtn.layer.borderWidth = 2;
    
    self.areaBtn.layer.cornerRadius = 15;
    self.areaBtn.layer.borderColor = [colorWithHexString(@"#5DAFF9") CGColor];
    self.areaBtn.layer.borderWidth = 2;
    
    self.systemBtn.layer.cornerRadius = 15;
    self.systemBtn.layer.borderColor = [colorWithHexString(@"#5DAFF9") CGColor];
    self.systemBtn.layer.borderWidth = 2;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
