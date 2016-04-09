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
    
    self.stateView.text = [self transVertifyState:projectInfo.verify_state];
    self.typeView.text = [projectInfo.type integerValue] == 1 ? @"项目管理公司" : @"客户组";
    self.apartmentView.text = projectInfo.department;
    self.professionView.text = projectInfo.subgroup;
    self.skillView.text = projectInfo.extra_subgroup;
}

- (NSString *)transVertifyState:(NSString *)state
{
    // verify_state 状态：0未认证 1申请中 2已认证，没有状态3（不通过），如果审核的时候选择了不通过，则将状态直接设置为0
    NSString *stateStr;
    switch ([state integerValue]) {
        case 0: {
            stateStr = @"未认证";
            self.stateView.textColor = colorWithHexString(@"#696869");
        } break;
        case 1: {
            stateStr = @"申请中";
            self.stateView.textColor = colorWithHexString(@"#D2564D");
        } break;
        case 2: {
            stateStr = @"已认证";
            self.stateView.textColor = colorWithHexString(@"#5BB0F7");
        } break;
        default: break;
    }
    return stateStr;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
