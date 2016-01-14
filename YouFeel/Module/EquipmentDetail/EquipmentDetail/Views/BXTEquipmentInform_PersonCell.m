//
//  BXTEquipmentInform_PersonCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/7.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEquipmentInform_PersonCell.h"
#import "UIImageView+WebCache.h"
#import "BXTHeaderForVC.h"

@implementation BXTEquipmentInform_PersonCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cellPerson";
    BXTEquipmentInform_PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEquipmentInform_PersonCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setUserList:(BXTEquipmentControlUserArr *)userList
{
    _userList = userList;
    
    NSString *head_pic = userList.head_pic;
    NSString *iconPic = [head_pic stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconPic] placeholderImage:[UIImage imageNamed:@"New_Ticket_icon"]];
    
    self.nameView.text = [NSString stringWithFormat:@"负责人：%@", userList.name];
    self.phoneView.text = [NSString stringWithFormat:@"联系电话：%@", userList.mobile];
}

- (void)awakeFromNib {
    // Initialization code
    
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width/2;
    self.iconView.layer.masksToBounds = YES;
    
    self.connectView.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    self.connectView.layer.borderWidth = 0.5;
    self.connectView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
