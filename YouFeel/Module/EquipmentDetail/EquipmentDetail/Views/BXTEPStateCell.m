//
//  BXTEPStateCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEPStateCell.h"
#import "BXTGlobal.h"

@implementation BXTEPStateCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTEPStateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEPStateCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)setStateList:(BXTEquipmentState *)stateList
{
    _stateList = stateList;
    
    NSInteger phone = [[NSString stringWithFormat:@"%@", stateList.create_time] integerValue];
    NSString *phoneStr = [BXTGlobal transTimeWithDate:[NSDate dateWithTimeIntervalSince1970:phone] withType:@"yyyy/MM/dd"];
    self.statusView.text = [NSString stringWithFormat:@"状态：%@", stateList.state_name];
    self.timeView.text = [NSString stringWithFormat:@"日期：%@", phoneStr];
    self.personView.text = [NSString stringWithFormat:@"记录人：%@", stateList.name];
    self.phoneView.text = [NSString stringWithFormat:@"电话：%@", stateList.mobile];
    self.descView.text = [NSString stringWithFormat:@"说明：%@", stateList.desc];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
