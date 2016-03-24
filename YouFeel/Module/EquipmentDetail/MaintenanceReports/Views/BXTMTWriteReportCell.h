//
//  BXTMTWriteReportCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/3/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTMTWriteReportCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textView;

+ (instancetype)cellWithTableViewCell:(UITableView *)tableView;

@end
