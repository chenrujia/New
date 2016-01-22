//
//  BXTMailListCell.m
//  YouFeel
//
//  Created by 满孝意 on 15/12/31.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTMailListCell.h"
#import "UIImageView+WebCache.h"
#import "BXTGlobal.h"

@implementation BXTMailListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTMailListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTMailListCell" owner:nil options:nil] lastObject];
    }
    
    
    return cell;
}

- (void)setMailListModel:(BXTMailListModel *)mailListModel
{
    _mailListModel = mailListModel;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:mailListModel.head] placeholderImage:[UIImage imageNamed:@"New_Ticket_icon"]];
    self.nameView.text = mailListModel.name;
    self.positionView.text = mailListModel.role_name;
    
    @weakify(self);
    [[self.phoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", mailListModel.mobile];
        UIWebView *callWeb = [[UIWebView alloc] init];
        [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
        [self addSubview:callWeb];
    }];
    
}

- (void)awakeFromNib {
    // Initialization code
    
    self.iconView.layer.cornerRadius = 20;
    self.iconView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
