//
//  BXTUserInformCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/9.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTUserInformCell.h"
#import "BXTGlobal.h"

@implementation BXTUserInformCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTUserInformCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTUserInformCell" owner:nil options:nil] lastObject];
    }
    
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    
    self.titleView.font = [UIFont systemFontOfSize:17];
    self.detailView.font = [UIFont systemFontOfSize:17];
    self.detailView.textColor = colorWithHexString(CellContentColorStr);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
