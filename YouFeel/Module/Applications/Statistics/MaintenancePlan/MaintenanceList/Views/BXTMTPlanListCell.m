//
//  BXTMTPlanListCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMTPlanListCell.h"

@implementation BXTMTPlanListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTMTPlanListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTMTPlanListCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)setPlanList:(BXTMTPlanList *)planList
{
    _planList = planList;
    
    self.orderNumView.text = [NSString stringWithFormat:@"编号：%@", planList.inspection_code];
    self.statusView.text = [NSString stringWithFormat:@"%@", [planList.state integerValue] == 1 ? @"维保中" : @"已完成"];
    self.projectView.text = [NSString stringWithFormat:@"维保项目%@", planList.faulttype];
    self.planView.text = [NSString stringWithFormat:@"维保计划：%@--%@", planList.start_date, planList.end_date];
    self.repairerView.text = [NSString stringWithFormat:@"维修人：%@", planList.user_name];
    self.timeView.text = [NSString stringWithFormat:@"完成时间：%@", planList.end_date];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
