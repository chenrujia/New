//
//  BXTRankingCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTRankingCell.h"
#import "BXTHeaderFile.h"

@implementation BXTRankingCell

+ (instancetype)cellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    BXTRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTRankingCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 1) {
        cell.backgroundColor = colorWithHexString(@"#E2E6E8");
    }
    
    return cell;
}

- (void)setRanking:(BXTRankingData *)ranking
{
    _ranking = ranking;
    
    self.rankingView.text = [NSString stringWithFormat:@"%ld", (long)ranking.ranking];
    self.integralView.text = [NSString stringWithFormat:@"%ld", (long)ranking.score];
    if (ranking.is_self == 1) {
        self.backgroundColor = colorWithHexString(@"#5CAFF8");
    }
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
