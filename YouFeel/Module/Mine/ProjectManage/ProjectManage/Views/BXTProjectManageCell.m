//
//  BXTProjectManageCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTProjectManageCell.h"
#import "BXTHeaderFile.h"

@implementation BXTProjectManageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTProjectManageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTProjectManageCell" owner:nil options:nil] lastObject];
    }
    
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    
    self.switchBtn.layer.borderWidth = 1;
    self.switchBtn.layer.borderColor = [colorWithHexString(@"#5DAEF9") CGColor];
    self.switchBtn.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
