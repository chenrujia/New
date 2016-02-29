//
//  BXTEquipmentListCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEquipmentListCell.h"

@implementation BXTEquipmentListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTEquipmentListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEquipmentListCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)setEpList:(BXTEPList *)epList
{
    _epList = epList;
    
    self.NumberView.text = [NSString stringWithFormat:@"设备编号：%@", epList.code_number];
    self.statusView.text = [NSString stringWithFormat:@"%@", epList.state_name];
    self.systemView.text = [NSString stringWithFormat:@"系统：%@", epList.type_name];
    self.nameView.text = [NSString stringWithFormat:@"设备名称：%@", epList.name];
    self.locationView.text = [NSString stringWithFormat:@"位置：%@", epList.place];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
