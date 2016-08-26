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
    self.moneyView.text = [NSString stringWithFormat:@"金额: %@ 元", [BXTGlobal transNum:eleInfo.money]];
    self.rateView.text = [NSString stringWithFormat:@"比例: %@%%", [BXTGlobal transNum:eleInfo.per]];
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %@ 元", [BXTGlobal transNum:eleInfo.mom_money]];
    self.circleImageView.image = [self judgeImage:eleInfo.mom_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", eleInfo.mom];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %@ 元", [BXTGlobal transNum:eleInfo.an_money]];
    self.similarImageView.image = [self judgeImage:eleInfo.an_sign];
    self.similarNumView.text = [NSString stringWithFormat:@"%@", eleInfo.an];
}

- (void)setWatInfo:(BXTEySyWatInfo *)watInfo
{
    _watInfo = watInfo;
    
    self.roundView.backgroundColor = colorWithHexString(@"#6DA9E8");
    self.typeView.text = @"水";
    self.moneyView.text = [NSString stringWithFormat:@"金额: %@ 元", [BXTGlobal transNum:watInfo.money]];
    self.rateView.text = [NSString stringWithFormat:@"比例: %@%%", [BXTGlobal transNum:watInfo.per]];
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %@ 元", [BXTGlobal transNum:watInfo.mom_money]];
    self.circleImageView.image = [self judgeImage:watInfo.mom_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", watInfo.mom];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %@ 元", [BXTGlobal transNum:watInfo.an_money]];
    self.similarImageView.image = [self judgeImage:watInfo.an_sign];
    self.similarNumView.text = [NSString stringWithFormat:@"%@", watInfo.an];
}

- (void)setTheInfo:(BXTEySyTheInfo *)theInfo
{
    _theInfo = theInfo;
    
    self.roundView.backgroundColor = colorWithHexString(@"#FBF56B");
    self.typeView.text = @"燃气";
    self.moneyView.text = [NSString stringWithFormat:@"金额: %@ 元", [BXTGlobal transNum:theInfo.money]];
    self.rateView.text = [NSString stringWithFormat:@"比例: %@%%", [BXTGlobal transNum:theInfo.per]];
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %@ 元", [BXTGlobal transNum:theInfo.mom_money]];
    self.circleImageView.image = [self judgeImage:theInfo.mom_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", theInfo.mom];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %@ 元", [BXTGlobal transNum:theInfo.an_money]];
    self.similarImageView.image = [self judgeImage:theInfo.an_sign];
    self.similarNumView.text = [NSString stringWithFormat:@"%@", theInfo.an];
}

- (void)setGasInfo:(BXTEySyGasInfo *)gasInfo
{
    _gasInfo = gasInfo;
    
    self.roundView.backgroundColor = colorWithHexString(@"#F2B56F");
    self.typeView.text = @"热能";
    self.moneyView.text = [NSString stringWithFormat:@"金额: %@ 元", [BXTGlobal transNum:gasInfo.money]];
    self.rateView.text = [NSString stringWithFormat:@"比例: %@%%", [BXTGlobal transNum:gasInfo.per]];
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %@ 元", [BXTGlobal transNum:gasInfo.mom_money]];
    self.circleImageView.image = [self judgeImage:gasInfo.mom_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", gasInfo.mom];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %@ 元", [BXTGlobal transNum:gasInfo.an_money]];
    self.similarImageView.image = [self judgeImage:gasInfo.an_sign];
    self.similarNumView.text = [NSString stringWithFormat:@"%@", gasInfo.an];
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
