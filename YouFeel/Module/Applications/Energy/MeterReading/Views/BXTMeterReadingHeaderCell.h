//
//  BXTMeterReadingHeaderCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/6/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTMeterReadingHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
