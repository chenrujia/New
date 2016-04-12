//
//  BXTCertificationManageInfoTableViewCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTCertificationManageInfoCell.h"

@implementation BXTCertificationManageInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTCertificationManageInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTCertificationManageInfoCell" owner:nil options:nil] lastObject];
    }
    
    
    return cell;
}

- (void)setProjectInfo:(BXTProjectInfo *)projectInfo
{
    _projectInfo = projectInfo;
    
    self.typeView.text = [projectInfo.type integerValue] == 1 ? @"项目管理公司" : @"客户组";
    self.departmentView.text = projectInfo.department;
    self.positionView.text = projectInfo.duty_name;
    self.groupView.text = projectInfo.subgroup;
    self.professionView.text = projectInfo.extra_subgroup;
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