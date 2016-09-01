//
//  BXTProjectInformContentCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTProjectInformContentCell.h"
#import "BXTGlobal.h"

@implementation BXTProjectInformContentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTProjectInformContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTProjectInformContentCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setProjectInfo:(BXTPersonInform *)projectInfo
{
    _projectInfo = projectInfo;
    
    self.typeView.text = projectInfo.type == 1 ? @"员工" : @"客户";
    self.apartmentView.text = projectInfo.department_name;
    
    if (projectInfo.type == 1) {
        self.positionTitleView.text = @"职位：";
        self.professionTitleView.text = @"专业组：";
        self.skillTitleView.text = @"专业技能：";
        self.positionView.text = projectInfo.duty_name;
        self.professionView.text = projectInfo.subgroup_name;
        self.skillView.text = projectInfo.have_subgroup_name;
        
        if ([projectInfo.duty_name isEqualToString:@""]) {
            self.positionView.text = @"暂无";
        }
        if ([projectInfo.subgroup_name isEqualToString:@""]) {
            self.professionTitleView.hidden = YES;
            self.professionView.hidden = YES;
        }
        if ([projectInfo.have_subgroup_name isEqualToString:@""]) {
            self.skillTitleView.hidden = YES;
            self.skillView.hidden = YES;
        }
    }
    else {
        self.apartmentTitleView.text = @"所属：";
        self.apartmentView.text = projectInfo.stores_name;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
