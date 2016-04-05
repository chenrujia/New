//
//  BXTMyIntegralThirdCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMyIntegralThirdCell.h"
#import "BXTMyIntegralData.h"
#import "BXTHeaderFile.h"

@implementation BXTMyIntegralThirdCell

+ (instancetype)cellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    BXTMyIntegralThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTMyIntegralThirdCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        if (indexPath.section == 2) {
            cell.backgroundColor = colorWithHexString(@"#76e3c7");
        } else if (indexPath.section == 3) {
            cell.backgroundColor = colorWithHexString(@"#f99e8c");
        }
        
        cell.titleView.textColor = [UIColor whiteColor];
        cell.orderView.textColor = [UIColor whiteColor];
        cell.percentView.textColor = [UIColor whiteColor];
        cell.rankingView.textColor = [UIColor whiteColor];
    }
    
    if (indexPath.section == 3) {
        cell.orderView.hidden = YES;
    }
    
    return cell;
}

- (void)setComplate:(BXTComplateData *)complate
{
    _complate = complate;
    
    self.orderView.text = [NSString stringWithFormat:@"%@/%@", complate.over, complate.total];
    self.percentView.text = [NSString stringWithFormat:@"%@", complate.percent];
    self.rankingView.text = [NSString stringWithFormat:@"%@", complate.score];
}

- (void)setPraise:(BXTPraiseData *)praise
{
    _praise = praise;
    
    self.percentView.text = [NSString stringWithFormat:@"%@", praise.percent];
    self.rankingView.text = [NSString stringWithFormat:@"%@", praise.score];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
