//
//  BXTMeterReadingHeaderCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/6/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMeterReadingHeaderCell.h"

@implementation BXTMeterReadingHeaderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"HeaderCell";
    BXTMeterReadingHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTMeterReadingHeaderCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)setMeterReadingInfo:(BXTMeterReadingInfo *)meterReadingInfo
{
    _meterReadingInfo = meterReadingInfo;
    
    self.iconView.image = [self returnIconImageWithCheckPriceType:meterReadingInfo.check_price_type];
    
    [self refreshFilterView:meterReadingInfo.meter_condition];
    
    self.titleView.text = [NSString stringWithFormat:@"%@", meterReadingInfo.meter_name];
    self.codeView.text = [NSString stringWithFormat:@"编号：%@", meterReadingInfo.code_number];
    self.rateView.text = [NSString stringWithFormat:@"倍率：%@", meterReadingInfo.meter_name];
    self.stateView.text = [NSString stringWithFormat:@"状态：%@", meterReadingInfo.meter_name];
}

- (void)setLastList:(BXTMeterReadingLastList *)lastList
{
    _lastList = lastList;
    
    self.lastTimeView.text = [NSString stringWithFormat:@"上次抄表时间：%@", lastList.create_time];
}

- (void)setEnergyConsumptionInfo:(BXTEnergyConsumptionInfo *)energyConsumptionInfo
{
    _energyConsumptionInfo = energyConsumptionInfo;
    
    self.iconView.image = [self returnIconImageWithCheckPriceType:energyConsumptionInfo.check_price_type];
    
    [self refreshFilterView:energyConsumptionInfo.meter_condition];
    
    self.titleView.text = [NSString stringWithFormat:@"%@", energyConsumptionInfo.meter_name];
    self.codeView.text = [NSString stringWithFormat:@"编号：%@", energyConsumptionInfo.code_number];
    self.rateView.text = [NSString stringWithFormat:@"倍率：%@", energyConsumptionInfo.meter_name];
    self.stateView.text = [NSString stringWithFormat:@"状态：%@", energyConsumptionInfo.state_name];
}

/**
 *  meter_condition:
 1 二维码扫描
 2 NFC扫描
 3 拍照
 */
- (void)refreshFilterView:(NSString *)meter_condition
{
    self.scanImage.hidden = YES;
    self.NFCImage.hidden = YES;
    self.photoImage.hidden = YES;
    if ([meter_condition rangeOfString:@"1"].location != NSNotFound) {
        self.scanImage.hidden = NO;
    }
    if ([meter_condition rangeOfString:@"2"].location != NSNotFound) {
        //self.NFCImage.hidden = NO;
    }
    if ([meter_condition rangeOfString:@"3"].location != NSNotFound) {
        self.photoImage.hidden = NO;
    }
}

//计量表接口，添加一个返回字段：check_price_type
//值 ：1-6
//1.手动，单一
//2.手动，峰谷
//3.手动，阶梯
//4.自动，单一
//5.自动，峰谷
//6.自动，阶梯
- (UIImage *)returnIconImageWithCheckPriceType:(NSString *)check_price_type
{
    NSString *imageStr;
    switch ([check_price_type integerValue]) {
        case 1: imageStr = @"energy_Manual_single"; break;
        case 2: imageStr = @"energy_Manual_Gu_Feng"; break;
        case 3: imageStr = @"energy_Manual_ladder"; break;
        case 4: imageStr = @"energy_Automatic_Translation"; break;
        case 5: imageStr = @"energy_Automatic_valley"; break;
        case 6: imageStr = @"energy_Automatic_ladder"; break;
        default: break;
    }
    return [UIImage imageNamed:imageStr];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
