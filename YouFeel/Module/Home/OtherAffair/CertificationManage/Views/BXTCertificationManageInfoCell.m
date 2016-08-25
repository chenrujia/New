//
//  BXTCertificationManageInfoTableViewCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTCertificationManageInfoCell.h"
#import "BXTGlobal.h"

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
    
    self.typeView.text = [projectInfo.type integerValue] == 1 ? @"员工" : @"客户";
    self.departmentView.text = projectInfo.department;
    self.positionView.text = projectInfo.duty_name;
    self.groupView.text = projectInfo.subgroup;
    self.professionView.text = projectInfo.extra_subgroup;
    
    if ([BXTGlobal isBlankString:projectInfo.subgroup]) {
        self.groupView.text = @"暂无";
    }
    if ([BXTGlobal isBlankString: projectInfo.extra_subgroup]) {
        self.professionView.text = @"暂无";
    }
    
    // 客户 - 处理
    if ([projectInfo.type integerValue] != 1) {
        self.departmentTitleView.text = @"所属：";
        self.departmentView.text = projectInfo.stores_name;
        
        self.positionTitleView.text = @"常用位置：";
        self.positionView.text = projectInfo.place;
        
        self.groupTitleView.hidden = YES;
        self.groupView.hidden = YES;
        
        self.ProfessionTitleView.hidden = YES;
        self.professionView.hidden = YES;
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
