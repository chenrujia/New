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

- (void)setProjectInfo:(BXTProjectInfo *)projectInfo
{
    _projectInfo = projectInfo;
    
    NSLog(@"--------- %@", projectInfo.subgroup);
    
    self.typeView.text = [projectInfo.type integerValue] == 1 ? @"物业员工" : @"客户";
    self.apartmentView.text = projectInfo.department;
    if ([projectInfo.type integerValue] == 1) {
        self.professionTitleView.text = @"专业组：";
        self.skillTitleView.text = @"专业技能：";
        self.professionView.text = projectInfo.subgroup;
        self.skillView.text = projectInfo.extra_subgroup;
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
