//
//  BXTEPSystemRateCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEPSystemRateCell.h"

@implementation BXTEPSystemRateCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTEPSystemRateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEPSystemRateCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)setEpList:(BXTEPSystemRate *)epList
{
    _epList = epList;
    
    self.sumView.text = [NSString stringWithFormat:@"设备共计：%@台", epList.total];
    self.normalView.text = [NSString stringWithFormat:@"运行：%@台", epList.working];
    self.faultView.text = [NSString stringWithFormat:@"故障：%@台", epList.fault];
    self.unableView.text = [NSString stringWithFormat:@"停运：%@台", epList.stop];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.roundView.layer.cornerRadius = 5;
    self.roundView2.layer.cornerRadius = 5;
    self.roundView3.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
