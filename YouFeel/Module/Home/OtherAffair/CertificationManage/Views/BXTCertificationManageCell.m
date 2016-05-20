//
//  BXTCertificationManageCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTCertificationManageCell.h"
#import "UIImageView+WebCache.h"

@implementation BXTCertificationManageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTCertificationManageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTCertificationManageCell" owner:nil options:nil] lastObject];
    }
    
    
    return cell;
}

- (void)setProjectInfo:(BXTProjectInfo *)projectInfo
{
    _projectInfo = projectInfo;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:projectInfo.headMedium] placeholderImage:[UIImage imageNamed:@"New_Ticket_icon"]];
    self.nameView.text = projectInfo.name;
    
    self.phoneView.text = [NSString stringWithFormat:@"电话：%@", projectInfo.mobile];
    if (!projectInfo.mobile) {
        self.phoneView.text = [NSString stringWithFormat:@"电话："];
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
