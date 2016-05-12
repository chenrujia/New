//
//  MainTableViewCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/21.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMainTableViewCell.h"
#import "BXTGlobal.h"
#import "BXTRepairInfo.h"
#import "BXTHeaderFile.h"

@implementation BXTMainTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTMainTableViewCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)setRepairInfo:(BXTRepairInfo *)repairInfo
{
    self.orderNumView.text = [NSString stringWithFormat:@"编号：%@", repairInfo.orderid];
    self.orderTypeView.text = [repairInfo.task_type intValue] == 1 ? @"日常" : @"维保";
    self.orderTypeView.backgroundColor = [repairInfo.task_type intValue] == 1 ? colorWithHexString(@"#F0B660") : colorWithHexString(@"#7EC86E");
    self.orderGroupView.text = [NSString stringWithFormat:@"%@  ", repairInfo.subgroup_name];
    self.orderStateView.text = [NSString stringWithFormat:@"%@", repairInfo.repairstate_name];
    self.firstView.text = [NSString stringWithFormat:@"时间：%@", repairInfo.fault_time_name];
    self.alertView.hidden = YES;
    
    // 日常工单 - 时间、位置、内容
    if ([repairInfo.task_type integerValue] == 1)
    {
        if ([repairInfo.is_appointment isEqualToString:@"2"])
        {
            self.alertView.hidden = NO;
        }
        self.secondView.text = [NSString stringWithFormat:@"位置：%@", repairInfo.place_name];
        self.thirdView.text = [NSString stringWithFormat:@"内容：%@", repairInfo.cause];
    }
    else // 维保工单 - 时间、项目、位置、内容
    {
        self.secondView.text = [NSString stringWithFormat:@"项目：%@", repairInfo.faulttype_name];
        self.thirdView.text = [NSString stringWithFormat:@"位置：%@", repairInfo.place_name];
        self.forthView.text = [NSString stringWithFormat:@"内容：%@", repairInfo.cause];
    }
    
    NSString *imageStr;
    switch ([repairInfo.timeout_state intValue]) {
        case 2: imageStr = @"list_overtime"; break;
        case 3: imageStr = @"list_expiring"; break;
        case 4: imageStr = @"list_expired"; break;
        case 5: imageStr = @"list_Emergency_Services"; break;
        default: break;
    }
    self.stateImageView.image = [UIImage imageNamed:imageStr];
}

- (void)awakeFromNib {
    // Initialization code
    
    self.orderTypeView.layer.cornerRadius = 2.f;
    self.orderTypeView.layer.masksToBounds = YES;
    
    self.orderGroupView.layer.cornerRadius = 2.f;
    self.orderGroupView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
