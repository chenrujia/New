//
//  BXTEnergySurveyViewChartCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/30.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergySurveyViewChartCell.h"

@interface BXTEnergySurveyViewChartCell ()

@end

@implementation BXTEnergySurveyViewChartCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"BXTEnergySurveyViewChartCell";
    BXTEnergySurveyViewChartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEnergySurveyViewChartCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setTotalInfo:(BXTEySyTotalInfo *)totalInfo
{
    _totalInfo = totalInfo;
    
    self.moneyView.text = [NSString stringWithFormat:@"金额: %.2f 元", totalInfo.money];
    
    self.circleView.text = [NSString stringWithFormat:@"环比: %.2f 元", totalInfo.mom_money];
    self.circleImageView.image = [self judgeImage:totalInfo.mom_sign];
    self.circleNumView.text = [NSString stringWithFormat:@"%@", totalInfo.mom];
    
    self.similarView.text = [NSString stringWithFormat:@"同比: %.2f 元", totalInfo.an_money];
    self.similarImageView.image = [self judgeImage:totalInfo.an_sign];
    self.similarNumView.text = [NSString stringWithFormat:@"%@", totalInfo.an];
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
