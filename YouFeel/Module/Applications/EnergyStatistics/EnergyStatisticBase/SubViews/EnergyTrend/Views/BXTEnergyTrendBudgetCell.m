//
//  BXTEnergyTrendBudgetCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyTrendBudgetCell.h"

@implementation BXTEnergyTrendBudgetCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"BXTEnergyTrendBudgetCell";
    BXTEnergyTrendBudgetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEnergyTrendBudgetCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setEnergyTrendInfo:(BXTEnergyTrendInfo *)energyTrendInfo
{
    _energyTrendInfo = energyTrendInfo;
    
    self.budgeView.text = [NSString stringWithFormat:@"预算：%@ Kwh", energyTrendInfo.energy_consumption_budget];
    self.differenceNumView.text = [NSString stringWithFormat:@"差异量：%ld Kwh", (long)energyTrendInfo.energy_consumption_budget_diff];
    self.differenceRateView.text = [NSString stringWithFormat:@"差异率：%@", energyTrendInfo.energy_consumption_budget_diff_per];
}

- (void)setMoneyTrendInfo:(BXTEnergyTrendInfo *)moneyTrendInfo
{
    _moneyTrendInfo = moneyTrendInfo;
    
    self.budgeView.text = [NSString stringWithFormat:@"预算：%@ 元", moneyTrendInfo.money_budget];
    self.differenceNumView.text = [NSString stringWithFormat:@"差异量：%ld 元", (long)moneyTrendInfo.money_budget_diff];
    self.differenceRateView.text = [NSString stringWithFormat:@"差异率：%@", moneyTrendInfo.money_budget_diff_per];
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
