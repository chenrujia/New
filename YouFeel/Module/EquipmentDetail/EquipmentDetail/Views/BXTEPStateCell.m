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
    
    NSString *statusStr = [NSString stringWithFormat:@"状态：%@", stateList.state_name];
    NSString *timeStr = [NSString stringWithFormat:@"日期：%@", phoneStr];
    NSString *personStr = [NSString stringWithFormat:@"记录人：%@", stateList.name];
    NSString *phoneStr1 = [NSString stringWithFormat:@"电话：%@", stateList.mobile];
    NSString *descStr = [NSString stringWithFormat:@"说明：%@", stateList.desc];
    self.statusView.attributedText = [BXTGlobal transToRichLabelOfIndex:3 String:statusStr];
    self.timeView.attributedText = [BXTGlobal transToRichLabelOfIndex:3 String:timeStr];
    self.personView.attributedText = [BXTGlobal transToRichLabelOfIndex:4 String:personStr];
    self.phoneView.attributedText = [BXTGlobal transToRichLabelOfIndex:3 String:phoneStr1];
    self.descView.attributedText = [BXTGlobal transToRichLabelOfIndex:3 String:descStr];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
