//
//  BXTProjectCertificationCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTProjectCertificationCell.h"
#import "BXTMyProject.h"
#import "BXTGlobal.h"

@implementation BXTProjectCertificationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTProjectCertificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTProjectCertificationCell" owner:nil options:nil] lastObject];
    }
    
    
    return cell;
}

- (void)setMyProject:(BXTMyProject *)myProject
{
    _myProject = myProject;
    
    self.titleView.text = myProject.name;
    self.stateView.text = [self transVertifyState:myProject.verify_state];
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
