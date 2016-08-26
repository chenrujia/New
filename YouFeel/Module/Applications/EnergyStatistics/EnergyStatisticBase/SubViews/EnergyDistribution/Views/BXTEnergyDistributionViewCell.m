//
//  BXTEnergyDistributionViewCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/8/10.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyDistributionViewCell.h"
#import "BXTGlobal.h"

@implementation BXTEnergyDistributionViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"BXTEnergyDistributionViewCell";
    BXTEnergyDistributionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEnergyDistributionViewCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setEnergyListInfo:(BXTEYDTListsInfo *)energyListInfo
{
    _energyListInfo = energyListInfo;
    
    self.typeView.text = energyListInfo.name;
    self.moneyView.text = [NSString stringWithFormat:@"能耗量: %@ %@", [BXTGlobal transNum:energyListInfo.energy_consumption], self.unit];
    self.rateView.text = [NSString stringWithFormat:@"比例: %.2f%%", energyListInfo.energy_consumption_per];
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %@ %@", [BXTGlobal transNum:energyListInfo.mom_energy_consumption], self.unit];
    self.circleImageView.image = [self judgeImage:energyListInfo.mom_energy_consumption_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", energyListInfo.mom_energy_consumption_per];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %@ %@", [BXTGlobal transNum:energyListInfo.an_energy_consumption], self.unit];
    self.similarImageView.image = [self judgeImage:energyListInfo.an_energy_consumption_sign];
    self.similarNumView.text = [NSString stringWithFormat:@"%@", energyListInfo.an_energy_consumption_per];
}



- (void)setMoneyListInfo:(BXTEYDTListsInfo *)moneyListInfo
{
    _moneyListInfo = moneyListInfo;
    
    self.typeView.text = moneyListInfo.name;
    self.moneyView.text = [NSString stringWithFormat:@"金额: %@ 元", [BXTGlobal transNum:moneyListInfo.money]];
    self.rateView.text = [NSString stringWithFormat:@"比例: %.2f%%", moneyListInfo.money_per];
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %@ 元", [BXTGlobal transNum:moneyListInfo.mom_money]];
    self.circleImageView.image = [self judgeImage:moneyListInfo.mom_money_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", moneyListInfo.mom_money_per];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %@ 元", [BXTGlobal transNum:moneyListInfo.an_money]];
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
    
    self.roundView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
