//
//  BXTMTPlanListCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMTPlanListCell.h"
#import "BXTGlobal.h"

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
    
    NSString *projectStr = [NSString stringWithFormat:@"维保项目：%@", planList.faulttype];
    NSString *planStr = [NSString stringWithFormat:@"维保计划：%@--%@", planList.start_date, planList.end_date];
    NSString *repairerStr = [NSString stringWithFormat:@"维修人：%@", planList.user_name];
    self.projectView.attributedText = [BXTGlobal transToRichLabelOfIndex:5 String:projectStr];
    self.planView.attributedText = [BXTGlobal transToRichLabelOfIndex:5 String:planStr];
    self.repairerView.attributedText = [BXTGlobal transToRichLabelOfIndex:4 String:repairerStr];
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
