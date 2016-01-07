//
//  BXTEquipmentFilesCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/6.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEquipmentFilesCell.h"

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

- (void)setInspectionList:(BXTInspectionData *)inspectionList
{
    _inspectionList = inspectionList;
    
    self.orderIDView.text = [NSString stringWithFormat:@"编号：%@", inspectionList.inspectionCode];
    self.typeView.text = [NSString stringWithFormat:@"%@", inspectionList.faulttypeTypeName];
    
    self.projectView.text = [NSString stringWithFormat:@"维保项目：%@", inspectionList.inspectionItemName];
    self.planView.text = [NSString stringWithFormat:@"维保计划：%@", inspectionList.inspectionTime];
    self.repairManView.text = [NSString stringWithFormat:@"维修人：%@", inspectionList.repairUser];
    
    self.endTimeView.text = [NSString stringWithFormat:@"完成时间：%@", inspectionList.createTime];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
