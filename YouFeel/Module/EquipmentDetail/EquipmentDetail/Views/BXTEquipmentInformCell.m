//
//  BXTEquipmentInformCell.m
//  YouFeel
//
//  Created by 满孝意 on 15/12/29.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTEquipmentInformCell.h"
#import "BXTGlobal.h"
#import "BXTPublicSetting.h"

@implementation BXTEquipmentInformCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTEquipmentInformCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEquipmentInformCell" owner:nil options:nil] lastObject];
    }
    
    cell.statusView.hidden = YES;
    cell.detailView.textColor = colorWithHexString(CellContentColorStr);
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
