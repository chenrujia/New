//
//  BXTOtherAffairCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTOtherAffairCell.h"
#import "BXTOtherAffair.h"

@implementation BXTOtherAffairCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTOtherAffairCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTOtherAffairCell" owner:nil options:nil] lastObject];
    }
    
    
    return cell;
}

- (void)setAffairModel:(BXTOtherAffair *)affairModel
{
    _affairModel = affairModel;
    
    switch ([affairModel.affairs_type integerValue]) {
        case 1: self.titleView.text = @"认证审批"; break;
        case 11: self.titleView.text = @"维修确认"; break;
        case 12: self.titleView.text = @"待评价工单"; break;
        default: break;
    }
    self.timeView.text = affairModel.affairs_time_name;
    self.introView.text = affairModel.affairs_desc;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
