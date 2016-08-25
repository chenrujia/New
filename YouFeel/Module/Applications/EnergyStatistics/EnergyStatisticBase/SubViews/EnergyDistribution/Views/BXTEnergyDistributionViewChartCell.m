//
//  BXTEnergyDistributionViewChartCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/30.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyDistributionViewChartCell.h"
#import "BXTGlobal.h"

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
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %@ %@", [BXTGlobal transNum:energyListInfo.mom_energy_consumption], self.unit];
    self.circleImageView.image = [self judgeImage:energyListInfo.mom_energy_consumption_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", energyListInfo.mom_energy_consumption_per];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %@ %@", [BXTGlobal transNum:energyListInfo.an_energy_consumption], self.unit];
    self.similarImageView.image = [self judgeImage:energyListInfo.an_energy_consumption_sign];
    self.similarNumView.text = [NSString stringWithFormat:@"%@", energyListInfo.an_energy_consumption_per];
    
    self.trueNumView.text = [NSString stringWithFormat:@"绝对能耗: %@ %@", [BXTGlobal transNum:energyListInfo.true_energy_consumption], self.unit];
    self.statisticErrorView.text = [NSString stringWithFormat:@"统计误差: %@", [BXTGlobal transNum:energyListInfo.true_energy_consumption_diff]];
}

- (void)setMoneyListInfo:(BXTEYDTTotalInfo *)moneyListInfo
{
    _moneyListInfo = moneyListInfo;
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %@ 元", [BXTGlobal transNum:moneyListInfo.mom_money]];
    self.circleImageView.image = [self judgeImage:moneyListInfo.mom_money_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", moneyListInfo.mom_money_per];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %@ 元", [BXTGlobal transNum:moneyListInfo.an_money]];
    self.similarImageView.image = [self judgeImage:moneyListInfo.an_money_sign];
    self.similarNumView.text = [NSString stringWithFormat:@"%@", moneyListInfo.an_money_per];
    
    self.trueNumView.text = [NSString stringWithFormat:@"绝对费用: %@ 元", [BXTGlobal transNum:moneyListInfo.true_money]];
    self.statisticErrorView.text = [NSString stringWithFormat:@"统计误差: %@", [BXTGlobal transNum:moneyListInfo.true_money_diff]];
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
    
    self.trueNumView.hidden = YES;
    self.statisticErrorView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
