//
//  BXTEquipmentListCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEquipmentListCell.h"
#import "BXTGlobal.h"

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
    [self adjustStateColor:epList.state];
    
    self.systemView.text = [NSString stringWithFormat:@"系统：%@", epList.type_name];
    self.nameView.text = [NSString stringWithFormat:@"设备名称：%@", epList.name];
    self.locationView.text = [NSString stringWithFormat:@"位置：%@", epList.place];
}

- (void)adjustStateColor:(NSString *)state
{
    NSString *colorStr;
    switch ([state integerValue]) {
        case 1: colorStr = @"#34B47E"; break;
        case 2: colorStr = @"#EA3622"; break;
        case 3: colorStr = @"#D6AD5B"; break;
        case 4: colorStr = @"#989C9F"; break;
        default: break;
    }
    self.statusView.textColor = colorWithHexString(colorStr);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
