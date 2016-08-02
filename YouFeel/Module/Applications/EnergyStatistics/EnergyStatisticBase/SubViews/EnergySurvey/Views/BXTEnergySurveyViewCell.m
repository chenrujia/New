//
//  BXTEnergySurveyViewCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergySurveyViewCell.h"
#import "BXTGlobal.h"

@implementation BXTEnergySurveyViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"BXTEnergySurveyViewCell";
    BXTEnergySurveyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEnergySurveyViewCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark -
#pragma mark - 能效概况
- (void)setEleInfo:(BXTEySyEleInfo *)eleInfo
{
    _eleInfo = eleInfo;
    
    self.roundView.backgroundColor = colorWithHexString(@"#E99390");
    self.typeView.text = @"电能";
    self.moneyView.text = [NSString stringWithFormat:@"金额: %@ 元", eleInfo.money];
    self.rateView.text = [NSString stringWithFormat:@"比例: %.2f%%", eleInfo.per];
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %.2f 元", eleInfo.mom_money];
    self.circleImageView.image = [self judgeImage:eleInfo.mom_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", eleInfo.mom];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %.2f 元", eleInfo.an_money];
    self.similarImageView.image = [self judgeImage:eleInfo.an_sign];
    self.similarNumView.text = [NSString stringWithFormat:@"%@", eleInfo.an];
}

- (void)setWatInfo:(BXTEySyWatInfo *)watInfo
{
    _watInfo = watInfo;
    
    self.roundView.backgroundColor = colorWithHexString(@"#6DA9E8");
    self.typeView.text = @"水";
    self.moneyView.text = [NSString stringWithFormat:@"金额: %@ 元", watInfo.money];
    self.rateView.text = [NSString stringWithFormat:@"比例: %.2f%%", watInfo.per];
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %.2f 元", watInfo.mom_money];
    self.circleImageView.image = [self judgeImage:watInfo.mom_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", watInfo.mom];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %.2f 元", watInfo.an_money];
    self.similarImageView.image = [self judgeImage:watInfo.an_sign];
    self.similarNumView.text = [NSString stringWithFormat:@"%@", watInfo.an];
}

- (void)setTheInfo:(BXTEySyTheInfo *)theInfo
{
    _theInfo = theInfo;
    
    self.roundView.backgroundColor = colorWithHexString(@"#FBF56B");
    self.typeView.text = @"燃气";
    self.moneyView.text = [NSString stringWithFormat:@"金额: %@ 元", theInfo.money];
    self.rateView.text = [NSString stringWithFormat:@"比例: %.2f%%", theInfo.per];
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %.2f 元", theInfo.mom_money];
    self.circleImageView.image = [self judgeImage:theInfo.mom_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", theInfo.mom];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %.2f 元", theInfo.an_money];
    self.similarImageView.image = [self judgeImage:theInfo.an_sign];
    self.similarNumView.text = [NSString stringWithFormat:@"%@", theInfo.an];
}

- (void)setGasInfo:(BXTEySyGasInfo *)gasInfo
{
    _gasInfo = gasInfo;
    
    self.roundView.backgroundColor = colorWithHexString(@"#F2B56F");
    self.typeView.text = @"热能";
    self.moneyView.text = [NSString stringWithFormat:@"金额: %@ 元", gasInfo.money];
    self.rateView.text = [NSString stringWithFormat:@"比例: %.2f%%", gasInfo.per];
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %.2f 元", gasInfo.mom_money];
    self.circleImageView.image = [self judgeImage:gasInfo.mom_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", gasInfo.mom];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %.2f 元", gasInfo.an_money];
    self.similarImageView.image = [self judgeImage:gasInfo.an_sign];
    self.similarNumView.text = [NSString stringWithFormat:@"%@", gasInfo.an];
}

#pragma mark -
#pragma mark - 能效分布
- (void)setEnergyListInfo:(BXTEYDTListsInfo *)energyListInfo
{
    _energyListInfo = energyListInfo;
    
    self.typeView.text = energyListInfo.name;
    self.moneyView.text = [NSString stringWithFormat:@"能耗量: %@ %@", energyListInfo.energy_consumption, self.unit];
    self.rateView.text = [NSString stringWithFormat:@"比例: %.2f%%", energyListInfo.energy_consumption_per];
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %ld %@", (long)energyListInfo.mom_energy_consumption, self.unit];
    self.circleImageView.image = [self judgeImage:energyListInfo.mom_energy_consumption_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", energyListInfo.mom_energy_consumption_per];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %ld %@", (long)energyListInfo.an_energy_consumption, self.unit];
    self.similarImageView.image = [self judgeImage:energyListInfo.an_energy_consumption_sign];
    self.similarNumView.text = [NSString stringWithFormat:@"%@", energyListInfo.an_energy_consumption_per];
}

- (void)setMoneyListInfo:(BXTEYDTListsInfo *)moneyListInfo
{
    _moneyListInfo = moneyListInfo;
    
    self.typeView.text = moneyListInfo.name;
    self.moneyView.text = [NSString stringWithFormat:@"金额: %@ 元", moneyListInfo.money];
    self.rateView.text = [NSString stringWithFormat:@"比例: %.2f%%", moneyListInfo.money_per];
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %ld 元", (long)moneyListInfo.mom_money];
    self.circleImageView.image = [self judgeImage:moneyListInfo.mom_money_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", moneyListInfo.mom_money_per];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %ld 元", (long)moneyListInfo.an_money];
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
