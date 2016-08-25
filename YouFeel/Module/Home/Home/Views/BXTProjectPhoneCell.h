//
//  BXTProjectPhoneCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/8/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTProjectPhoneCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
