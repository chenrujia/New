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
    
    self.orderIDView.text = [NSString stringWithFormat:@"工单号：%@", orderList.orderid];
    self.groupView.text = [NSString stringWithFormat:@"  %@  ", orderList.subgroup_name];
    
    self.locationView.text = [NSString stringWithFormat:@"位置：%@", orderList.place_name];
    self.repairPersonView.text = [NSString stringWithFormat:@"报修人：%@", orderList.repair_user];
    self.typeView.text = [NSString stringWithFormat:@"故障类型：%@", orderList.faulttype_name];
    self.describeView.text = [NSString stringWithFormat:@"故障描述：%@", orderList.cause];
    
    self.endTimeView.text = [NSString stringWithFormat:@"截止时间：%@", orderList.inspection_end_time_name];
    self.timeView.text =  [NSString stringWithFormat:@"报修时间：%@", orderList.fault_time_name];
    
    if ([orderList.repairstate integerValue] == 2) {
        [self.receiveOrderView setTitle:@"已接单" forState:UIControlStateNormal];
        self.receiveOrderView.backgroundColor = colorWithHexString(@"#d9d9d9");
        self.receiveOrderView.userInteractionEnabled = NO;
    }
    
    if (![BXTGlobal shareGlobal].isRepair) {
        self.receiveOrderView.backgroundColor = colorWithHexString(@"#d9d9d9");
        self.receiveOrderView.userInteractionEnabled = NO;
    }
}

- (void)awakeFromNib {
    // Initialization code
    
    self.groupView.layer.borderWidth = 0.5;
    self.groupView.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    self.groupView.layer.cornerRadius = 5;
    
    self.receiveOrderView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
