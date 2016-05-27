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

- (void)setInspectionList:(BXTDeviceMaintenceInfo *)inspectionList
{
    _inspectionList = inspectionList;
    
    self.orderIDView.text = [NSString stringWithFormat:@"编号：%@", inspectionList.inspection_code];
    self.typeView.text = [NSString stringWithFormat:@"  %@  ", [self transStateWithStr:inspectionList.state]];
    
    NSString *systemStr = [NSString stringWithFormat:@"维保系统：%@", inspectionList.faulttype_type_name];
    NSString *projectStr = [NSString stringWithFormat:@"维保项目：%@", inspectionList.inspection_item_name];
    NSString *planStr = [NSString stringWithFormat:@"维保计划：%@", inspectionList.inspection_time];
    NSString *repairManStr = [NSString stringWithFormat:@"维保人：%@", inspectionList.repair_user];
    self.systemView.attributedText = [BXTGlobal transToRichLabelOfIndex:5 String:systemStr];
    self.projectView.attributedText = [BXTGlobal transToRichLabelOfIndex:5 String:projectStr];
    self.planView.attributedText = [BXTGlobal transToRichLabelOfIndex:5 String:planStr];
    self.repairManView.attributedText = [BXTGlobal transToRichLabelOfIndex:4 String:repairManStr];
    
    self.endTimeView.text = [NSString stringWithFormat:@"完成时间：%@", inspectionList.create_time];
}

- (void)awakeFromNib
{
    self.typeView.layer.borderWidth = 0.5;
    self.typeView.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    self.typeView.layer.cornerRadius = 5;
}

- (NSString *)transStateWithStr:(id)state
{
    NSInteger stateNum = [[NSString stringWithFormat:@"%@", state] integerValue];
    NSString *stateStr;
    switch (stateNum) {
        case 0: stateStr = @"未开始"; break;
        case 1: stateStr = @"维保中"; break;
        case 2: stateStr = @"已完成"; break;
        default: break;
    }
    return stateStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
