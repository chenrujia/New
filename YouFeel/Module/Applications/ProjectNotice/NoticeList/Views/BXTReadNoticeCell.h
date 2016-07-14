//
//  BXTReadNoticeCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTReadNotice.h"

@interface BXTReadNoticeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *introView;
@property (weak, nonatomic) IBOutlet UILabel *timeView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) BXTReadNotice *noticeModel;

@end
