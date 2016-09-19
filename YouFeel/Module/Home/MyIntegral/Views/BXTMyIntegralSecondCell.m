//
//  BXTMyIntegralSecondCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMyIntegralSecondCell.h"
#import "BXTMyIntegralData.h"

@implementation BXTMyIntegralSecondCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTMyIntegralSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTMyIntegralSecondCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setMyIntegral:(BXTMyIntegralData *)myIntegral
{
    _myIntegral = myIntegral;
    
    self.rankingView.text = [NSString stringWithFormat:@"排名：%@", myIntegral.ranking];
    self.sumView.text = [NSString stringWithFormat:@"总分：%@", myIntegral.total_score];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
