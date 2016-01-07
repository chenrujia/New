//
//  BXTEquipmentInform_PersonCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/7.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTEquipmentControlUserArr.h"

@interface BXTEquipmentInform_PersonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *phoneView;

@property (weak, nonatomic) IBOutlet UIButton *connectView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) BXTEquipmentControlUserArr *userList;

@end
