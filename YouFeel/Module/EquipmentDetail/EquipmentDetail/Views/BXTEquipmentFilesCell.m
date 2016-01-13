//
//  BXTEquipmentFilesCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/6.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEquipmentFilesCell.h"
#import "BXTGlobal.h"

@implementation BXTEquipmentFilesCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTEquipmentFilesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEquipmentFilesCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)setInspectionList:(BXTMaintenceInfo *)inspectionList
{
    _inspectionList = inspectionList;
    
    self.orderIDView.text = [NSString stringWithFormat:@"编号：%@", inspectionList.inspection_code];
    self.typeView.text = [NSString stringWithFormat:@"  %@  ", inspectionList.faulttype_type_name];
    self.projectView.text = [NSString stringWithFormat:@"维保项目：%@", inspectionList.inspection_item_name];
    self.planView.text = [NSString stringWithFormat:@"维保计划：%@", inspectionList.inspection_time];
    self.repairManView.text = [NSString stringWithFormat:@"维修人：%@", inspectionList.repair_user];
    self.endTimeView.text = [NSString stringWithFormat:@"完成时间：%@", inspectionList.create_time];
}

- (void)awakeFromNib {
    // Initialization code
    
    self.typeView.layer.borderWidth = 0.5;
    self.typeView.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    self.typeView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
