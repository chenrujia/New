//
//  BXTProjectManageCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXTMyProject;

@interface BXTProjectManageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *stateView;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
@property (weak, nonatomic) IBOutlet UIImageView *locationView;

@property (strong, nonatomic) BXTMyProject *project;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
