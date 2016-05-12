//
//  BXTReadNoticeCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTReadNoticeCell.h"

@implementation BXTReadNoticeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTReadNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTReadNoticeCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)setNoticeModel:(BXTReadNotice *)noticeModel
{
    _noticeModel = noticeModel;
    
    self.titleView.text = noticeModel.title;
    self.introView.text = noticeModel.summary;
    self.timeView.text = [NSString stringWithFormat:@"发送时间：%@", noticeModel.update_time_name];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
