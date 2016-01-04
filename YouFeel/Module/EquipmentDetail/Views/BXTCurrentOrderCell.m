//
//  BXTCurrentOrderCell.m
//  YouFeel
//
//  Created by 满孝意 on 15/12/30.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTCurrentOrderCell.h"

@implementation BXTCurrentOrderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTCurrentOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTCurrentOrderCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)setOrderList:(BXTCurrentOrderData *)orderList
{
    _orderList = orderList;
    
    self.locationView.text = [NSString stringWithFormat:@"位置：%@", orderList.place];
    self.typeView.text = [NSString stringWithFormat:@"故障类型：%@", orderList.faulttypeName];
    self.describeView.text = [NSString stringWithFormat:@"故障描述：%@", orderList.cause];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
