//
//  BXTEnergyTrendHiddenCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/8/4.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyTrendHiddenCell.h"

@implementation BXTEnergyTrendHiddenCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"BXTEnergyTrendHiddenCell";
    BXTEnergyTrendHiddenCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEnergyTrendHiddenCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setEnergyTrendInfo:(BXTEnergyTrendInfo *)energyTrendInfo
{
    _energyTrendInfo = energyTrendInfo;
    
    self.consumptionView.text = [NSString stringWithFormat:@"总能耗：%ld Kwh", (long)energyTrendInfo.energy_consumption];
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %ld Kwh", (long)energyTrendInfo.mom_energy_consumption];
    self.circleImageView.image = [self judgeImage:energyTrendInfo.mom_energy_consumption_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", energyTrendInfo.mom_energy_consumption_per];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %ld Kwh", (long)energyTrendInfo.an_energy_consumption];
    self.similarImageView.image = [self judgeImage:energyTrendInfo.an_energy_consumption_sign];
    self.similarNumView.text = [NSString stringWithFormat:@"%@", energyTrendInfo.an_energy_consumption_per];
    
    self.trueNumView.text = [NSString stringWithFormat:@"绝对能耗: %ld Kwh", (long)energyTrendInfo.true_energy_consumption];
    self.statisticErrorView.text = [NSString stringWithFormat:@"统计误差: %ld", (long)energyTrendInfo.true_energy_consumption_diff];
}

- (void)setMoneyTrendInfo:(BXTEnergyTrendInfo *)moneyTrendInfo
{
    _moneyTrendInfo = moneyTrendInfo;
    
    self.consumptionView.text = [NSString stringWithFormat:@"总费用：%ld 元", (long)moneyTrendInfo.money];
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %ld 元", (long)moneyTrendInfo.mom_money];
    self.circleImageView.image = [self judgeImage:moneyTrendInfo.mom_money_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", moneyTrendInfo.mom_money_per];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %.ld 元", (long)moneyTrendInfo.an_money];
    self.similarImageView.image = [self judgeImage:moneyTrendInfo.an_money_sign];
    self.similarNumView.text = [NSString stringWithFormat:@"%@", moneyTrendInfo.an_money_per];
    
    self.trueNumView.text = [NSString stringWithFormat:@"绝对费用: %ld 元", (long)moneyTrendInfo.true_money];
    self.statisticErrorView.text = [NSString stringWithFormat:@"统计误差: %ld", (long)moneyTrendInfo.true_money_diff];
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
    
    self.roundView.layer.cornerRadius = 5;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
