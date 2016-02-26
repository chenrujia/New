//
//  BXTEquipmentListCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/2/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTEquipmentListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *NumberView;
@property (weak, nonatomic) IBOutlet UILabel *statusView;

@property (weak, nonatomic) IBOutlet UILabel *systemView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *locationView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
