//
//  BXTEquipmentInformCell.h
//  YouFeel
//
//  Created by 满孝意 on 15/12/29.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTEquipmentInformCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *detailView;
@property (weak, nonatomic) IBOutlet UILabel *statusView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *title_width;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
