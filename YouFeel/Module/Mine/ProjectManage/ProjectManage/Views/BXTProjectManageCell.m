//
//  BXTProjectManageCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTProjectManageCell.h"
#import "BXTHeaderFile.h"
#import "BXTMyProject.h"
#import "BXTGlobal.h"
#import "BXTHeadquartersInfo.h"

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

- (void)setProject:(BXTMyProject *)project
{
    _project = project;
    
    self.titleView.text = project.name;
    self.stateView.text = [self transVertifyState:project.verify_state];
    
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    if ([project.shop_id isEqualToString:companyInfo.company_id]) {
        self.locationView.hidden = NO;
        self.switchBtn.hidden = YES;
    }
    else {
        self.locationView.hidden = YES;
        self.switchBtn.hidden = NO;
    }
    
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
    [super awakeFromNib];
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
