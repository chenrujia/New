//
//  BXTEnergyRecordTableViewCell.m
//  YouFeel
//
//  Created by Jason on 16/7/6.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyRecordTableViewCell.h"
#import "BXTGlobal.h"

@implementation BXTEnergyRecordTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTEnergyRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEnergyRecordTableViewCell" owner:nil options:nil] lastObject];
    }
    
    
    return cell;
}

- (void)setListInfo:(BXTEnergyMeterListInfo *)listInfo
{
    _listInfo = listInfo;
    
    self.iconImage.image = [self returnIconImageWithCheckPriceType:listInfo.check_price_type];
    [self refreshFilterView:listInfo.meter_condition];
    
    // 收藏
    NSString *imageStr = [listInfo.is_collect isEqualToString:@"1"] ? @"energy_favourite_star" : @"energy_favourite_unstar";
    [self.starView setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    
    NSLog(@"%@", listInfo.check_price_type);
    self.energyNumber.text = [NSString stringWithFormat:@"编号：%@", listInfo.code_number];
    self.energySubName.attributedText = [BXTGlobal transToRichLabelOfIndex:4 String:[NSString stringWithFormat:@"子表名：%@", listInfo.meter_name]];
    self.energyNode.attributedText = [BXTGlobal transToRichLabelOfIndex:5 String:[NSString stringWithFormat:@"能源节点：%@", listInfo.measurement_path_name]];
    self.energyPlace.attributedText = [BXTGlobal transToRichLabelOfIndex:5 String:[NSString stringWithFormat:@"安装位置：%@", listInfo.meter_name]];
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end