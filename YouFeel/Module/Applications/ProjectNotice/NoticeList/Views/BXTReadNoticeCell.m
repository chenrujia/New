//
//  BXTReadNoticeCell.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTReadNoticeCell.h"
#import "BXTPublicSetting.h"
#import "BXTGlobal.h"

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
    self.introView.textColor = colorWithHexString(CellContentColorStr);
    self.timeView.text = [NSString stringWithFormat:@"%@", noticeModel.update_time_name];
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
