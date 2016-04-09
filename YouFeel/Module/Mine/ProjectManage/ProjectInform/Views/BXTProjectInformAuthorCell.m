//
//  BXTProjectInformAuthorCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTProjectInformAuthorCell.h"
#import "BXTHeaderFile.h"
#import "UIImageView+WebCache.h"

@implementation BXTProjectInformAuthorCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTProjectInformAuthorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTProjectInformAuthorCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setProjectInfo:(BXTProjectInfo *)projectInfo
{
    _projectInfo = projectInfo;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:projectInfo.headMedium] placeholderImage:[UIImage imageNamed:@"New_Ticket_icon"]];
    self.nameView.text = projectInfo.name;
    self.apartmentView.text = projectInfo.department;
    self.positionView.text = projectInfo.duty_name;
}

- (void)awakeFromNib {
    // Initialization code
    
    self.connectBtn.layer.borderWidth = 1;
    self.connectBtn.layer.borderColor = [colorWithHexString(@"#5DAEF9") CGColor];
    self.connectBtn.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
