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
    
    NSString *systemStr = [NSString stringWithFormat:@"系统：%@", epList.type_name];
    NSString *nameStr = [NSString stringWithFormat:@"设备名称：%@", epList.name];
    NSString *locationStr = [NSString stringWithFormat:@"安装位置：%@", epList.place];
    self.systemView.attributedText = [BXTGlobal transToRichLabelOfIndex:3 String:systemStr];
    self.nameView.attributedText = [BXTGlobal transToRichLabelOfIndex:5 String:nameStr];
    self.locationView.attributedText = [BXTGlobal transToRichLabelOfIndex:3 String:locationStr];
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
