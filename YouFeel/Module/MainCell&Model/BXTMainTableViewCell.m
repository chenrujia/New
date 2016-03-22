//
//  MainTableViewCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/21.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMainTableViewCell.h"
#import "BXTGlobal.h"

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
